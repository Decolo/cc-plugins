"""Test file to verify hook triggers review."""


def calculate_sum(numbers):
    """Calculate sum of numbers."""
    total = 0
    for num in numbers:
        total += num
    return total


def main():
    """Main function."""
    numbers = [1, 2, 3, 4, 5]
    result = calculate_sum(numbers)
    print(f"Sum: {result}")


if __name__ == "__main__":
    main()
