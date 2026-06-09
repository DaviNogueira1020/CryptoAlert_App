-- ==========================================
-- CRYPTO ASSETS
-- ==========================================

CREATE TABLE crypto_assets(
    symbol VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    image_url TEXT
);

-- ==========================================
-- MARKET SNAPSHOTS
-- ==========================================

CREATE TABLE market_snapshots(
    symbol VARCHAR(20) PRIMARY KEY,
    price_usd NUMERIC(18,8) NOT NULL,
    change_24h NUMERIC(10,4),
    volume_24h NUMERIC(20,2),
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_market_snapshot_asset
        FOREIGN KEY(symbol)
        REFERENCES crypto_assets(symbol)
        ON DELETE CASCADE
);

-- ==========================================
-- DEFAULT ASSETS
-- ==========================================

INSERT INTO crypto_assets(
    symbol,
    name
)
VALUES
    ('BTCUSDT', 'Bitcoin'),
    ('ETHUSDT', 'Ethereum'),
    ('SOLUSDT', 'Solana'),
    ('BNBUSDT', 'BNB'),
    ('ADAUSDT', 'Cardano'),
    ('XRPUSDT', 'XRP'),
    ('DOGEUSDT', 'Dogecoin');