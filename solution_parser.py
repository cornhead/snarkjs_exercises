#!/usr/bin/python3

import sys
import re

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def usage():
    eprint('Usage: solution_parser [command] [arguments]')
    eprint('')
    eprint('Available Commands:')
    eprint('\texercises\tParse input to create exercise circom files.')
    eprint('\tsolutions\tParse input to create solution circom files.')
    eprint('\t\t\tIf a tag is specified in the arguments, only')
    eprint('\t\t\tsolutions with this tag will be exported.')
    eprint('\thelp\t\tprint this message')
    eprint('')
    eprint('This script reads from stdin and writes to stdout.')
    eprint('Everything between lines "===START SOLUTION==="')
    eprint('and "===END SOLUTION===" will be replaced either with')
    eprint('a todo note to indicate tasks or the given code for solutions.')
    eprint('')
    eprint('To speficy a tag for a solution, use')
    eprint('    ====START SOLUTION: <tag>===')
    eprint('')
    eprint('If a start-solution line and an end-solution line are found')
    eprint('in immediate succession, they are understood as two alternative')
    eprint('solutions of the same task and only one todo statement will be')
    eprint('generated for the `exercises` command.')
    eprint('')
    eprint('Author: Konrad Klier, Nov 2024')

    sys.exit(1)



regex_start = re.compile('===START SOLUTION(:(.*))?===')
regex_end = re.compile('===END SOLUTION===')


def exercises():
    is_in_block = False
    previous_line = ''

    for line in sys.stdin.readlines():
        if regex_start.search(line):
            is_in_block = True
            if not regex_end.search(previous_line):
                print('    // TODO: complete the template')

        elif regex_end.search(line):
            is_in_block = False
        else:
            if not is_in_block:
                print(line, end='')

        previous_line = line


def solutions(tag=None):

    is_in_block = False
    current_tag = None

    for line in sys.stdin.readlines():
        if regex_start.search(line):
            current_tag = regex_start.search(line).group(2)
            if current_tag != None:
                current_tag = current_tag.strip()

            is_in_block = True

        elif regex_end.search(line):
            is_in_block = False
        else:
            if not is_in_block or (is_in_block and (current_tag == tag or current_tag == None)):
                print(line, end='')

def main():
    argc = len(sys.argv)-1
    if argc == 0:
        eprint(f'Error: No command specified')
        usage()

    cmd = sys.argv[1]

    match cmd:
        case 'exercises':
            if argc != 1:
                eprint(f'Error: Command `exercises` expects no arguments, {argc-1} given.')
                usage()

            exercises()

        case 'solutions':
            if argc > 2:
                eprint(f'Error: Command `solutions` expects at most 1 argument, {argc-1} given.')
                usage()

            tag = None
            if argc == 2:
                tag = sys.argv[2]

            solutions(tag)

        case 'help':
            usage()

        case _:
            eprint(f'Error: Unknown command "{cmd}"')
            usage()


if __name__ == '__main__':
    main()
