// Markdown to Robox rich text compiler.
#include <iostream>
#include <chrono>
#include <fstream>
#include <unordered_map>
#include <string>
#define ANSI_RED   "\e[0;31m"
#define ANSI_RESET "\e[0m"

using std::string;
using namespace std::chrono;

template <typename T>
void print(T input)
{
    std::cout << input << "\n";
}

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
    }
}

int main(int argc, char* argv[])
{
    if (argc < 3)
    {
        print(ANSI_RED "error: " ANSI_RESET "input and/or output file not included.");
        print("Usage: md-to-richtext <input file> <output file>");
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
        output += parse_line(line);
    }

    in_file.close();
    std::ofstream out_file(argv[2]);
    if (!out_file.is_open())
    {
        error("error: failed opening output file.");
        return 1;
    }

    out_file << output;
    auto end = high_resolution_clock::now();
    duration<double, std::milli> ms = end - start;
    print(std::to_string(ms.count()) + "ms");
    return 0;
}