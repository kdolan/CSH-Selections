#This file will gather the "selection groups" and applications within that group.
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

    with open('Views/index.html','r') as myfile:
        raw_html = myfile.read()

    raw_html = template.format(raw_html)

    group = http_request.get_cookie("CSH-Selections-Group")

    applicant_groups = dbConn.get_applicantGroups()
    apps_reviewed = dbConn.get_appsReviwedBySession(http_request.get_cookie("CSH-Selections"))

    if(len(applicant_groups)==0):
        return "WARNING: There are currently no applicantions/groups. Selections is disabled"

    group_options = _format_options(applicant_groups, group)
    print group_options

    """The applicant_list holds a list of all applicants where the index of the
    list is the group number. The size of the list is the largest group. The largest
    group is the last item in the list because get_applicantGroups returns the
    groups from smallest to largest. +1 for 0 indexed array."""
    applicant_list = [''] * (applicant_groups[-1] + 1)

    if(len(applicant_list)==0):
        return "WARNING: There are currently no applications. Selections is disabled"
    for group in applicant_groups:
        applicants = dbConn.get_applicantInGroup(group)
        applicants = [x for x in applicants if x not in apps_reviewed]
        applicant_list[group] = applicants

    #Determine if the eval submitted successfully alert should be shown based on
    #if the sbmtd flag is passed
    hide_div_submit = "hidden"
    try:
        http_request.query["sbmtd"] #Exception if key does not exist (not passed)
        hide_div_submit = ""
    except:
        pass

    hide_div_done = "hidden"
    try:
        http_request.query["done"] #Exception if key does not exist (not passed)
        hide_div_done = ""
    except:
        pass

    js_applicant_array = _format_javascript_array(applicant_list )
    return raw_html.format(js_applicant_array, group_options, hide_div_submit, hide_div_done)

def _format_options(optionList, group=None):
    returnString = ""
    for option in optionList:
        if(str(option) == group):
            returnString += '<option value="{0}" selected>{0}</option>'.format(option)
        else:
            returnString += '<option value="{0}">{0}</option>'.format(option)

    return returnString

"""Formats javascript array so that when the group drop down is updated
the applicant dropdown can also be updated"""
def _format_javascript_array(applicant_list):
    formated_applicant_list = []
    for applicants_in_group in applicant_list:
        formated_applicant_list.append(_format_options(applicants_in_group))

    return str(formated_applicant_list)
