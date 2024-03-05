from collections import defaultdict
from ParseTreeNode import ParseTreeNode
from Grammar import Grammar

class ParserOutput:
    def __init__(self, parse_tree_root):
        self.parse_tree_root = parse_tree_root

    def transform_parsing_tree(self):
        return str(self.parse_tree_root)

    def print_to_screen(self):
        if self.parse_tree_root:
            print(self.parse_tree_root)

    def print_to_file(self, filename):
        if self.parse_tree_root:
            with open(filename, 'w') as file:
                file.write(str(self.parse_tree_root))