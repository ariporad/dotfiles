"""
This module manages storing authentication tokens with the macOS keychain.
"""
import subprocess
from .config import KEYCHAIN_ACCOUNT_NAME, KEYCHAIN_BUNDLE_ID


_token = None
"""
The currently active token.

Do not access this directly, instead use get_token().
"""


class Token:
    """
	A container for a Salesforce token and its corresponding instance URL.
	"""

    def __init__(self, instance_url, token):
        self.instance_url = instance_url
        self.token = token

    def serialize(self):
        """
		Serialize this token to a string.
		
		Use Token.deserialize() for deserialization.
		"""

        return "{};{}".format(self.instance_url, self.token)

    @classmethod
    def deserialize(cls, serialized):
        """
		Deserialize a token serialized via Token#serialize.
		"""

        parts = serialized.split(";")

        # Make sure the token at least looks a reasonably valid
        if len(parts) != 2 or len(parts[0]) == 0 or len(parts[1]) == 0:
            return None

        return cls(parts[0], parts[1])


def get_token():
    """
	Get the current token.

	Handles reading the token from the keychain transparently, and conequently,
	may raise an exception if accessing the keychain fails. Returns None if there
	is no token stored in the keychain.
	"""

    global _token

    # We cache tokens to avoid pointlessly accessing the keychain.
    if _token is not None:
        return _token

    proc = subprocess.run(
        [
            "security",
            "find-generic-password",
            "-a",
            KEYCHAIN_ACCOUNT_NAME,
            "-s",
            KEYCHAIN_BUNDLE_ID,
            "-gw",
        ],
        check=False,
        capture_output=True,
    )

    _token = Token.deserialize(proc.stdout.decode("utf-8").strip())

    return _token


def _delete_token():
    """
	Delete the current token. Don't use directly, use `set_token(None)` instead.

	Also deletes the token from the keychain. This method may be called if there is
	no current token.
	"""

    global _token

    # get_token() checks the keychain, so if it returns None, then we know there is
    # neither a token in memory nor in the keychain.
    if get_token() is None:
        return

    _token = None

    subprocess.run(
        [
            "security",
            "delete-generic-password",
            "-a",
            KEYCHAIN_ACCOUNT_NAME,
            "-s",
            KEYCHAIN_BUNDLE_ID,
        ],
        check=True,
        capture_output=True,
    )


def set_token(token):
    """
	Set the current token.

	Also stores the new token in the keychain. It is safe to call this method
	irrespective of the current token (or lack thereof). Calling this method
	with `None` is equivalent to calling delete_token().
	"""

    global _token

    # set_token(None) makes sense semantically, but requires a different implementation,
    # so we shell out to delete_token().
    if token is None:
        _delete_token()
    else:
        subprocess.run(
            [
                "security",
                "add-generic-password",
                "-a",
                KEYCHAIN_ACCOUNT_NAME,
                "-s",
                KEYCHAIN_BUNDLE_ID,
                "-w",
                token.serialize(),
            ],
            check=True,
            capture_output=True,
        )

        _token = token
