def get_tokens(filename: str):
    tokens = {}
    with open(filename, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        for line in lines:
            line = line.replace('\n', '')
            line = line.replace(" ", '')
            tokens[line] = -1
    return tokens
