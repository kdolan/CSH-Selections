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

    def usp_exec(self, usp_name, args):
        self.cursor.callproc(usp_name, args)
        self.db.commit()
