# Pager Installation and Usage Guide

## Table of Contents

1. [Initialization](#initialization)
2. [Database](#database)
3. [Login](#login)
4. [Add a User](#add-a-user)

---

## Initialization

### Prerequisites

- Git installed
- Docker and Docker-Compose installed
- PowerShell (for Windows users) or Bash shell (for Unix-based systems)

### Steps

1. **Clone the repository and navigate into the directory:**

    ```bash
    git clone --depth 1 git@github.com:Amitron-Labs/pager.git && cd pager
    ```

2. **Initialize and update submodules:**

    ```bash
    git submodule init
    git submodule update
    ```

3. **Run the initialization script. Replace `<mode>` with either `local` or `amitron`.**

    - **For PowerShell on Windows:**

        ```bash
        .\init -Mode <mode>
        ```

    - **For Bash on Unix-based systems:**

        ```bash
        source init <mode>
        ```

4. **Build Docker images, run the containers, and follow the logs:**

    ```bash
    docker-compose up -d && docker-compose logs -f
    ```

---

## Database

The database is run as a container on the same machine where the initialization occurs.

---

## Login

- **URL**:
  - If `amitron` was used as the argument in the initialization script, use `http://192.168.2.59`.
  - Otherwise, use `http://localhost`.

- **Temporary Password**: `amitron2001`

---

## Add a User

### Prerequisites

Before adding a user, ensure that you have the following information:

- Base ID: A three-digit number
- Pager ID: A four-digit number relative to the Base ID

### SQL Command

To add a user, execute the following SQL command:

```sql
INSERT INTO pager.capcode
VALUES ('<base_id>', '<pager_id>', '<manufacturing_area>', '<first_last_name>');
