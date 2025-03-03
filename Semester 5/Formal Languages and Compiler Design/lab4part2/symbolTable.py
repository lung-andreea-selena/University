from BST import BinarySearchTree
import re

from finiteStateMachine import FiniteStateMachine


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


def getVariables(fsm: FiniteStateMachine, cod: str):
    variables = []
    lines = cod.split('\n')
    for line in lines:
        words = line.split()
        while len(words)> 1:
            first = words[0]
            second = words[1]
            if first == "float" or first == "integer" or first == "string" or first == "double":
                if fsm.check_sequence(second) is True:
                    variables.append(second)
            words.pop(0)
    return variables

def getNumbers(fsm: FiniteStateMachine, cod: str):
    numbers = []
    lines = cod.split('\n')
    for line in lines:
        words = line.split()
        while len(words)> 1:
            first = words[0]
            second = words[1]
            if first == "=" or first == "+" or first == "-" or first == "==" or first == "<" or first == ">" or first == "<=" or first == ">=" or first == "!=" or first == "%" or first == "*":
                if fsm.check_sequence(second) is True:
                    numbers.append(second)
            words.pop(0)
    return numbers

def getStrings(fsm: FiniteStateMachine, cod: str):
    strings = []
    lines = cod.split('\n')
    for line in lines:
        words = line.split()
        while len(words)> 1:
            first = words[0]
            second = words[1]
            if first == "==" or first == "=":
                if fsm.check_sequence(second) is True:
                    strings.append(second)
            words.pop(0)
    return strings



def getST(cod: str, tokens : dict):
    # we get the variables by using regex
    # \s is for whitespaces
    #pattern_variables = r'\b(float|integer|string|double)\s+(\w+)\b'

    var_alphabet = []
    var_states = []
    var_initial_state = ""
    var_final_states = []
    var_transitions = []
    variable_fsm = FiniteStateMachine(var_alphabet, var_states, var_initial_state, var_final_states, var_transitions)
    variable_fsm.read_from_file("variables.txt")
    variables = getVariables(variable_fsm, cod)

    #variables = re.findall(pattern_variables, cod)
    #print(variables)
    #variables = [var[1] for var in variables]

    exception = None

    # remove reserved keywords from the variable list
    for var in variables:
        if var in tokens.keys():
            variables.remove(var)

    st_var = SymbolTable()
    for var in variables:
        st_var.add_symbol(var)

    # the constants can be real numbers or strings
    #pattern_constants = r'(\+|-|=|<|>|==|<=|>=|!=|\*|%|\\)\s+(\d+\.*\d*)'
    int_alphabet = []
    int_states = []
    int_initial_state = ""
    int_final_states = []
    int_transitions = []
    integer_fsm = FiniteStateMachine(int_alphabet, int_states, int_initial_state, int_final_states, int_transitions)
    integer_fsm.read_from_file("real.txt")
    integers = getNumbers(integer_fsm, cod)

    #pattern_strings = r'(=|==)\s+"([^"]*)"'
    # finding strings
    string_alphabet = []
    string_states = []
    string_initial_state = ""
    string_final_states = []
    string_transitions = []
    string_fsm = FiniteStateMachine(string_alphabet, string_states, string_initial_state, string_final_states, string_transitions)
    string_fsm.read_from_file("strings.txt")
    strings = getStrings(string_fsm, cod)

    # constants = re.findall(pattern_constants, cod)
    # constants = [c[1] for c in constants]

    # strings = re.findall(pattern_strings, cod)
    # strings = [s[1] for s in strings]

    constants = integers + strings

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