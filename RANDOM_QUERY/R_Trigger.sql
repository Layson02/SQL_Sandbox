USE [bdpedido]
GO

create trigger bebida on bebida for
insert, update, delete as
-- query do trigger