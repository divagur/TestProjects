
alter table dbo.shipments add custom_post_id int null
go
ALTER TABLE [dbo].[shipments]  WITH CHECK ADD  CONSTRAINT [FK_shipments_custom_post] FOREIGN KEY([custom_post_id])
REFERENCES [dbo].[custom_posts] ([id])
GO

ALTER TABLE [dbo].[shipments] CHECK CONSTRAINT [FK_shipments_custom_post]


alter table dbo.shipments add warehouse_id int null
go
ALTER TABLE [dbo].[shipments]  WITH CHECK ADD  CONSTRAINT [FK_shipments_warehouse] FOREIGN KEY([warehouse_id])
REFERENCES [dbo].[warehouses] ([id])
GO

ALTER TABLE [dbo].[shipments] CHECK CONSTRAINT [FK_shipments_warehouse]

alter table dbo.shipments add transport_view_id int null
go
ALTER TABLE [dbo].[shipments]  WITH CHECK ADD  CONSTRAINT [FK_shipments_transport_view] FOREIGN KEY([transport_view_id])
REFERENCES [dbo].[transport_view] ([id])
GO

ALTER TABLE [dbo].[shipments] CHECK CONSTRAINT [FK_shipments_transport_view]