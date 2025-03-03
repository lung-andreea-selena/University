from symbolTable import SymbolTable


def getPIF(code: str, tokens: dict, st_var: SymbolTable, st_const : SymbolTable):
    lines = code.split('\n')
    line_number = 0
    error_found = False
    pif = [] # list of pairs
    exception = None
    for line in lines:
        line_number += 1
        words = line.split()
        for word in words:
            if word in tokens.keys():
                pif.append((word, tokens[word]))
            elif st_const.get_index_from_symbol(word.replace('"', '')) != None or st_var.get_index_from_symbol(word) != None:
                if word[0].isalpha(): #if first character is alpha, then it's a variable, if it's a number or " then it's a constant
                    pif.append(("ID", st_var.get_index_from_symbol(word)))
                else:
                    pif.append(("CONST", st_const.get_index_from_symbol(word)))
            else:
                print(f"Lexical error at line {line_number}: Invalid token - {word}")
                error_found = True

    if not error_found:
        print("Lexically correct")

    return pif, exception