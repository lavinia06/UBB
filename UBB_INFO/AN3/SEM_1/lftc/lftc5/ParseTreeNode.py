class ParseTreeNode:
    def __init__(self, value, father=None, sibling=None):
        self.value = value
        self.father = father
        self.sibling = sibling
        self.children = []

    def add_child(self, child):
        self.children.append(child)

    def __str__(self, level=0):
        result = "\t" * level + f"Value: {self.value}\n"
        for child in self.children:
            result += child.__str__(level + 1)
        return result

    def add_sibling(self, sibling):
        if self.sibling is None:
            self.sibling = sibling
        else:
            self.sibling.add_sibling(sibling)