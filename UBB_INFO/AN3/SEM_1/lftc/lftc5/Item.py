class Item:
    def __init__(self, lhs: str, rhs: list, lookahead: str):
        self.lhs = lhs
        self.rhs = rhs
        self.lookahead = lookahead

    def __eq__(self, other):
        return self.rhs == other.rhs and \
               self.lhs == other.lhs and \
               self.lookahead == other.lookahead

    def __str__(self):
        result = f"[{self.lhs} -> {' '.join(self.rhs)}, {self.lookahead}]"
        return result