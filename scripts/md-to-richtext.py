#!/usr/bin/python3
# Converts Markdown into Roblox rich text format for use in text labels.
import sys
import time

# Key is the number of heading, value is the font size
HEADING_MAP = {
    1: 32,
    2: 24,
    3: 20,
    4: 16,
    5: 14,
    6: 12,
}

def parse_line(line: str) -> str:
    output = ""
    size = len(line)

    # Used to track how many start-of-line hashes there are
    # to figure out the heading.
    hashes = 0
    # -1 means no italic/bold.
    italic_start_index = -1
    bold_start_index = -1
    heading = 0
    should_skip = False
    for i, char in enumerate(line):
        if should_skip:
            should_skip = True
            continue
        if char == "#" and hashes < 6 and (hashes > 0 or i == 0):
            hashes += 1
        elif char == " " and hashes > 0:
            heading = hashes
            hashes = 0
        # Starts with hashes, but there is no single whitespace, so it's not a heading.
        # We ignore it and reset hashes to not cause ambiguity in next iteration.
        elif hashes > 0:
            # We invert it so that we make it clear that it's not a heading, but also it
            # should start with that amount of hashes.
            heading = -hashes
            hashes = 0
            output += char
        elif char == "*" and italic_start_index != -1:
            output = output[:italic_start_index] + "<i>" + output[italic_start_index:] + "</i>"
            italic_start_index = -1
        elif char == "*" and i+1 < size and line[i+1] == "*" and bold_start_index != -1:
            output = output[:bold_start_index] + "<b>" + output[bold_start_index:] + "</b>"
        # Bold takes two asterisks instead of one, so we check for it first instead of italic.
        # We must skip the next iteration if it is an asterisk because we already checked it.
        elif char == "*" and i+1 < size and line[i+1] == "*":
            bold_start_index = i
            should_skip = True
        elif char == "*":
            italic_start_index = i
        # No special syntax
        else:
            output += char
    
    if heading > 0:
        output = f'<font size="{HEADING_MAP[heading]}">' + output + "</font>"
    if heading < 0:
        append_hash = '#' * -heading
        output = append_hash + output

    return output

if len(sys.argv) < 3:
    print("Error: must specify input and output file.")
    print("Usage:")
    print("md-to-rich-text <input file path> <output file path>")

input_file = sys.argv[1]
output_file = sys.argv[2]

output = ""

start = time.perf_counter()

with open(input_file, "r") as file:
    # Placeholder so that line isn't an empty string, but also isn't empty
    # so that the while loop isn't skipped.
    line = "\n"
    while line != "":
        line = file.readline()
        line = line.rstrip("\n")
        output += parse_line(line)
        output += "\n"

with open(output_file, "w") as out:
    out.write(output)

end = time.perf_counter()
print(f"Parsing and writing to file complete, took {(end - start) * 1000} ms.")