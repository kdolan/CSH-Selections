#This file will gather the "selection groups" and applications within that group.
def page_html(dbconn):
    raw_html = None
    with open('Views/index.html','r') as myfile:
        raw_html = myfile.read()

    applicant_groups = dbconn.get_applicantGroups()
    group_options = _format_options(applicant_groups)
    print group_options

    applicant_list = [] #List that hold a list of applicants for each group.
    for group in applicant_groups:
        applicants = dbconn.get_applicantInGroup(group)
        applicant_list.append(applicants)
    print(applicant_list)
    return raw_html.format(group_options, "")

def _format_options(optionList):
    returnString = ""
    for option in optionList:
        returnString += '<option value="{0}">{0}</option>'.format(option)

    return returnString

"""Formats javascript array so that when the group drop down is updated
the applicant dropdown can also be updated"""
def _format_javascript_array(applicant_list):
    pass
