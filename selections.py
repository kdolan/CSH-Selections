import bottle
import json
from bottle import route, request, run
from DataAccessLayer import DAL

import Controllers.index

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


#INDEX Page
def index():
    return Controllers.index.page_html(dbConn)

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
    appId = request.query.id
    return "Eval page " + appId

def post_eval():
    return "Post to eval"

#Configuration
def read_config():
    with open('db.config') as config:
        return json.load(config)

if __name__ == "__main__":
    config = read_config()
    dbConn = DAL(config['mysql_server'], config['username'], config['password'], config['database'])

    setup_routing()
    run(host='localhost', port=8080, debug=True)
