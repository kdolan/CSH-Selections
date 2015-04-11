#DataAccessLayer
import MySQLdb
import hashlib #for md5
import time
import random

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

    """
    Creates a new session with username and password. The password is hashed by
    this function and sent to the database for auth.

    RETURNS: List with two elements. The first element is the integer access
    level of the user. The second element is the session key. If authentication
    fails (access level -1) the second element will be None.
    """
    def create_session(self, username, password, session_name, ip_addr):
        m = hashlib.md5()
        m.update(password)
        password_hash = m.hexdigest()
        args = [username, str(password_hash)]
        m.update(username+str(time.time())+str(random.random()))
        session_key = m.hexdigest()
        #Returns 0 if credential is valid. Return 1 if user is admin. Return -1 if invalid login
        result = self.usp_exec('spSession_create', [session_key, username, password_hash, session_name, ip_addr])

        #Extract access level from the raw result
        access_level = result[0][0]

        if(access_level == 0 or access_level == 1): #Normal user or admin user
            return_list = [access_level, session_key]
        else: #invalid auth or result
            return_list = [access_level, None]
        return return_list
    """
    Validates a session.
    Return Values:
    -1: Invalid session
    0: Valid session
    1: Admin session
    """
    def validate_session(self, session_key):
        result = self.usp_exec('spSession_validate', [session_key])
        #Extract access level
        access_level = result[0][0]
        return access_level

    def insert_score(self, critieraId, applicant_id, session_key, score):
        args = [critieraId, applicant_id, session_key, score]
        self.usp_exec('spInsert_score', args)

    def insert_criteria(self, name, description, min_score, max_score, weight):
        args = [name, descriotion, min_score, max_score, weight]
        self.usp_exec('spInsert_criteria', args)

    def insert_applicant(self, applicant_id, gender, group):
        if(gender == M):
            gender = 0
        else:
            gender = 1
        args = [applicant_id, gender, group]
        self.usp_exec('spInsert_applicant', args)

    def update_applicant(self, applicant_id, group):
        args = [applicant_id, group]
        self.usp_exec('spUpdate_applicant', args)

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
        return groups

    def get_applicantInGroup(self, groupId):
        results = self.usp_exec('spGet_applicantInGroup', [groupId])
        applicants = []
        for applicant in results:
            applicants.append(applicant[0])
        return applicants

    def get_criteria(self):
        results = self.usp_exec('spGet_criteria', [])
        return results

