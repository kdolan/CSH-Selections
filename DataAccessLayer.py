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
        #exec_str = "CALL `spInsert_user` ('{0}', '{1}');".format(username, password_hash)
        #print(exec_str)
        args = [username, str(password_hash)]
        self.cursor.callproc('spInsert_user', args)
        self.db.commit()
