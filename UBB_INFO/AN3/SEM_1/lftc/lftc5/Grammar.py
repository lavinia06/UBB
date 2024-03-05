class Grammar:
    EPSILON = "epsilon"
    STARTING_SYMBOL = "S'"

    def __init__(self, is_enhanced=False):
        self.non_terminals = []
        self.terminals = []
        self.starting_nt = ""
        self.productions = {}
        self.is_enhanced = is_enhanced

    def check_if_grammar_is_enhanced(self):
        # check that the starting symbol has only one production
        if len(self.productions[self.starting_nt]) != 1:
            return False
        # check that the starting symbol does not appear on the right hand side of any production
        for production in self.productions.values():
            for rhs in production:
                if self.starting_nt in rhs:
                    return False
        return True

    def make_enhanced_grammar(self):
        if not self.is_enhanced:
            # add a new non-terminal symbol S'
            self.non_terminals.append(Grammar.STARTING_SYMBOL)
            # add a new production S' -> S
            self.productions[Grammar.STARTING_SYMBOL] = [[self.starting_nt]]
            self.starting_nt = Grammar.STARTING_SYMBOL
            self.is_enhanced = True

    def FIRST(self, symbol):
        if symbol in self.terminals:
            return {symbol}
        elif symbol in self.non_terminals:
            first_set = set()
            for production in self.productions[symbol]:
                for current_symbol in production:
                    first_set |= (set(self.FIRST(current_symbol)) - {self.EPSILON})
                    if self.EPSILON not in self.FIRST(current_symbol):
                        break
                else:
                    # This else clause is executed if the inner loop completes without hitting a break
                    if self.EPSILON in self.FIRST(current_symbol):
                        first_set.add(self.EPSILON)
            return first_set
        else:
            return {symbol}  # For terminals

    def FOLLOW(self, symbol, processing=None):
        if processing is None:
            processing = set()

        if symbol == self.starting_nt:
            return {'$'}

        follow_set = set()

        if symbol not in self.non_terminals:
            return follow_set  # For terminals

        if symbol in processing:
            return follow_set  # Avoid infinite recursion

        processing.add(symbol)

        for nonterminal in self.non_terminals:
            for production in self.productions[nonterminal]:
                for i, current_symbol in enumerate(production):
                    if current_symbol == symbol:
                        if i < len(production) - 1:
                            follow_set |= self.FIRST(production[i + 1]) - {self.EPSILON}
                            if self.EPSILON in self.FIRST(production[i + 1]):
                                follow_set |= self.FOLLOW(nonterminal, processing)
                        elif nonterminal != symbol:
                            follow_set |= self.FOLLOW(nonterminal, processing)

        processing.remove(symbol)

        return follow_set

    @staticmethod
    def __process_line(line: str):
        # Get what comes after the '='
        return line.strip().split(' ')[2:]

    def read_from_file(self, file_name: str):
        with open(file_name) as file:
            N = self.__process_line(file.readline())
            E = self.__process_line(file.readline())
            S = self.__process_line(file.readline())[0]

            file.readline()  # P =
            # Get all transitions
            P = {}
            for line in file:
                split = line.strip().split('->')
                source = split[0].strip()
                sequence = split[1].lstrip(' ')
                sequence_list = []
                for c in sequence.split(' '):
                    sequence_list.append(c)

                if source in P.keys():
                    P[source].append(sequence_list)
                else:
                    P[source] = [sequence_list]

            self.non_terminals = N
            self.terminals = E
            self.starting_nt = S
            self.productions = P

    def check_cfg(self):
        has_starting_symbol = False
        for key in self.productions.keys():
            if key == self.starting_nt:
                has_starting_symbol = True
            if key not in self.non_terminals:
                return False
        if not has_starting_symbol:
            return False
        for production in self.productions.values():
            for rhs in production:
                for value in rhs:
                    if value not in self.non_terminals and value not in self.terminals and value != Grammar.EPSILON:
                        return False
        return True


    def cfg_check(self):
        return not any([elem for elem in self.productions.keys() if len(elem) > 1])


    def __str__(self):
        result = "Non-terminals = " + str(self.non_terminals) + "\n"
        result += "Terminals = " + str(self.terminals) + "\n"
        result += "Starting non-terminal = " + str(self.starting_nt) + "\n"
        result += "Productions = " + str(self.productions) + "\n"
        return result