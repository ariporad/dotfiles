#!/usr/bin/env python3
"""
Log out of Salesforce by deleting the current token (if it exists.)

Exposed in Alfred as the `logout-force` command. It is valid to invoke
this file even if there is no current token.

Prints out a status message to display to the user.
"""

import sys
import json
from core.auth import set_token


def logout():
    try:
        set_token(None)
        print("Signed out Successfully!")
    except:
        print("Failed to Sign out! Please Try Again!")


if __name__ == "__main__":
    logout()
