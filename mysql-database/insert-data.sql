-- VE - Virtual Environment for Openvz (container)
-- vzWin - Openvz for Windows

INSERT INTO fhosts_region_a (hostname_alias, ip_address, password_hash, sub_region, virtualization_type)
VALUES
  ('jamaicanode', '000.000.000.000', sha2('teste123*',256), 'ashburn', 'VE');
select * from fhosts_region_a;
-- delete from tabela where ...
-- drop table ...


