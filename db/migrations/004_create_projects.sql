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
