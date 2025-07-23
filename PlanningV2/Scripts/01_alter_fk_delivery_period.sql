
ALTER TABLE [dbo].[delivery_period] DROP CONSTRAINT [FK_custom_post_fk]
GO

ALTER TABLE [dbo].[delivery_period]  WITH CHECK ADD  CONSTRAINT [FK_custom_post_fk] FOREIGN KEY([custom_post_id])
REFERENCES [dbo].[custom_posts] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[delivery_period] CHECK CONSTRAINT [FK_custom_post_fk]
GO


