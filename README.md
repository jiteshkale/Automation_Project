# Automation_Project
 This Git Repo contains bash script as a part of course assignment.
 The bash script does the following
        1)Update the ubuntu binaries.
        2)Checks if Apache2 Web Server is installed or not. Installs it if not.
        3)Checks the status of Apache2 web server. Starts it if stopped or not running.
        4)Creates a tar archive of apache2 access log and stores in /tmp folder.
        5)Copies the tar archive to AWS S3 bucket.
        6)Creats a book-keeping inventory in the form of HTML which keep traks of archives.
        7)Crons itself in order to run everyday at specific time with root priviliges.
