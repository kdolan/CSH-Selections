# CSH-Selections
Computer Science House web application for managing the selections process.

Web Framework: Bottle
Database: MySQL
Version: v1.0

#Implementation
The data access layer DAL provides access to the mysql database backend though stored procedures. This data is collected by the page controllers that then render the views.

# Pages
accountCreate - Creates a new user account.
eval - Takes an application id, presents the application and the evaluation rubric.
results - Generates spreadsheet with score of all applicants
importApplications - Imports applications ids from .csv

# Usage
To start the web server:

`python selections.py`

To start the web server and change the password of the selections user:

`python selections.py new_password`

# Modules
pip install bottle
apt-get install libmysqlclient-dev #For MySQL-python
apt-get install python2.7-dev #For MySQL-python
pip install MySQL-python

# Inital Setup
Database Setup:
1) Create an admin user
2) Create a selections user or create indivudal accounts for all members of selections
3) Import or set the criteria in the database. All criteira is data driven (It is trivial to change the rubric or how it works)
4) Import applications and groups
5) Upload the application pdfs so they can be downloaded. Application pdfs should be put in the Applications directory where the file name is {groupNumber}.pdf.

Config Setup:
1) Set the host and the port in selections.py
2) Set database credentials in the db.config file

To Switch to Interview Mode:
1) Create a new database with new criteria (the interview rubric)
2) Change the db.config to point to the new database.
3) Import the applications into the interview database.
