
alter table dbo.shipments add custom_post_id int null
go
ALTER TABLE [dbo].[shipments]  WITH CHECK ADD  CONSTRAINT [FK_shipments_custom_post] FOREIGN KEY([custom_post_id])
REFERENCES [dbo].[custom_posts] ([id])
GO

ALTER TABLE [dbo].[shipments] CHECK CONSTRAINT [FK_shipments_custom_post]
