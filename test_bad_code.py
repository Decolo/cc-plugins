"""Test file with intentional issues for code review."""

import os
import sys
import json
import requests


# Security issue: hardcoded credentials
API_KEY = "sk-1234567890abcdef"
DATABASE_PASSWORD = "admin123"


def getData(url):
    """Fetch data from API."""
    # No error handling
    response = requests.get(url, headers={"Authorization": f"Bearer {API_KEY}"})
    return response.json()


def process_data(data):
    """Process the data."""
    # Unused variable
    temp = []

    # Potential SQL injection
    query = f"SELECT * FROM users WHERE id = {data['user_id']}"

    # Using eval - dangerous!
    result = eval(data['expression'])

    return result


def main():
    url = "https://api.example.com/data"
    data = getData(url)
    result = process_data(data)
    print(result)


if __name__ == "__main__":
    main()
