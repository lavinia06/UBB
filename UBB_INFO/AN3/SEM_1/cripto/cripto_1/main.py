import math, time

#the built in function from python
def gcd_builtin(a, b):
    return math.gcd(a, b)

#method of successive differences
def method_1(a, b):
    while a!=b :
        if a>b:
            a=a-b
        else:
            b=b-a
    return a


def gcd_euclidean(a, b):
    while b:
        a, b = b, a % b
    return a


def extended_gcd(a, b):
    if a == 0:
        return b, 0, 1
    else:
        gcd, x, y = extended_gcd(b % a, a)
        return gcd, y - (b // a) * x, x

def gcd_extended(a, b):
    gcd, x, y = extended_gcd(a, b)
    return gcd


if __name__ == '__main__':
    print(method_1(24, 8))

    inputs = [(1234567890, 987654321),
              (1024, 256),
              (105, 315),
              (999, 0),
              (1234567890, 1),
              (876543210, 135792468),
              (5, 7),
              (111, 222),
              (987654321, 1234567890),
              (123, 456)]

    for a, b in inputs:
        start_time = time.time()
        result_euclidean = gcd_euclidean(a, b)
        euclidean_time = time.time() - start_time

        start_time = time.time()
        result_builtin = gcd_builtin(a, b)
        builtin_time = time.time() - start_time

        start_time = time.time()
        result_extended = gcd_extended(a, b)
        extended_time = time.time() - start_time

        print(f"GCD({a}, {b}):")
        print(f"Euclidean Algorithm: GCD = {result_euclidean}, Time = {euclidean_time:.8f} seconds")
        print(f"Builtin Function: GCD = {result_builtin}, Time = {builtin_time:.8f} seconds")
        print(f"Extended Euclidean Algorithm: GCD = {result_extended}, Time = {extended_time:.8f} seconds")
        print()


