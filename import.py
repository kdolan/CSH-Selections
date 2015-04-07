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

    for row in matrix:
        print(row)
        #If applicant exists in db then update group
        #If they do not exist then add them
        #For all applicants not imported update the group to 0

