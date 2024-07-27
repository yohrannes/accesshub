-- VE - Virtual Environment for Openvz (container)
-- vzWin - Openvz for Windows

INSERT INTO phosts_region_a (hostname_alias, ip_address, user, password, sub_region, virtualization_type)
VALUES
	('jamaicanode', '000.000.000.000','root', 'teste123*', 'ashburn', 'VE'),
	('australianode', '099.000.000.000', 'root', 'teste123*', 'campinas', 'vzWin');

select * from phosts_region_a;
select hostname_alias from phosts_region_a;
select user, ip_address, ssh_port from phosts_region_a where id = 2;
SELECT id FROM phosts_region_a where virtualization_type = 'vzWin' AND hostname_alias = 'jamaicanode';
-- delete from tabela where ...
delete from phosts_region_a where id = 1;
-- drop table ...
