import unittest

from Grammar import Grammar


class TestGrammarMethods(unittest.TestCase):

    def setUp(self):
        # You can initialize your Grammar object here for testing
        self.grammar = Grammar()

    def test_first_terminal(self):
        self.grammar.non_terminals = ['A']
        self.grammar.terminals = ['a']
        self.grammar.productions = {'A': [['a']]}
        result = self.grammar.FIRST('A')
        self.assertEqual(result, {'a'})

    def test_first_non_terminal(self):
        self.grammar.non_terminals = ['A', 'B']
        self.grammar.terminals = ['a']
        self.grammar.productions = {'A': [['B']], 'B': [['a']]}
        result = self.grammar.FIRST('A')
        self.assertEqual(result, {'a'})

    def test_first_epsilon(self):
        self.grammar.non_terminals = ['A', 'B']
        self.grammar.terminals = ['a']
        self.grammar.productions = {'A': [['B']], 'B': [['epsilon']]}
        result = self.grammar.FIRST('A')
        self.assertEqual(result, set())

    def test_follow_terminal(self):
        self.grammar.non_terminals = ['A']
        self.grammar.terminals = ['a']
        self.grammar.productions = {'A': [['a']]}
        self.grammar.starting_nt = 'A'
        result = self.grammar.FOLLOW('A')
        self.assertEqual(result, {'$'})

    def test_follow_non_terminal(self):
        self.grammar.non_terminals = ['A', 'B']
        self.grammar.terminals = ['a']
        self.grammar.productions = {'A': [['B']], 'B': [['a']]}
        self.grammar.starting_nt = 'A'
        result = self.grammar.FOLLOW('B')
        self.assertEqual(result, {'$'})

    def test_follow_epsilon(self):
        self.grammar.non_terminals = ['A', 'B']
        self.grammar.terminals = ['a']
        self.grammar.productions = {'A': [['B']], 'B': [['epsilon']]}
        self.grammar.starting_nt = 'A'
        result = self.grammar.FOLLOW('B')
        self.assertEqual(result, {'$'})

if __name__ == '__main__':
    unittest.main()