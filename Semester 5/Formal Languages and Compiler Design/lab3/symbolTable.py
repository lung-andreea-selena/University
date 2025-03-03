from BST import BinarySearchTree
import re

class SymbolTable:
    def __init__(self):
        self.binarySearchTree = BinarySearchTree()

    def add_symbol(self, symbol):
        self.binarySearchTree.insert(symbol)

    def get_symbol_from_index(self,index):
        return self.binarySearchTree.get_element_from_index(index)

    def get_index_from_symbol(self, symbol):
        return self.binarySearchTree.get_index(symbol)

    def write_symbol_table(self, filename):
        self.binarySearchTree.inorder_traversal_write(filename)


def getST(cod: str, tokens : dict):
    # we get the variables by using regex
    # \s is for whitespaces
    pattern_variables = r'\b(float|integer|string|double)\s+(\w+)\b'

    variables = re.findall(pattern_variables, cod)
    #print(variables)
    variables = [var[1] for var in variables]

    exception = None

    # remove reserved keywords from the variable list
    for var in variables:
        if var in tokens.keys():
            variables.remove(var)

    st_var = SymbolTable()
    for var in variables:
        st_var.add_symbol(var)

    # the constants can be real numbers or strings
    pattern_constants = r'(\+|-|=|<|>|==|<=|>=|!=|\*|%|\\)\s+(\d+\.*\d*)'
    pattern_strings = r'(=|==)\s+"([^"]*)"'

    constants = re.findall(pattern_constants, cod)
    constants = [c[1] for c in constants]

    strings = re.findall(pattern_strings, cod)
    strings = [s[1] for s in strings]

    constants = constants + strings

    # remove reserved keywords from the constants list
    for c in constants:
        if c in tokens.keys():
            constants.remove(c)
        elif c in variables:
            constants.remove(c)

    constants = set(constants)

    st_const = SymbolTable()
    for c in constants:
        st_const.add_symbol(c)

    return st_var, st_const, exception