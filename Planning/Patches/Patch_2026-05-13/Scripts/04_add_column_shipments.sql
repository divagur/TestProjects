
alter table dbo.shipments add last_modify_user varchar(50) null
alter table dbo.shipments add last_modify_date datetime null

alter table dbo.shipment_orders add last_modify_user varchar(50) null
alter table dbo.shipment_orders add last_modify_date datetime null

alter table dbo.shipment_order_parts add last_modify_user varchar(50) null
alter table dbo.shipment_order_parts add last_modify_date datetime null


alter table dbo.movement add last_modify_user varchar(50) null
alter table dbo.movement add last_modify_date datetime null

alter table dbo.movement_item add last_modify_user varchar(50) null
alter table dbo.movement_item add last_modify_date datetime null


