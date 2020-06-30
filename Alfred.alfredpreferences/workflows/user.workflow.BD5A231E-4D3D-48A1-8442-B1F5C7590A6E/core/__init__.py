"""
This module contains all primary functionality of the workflow.

This module is wrapped by the top-level scripts, which are invoked by Alfred.
"""

from .render import render_login_notice, render_search_result, render_pending
from .auth import get_token, set_token
from .salesforce import search, aquire_token
