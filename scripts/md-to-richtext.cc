// Markdown to Robox rich text compiler.
// Note that this is C++, not Luau, which means that we are
// dealing with an incompetent compiler (MSVC, GCC, LLVM, whatever,
// they are all equally bad), so do not mess with this.
#include <iostream>
#include <chrono>
#include <fstream>
#include <unordered_map>
#include <string>
#define ANSI_RED   "\e[0;31m"
#define ANSI_RESET "\e[0m"

// Yes I'm too lazy to type std::string.
using std::string;
using namespace std::chrono;
typedef unsigned char uchar;

const std::unordered_map<uchar, uchar> HEADING_MAP = {
    {1, 32},
    {2, 24},
    {3, 20},
    {4, 16},
    {5, 14},
    {6, 12}
};

// There should be concepts to prevent the compiler from
// throwing template instantiation jargon, but then I
// realised that nobody is stupid enough to pass random
// nonsense to the print function... right?
template <typename T>
void print(T input)
{
    std::cout << input << "\n";
}

// When this function is called, note that it is entirely
// the user's fault. We are not sorry for what the user has
// done; it is the user's problem. We are not dealing with
// whatever ritual the user did to cause the error.
template <typename T>
void error(T input)
{
    std::cerr << input << "\n";
}

string parse_line(string& line)
{
    string output = "";
    size_t size = line.length();
    int hashes = 0;
    int italic_start_index = -1;
    int bold_start_index = -1;
    int heading = 0;
    bool should_skip = false;
    bool is_list = false;

    for (int i = 0; i < line.length(); i++)
    {
        if (should_skip)
        {
            should_skip = false;
            continue;
        }
        char ch = line[i];
        if (ch == '-' && i == 0 && size > 2 && line[i+1] == ' ')
        {
            is_list = true;
        }
        if (ch == '#' && hashes < 6 && (hashes > 0 || i == 0))
        {
            hashes++;
        }
        else if (ch == ' ' && hashes > 0)
        {
            heading = hashes;
            hashes = 0;
        }
        else if (hashes > 0)
        {
            heading = -hashes;
            hashes = 0;
            output += ch;
        }
        else if (ch == '*' && italic_start_index != -1)
        {
            output = output.substr(0, italic_start_index) + "<i>" + output.substr(italic_start_index) + "</i>";
            italic_start_index = -1;
        }
        else if (ch == '*' && i+1 < size && line[i+1] == '*' && bold_start_index != -1)
        {
            output = output.substr(0, bold_start_index) + "<b>" + output.substr(bold_start_index) + "</b>";
        }
        else if (ch == '*' && i+1 < size && line[i+1] == '*')
        {
            bold_start_index = i;
            should_skip = true;
        }
        else if (ch == '*')
        {
            italic_start_index = i;
        }
        else
        {
            output += ch;
        }
    }

    if (heading > 0)
    {
        output = "<font size=\"" + std::to_string(HEADING_MAP.at(heading)) + "\">"+ output + "</font>";
    }
    if (heading < 0)
    {
        heading = -heading;
        string append_hash = "";
        for (int i = 0; i < heading; i++)
        {
            append_hash += "#";
        }
        output = append_hash + output;
    }

    if (is_list)
    {
        output = "  • " + output;
    }

    return output;
}

int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        print(ANSI_RED "error: " ANSI_RESET "input and/or output file not included.");
        print("Usage: md-to-richtext <input file> [output file]");
        print("If output file is not supplied, the output will instead be printed to standard output.");
        return 1;
    }

    auto start = high_resolution_clock::now();
    std::ifstream in_file(argv[1]);
    string line;
    if (!in_file.is_open())
    {
        error("error: failed opening input file.");
        return 1;
    }

    string output = "";
    while (std::getline(in_file, line))
    {
        output += parse_line(line) + "\n";
    }

    in_file.close();
    if (argc == 2)
    {
        print(output);
    }
    else
    {
        std::ofstream out_file(argv[2]);
        if (!out_file.is_open())
        {
            error("error: failed opening output file.");
            return 1;
        }

        out_file << output;
        out_file.close();
    }

    auto end = high_resolution_clock::now();
    duration<double, std::milli> ms = end - start;
    print("Parsing and writing complete, took " + std::to_string(ms.count()) + "ms");
    return 0;
}