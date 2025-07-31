# Final-Project-Dev-Tools

## Joomla Website with Docker

This project provides a **Docker-based setup** for running a Joomla website alongside a MySQL database. Both services operate inside their own containers and are linked through a shared network, making it simple to start and manage a Joomla site locally.

---

## 👥 Team Members
- **Lina Flat** – 322690181
- **Tamar Kenan** – 209335538
- **Ofek Weiss** – 207702382

---

## Technologies
- **Docker & Docker Compose** – Container orchestration
- **Joomla CMS** – Content management platform
- **MySQL Database** – Data storage engine
- **Bash Scripts** – Command-line automation
- **Linux Environment** – Main target OS (also works on macOS with Docker Desktop)

---

## Setup Instructions

### 1. Give permissions to the scripts:
```bash
chmod +x setup.sh backup.sh restore.sh cleanup.sh
```

### 2. Launch the containers:
```bash
./setup.sh
```

### 3. Access Joomla:
-  **Website:** [http://localhost:8080](http://localhost:8080)
-  **Admin area:** [http://localhost:8080/administrator](http://localhost:8080/administrator)
-  **Login details:**
  - Username: `demoadmin`
  - Password: `secretpassword`

---

## Backing Up Data
Create a timestamped backup of the database and website content:
```bash
./backup.sh
```
Files are saved in the `./backups/` folder.

---

## Restoring from Backup
To bring back the latest saved state:
```bash
./restore.sh
```
This will rebuild the environment and reload all stored data.

---

## Cleaning Up
Remove all running containers, related volumes, and networks:
```bash
./cleanup.sh
```
Resets the setup completely.

---

## Quick Recovery Steps
1. Clone this repository:
```bash
git clone https://github.com/Ofir-Evgi/Dev-Tools---Final-Project.git
cd Dev-Tools---Final-Project
```
2. Make scripts executable:
```bash
chmod +x *.sh
```
3. Start or restore the environment:
```bash
./setup.sh    # Start a new environment
./restore.sh  # Load a previous backup
```
