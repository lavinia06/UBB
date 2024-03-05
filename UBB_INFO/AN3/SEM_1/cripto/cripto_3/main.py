import math


def is_square(num):
    """Check if a number is a perfect square."""
    root = int(math.sqrt(num))
    return root * root == num


def fermat_factorization(n, B):
    """Generalized Fermat's Factorization Algorithm."""
    k = 1

    while True:
        t0 = int(math.sqrt(k * n))

        for t in range(t0 + 1, t0 + B + 1):
            tsquare = t * t - k * n

            if is_square(tsquare):
                s = int(math.sqrt(tsquare))
                factor1 = t + s
                factor2 = t - s

                if factor1 != 1 and factor2 != 1 and factor1 != n and factor2 != n:
                    # Non-trivial factors found
                    return factor1, factor2

        k += 1


# Example
n = 141467
B = 100  # Adjust B as needed

factor1, factor2 = fermat_factorization(n, B)

print(f"Factors of {n}: {factor1} and {factor2}")
