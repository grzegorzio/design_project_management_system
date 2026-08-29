CREATE TABLE employees (
    id         SERIAL PRIMARY KEY,
    user_id    INT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    full_name  VARCHAR(100) NOT NULL,
    position   VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
