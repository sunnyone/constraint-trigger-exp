-- パターン1：同じ家族内で同じ番号（OK）

INSERT INTO family (id) VALUES ('00000000-0000-0000-0000-000000000001');

INSERT INTO customer (id, name, phone_number) VALUES
  ('00000000-0000-0000-0000-000000000011', 'Alice', '000-0000-0000'),
  ('00000000-0000-0000-0000-000000000012', 'Bob',   '000-0000-0000');

INSERT INTO family_member (family_id, customer_id) VALUES
  ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000011'),
  ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000012');
