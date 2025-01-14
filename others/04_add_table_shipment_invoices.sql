/****** Object:  Table [dbo].[shipmnet_invoices]    Script Date: 28.12.2024 15:51:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[shipment_invoices](
	[id] [int]  IDENTITY(1,1) NOT NULL,
	[shp_id] [int] NULL,
	[create_date] [datetime] NULL,
	[actual_date] [datetime] NULL,
	[number] [varchar](20) NULL,
	[invoice_type] [varchar](32) NULL,
	[source_code] [varchar](10) NULL,
	[recipient_code] [varchar](10) NULL,
	[delivery_type] [varchar](128) NULL,
	[Status] [varchar](32) NULL,
	[Error] [varchar](512) NULL
 CONSTRAINT [PK_shipment_invoices] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[shipment_invoices]  WITH CHECK ADD  CONSTRAINT [FK_shipment_invoices_shipmnet] FOREIGN KEY([shp_id])
REFERENCES [dbo].[shipments] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[shipment_invoices] CHECK CONSTRAINT [FK_shipment_invoices_shipmnet]
GO


