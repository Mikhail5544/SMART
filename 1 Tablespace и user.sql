-- Create the user 
create user CP
  default tablespace INS_DATA
  temporary tablespace TEMP
  profile DEFAULT
  quota unlimited on "INDEX"
  quota unlimited on INS_DATA
  identified by "2q";
  
grant select_catalog_role to CP;

-- Grant/Revoke system privileges 
grant alter session to CP;
grant create cluster to CP;
grant create database link to CP;
grant create dimension to CP;
grant create indextype to CP;
grant create library to CP;
grant create materialized view to CP;
grant create operator to CP;
grant create procedure to CP;
grant create role to CP;
grant create sequence to CP;
grant create session to CP;
grant create synonym to CP;
grant create table to CP;
grant create trigger to CP;
grant create type to CP;
grant create view to CP;
grant debug connect session to CP;
grant query rewrite to CP;

-- Create the role 
create role F_SMART_RO_ROLE;
create role F_SMART_RW_ROLE;
