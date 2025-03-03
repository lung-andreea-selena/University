from ParserOutput import ParserOutput
from grammar import Grammar

#grammar = Grammar()
#grammar.read_from_file('g1.txt')

# Print basic grammar info
#grammar.print_non_terminals()
#grammar.print_terminals()
#grammar.print_productions()

# LR(0) Functions
#states, transitions = grammar.canonical_collection()
#print("Canonical Collection of LR(0) Items:")
#for i, state in enumerate(states):
 #   print(f"State {i}: {state}")
#print("\nTransitions:")
#for (state, symbol), target_state in transitions.items():
 #   print(f"{state} --{symbol}--> {target_state}")

if __name__ == "__main__":
    from grammar import Grammar

    # Initialize the grammar
    grammar = Grammar()
    grammar.read_from_file("g1.txt")  # Adjust to your file

    # Create and populate the ParserOutput
    parser_output = ParserOutput()
    parser_output.generate_from_grammar(grammar)

    # Build Parsing Tree (Provide the parse sequence as an example)
    parse_sequence = ["r1", "r2", "r3"]  # Replace with actual sequence
    parser_output.build_parsing_tree(parse_sequence, grammar)

    # Print Parsing Tree
    parser_output.print_parsing_tree()
    parser_output.save_parsing_tree_to_file()

    # Print other outputs
    parser_output.print_to_screen()
    parser_output.save_to_file()
