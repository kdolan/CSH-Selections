#DataAccessLayer
import MySQLdb
import hashlib #for md5
import time

class DAL(object):

    def __init__(self, db_host, db_user, db_password, db):
        self.db = MySQLdb.connect(db_host, db_user, db_password, db)
        #self.cursor = self.db.cursor() Not opened by default
        self.cursor = None

    def insert_user(self, username, password):
        m = hashlib.md5()
        m.update(password)
        password_hash = m.hexdigest()
        args = [username, str(password_hash)]
        self.usp_exec('spInsert_user', args)

    def validate_login(self, username, password):
        m = hashlib.md5()
        m.update(password)
        password_hash = h.hexdigest()
        args = [username, str(password_hash)]
        #TODO: CALL USP
        #TODO: Return 0 if credential is valid. Return 1 if user is admin. Return -1 if invalid login

    def validate_session(self, session_key):
        pass
        #TODO: Validate session key. Update last active time of session to now.

    def insert_session(self, session_key):
        pass
        #TODO: Creates a new session

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
        self.cursor = self.db.cursor()
        self.cursor.callproc(usp_name, args)
        result = self.cursor.fetchall()
        self.cursor.close()
        self.db.commit()
        return result

    def get_applicantGroups(self):
        results = self.usp_exec('spGet_applicantGroups', [])
        groups = []
        for result in results:
            groups.append(result[0])
        print(groups)
        return groups

    def get_applicantInGroup(self, groupId):
        pass
        #TODO
