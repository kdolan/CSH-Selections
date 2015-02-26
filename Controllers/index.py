#This file will gather the "selection groups" and applications within that group.
def page_html(dbconn):
    raw_html = None
    with open('Views/index.html','r') as myfile:
        raw_html = myfile.read()

    applicant_groups = dbconn.get_applicantGroups()
    group_options = _format_options(applicant_groups)
    print group_options

    """The applicant_list holds a list of all applicants where the index of the
    list is the group number. The size of the list is the largest group. The largest
    group is the last item in the list because get_applicantGroups returns the
    groups from smallest to largest. +1 for 0 indexed array."""
    applicant_list = [''] * (applicant_groups[-1] + 1)
    for group in applicant_groups:
        applicants = dbconn.get_applicantInGroup(group)
        applicant_list[group] = applicants

    js_applicant_array = _format_javascript_array(applicant_list)
    return raw_html.format(js_applicant_array, group_options)

def _format_options(optionList):
    returnString = ""
    for option in optionList:
        returnString += '<option value="{0}">{0}</option>'.format(option)

    return returnString

"""Formats javascript array so that when the group drop down is updated
the applicant dropdown can also be updated"""
def _format_javascript_array(applicant_list):
    formated_applicant_list = []
    for applicants_in_group in applicant_list:
        formated_applicant_list.append(_format_options(applicants_in_group))

    return str(formated_applicant_list)
