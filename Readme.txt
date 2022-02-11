Setup TestLink application 
1. Edit file .env with requred data eg username, pass, db name,  what you want to use
2. To start application type docker-compose up -d or use docker stack deploy -c <(docker-compose config) your_stack_name
3. Go to http://localhost:8086 and login with creds admin/admin
4. To stop and remove use docker-compose down --volume
