import unittest

from PIF import getPIF
from symbolTable import SymbolTable

class TestPIF(unittest.TestCase):
    def setUp(self):
        # Define sample tokens and symbol tables
        self.tokens = {'if': 'IF', 'else': 'ELSE', 'while': 'WHILE'}
        self.st_var = SymbolTable()
        self.st_const = SymbolTable()

    def test_getPIF_with_valid_code(self):
        # Sample code input
        code = 'if x < 10 then\nelse y = 20'
        # Add symbols to symbol tables
        self.st_var.add_symbol("x")
        self.st_const.add_symbol("10")
        self.st_var.add_symbol("y")
        self.st_const.add_symbol("20")

        # Generate PIF and validate structure
        pif, exception = getPIF(code, self.tokens, self.st_var, self.st_const)
        expected_pif = [("if", "IF"), ("ID", 0), ("CONST", 0), ("else", "ELSE"), ("ID", 1), ("CONST", 1)]

        self.assertEqual(pif, expected_pif)
        self.assertIsNone(exception)
