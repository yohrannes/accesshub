create database db_fhosts; -- Phisical hosts
use db_fhosts;
CREATE TABLE fhosts_region_a (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    hostname_alias VARCHAR(50) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    password_hash VARCHAR(200) NOT NULL,
    sub_region VARCHAR(50) NOT NULL,
    virtualization_type ENUM('none', 'vmware', 'kvm', 'hyper-v', 'xen', 'vzWin', 'VE', 'other') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
