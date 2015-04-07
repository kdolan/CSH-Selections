from DataAccessLayer import DAL
import csv
import sys

dbConn = None #InitLater

if __name__ == "__main__":
    csvFile = sys.argv[1]

    matrix = list()
    with open(csvFile, 'rb') as file:
        contents = csv.reader(file)
        for row in contents:
            matrix.append(row)

    current_applicants = dbConn.get_allAplicants()
    imported_applicants = [d[0] for d in matrix] #get the application id for all rows in file

    new_applicants = list()
    update_applicants = list()
    notUpdated_applicants = list()

    for applicant in imported_applicants:
        if applicant in current_applicants: #If the applicant already exists in the db
            update_applicants.append(applicant)
        else
            new_applicants.append(applicant)

    for applicant in current_applicants:
        if applicant not in imported_applicants:
            notUpdated_applicants.append(applicant)

    for row in matrix:
        print(row)

        application_id = row[0]
        gender = row[1]

        if(gender == "M"):
            gender = 0
        else
            gender = 1

        group = row[2]

        if application_id in new_applicants:
            #dbConn.insert_applicant
        else:
            #dbConn.update_applicant

    for applicant in notUpdated_applicants:
        #dbConn.update_clearGroup

