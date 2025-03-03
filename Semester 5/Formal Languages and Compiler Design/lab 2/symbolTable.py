from BST import BinarySearchTree
class SymbolTable:
    def __init__(self):
        self.binarySearchTree = BinarySearchTree()

    def add_symbol(self, symbol):
        self.binarySearchTree.insert(symbol)

    def get_symbol_from_index(self,index):
        return self.binarySearchTree.get_element_from_index(index)

    def get_index_from_symbol(self, symbol):
        return self.binarySearchTree.get_index(symbol)

    def print_symbol_table(self):
        self.binarySearchTree.inorder_traversal_print()
