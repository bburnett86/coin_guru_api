## **🚀 Coin Guru API - Setup Guide**

### **📌 Prerequisites**
Ensure you have the following installed on your system before proceeding:

- **[Docker](https://docs.docker.com/get-docker/)** (for containerized development)
- **[Docker Compose](https://docs.docker.com/compose/install/)** (for managing multi-container applications)
- **[Git](https://git-scm.com/downloads)** (to clone the repository)
- **[Ruby](https://www.ruby-lang.org/en/)** *(Only if running outside Docker)*
- **[PostgreSQL](https://www.postgresql.org/)** *(Optional if running outside Docker)*  

---

## **📂 Environment Setup**
### **1️⃣ Clone the Repository**
```sh
git clone https://github.com/YOUR_USERNAME/coin_guru_api.git
cd coin_guru_api
```

---

## **🛠 Development Setup**
### **2️⃣ Set Up Environment Variables**
Copy the sample `.env` file and configure the necessary variables:
```sh
cp .env.dev.example .env.dev
```
Then, edit the `.env.dev` file:
```sh
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=coin_guru_api_development
DATABASE_HOST=db
DATABASE_PORT=5432
RAILS_MASTER_KEY=your_master_key_here
```

### **3️⃣ Build and Start the Dev Environment**
Run the following to build and start your development environment:
```sh
docker-compose --env-file .env.dev -f docker-compose.dev.yml up -d --build
```

### **4️⃣ Check Running Containers**
Ensure both `db` and `web` services are running:
```sh
docker-compose -f docker-compose.dev.yml ps
```

### **5️⃣ Set Up the Database**
Run migrations:
```sh
docker-compose -f docker-compose.dev.yml exec web bundle exec rails db:setup
```

Alternatively, you can run the steps separately:
```sh
docker-compose -f docker-compose.dev.yml exec web bundle exec rails db:create
docker-compose -f docker-compose.dev.yml exec web bundle exec rails db:migrate
```

---

## **🤦‍♂️ Testing Setup**
### **2️⃣ Set Up Environment Variables**
Copy and configure the test environment file:
```sh
cp .env.test.example .env.test
```
Edit `.env.test` to match:
```sh
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=coin_guru_api_test
DATABASE_HOST=localhost
DATABASE_PORT=5432
RAILS_MASTER_KEY=your_master_key_here
```

### **3️⃣ Build and Start the Test Environment**
Run:
```sh
docker-compose -f docker-compose.test.yml up -d --build
```

### **4️⃣ Run Tests**
Execute the test suite:
```sh
docker-compose -f docker-compose.test.yml exec web bundle exec rspec
```

---

## **🛠 Useful Commands**
### **📌 Stopping Containers**
To stop the running services without deleting data:
```sh
docker-compose -f docker-compose.dev.yml stop
```
To stop and remove containers:
```sh
docker-compose -f docker-compose.dev.yml down
```

### **📌 Rebuilding Containers**
If you make changes and need a fresh build:
```sh
docker-compose -f docker-compose.dev.yml build --no-cache
docker-compose -f docker-compose.dev.yml up -d --build
```

### **📌 Viewing Logs**
To check for errors or debug:
```sh
docker-compose -f docker-compose.dev.yml logs -f web
```

### **📌 Running RuboCop**
To fix linting issues with RuboCop:
```sh
bundle exec rubocop -A
```

---

## **❓ Troubleshooting**
### **🔴 Web Container Won’t Start**
1. Check logs:
   ```sh
   docker-compose -f docker-compose.dev.yml logs web
   ```
2. Ensure gems are installed:
   ```sh
   docker-compose -f docker-compose.dev.yml exec web bundle install
   ```
3. Restart the web service:
   ```sh
   docker-compose -f docker-compose.dev.yml restart web
   ```

### **🔴 Database Issues**
- If migrations fail, try:
  ```sh
  docker-compose -f docker-compose.dev.yml exec web bundle exec rails db:drop db:create db:migrate
  ```

---

## **💡 Additional Notes**
- If using **MacOS/Linux**, prefix `docker-compose` with `sudo` if necessary.
- Ensure your `.env` files are correctly populated before running any setup commands.

---