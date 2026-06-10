-- ==========================================
-- MARKET DATA ENHANCEMENTS
-- ==========================================

ALTER TABLE market_snapshots
ADD COLUMN change_7d NUMERIC(10,4);

ALTER TABLE market_snapshots
ADD COLUMN change_30d NUMERIC(10,4);

ALTER TABLE market_snapshots
ADD COLUMN market_cap NUMERIC(30,2);

ALTER TABLE market_snapshots
ADD COLUMN circulating_supply NUMERIC(30,8);

ALTER TABLE market_snapshots
ADD COLUMN total_supply NUMERIC(30,8);