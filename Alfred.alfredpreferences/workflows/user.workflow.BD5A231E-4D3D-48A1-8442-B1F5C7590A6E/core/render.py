"""
Helpers which render data in the correct format for Alfred.

NOTE: Each function returns a single entry in the `items` array in the final JSON.
"""
from .auth import get_token


def render_search_result(result):
    """
    Render an item representing a search result.

    :param result: the dict returned by Salesforce representing the search result.
    """

    # We do this relatively convoluted way of checking for phone/website just in case
    # result[Whatever] is either nonexistant *or* None/null.
    website = result["Website"] if "Website" in result else None
    phone = result["Phone"] if "Phone" in result else None

    return {
        "uid": result["Id"],
        "type": "default",
        "title": result["Name"],
        "subtitle": "Open in Salesforce...",
        "arg": "{}/lightning/r/Account/{}/view".format(
            get_token().instance_url, result["Id"]
        ),
        "valid": True,
        "autocomplete": result["Name"],
        "mods": {
            "alt": {
                "arg": ("tel:" + phone) if phone is not None else "",
                "valid": phone is not None,
                "subtitle": "Call {}...".format(phone)
                if phone is not None
                else "No Phone Number",
            },
            "cmd": {
                "arg": website,
                "valid": website is not None,
                "subtitle": (
                    "Open {}...".format(website)
                    if website is not None
                    else "No Website"
                ),
            },
        },
    }


def render_login_notice():
    """
    Render an item informing the user that they must log in to Salesforce.
    """

    return {
        "uid": "#login",
        "type": "default",
        "title": "Please login to Salesforce to use this workflow!",
        "subtitle": 'Use the "login-force" command to sign in to Salesforce.',
        "valid": False,
    }


def render_pending():
    """
    Render an item representing pending results.
    
    This item is displayed when the user has type only one letter (which isn't
    a valid Salesforce search), which, due to debouncing, is very uncommon.
    """

    return {
        "uid": "#none",
        "type": "default",
        "title": "Search Salesforce for Companies",
        "subtitle": "Searching Salesforce...",
        "valid": False,
        "autocomplete": "",
    }
