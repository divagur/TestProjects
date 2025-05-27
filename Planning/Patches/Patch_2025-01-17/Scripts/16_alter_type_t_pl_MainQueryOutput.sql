
/****** Object:  UserDefinedTableType [dbo].[T_PL_MainQueryOutput]    Script Date: 11.11.2024 11:13:26 ******/
DROP TYPE [dbo].[T_PL_MainQueryOutput]
GO

/****** Object:  UserDefinedTableType [dbo].[T_PL_MainQueryOutput]    Script Date: 11.11.2024 11:13:26 ******/
CREATE TYPE [dbo].[T_PL_MainQueryOutput] AS TABLE(
	[ShpID] [int] NULL,
	[OrdID] [int] NULL,
	[OrdLVID] [int] NULL,
	[ShpDate] [date] NULL,
	[ShpSlotID] [int] NULL,
	[SlotTime] [time](0) NULL,
	[ShpIn] [bit] NULL,
	[InOut] [nvarchar](8) NULL,
	[OrdLVCode] [nvarchar](32) NULL,
	[OrdPartLVCode] [nvarchar](32) NULL,
	[ShpDepLVID] [int] NULL,
	[DepCode] [nvarchar](10) NULL,
	[ShpSpecialCond] [bit] NULL,
	[ShpIsCourier] [bit] NULL,
	[ShpGateID] [int] NULL,
	[GateName] [varchar](8) NULL,
	[KlientName] [varchar](64) NULL,
	[OrderStatus] [varchar](30) NULL,
	[PrcReady] [varchar](7) NULL,
	[DoneShare] [decimal](28, 7) NULL,
	[ShpComment] [varchar](500) NULL,
	[OrdComment] [varchar](500) NULL,
	[ShpDriverPhone] [varchar](30) NULL,
	[ShpDriverFio] [varchar](80) NULL,
	[TransportCompanyName] [varchar](80) NULL,
	[TransportTypeName] [varchar](80) NULL,
	[ShpVehicleNumber] [varchar](32) NULL,
	[ShpTrailerNumber] [varchar](32) NULL,
	[ShpAttorneyNumber] [varchar](30) NULL,
	[ShpAttorneyDate] [date] NULL,
	[ShpSubmissionTime] [datetime] NULL,
	[ShpStartTime] [datetime] NULL,
	[ShpEndTimePlan] [datetime] NULL,
	[ShpEndTimeFact] [datetime] NULL,
	[ShpDelayReasonName] [varchar](254) NULL,
	[ShpDelayComment] [varchar](200) NULL,
	[ShpForwarderFio] [varchar](80) NULL,
	[OrdLVType] [varchar](77) NULL,
	[ShpStampNumber] [varchar](25) NULL,
	[IsAddLv] [bit] NULL,
	[IsEdm] [bit] NULL,
	[ShippingPlacesNumber] [int] NULL,
	[OrderWeight] [decimal](19, 6) NULL,
	[ShpSupplierName] [varchar](254) NULL,
	[TransportViewName] [varchar](50) NULL,
	[WarehouseName] [varchar](254) NULL,
	[FontColor] [int] NULL,
	[BackgroundColor] [int] NULL
)
GO




