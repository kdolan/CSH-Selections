#This file will gather the "selection groups" and applications within that group.
def page_html(dbconn):
    raw_html = None
    with open('Views/index.html','r') as myfile:
        raw_html = myfile.read()

    group_options = _format_options(dbconn.get_applicantGroups())
    print group_options
    return raw_html.format(group_options, "")

def _format_options(optionList):
    returnString = ""
    for option in optionList:
        returnString += '<option value="{0}">{0}</option>'.format(option)

    return returnString
