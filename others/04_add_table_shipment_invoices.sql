/****** Object:  Table [dbo].[shipmnet_invoices]    Script Date: 28.12.2024 15:51:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[shipmnet_invoices](
	[id] [int] NOT NULL,
	[shp_id] [int] NULL,
	[create_date] [datetime] NULL,
	[actual_date] [datetime] NULL,
	[number] [varchar](20) NULL,
	[invoice_type] [bit] NULL,
	[source_code] [varchar](10) NULL,
	[recipient_code] [varchar](10) NULL,
	[delivery_type] [varchar](128) NULL,
 CONSTRAINT [PK_shipmnet_invoices] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[shipmnet_invoices]  WITH CHECK ADD  CONSTRAINT [FK_shipmnet_invoices_shipmnet] FOREIGN KEY([shp_id])
REFERENCES [dbo].[shipments] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[shipmnet_invoices] CHECK CONSTRAINT [FK_shipmnet_invoices_shipmnet]
GO


