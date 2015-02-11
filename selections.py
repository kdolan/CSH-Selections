import bottle
import json
from bottle import route, request, run
from DataAccessLayer import DAL

dbConn = None #DataAccessLayer for interactiung with the db

def setup_routing():
    bottle.route('/eval', 'GET', get_eval)
    bottle.route('/eval', 'POST', post_eval)

    bottle.route('/account', 'GET', get_account)
    bottle.route('/account', 'POST', post_account)

    bottle.route('/import', 'GET', get_import)
    bottle.route('/import', 'POST', post_import)

#EVAL PAGE
def get_eval():
    appId = request.query.id
    return "Eval page " + appId

def post_eval():
    return "Post to eval"

#ACCOUNT PAGE - For creating accounts
def get_account():
    return "Get account"

def post_account():
    username = request.forms.get('username')
    password = request.forms.get('password')
    dbConn.insert_user(username, password)
    print( "Create User " + username)
    return "USER CREATED"

#IMPORT - For importing applications/accounts
def get_import():
    return "Display import page"

def post_import():
    return "Import some things"

#Configuration
def read_config():
    with open('db.config') as config:
        return json.load(config)

if __name__ == "__main__":
    config = read_config()
    dbConn = DAL(config['mysql_server'], config['username'], config['password'], config['database'])

    setup_routing()
    run(host='localhost', port=8080, debug=True)
