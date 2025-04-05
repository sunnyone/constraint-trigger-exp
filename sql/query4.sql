-- パターン4：電話番号が NULL の場合（OK）

INSERT INTO customer (id, name, phone_number) VALUES
  ('00000000-0000-0000-0000-000000000016', 'Frank', NULL),
  ('00000000-0000-0000-0000-000000000017', 'Grace', NULL);
