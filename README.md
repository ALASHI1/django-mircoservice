# Django Microservice - Dockerized Deployment

This is a Django-based microservice application containerized using Docker. It includes PostgreSQL, Redis, Celery for background tasks and Gunicorn as the production WSGI server. The infrastructure is managed with Terraform and deployed on AWS EC2.

---

### 🚀 Live Demo  
**[http://13.48.146.116:8000](http://13.48.146.116:8000)**  
**[http://13.48.146.116:8000/swagger](http://13.48.146.116:8000/swagger)**  

> Deployed on an AWS EC2 instance using Gunicorn + Whitenoise

---

## 🚀 Features
- Django 5.2 + DRF
- PostgreSQL (via Docker)
- Redis + Celery for async task processing
- Swagger (drf-yasg) for API documentation
- Docker Compose for local orchestration
- Gunicorn as production WSGI server
- Terraform for AWS infrastructure (EC2, Security Groups, CloudWatch, S3)
- GitHub Actions CI/CD deployment to EC2

---

## 📦 Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) *(if managing infrastructure)*


---

## 🛠️ Setup (Local Development)

### 1. Clone the Repository
```bash
git clone https://github.com/ALASHI1/django-mircoservice.git
cd django-mircoservice
```

### 2. Set up `.env`
Create a `.env` file in the root directory with the following content:
```env
POSTGRES_DB=your_db
POSTGRES_USER=your_user
POSTGRES_PASSWORD=your_password
```

### 3. Start the App
```bash
docker-compose up -d --build
```

### 4. Access:
- **Django**: http://localhost:8000
- **Swagger UI**: http://localhost:8000/swagger/


---

## ⚙️ Infrastructure (Terraform)

### S3 Backend Setup
- Stores Terraform state in versioned S3 bucket

### EC2 Deployment
- Amazon Linux 2023 (ARM)
- Docker, Docker Compose installed via GitHub Actions
- Security group exposes ports: 22 (SSH), 80, 443, 8000
- CloudWatch + IAM Role for logs

Run Terraform:
```bash
terraform init
terraform apply
```

---

## 🤖 CI/CD (GitHub Actions)
- Deploys to EC2 on every push to `main`
- Uses `appleboy/ssh-action` to SSH and redeploy Docker containers

---

## 🐘 Services
| Service | Port | Description |
|--------|------|-------------|
| Django (Gunicorn) | 8000 | Web API |
| PostgreSQL | 5432 | Relational database |
| Redis | 6379 | Broker for Celery |
| Celery | — | Background task worker |

---

## 📚 Documentation
- Swagger UI available at `/swagger/`
- Endpoints organized with `drf-yasg`

### 👨‍🏫How to use the swagger

1. go to the url `/swagger/`
2. Signup and login to get the token
3. Click the Authorize button on the top right corner
4. Enter the token in the format `Token <token>` and click Authorize ('Dont forget the "Token" prefix')
5. Then you can use the APIs with the token

---

## 🧠 Architectural Notes
See [ARCHITECTURE.md](./ARCHITECTURE.md) for in-depth system design and infrastructure details.


