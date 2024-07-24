-- VE - Virtual Environment for Openvz (container)
-- vzWin - Openvz for Windows

INSERT INTO phosts_region_a (hostname_alias, ip_address, password, sub_region, virtualization_type)
VALUES
	('jamaicanode', '000.000.000.000', 'teste123*', 'ashburn', 'VE'),
	('australianode', '099.000.000.000', 'teste123*', 'campinas', 'vzWin');
select * from phosts_region_a;
select hostname_alias from phosts_region_a;
-- delete from tabela where ...
delete from phosts_region_a where id = 1;
-- drop table ...
