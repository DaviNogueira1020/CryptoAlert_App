CREATE TABLE alerts (
    id VARCHAR(50) PRIMARY KEY,
    symbol VARCHAR(20) NOT NULL,
    target DOUBLE PRECISION NOT NULL,
    type VARCHAR(10) NOT NULL
        CHECK (type IN ('above', 'below')),
    active BOOLEAN NOT NULL DEFAULT TRUE
);