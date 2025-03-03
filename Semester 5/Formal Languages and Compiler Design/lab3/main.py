from PIF import getPIF
from symbolTable import SymbolTable, getST
from tokens import get_tokens

tokens = get_tokens('tokens.txt')

with open('p1.txt', 'r', encoding='utf-8') as f:
    cod = f.read()

st_var, st_const, exception = getST(cod, tokens)

# Write the ST
st_var.write_symbol_table("STvar.out")
st_const.write_symbol_table("STconst.out")

pif, exception2 = getPIF(cod, tokens, st_var, st_const)

# Write the PIF table
pif_file = open("PIF.out", "w", encoding='utf-8')
for pair in pif:
    pif_file.write(str(pair[0]) + " | " + str(pair[1]) + '\n')

if exception != None:
    raise exception

if exception2 != None:
    raise exception2
