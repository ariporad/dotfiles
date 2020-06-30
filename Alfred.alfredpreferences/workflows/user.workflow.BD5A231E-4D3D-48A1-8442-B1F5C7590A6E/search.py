#!/usr/bin/env python3
"""
Search Salesforce for a company (Account) matching `argv[1]`.

Exposed in Alfred as "force". Intellegently handles logged out, pending,
and no result cases.

Only matches on the "Name" field.

If run without arguments, will prompt from stdin.
"""

import sys
import json
import subprocess

from urllib.parse import urlencode
from urllib.request import urlopen, Request
from core import (
    get_token,
    search,
    render_login_notice,
    render_pending,
    render_search_result,
)


def do_search(query):
    """
	Search Salesforce for a company (Account) matching `query`.

	Exposed in Alfred as "force". Intellegently handles logged out, pending,
	and no result cases.

	Only matches on the "Name" field.
	"""
    if get_token() is None:
        return render_login_notice()
    elif len(query) > 1:  # Salesforce only accepts queries >1 char
        results = search(query)
        return list(map(render_search_result, results))
    else:
        return render_pending()


if __name__ == "__main__":
    # If we're running from the command line, prompt for input
    output = do_search(sys.argv[1] if sys.argv[1] != "" else input("Search Query: "))

    # Allow main() to return a single item or a list of items for convinence
    if not isinstance(output, list):
        output = [output]

    # Write the items to stdout in the proper format
    print(json.dumps({"items": output}))
