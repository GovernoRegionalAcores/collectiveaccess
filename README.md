# CollectiveAccess

## About

- This image does not contain MySQL, it needs to be linked;
- Contains both Providence and Pawtucket2;
- Providence is accessed by <domain>:<port>/providence.

## Usage

docker run –link your-mysql:mysql -p 80:80 -e DB_USER=your-dbuser -e DB_PW=yourdbpass -e DB_NAME=yourdbname governoregionalazores/collectiveaccess

