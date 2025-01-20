/****** Object:  Table [dbo].[custom_posts]    Script Date: 23.12.2024 11:18:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[custom_posts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](32) NULL,
	[name] [varchar](254) NULL,
	[descr] [varchar](254) NULL,
 CONSTRAINT [PK_custom_posts] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


