from transition import Transition


class FiniteStateMachine:
    def __init__(self, alphabet, states, initial_state, transitions, final_states):
        self.alphabet = alphabet
        self.states = states
        self.initial_state = initial_state
        self.transitions = transitions
        self.final_states = final_states

    def get_alphabet(self):
        return self.alphabet

    def get_transitions(self):
        return self.transitions

    def get_final_states(self):
        return self.final_states

    def get_states(self):
        return self.states

    def check_sequence(self, sequence):
        prefix = ""
        current_state = self.initial_state
        # check if the full sequence that is entered takes you from init state to a final state
        while sequence:
            found = False
            for transition in self.transitions:
                if (
                    transition.get_source_state() == current_state
                    and transition.get_value() == sequence[: len(transition.get_value())]
                ):
                    prefix += transition.get_value()
                    sequence = sequence[len(transition.get_value()) :]
                    current_state = transition.get_destination_state()
                    found = True
                    break
            if not found:
                return False

        if current_state in self.final_states:
            return True

        return False

    def split_line(self, words, line):
        while line:
            word, _, line = line.partition(',')
            words.append(word)

    def read_from_file(self, file_name):
        alphabet = []
        states = []
        initial_state = ""
        final_states = []
        transitions = []

        with open(file_name, "r") as fin:
            self.split_line(alphabet, fin.readline().strip())
            self.split_line(states, fin.readline().strip())
            initial_state = fin.readline().strip()
            self.split_line(final_states, fin.readline().strip())

            for line in fin:
                source_state, line = line.split(",", 1)
                destination_state, value = line.split(",", 1)
                transitions.append(Transition(source_state, destination_state, value.strip()))

        self.alphabet = alphabet
        self.states = states
        self.initial_state = initial_state
        self.final_states = final_states
        self.transitions = transitions