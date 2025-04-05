DELETE FROM family_member;
DELETE FROM customer;
DELETE FROM family;

BEGIN;
-- 家族1
INSERT INTO family (id) VALUES ('11111111-1111-1111-1111-111111111111');
-- 顧客A, B を作成し、同じ家族に所属させる
INSERT INTO customer (id, name, phone_number) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Alice', '090-1234-5678'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Bob',   '090-1234-5678');

INSERT INTO family_member (family_id, customer_id) VALUES
  ('11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  ('11111111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb');

COMMIT;
