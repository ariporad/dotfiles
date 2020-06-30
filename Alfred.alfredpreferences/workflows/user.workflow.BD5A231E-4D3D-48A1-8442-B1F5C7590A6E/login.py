#!/usr/bin/env python3
"""
Log in to Salesforce with a username, password, and (optionally) a 2FA token.

Expects argv[1] to be in the format of "username password" or "username password 2facode."

Exposed in Alfred as the `login-force` command. It is valid to invoke this file even if there
is a current token.

This requires internet access to exchange the user's credentials for an OAuth token. The
credentials are not stored.

Writes a status message to display to the user on stdout.

NOTE: Does not support a password with space(es) in it. Behevior in that case is undefined. It
	  is unclear if Salesforce supports such a password.
"""

import sys
import json
from core.salesforce import aquire_token


def login(query):
    try:
        parts = sys.argv[1].split(" ")

        username = parts[0]
        password = parts[1]

        if len(parts) > 2:
            password += parts[2]  # Salesforce wants the token appended to the password

        aquire_token(username, password)
        print("Signed in Successfully!")
    except:
        print("Failed to Sign in! Please Try Again!")


if __name__ == "__main__":
    login(sys.argv[1] if sys.argv[1] != "" else input("Input: "))

