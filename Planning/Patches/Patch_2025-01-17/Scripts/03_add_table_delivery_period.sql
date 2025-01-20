
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[delivery_period](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[custom_post_id] [int] NULL,
	[warehouse_id] [int] NULL,
	[delivery_day] [int] NULL,
 CONSTRAINT [PK_delivery_period] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[delivery_period]  WITH CHECK ADD  CONSTRAINT [FK_custom_post_fk] FOREIGN KEY([custom_post_id])
REFERENCES [dbo].[custom_posts] ([id])
GO

ALTER TABLE [dbo].[delivery_period] CHECK CONSTRAINT [FK_custom_post_fk]
GO

ALTER TABLE [dbo].[delivery_period]  WITH CHECK ADD  CONSTRAINT [FK_warehouse_delivery_period_fk] FOREIGN KEY([warehouse_id])
REFERENCES [dbo].[warehouses] ([id])
GO

ALTER TABLE [dbo].[delivery_period] CHECK CONSTRAINT [FK_warehouse_delivery_period_fk]
GO


