CREATE TABLE clients (
    id           SERIAL PRIMARY KEY,
    user_id      INT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    company_name VARCHAR(100) NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    phone        VARCHAR(16),
    inn          VARCHAR(12) NOT NULL UNIQUE,
    created_at   TIMESTAMP NOT NULL DEFAULT now()
);
