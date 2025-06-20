
DROP TYPE [dbo].[T_PL_ShipmentHist]
GO

/****** Object:  UserDefinedTableType [dbo].[T_PL_ShipmentHist]    Script Date: 29.05.2025 14:09:34 ******/
CREATE TYPE [dbo].[T_PL_ShipmentHist] AS TABLE(
	[dml_id] [int] NULL,
	[dml_type] [varchar](1) NULL,
	[dml_type_name] [varchar](20) NOT NULL,
	[dml_date] [datetime] NOT NULL,
	[dml_user_name] [varchar](64) NOT NULL,
	[dml_comp_name] [varchar](64) NOT NULL,
	[shipment_id] [int] NOT NULL,
	[SlotTime] [time](0) NULL,
	[s_date] [date] NULL,
	[s_comment] [varchar](500) NULL,
	[o_comment] [varchar](500) NULL,
	[gate_name] [varchar](8) NULL,
	[sp_condition] [bit] NULL,
	[driver_phone] [varchar](30) NULL,
	[driver_fio] [varchar](80) NULL,
	[vehicle_number] [varchar](32) NULL,
	[trailer_number] [varchar](32) NULL,
	[attorney_number] [varchar](30) NULL,
	[attorney_date] [date] NULL,
	[submission_time] [datetime] NULL,
	[start_time] [datetime] NULL,
	[end_time] [datetime] NULL,
	[leave_time] [datetime] NULL,
	[delay_reasons_name] [varchar](254) NULL,
	[delay_comment] [varchar](200) NULL,
	[depositor_id] [int] NULL,
	[is_courier] [bit] NULL,
	[forwarder_fio] [varchar](80) NULL,
	[stamp_number] [varchar](25) NULL,
	[attorney_issued] [varchar](150) NULL,
	[s_in] [bit] NULL,
	[is_add_lv] [bit] NULL,
	[transport_company_name] [varchar](254) NULL,
	[transport_type_name] [varchar](50) NULL,
	[supplier_name] [varchar](254) NULL,
	[custom_post_name] [varchar](254) NULL,
	[warehouse_name] [varchar](254) NULL,
	[transport_view_name] [varchar](50) NULL,
	[dep_name] [varchar](254) NULL,
	[dep_lv_id] [int] NULL,
	[dep_lv_db] [varchar](254) NULL,
	[FontColor] [int] NULL,
	[BackgroundColor] [int] NULL,
	[log_num] [int] NULL,
	[InOut] [nvarchar](8) NULL
)
GO


