def login(dbConn, http_response, username, password):
    #TODO: Validate login and create session variable with session key
    auth_result = dbConn.create_session(username, password)
    if(auth_result[1] != None): #Session key is only defined when auth was valid
        #Set cookie with session key
        http_response.set_cookie("CSH-Selections", auth_result[1])
    return auth_result[0] #result access level
"""
Attempts to validate the current session.
If the session is invalid the user is redirected
to the index page and the login screen is shown.

PARAM: redirect_on_fail: True when the user should be redirected
to the index page and shown the login screen. Notably, this param
is false when validate_session is called from the index page.
http params are the bottle request and response objects.

RETURNS: A list of two elements is returned. The first element
is the integer access level of the user. The second element is the
text to insert html header (for redirect). When no redirect is needed
the second element of the list will be an empty string.

None is returned if the 'CSH-Selections' cookie is not found.
"""
def validate_session(dbConn, http_request, http_response, redirect_on_fail=True):
    #TODO: Call DAL to validate session. Return the access level of
    #user. If the validation failed

    session_key = http_request.get_cookie("CSH-Selections")
    if (session_key == None):
        return None #No Session found

    #Try and validate the session
    access_level = dbConn.validate_session(session_key)

    return access_level
