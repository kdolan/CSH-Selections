from DataAccessLayer import DAL
from selections import read_config
import csv
import sys

dbConn = None #InitLater

if __name__ == "__main__":
    csvFile = sys.argv[1]

    config = read_config()
    dbConn =  DAL(config['mysql_server'], config['username'], config['password'], config['database'])

    matrix = list()
    with open(csvFile, 'rb') as file:
        contents = csv.reader(file)
        for row in contents:
            matrix.append(row)

    current_applicants = dbConn.get_allApplicants()
    imported_applicants = [d[0] for d in matrix] #get the application id for all rows in file

    new_applicants = list()
    update_applicants = list()
    notUpdated_applicants = list()

    for applicant in imported_applicants:
        if applicant in current_applicants: #If the applicant already exists in the db
            update_applicants.append(applicant)
        else:
            new_applicants.append(applicant)

    for applicant in current_applicants:
        if applicant not in imported_applicants:
            notUpdated_applicants.append(applicant)

    matrix.pop(0) #Pop off the header row of the csv
    for row in matrix:
        #print(row)

        application_id = row[0]
        gender = row[1]

        if(gender == "M"):
            gender = 0
        else:
            gender = 1

        group = row[2]

        if application_id in new_applicants:
            dbConn.insert_applicant(application_id, gender, group)
            print("Inserting New Applicant: "+str(application_id))
        else:
            dbConn.update_applicant(application_id, group)
            print("Updating Existing Applicant: "+str(application_id))

    for applicant in notUpdated_applicants:
        dbConn.update_applicant(application_id, 0) #Clear group
        print("Clearing Group for Applicant: "+str(application_id))

