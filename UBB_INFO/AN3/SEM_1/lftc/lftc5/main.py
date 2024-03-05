from Grammar import Grammar
from Parser import Parser, ParserOutput

def menu(gr, parser):
    while True:
        inp = input(">")
        if inp == "1":
            print(gr.non_terminals)
        elif inp == "2":
            print(gr.terminals)
        elif inp == "3":
            print(gr.starting_nt)
        elif inp == "4":
            print(gr.productions)
        elif inp == "5":
            print(gr.cfg_check())
        elif inp == "6":
            print_parsing_table(parser)
        elif inp == "7":
            parse_input_and_print_tree(parser)
        elif inp == "0":
            break
        else:
            print("Invalid action!")

def print_menu():
    print("1. Print the set of non-terminals\n"
          "2. Print the set of terminals\n"
          "3. Print the starting non-terminal\n"
          "4. Print the productions\n"
          "5. Check if the grammar is context-free\n"
          "6. Print the parsing table\n"
          "7. Parse input and print parse tree\n"
          "0. Exit\n\n")

def print_parsing_table(parser):
    print("Parsing Table:")
    for nonterminal, row in parser.parsing_table.items():
        for terminal, production in row.items():
            print(f"{nonterminal} -> {terminal}: {production}")

def parse_input_and_print_tree(parser, input_filename):
    try:
        with open(input_filename, 'r') as file:
            input_string = file.read()
    except FileNotFoundError:
        print(f"Error: File '{input_filename}' not found.")
        return

    success = parser.parse(input_string)

    if success:
        print("Parse Tree:")
        parser.print_parse_tree()
        parser_output = ParserOutput(parser.current_parse_tree_node)
        parser_output.print_to_screen()

        # Additional option: Save parse tree to a file
        save_to_file = input("Do you want to save the parse tree to a file? (y/n): ").lower()
        if save_to_file == "y":
            filename = input("Enter the filename: ")
            parser_output.print_to_file(filename)

if __name__ == '__main__':
    # Read the grammar from the file
    g = Grammar()
    g.read_from_file("g1.in")

    # Make the grammar enhanced
    g.make_enhanced_grammar()

    # Create and generate the parser
    parser = Parser(g)
    parser.generate_parsing_table()

    # Specify the input file
    input_file = "g1.in"

    # Parse input from file
    parse_input_and_print_tree(parser, input_file)
