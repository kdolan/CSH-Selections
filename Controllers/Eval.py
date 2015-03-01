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

    with open('Views/criteria_row.txt', 'r') as rowTxtFile:
        row_text = rowTxtFile.read()

    table_rows = ""
    all_criteria = dbConn.get_criteria()
    counter = 1
    max_score = 0
    weight_list = [0]
    #c for criteria
    for c in all_criteria:
        table_rows += row_text.format(counter, c[1], int(c[3]), int(c[4]), int(c[5]), c[2])
        max_score += int(c[4]) * int(c[5]) #calculate max score
        weight_list.append(int(c[5]))
        counter += 1

    counter -= 1 #Set counter to be the number of criteria
    return raw_html.format(str(weight_list), str(counter), table_rows, str(max_score))
