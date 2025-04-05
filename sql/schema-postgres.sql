-- 初期化
DROP TABLE IF EXISTS family_member CASCADE;
DROP TABLE IF EXISTS family CASCADE;
DROP TABLE IF EXISTS customer CASCADE;

-- テーブル追加
CREATE TABLE customer (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    phone_number TEXT
);

CREATE INDEX customer_phone_number_index ON customer (phone_number);

CREATE TABLE family (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY
);

CREATE TABLE family_member (
    family_id UUID NOT NULL REFERENCES family(id),
    customer_id UUID NOT NULL REFERENCES customer(id),
    PRIMARY KEY (family_id, customer_id)
);

CREATE INDEX family_member_family_id_index ON family_member (family_id);
CREATE INDEX family_member_customer_id_index ON family_member (customer_id);

-- view
CREATE OR REPLACE VIEW customer_phone_number_conflicts AS
WITH base AS (
  SELECT
    c.id AS customer_id,
    c.phone_number,
    f.family_id
  FROM customer c
  LEFT JOIN family_member f ON c.id = f.customer_id
),
pairs AS (
  SELECT
    t1.customer_id AS t1_customer_id,
    t2.customer_id AS t2_customer_id,
    t1.phone_number AS t1_phone_number,
    t2.phone_number AS t2_phone_number,
    t1.family_id AS t1_family_id,
    t2.family_id AS t2_family_id
  FROM base t1
  JOIN base t2
    ON t1.customer_id <> t2.customer_id
)

SELECT *
FROM pairs
WHERE t1_phone_number IS NOT NULL
  AND t1_phone_number = t2_phone_number
  AND (
    t1_family_id IS NULL
    OR t2_family_id IS NULL
    OR t1_family_id <> t2_family_id
  );

-- functions
CREATE OR REPLACE FUNCTION check_customer_phone_number_conflict_on_update()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM customer_phone_number_conflicts
    WHERE t1_customer_id = NEW.id
  ) THEN
    RAISE EXCEPTION 'Phone number conflict: cannot update customer';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_customer_phone_number_conflict_on_family_change()
RETURNS TRIGGER AS $$
DECLARE
  target_id UUID;
BEGIN
  IF TG_OP = 'DELETE' THEN
    target_id := OLD.customer_id;
  ELSE
    target_id := NEW.customer_id;
  END IF;

  IF EXISTS (
    SELECT 1 FROM customer_phone_number_conflicts
    WHERE t1_customer_id = target_id
  ) THEN
    RAISE EXCEPTION 'Phone number conflict: cannot change family';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger
CREATE CONSTRAINT TRIGGER check_customer_phone_number_conflict_trigger
AFTER INSERT OR UPDATE OF phone_number ON customer
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_customer_phone_number_conflict_on_update();

CREATE CONSTRAINT TRIGGER check_customer_phone_number_conflict_on_family_trigger
AFTER INSERT OR UPDATE OR DELETE ON family_member
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_customer_phone_number_conflict_on_family_change();

