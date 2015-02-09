import bottle
from bottle import route, request, run

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
    return "Create account"

#IMPORT - For importing applications/accounts
def get_import():
    return "Display import page"

def post_import():
    return "Import some things"

setup_routing()
run(host='localhost', port=8080, debug=True)
