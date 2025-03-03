import unittest
from BST import BinarySearchTree

class TestBinarySearchTree(unittest.TestCase):
    def setUp(self):
        self.bst = BinarySearchTree()
        self.bst.insert(10)
        self.bst.insert(5)
        self.bst.insert(15)
        self.bst.insert(3)
        self.bst.insert(7)
        self.bst.insert(12)
        self.bst.insert(17)

    def test_insert(self):
        self.assertEqual(self.bst.root.key, 10)
        self.assertEqual(self.bst.root.left.key, 5)
        self.assertEqual(self.bst.root.right.key, 15)

    def test_get_index(self):
        self.assertEqual(self.bst.get_index(10), 3)  # Root element
        self.assertEqual(self.bst.get_index(3), 0)  # Leftmost element
        self.assertEqual(self.bst.get_index(7), 2)  # Right child of left node
        self.assertEqual(self.bst.get_index(12), 4)  # Left child of the right node

    def test_get_index_non_existent(self):
        self.assertIsNone(self.bst.get_index(20))

    def test_get_element_from_index(self):
        # Test getting elements by index
        self.assertEqual(self.bst.get_element_from_index(0), 3)  # Leftmost element
        self.assertEqual(self.bst.get_element_from_index(1), 5)  # Parent of left subtree
        self.assertEqual(self.bst.get_element_from_index(3), 10)  # Root element
        self.assertEqual(self.bst.get_element_from_index(6), 17)  # Rightmost element

    def test_get_element_from_index_out_of_bounds(self):
        self.assertIsNone(self.bst.get_element_from_index(7))  # Index too high

    def test_inorder_traversal_print(self):
        import io
        import sys

        # Save the current stdout
        captured_output = io.StringIO()  # Create a StringIO buffer to capture output
        sys_stdout = sys.stdout  # Backup the real stdout

        try:
            sys.stdout = captured_output  # Redirect stdout to the StringIO buffer
            self.bst.inorder_traversal_write()
            sys.stdout = sys_stdout  # Reset stdout back to its original value

            # Define expected output
            expected_output = "0 : 3\n1 : 5\n2 : 7\n3 : 10\n4 : 12\n5 : 15\n6 : 17\n"
            self.assertEqual(captured_output.getvalue(), expected_output)

        finally:
            # Ensure stdout is always reset back to normal, even if the test fails
            sys.stdout = sys_stdout

if __name__ == '__main__':
    unittest.main()