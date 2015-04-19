#TODO: This module will gather data from the database including application and eval criteria. It will then render the eval page with the application and rubric.
import auth
import ast
import index

def page_html(dbConn, http_request, http_response):
    raw_html = None

    access_level = auth.validate_session(dbConn, http_request, False)
    session_name = dbConn.get_sessionUsername(http_request.get_cookie("CSH-Selections"))

    #If not authenticated return login page
    if(access_level != 0 and access_level != 1):
        with open('Views/login.html', 'r') as myfile:
            return myfile.read()

    with open('Views/template.html', 'r') as templateFile:
        template = templateFile.read()

    with open('Views/eval.html','r') as myfile:
        raw_html = myfile.read()

    raw_html = template.format(raw_html)

    with open('Views/criteria_row.txt', 'r') as rowTxtFile:
        row_text = rowTxtFile.read()

    applicant_id = http_request.query["applicant"]
    applicant_group = http_request.query["group"]

    table_rows = ""
    all_criteria = dbConn.get_criteria()
    enabledCriteria = []
    counter = 1
    max_score = 0
    weight_list = [0]
    #c for criteria
    #Format Key: Row count, Criteria Name, min score, max score, weight description, criteria id.
    for c in all_criteria:
        if (c[6]==0): #If not disabled
            enabledCriteria.append(int(c[0]))
            table_rows += row_text.format(counter, c[1], int(c[3]), int(c[4]), int(c[5]), c[2], c[0])
            max_score += int(c[4]) * int(c[5]) #calculate max score
            weight_list.append(int(c[5]))
            counter += 1

    counter -= 1 #Set counter to be the number of criteria
    return raw_html.format(str(weight_list), str(counter), table_rows, str(max_score),str(enabledCriteria),applicant_id, applicant_group, session_name )

def submit_eval(dbConn, http_request, http_response, redirect):
    access_level = auth.validate_session(dbConn, http_request, False)

    #If not authenticated return login page
    if(access_level != 0 and access_level != 1):
        with open('Views/login.html', 'r') as myfile:
            return myfile.read()

    session_key = session_key = http_request.get_cookie("CSH-Selections")
    all_criteria = ast.literal_eval(http_request.forms.get("criteria"))
    application_id = http_request.forms.get("application_id")

    print application_id

    for criteria in all_criteria:
        min_max_score = dbConn.get_minMaxScore(criteria)
        score = http_request.forms.get("Score_"+str(criteria))
        if(score < min_max_score[0] and score > min_max_score[1]):
            dbConn.insert_error(session_key, "Invalid score: min max violation")
            raise(ValueError("Invalid Score! Your attempt to break a production evaluations system has been logged."))


    for criteria in all_criteria:
        score = http_request.forms.get("Score_"+str(criteria))
	dbConn.insert_score(criteria, application_id, session_key, score)
    redirect("index?sbmtd")
