import unittest
import os
from symbolTable import SymbolTable, getST
import tokens

class TestSymbolTable(unittest.TestCase):
    def setUp(self):
        # Sample tokens dictionary
        self.tokens = {'float': 'FLOAT', 'integer': 'INT', 'string': 'STRING'}

    def test_getST_empty_code(self):
        # Test for empty code input
        st_var, st_const, exception = getST("", self.tokens)
        self.assertEqual(st_var.binarySearchTree.root, None)
        self.assertEqual(st_const.binarySearchTree.root, None)
        self.assertIsNone(exception)

    def test_getST_with_variables_and_constants(self):
        # Code containing both variables and constants
        code = 'float x = 10\ninteger y = 20\nstring name = "John"'
        st_var, st_const, exception = getST(code, self.tokens)

        # Use a temporary file to capture in-order traversal output for variables
        temp_var_file = 'temp_var.txt'
        st_var.binarySearchTree.inorder_traversal_write(temp_var_file)
        with open(temp_var_file, 'r') as f:
            variables = f.read()

        # Check that variable names appear in the file
        self.assertIn('x', variables)
        self.assertIn('y', variables)
        self.assertIn('name', variables)

        # Use another temporary file for constants
        temp_const_file = 'temp_const.txt'
        st_const.binarySearchTree.inorder_traversal_write(temp_const_file)
        with open(temp_const_file, 'r') as f:
            constants = f.read()

        # Check that constants appear in the file
        self.assertIn('10', constants)
        self.assertIn('20', constants)
        self.assertIn('John', constants)

        # Clean up temporary files
        os.remove(temp_var_file)
        os.remove(temp_const_file)

        self.assertIsNone(exception)

