# Dockerized Django Project

This project is a Dockerized Django application with PostgreSQL database and Nginx web server.

## 🐳 Project Stack

- Django 4.2
- PostgreSQL 15
- Nginx
- Docker
- Docker Compose

---

## 📂 Project Structure

![alt text](img/4.png)

## ⚙️ How to Run the Project

1️⃣ Build and start containers:

docker-compose up -d --build

![alt text](img/1.png)

2️⃣ Apply database migrations:

docker-compose exec web python manage.py migrate

![alt text](img/2.png)

3️⃣ Open in browser:

http://localhost

If everything works correctly, you should see:

Docker Django Project is working!

![alt text](img/3.png)

### Database Configuration

The project uses PostgreSQL with the following default credentials:

Database: django_db

User: django_user

Password: django_password

Host: db

Port: 5432

### Services

web — Django application running with Gunicorn

db — PostgreSQL database

nginx — Reverse proxy server

### Useful Commands

View logs:

docker-compose logs -f

Stop containers:

docker-compose down

Rebuild project:

docker-compose up -d --build
