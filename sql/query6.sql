-- パターン6：phone_number の UPDATE による重複（NG）

INSERT INTO family (id) VALUES ('00000000-0000-0000-0000-000000000003');
INSERT INTO customer (id, name) VALUES
  ('00000000-0000-0000-0000-000000000018', 'Hank');
INSERT INTO customer_phone (customer_id, phone_number) VALUES
  ('00000000-0000-0000-0000-000000000018', '000-9999-9999');
INSERT INTO family_member (family_id, customer_id) VALUES
  ('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000018');

UPDATE customer_phone
SET phone_number = '000-0000-0000'
WHERE customer_id = '00000000-0000-0000-0000-000000000018';
