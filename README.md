# Automation_Project
 <p>This Git Repo contains bash script as a part of course assignment.</p>
 <p>The bash script does the following</p>
   <ul>
        <li> Update the ubuntu binaries. </li>
        <li> Checks if Apache2 Web Server is installed or not. Installs it if not. </li>
        <li> Checks the status of Apache2 web server. Starts it if stopped or not running. </li>
        <li> Creates a tar archive of apache2 access log and stores in /tmp folder. </li>
        <li> Copies the tar archive to AWS S3 bucket. </li>
        <li> Creats a book-keeping inventory in the form of HTML which keep traks of archives. </li>
        <li> Crons itself in order to run everyday at specific time with root priviliges. </li>
   </ul>
