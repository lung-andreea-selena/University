import unittest
import tokens

class TestTokens(unittest.TestCase):
    def test_get_tokens(self):
        # Create a temporary file with sample tokens
        token_filename = 'test_tokens.txt'
        with open(token_filename, 'w') as f:
            f.write("if\nelse\nwhile\nreturn\n")

        # Load tokens and check results
        result_tokens = tokens.get_tokens(token_filename)
        expected_tokens = {"if": -1, "else": -1, "while": -1, "return": -1}

        self.assertEqual(result_tokens, expected_tokens)

        # Clean up
        import os
        os.remove(token_filename)
