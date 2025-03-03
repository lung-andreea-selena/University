
from finiteStateMachine import FiniteStateMachine
from transition import Transition


def split_line(words, line):
    while line:
        word, _, line = line.partition(',')
        words.append(word)


def read_from_file(file_name):
    alphabet = []
    states = []
    initial_state = ""
    final_states = []
    transitions = []

    with open(file_name, "r") as fin:
        split_line(alphabet, fin.readline().strip())
        split_line(states, fin.readline().strip())
        initial_state = fin.readline().strip()
        split_line(final_states, fin.readline().strip())

        for line in fin:
            source_state, line = line.split(",", 1)
            destination_state, value = line.split(",", 1)
            transitions.append(Transition(source_state, destination_state, value.strip()))

    return alphabet, states, initial_state, final_states, transitions


def print_states(finite_state_machine):
    print("States:", " ".join(finite_state_machine.get_states()))


def print_alphabet(finite_state_machine):
    print("Alphabet:", " ".join(finite_state_machine.get_alphabet()))


def print_transitions(finite_state_machine):
    print("Transitions:")
    for transition in finite_state_machine.get_transitions():
        print("   ", transition.get_source_state(), transition.get_destination_state(), transition.get_value())


def print_final_states(finite_state_machine):
    print("Final states:", " ".join(finite_state_machine.get_final_states()))


def check_sequence(finite_state_machine):
    sequence = input("Verified sequence: ")
    if finite_state_machine.check_sequence(sequence):
        print("Valid sequence")
    else:
        print("Invalid sequence")



def print_commands():
    print("Options:")
    print("   0 - Exit")
    print("   1 - States")
    print("   2 - Alphabet")
    print("   3 - Transitions")
    print("   4 - Final states")
    print("   5 - Verify the validity of sequence")


if __name__ == "__main__":
    file_name = "constants.txt"
    alphabet, states, initial_state, final_states, transitions = read_from_file(file_name)

    finite_state_machine = FiniteStateMachine(alphabet, states, initial_state, transitions, final_states)
    while True:
        print_commands()
        command = int(input("-> "))
        if command == 0:
            exit(0)
        elif command == 1:
            print_states(finite_state_machine)
        elif command == 2:
            print_alphabet(finite_state_machine)
        elif command == 3:
            print_transitions(finite_state_machine)
        elif command == 4:
            print_final_states(finite_state_machine)
        elif command == 5:
            check_sequence(finite_state_machine)
        else:
            print("Invalid command!")
            exit(0)
        print("\n")
