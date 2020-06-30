"""
Provides a number of configuration constants used throughout the workflow.

Although many of these paramaters are actually provided through environment
variables, they are re-named here for convenience, consistency, and clarity.
"""

import os

CLIENT_ID = os.environ["SALESFORCE_CONSUMER_ID"]
"""The Salesforce Consumer ID."""

CLIENT_SECRET = os.environ["SALESFORCE_CONSUMER_SECRET"]
"""
The Salesforce Consumer Secret.

The nature of a client-side app is that it can't really keep a secret, so this is
rather pointless. However, that doesn't make much of a difference because a) you're
giving the app your password anyways, so it can do whatever it wants; and b) Salesforce
permits a secret-optional method of authentication in various circumstances, so
it's mostly a moot point.
"""

OAUTH_TOKEN_URL = "https://login.salesforce.com/services/oauth2/token"
"""The URL to aquire an OAuth Token."""


KEYCHAIN_ACCOUNT_NAME = "SalesforceToken"
"""The name under which we store the token in the Keychain"""

KEYCHAIN_BUNDLE_ID = os.environ["alfred_workflow_bundleid"]
"""The Bundle ID provided to the Keychain to namespace accounts."""
