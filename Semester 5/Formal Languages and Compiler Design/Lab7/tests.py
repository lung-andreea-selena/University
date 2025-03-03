import unittest
from parser import ParserOutput  # Replace with the correct import path


class TestParserOutput(unittest.TestCase):

    def setUp(self):
        # Initialize the ParserOutput object before each test
        self.parser_output = ParserOutput()
        self.parser_output.generate_from_grammar()

    def test_states_table(self):
        # Check if the states table is generated
        self.assertGreater(len(self.parser_output.states_table), 0, "States Table is empty.")

    def test_transitions_table(self):
        # Check if the transitions table is generated
        self.assertGreater(len(self.parser_output.transitions_table), 0, "Transitions Table is empty.")

    def test_action_table(self):
        # Check if the action table contains expected keys
        self.assertIn(0, self.parser_output.action_table, "Action Table does not contain state 0.")
        self.assertIn('$', self.parser_output.action_table[1], "Action Table does not contain accept action.")

    def test_goto_table(self):
        # Check if the goto table contains expected keys
        self.assertIn(0, self.parser_output.goto_table, "Goto Table does not contain state 0.")
        self.assertIn('A', self.parser_output.goto_table[0], "Goto Table does not contain non-terminal 'A'.")

    def test_conflict_detection(self):
        # Ensure no conflicts exist in the action table for this grammar
        for state, actions in self.parser_output.action_table.items():
            for symbol, entries in actions.items():
                self.assertFalse(
                    isinstance(entries, list) and len(entries) > 1,
                    f"Conflict detected in State {state}, Symbol '{symbol}': {entries}"
                )


    def test_file_outputs(self):
        # Check if outputs are saved to files
        self.parser_output.save_parsing_tree_to_file("test_parsing_tree.txt")
        self.parser_output.save_to_file("test_parser_output.txt")

        # Verify the files exist and are not empty
        with open("test_parsing_tree.txt", "r") as file:
            self.assertGreater(len(file.read()), 0, "Parsing Tree file is empty.")

        with open("test_parser_output.txt", "r") as file:
            self.assertGreater(len(file.read()), 0, "Parser Output file is empty.")


if __name__ == '__main__':
    unittest.main()
