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
