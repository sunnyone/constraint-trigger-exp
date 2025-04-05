-- パターン5：family_member を DELETE → 残った側が未所属になって重複（NG）

DELETE FROM family_member
WHERE customer_id = '00000000-0000-0000-0000-000000000012';
