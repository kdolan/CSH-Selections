def login(dbconn, username, password):
    #TODO: Validate login and create session variable with session key

"""
Attempts to validate the current session.
If the session is invalid the user is redirected
to the index page and the login screen is shown.

PARAM: redirect_on_fail: True when the user should be redirected
to the index page and shown the login screen. Notably, this param
is false when validate_session is called from the index page.

RETURNS: A list of two elements is returned. The first element
is the integer access level of the user. The second element is the
text to insert html header (for redirect). When no redirect is needed
the second element of the list will be an empty string.
"""
def validate_session(dbconn, session_key, redirect_on_fail=True):
    #TODO: Call DAL to validate session. Return the access level of
    #user. If the validation failed
