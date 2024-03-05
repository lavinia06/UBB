class Grammar:
    def __init__(self):
        self.nonterminals = set()
        self.terminals = set()
        self.productions = {}
        self.start_symbol = None

    def read_grammar_from_file(self, file_path):
        with open(file_path, 'r') as file:
            lines = file.readlines()

        for line in lines:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            if line.startswith('N ='):
                self.nonterminals = set(line.split('=')[1].strip().split())
            elif line.startswith('E ='):
                self.terminals = set(line.split('=')[1].strip().split())
            elif line.startswith('S ='):
                self.start_symbol = line.split('=')[1].strip()
            elif line.startswith('P ='):
                productions = lines[lines.index(line) + 1:]
                self.read_productions(productions)

    def read_productions(self, productions):
        for prod in productions:
            prod = prod.strip()
            if not prod or prod.startswith('#'):
                continue

            left, right = prod.split('->')
            left = left.strip()
            right = right.strip()

            if left not in self.productions:
                self.productions[left] = []

            self.productions[left].append(right)

    def print_set(self, name, items):
        print(f"{name}: {', '.join(items)}")

    def print_productions_for_nonterminal(self, nonterminal):
        if nonterminal in self.productions:
            productions = self.productions[nonterminal]
            for prod in productions:
                print(f"{nonterminal} -> {prod}")

    def print_grammar_info(self):
        self.print_set("Nonterminals", self.nonterminals)
        self.print_set("Terminals", self.terminals)
        print(f"Start Symbol: {self.start_symbol}")
        print("\nProductions:")
        for nonterminal in self.productions:
            self.print_productions_for_nonterminal(nonterminal)
        print("\nCFG Check:", "Valid" if self.check_cfg() else "Invalid")

    def check_cfg(self):
        # Add your CFG validation logic here
        # For LL(1) parsing, you need to check if the grammar is left-factored and has no left recursion.
        return True


# Example usage
if __name__ == "__main__":
    grammar = Grammar()
    grammar.read_grammar_from_file("g1.txt")  # Provide the path to your input file
    grammar.print_grammar_info()