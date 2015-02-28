#TODO: This module will gather data from the database including application and eval criteria. It will then render the eval page with the application and rubric.
import auth
def page_html(dbConn, http_request, http_response):
    raw_html = None

    access_level = auth.validate_session(dbConn, http_request, False)

    #If not authenticated return login page
    if(access_level != 0 and access_level != 1):
        with open('Views/login.html', 'r') as myfile:
            return myfile.read()

    with open('Views/template.html', 'r') as templateFile:
        template = templateFile.read()

    with open('Views/eval.html','r') as myfile:
        raw_html = myfile.read()

    raw_html = template.format(raw_html)

    return raw_html
