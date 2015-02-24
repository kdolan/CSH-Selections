#DataAccessLayer
import MySQLdb
import hashlib #for md5

class DAL(object):

    def __init__(self, db_host, db_user, db_password, db):
        self.db = MySQLdb.connect(db_host, db_user, db_password, db)
        self.cursor = self.db.cursor()

    def insert_user(self, username, password):
        m = hashlib.md5()
        m.update(password)
        password_hash = m.hexdigest()
        args = [username, str(password_hash)]
        self.usp_exec('spInsert_user', args)

    def check_login(self, username, password):
        m = hashlib.md5()
        m.update(password)
        password_hash = h.hexdigest()
        args = [username, str(password_hash)]
        #TODO: CALL USP
        #TODO: Return 0 if credential is valid. Return 1 if user is admin. Return -1 if invalid login

    def insert_score(self, criteria_id, reviewer_id, applicant_id):
        args = [criteria_id, reviewer_id, applicant_id]
        self.usp_exec('spInsert_score', args)

    def insert_criteria(self, name, description, min_score, max_score, weight):
        args = [name, descriotion, min_score, max_score, weight]
        self.usp_exec('spInsert_criteria', args)

    def insert_applicant(self, applicant_id, application_html):
        args = [applicant_id, applicantion_html]
        self.usp_exec('spInsert_applicant', args)

    def usp_exec(self, usp_name, args):
        self.cursor.callproc(usp_name, args)
        self.db.commit()

    def get_applicantGroups(self):
        #TODO

    def get_applicantInGroup(self, groupId):
        #TODO




