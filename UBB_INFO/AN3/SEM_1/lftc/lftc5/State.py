class State:
    def __init__(self, items):
        self.items = items

    def get_all_symbols_after_dot(self):
        result = set()
        for item in self.items:
            if item.dotPosition < len(item.rhs):
                result.add(item.rhs[item.dotPosition])
        return result

    def __eq__(self, other):
        return set(self.items) == set(other.items)

    def __str__(self):
        result = "State:\n"
        for item in self.items:
            result += f"\t{str(item)}\n"
        return result