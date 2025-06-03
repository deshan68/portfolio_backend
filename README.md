# 🚀 Portfolio Backend

A secure and modular backend built using **Ballerina**, designed for managing portfolio projects with authentication, authorization, and technology stack management features.

---

## 📌 Features

- 🧩 Modular Ballerina code structure
- 🔐 JWT-based authentication
- 🧑‍💼 Admin role management
- 📂 Project and tech stack CRUD operations
- 🗄️ MySQL database integration

---

## 🛠 Tech Stack

- **Language**: [Ballerina](https://ballerina.io/)
- **Authentication**: JWT
- **Database**: SQL-compatible database
- **Architecture**: RESTful API with interceptor-based auth
---

## 📁 Folder Structure

```bash
PORTFOLIO_BACKEND/
├── keys/                          # Public/private key files for JWT
├── modules/
│   ├── authorization/             # Admin auth and access control logic
│   ├── constant/                  # Project-wide constant values
│   ├── database/                  # DB client, queries, enums, and functions
│   ├── jwtToken/                  # JWT logic (sign, verify, interceptors)
│
├── target/                        # Ballerina build artifacts
├── .gitignore
├── Ballerina.toml                 # Ballerina project configuration
├── Config.toml.example            # Sample configuration file
├── db_creation.sql                # DB schema setup script
├── Dependencies.toml
├── service.bal                    # Main service entry point

```

## 🔐 Authentication

The API uses JWT (JSON Web Token) based authentication. Admin credentials are configured in `Config.toml` and tokens are required for accessing protected routes.

### Authentication Flow
1. Admin logs in using credentials
2. Backend returns a JWT token
3. Token is used in Authorization header for protected routes
4. Protected operations require admin role permissions

---

## 📋 API Endpoints

### Authentication Endpoints

#### `POST /login`
**Purpose**: Authenticate admin user and receive JWT token

**Request Body**:
```json
{
  "username": "admin_username",
  "password": "admin_password"
}
```

**Response**: 
- Success: JWT token string
- Error: `401 Unauthorized` or `500 Internal Server Error`

#### `GET /refresh`
**Purpose**: Generate a new JWT token for testing/refresh purposes

**Response**: 
- Success: JWT token string
- Error: `500 Internal Server Error`

---

### User Management

#### `GET /user-info`
**Purpose**: Get user information (protected endpoint)

**Authentication**: JWT required

**Response**: 
- Success: User object with details
- Error: `404 Not Found` or `500 Internal Server Error`

#### `POST /users`
**Purpose**: Create a new user (admin only)

**Authentication**: JWT required (admin role)

**Request Body**:
```json
{
  "username": "new_user",
  "password": "secure_password"
}
```

**Response**: 
- Success: `201 Created`
- Error: `401 Unauthorized` or `500 Internal Server Error`

---

### Projects Management

#### `GET /projects`
**Purpose**: Retrieve all projects with their tech stacks

**Authentication**: JWT required

**Response**: 
- Success: Array of project objects with tech stack details
- Error: `500 Internal Server Error`

#### `POST /projects`
**Purpose**: Create a new project (admin only)

**Authentication**: JWT required (admin role)

**Request Body**:
```json
{
  "title": "Project Title",
  "description": "Project description",
  "techStacks": [1, 2, 3],
  "githubRepoLink": "https://github.com/user/repo",
  "otherLink": "https://project-demo.com"
}
```

**Response**: 
- Success: `201 Created`
- Error: `401 Unauthorized` or `500 Internal Server Error`

---

### Writings Management

#### `GET /writings`
**Purpose**: Retrieve all writings/blog posts

**Authentication**: JWT required

**Response**: 
- Success: Array of writing objects
- Error: `500 Internal Server Error`

#### `POST /writings`
**Purpose**: Create a new writing/blog post (admin only)

**Authentication**: JWT required (admin role)

**Request Body**:
```json
{
  "title": "Article Title",
  "description": "Article content...",
  "link": "https://link-demo.com"
}
```

**Response**: 
- Success: `201 Created`
- Error: `401 Unauthorized` or `500 Internal Server Error`

---

### Tech Stacks Management

#### `GET /tech-stacks`
**Purpose**: Retrieve all available tech stacks/technologies

**Authentication**: JWT required

**Response**: 
- Success: Array of tech stack objects
- Error: `500 Internal Server Error`

#### `POST /tech-stacks`
**Purpose**: Create a new tech stack entry (admin only)

**Authentication**: JWT required (admin role)

**Request Body**:
```json
{
  "name": "React"
}
```

**Response**: 
- Success: `201 Created`
- Error: `401 Unauthorized` or `500 Internal Server Error`

---

### Experiences Management

#### `GET /experiences`
**Purpose**: Retrieve all work experiences with associated tech stacks

**Authentication**: JWT required

**Response**: 
- Success: Array of experience objects with tech stack details
- Error: `500 Internal Server Error`

#### `POST /experiences`
**Purpose**: Create a new work experience (admin only)

**Authentication**: JWT required (admin role)

**Request Body**:
```json
{
  "companyName": "Tech Company Inc.",
  "position": "Software Developer",
  "description": "Role description and responsibilities",
  "startDate": "2023-01-01",
  "endDate": "2024-01-01",
  "techStacks": [1, 2, 3],
  "isCurrentEmployee": false
}
```

**Response**: 
- Success: `201 Created`
- Error: `401 Unauthorized` or `500 Internal Server Error`

---

## 🚀 Getting Started

### Prerequisites
- Ballerina Swan Lake
- Database (MySQL/PostgreSQL)
- Admin credentials configured in `Config.toml`

### Running the API
1. Configure your database connection and admin credentials in `Config.toml`
2. Start the service: `bal run`
3. API will be available at `http://localhost:9090`

### Authentication Usage
1. First, authenticate: `POST /login` with admin credentials
2. Use returned JWT token in Authorization header: `Bearer <token>`
3. Access protected endpoints with the token

---

## 🔒 Security Features

- JWT-based authentication
- Role-based access control (admin permissions required for write operations)
- Protected routes for all sensitive operations
- Request context validation
- Comprehensive error handling and logging

---

## 📝 Error Responses

All endpoints may return these common error responses:

- `401 Unauthorized`: Invalid or missing JWT token, or insufficient permissions
- `500 Internal Server Error`: Database connection issues or server errors
- `404 Not Found`: Requested resource not found

---

*This API serves as the backend for a portfolio website, providing secure CRUD operations for managing personal projects, writings, experiences, and technical skills.*
