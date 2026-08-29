CREATE TABLE users (
    id            SERIAL PRIMARY KEY,
    login         VARCHAR(50)  NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          VARCHAR(20)  NOT NULL CHECK (role IN ('client', 'employee', 'admin')),
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP    NOT NULL DEFAULT now()
);
CREATE TABLE clients (
    id           SERIAL PRIMARY KEY,
    user_id      INT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    company_name VARCHAR(100) NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    phone        VARCHAR(16),
    inn          VARCHAR(12) NOT NULL UNIQUE,
    created_at   TIMESTAMP NOT NULL DEFAULT now()
);
CREATE TABLE employees (
    id         SERIAL PRIMARY KEY,
    user_id    INT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    full_name  VARCHAR(100) NOT NULL,
    position   VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
CREATE TABLE projects (
    id          SERIAL PRIMARY KEY,
    client_id   INT NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
    name        VARCHAR(150) NOT NULL,
    description TEXT,
    status      VARCHAR(20) NOT NULL DEFAULT 'planned'
                CHECK (status IN ('planned', 'in_progress', 'on_hold', 'completed', 'cancelled')),
    start_date  DATE,
    end_date    DATE,
    created_at  TIMESTAMP NOT NULL DEFAULT now()
);
CREATE TABLE tasks (
    id          SERIAL PRIMARY KEY,
    project_id  INT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    assignee_id INT REFERENCES employees(id) ON DELETE SET NULL,
    title       VARCHAR(150) NOT NULL,
    description TEXT,
    status      VARCHAR(20) NOT NULL DEFAULT 'todo'
                CHECK (status IN ('todo', 'in_progress', 'review', 'done')),
    priority    VARCHAR(10) NOT NULL DEFAULT 'medium'
                CHECK (priority IN ('low', 'medium', 'high')),
    due_date    DATE,
    created_at  TIMESTAMP NOT NULL DEFAULT now()
);
