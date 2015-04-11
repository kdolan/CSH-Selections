import bottle
import json
import os #for working directory
import sys
from bottle import route, request, run, hook, response, static_file, redirect
from DataAccessLayer import DAL

import Controllers.auth
import Controllers.index
import Controllers.Eval

dbConn = None #DataAccessLayer for interactiung with the db

def setup_routing():
    bottle.route('/eval', 'GET', get_eval)
    bottle.route('/eval', 'POST', post_eval)

    bottle.route('/admin/CreateUser', 'GET', get_create_user)
    bottle.route('/admin/CreateUser', 'POST', post_create_user)

    bottle.route('/admin/GroupApplications', 'GET', get_group_applications)
    bottle.route('/admin/GroupApplications', 'POST', post_group_applications)

    bottle.route('/admin/ViewScores', 'GET', get_view_scores)

    bottle.route('/import', 'GET', get_import)
    bottle.route('/import', 'POST', post_import)

    bottle.route('/', 'GET', index)
    bottle.route('/index', 'GET', index)

    bottle.route('/login', 'POST', post_login)
    bottle.route('/logout', 'GET', get_logout)

    bottle.route('/download', 'GET', get_download)

#INDEX Page
def index():
    return Controllers.index.page_html(dbConn, request, response)

#LOGIN Page
def post_login():
    username = request.forms.get('username')
    password = request.forms.get('password')
    session_name = request.forms.get('session_name')
    ipadrr = request.remote_addr

    access_level = Controllers.auth.login(dbConn, response, username, password, session_name, ipadrr)
    if(access_level == 1):
        #return "ADMIN LOGIN"
        pass
    if(access_level == 0):
        #return "USER LOGIN"
        pass
    else:
        #return "LOGIN FAIL"
        pass
    return Controllers.auth.redirect_to_index()

#LOGOUT
def get_logout():
    Controllers.auth.logout(response)
    return Controllers.auth.redirect_to_index()

#ADMIN - CREATE USER PAGE - For creating accounts
def get_create_user():
    return "Get account"

def post_create_user():
    username = request.forms.get('username')
    password = request.forms.get('password')
    dbConn.insert_user(username, password)
    print( "Create User " + username)
    return "USER CREATED"

#ADMIN - Group Applications - For adding applications to selection groups
def get_group_applications():
    return "Display group page"

def post_group_applications():
    return "Update application groups"

#ADMIN - View Scores
def get_view_scores():
    return "Display scores"

#ADMIN - IMPORT - For importing applications/accounts
def get_import():
    return "Display import page"

def post_import():
    return "Import some things"

#EVAL PAGE
def get_eval():
    response.set_cookie("CSH-Selections-Group", request.query["group"])
    return Controllers.Eval.page_html(dbConn, request, response)

def post_eval():
    #List of of criteria submitted
    #criteriaList = requests.forms.get('criteria')
    return Controllers.Eval.submit_eval(dbConn, request, response, redirect)
    #return "Post to eval"

def get_download():
    application_id = request.query['application']
    fileName = application_id+'.doc'
    path = os.getcwd()+'/Applications/'
    return static_file(fileName, root=path)

#Configuration
def read_config():
    with open('db.config') as config:
        return json.load(config)

if __name__ == "__main__":
    config = read_config()
    dbConn = DAL(config['mysql_server'], config['username'], config['password'], config['database'])

    if(len(sys.argv)==2): #Set selections password
        dbConn.update_user('selections', sys.argv[1])

    setup_routing()
    run(host='blackhawk.kevinjdolan.com', port=8080, debug=True)
