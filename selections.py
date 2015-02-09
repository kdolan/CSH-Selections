import bottle
from bottle import route, request, run

def setup_routing():
    bottle.route('/eval', 'GET', get_eval)
    bottle.route('/eval', 'POST', post_eval)

def get_eval():
    appId = request.query.id
    return "Eval page " + appId

def post_eval():
    return "Post to eval"

setup_routing()
run(host='localhost', port=8080, debug=True)
