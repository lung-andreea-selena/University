from src.repository.reposit import *
from src.services.service import ComplexService
from src.ui.ui import ComplexUI


def run_for_repo():
    while True:
        print('Choose the repo you want to work with: memory, textfile or binary')
        repo_use = input('Repository=')
        if repo_use == 'memory':
            repo = ComplexMemoryRepo()
            break
        elif repo_use == 'textfile':
            repo = ComplexTextRepo()
            break
        elif repo_use == 'binary':
            repo = ComplexBinaryRepo()
            break
        else:
            print('The repository is not valid')
    service = ComplexService(repo)
    ui = ComplexUI(service)
    ui.run()


run_for_repo()
