
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[SP_PL_GetShipmentLog]
	@ShpID int,
	@From		date,
	@Till		date	= NULL,
	@In			int		= NULL,
	@UserId varchar(64) = null
as
begin

	declare @t		T_PL_ShipmentHist;

	set @Till = isnull(@Till, @From);

	set @In = case when @In < 0 then NULL else @In end
	set @ShpID = case when @ShpID < 0 then NULL else @ShpID end
	set @UserId = case when LEN(@UserId) = 0 then NULL else @UserId end

	insert into @t 
	select
				s.dml_id,s.dml_type, 
				case s.dml_type when 'I' then 'Создание' when 'U' then 'Изменение' when 'D' then 'Удаление' end dml_type,
				s.dml_date, s.dml_user_name, s.dml_comp_name, s.shipment_id, 
				(case isnull(s.sp_condition,0) when 0 then ts.slot_time else s.special_time end) slot_time, s.s_date,
				s.s_comment, s.o_comment, g.name gate_name, s.sp_condition, s.driver_phone, s.driver_fio,  
				s.vehicle_number, s.trailer_number, s.attorney_number, s.attorney_date,
				s.submission_time, s.start_time, s.end_time, s.leave_time, dr.name AS delay_reason_name, s.delay_comment,
				s.depositor_id dep_id,s.is_courier, s.forwarder_fio,
				s.stamp_number,s.attorney_issued, 
				s.s_in, s.is_add_lv, tc.name tc_name, tt.name transport_type_name, 
				splr.name ,cpst.name, wh.name,tw.name,
				d.name, d.lv_id dep_lv_id, d.lv_base dep_lv_db, 
				0 FontColor,0 BackgroundColor,
				ROW_NUMBER() OVER(PARTITION BY s.shipment_id ORDER BY s.shipment_id,s.dml_date) AS log_num, N'выход' InOut
	FROM            dbo.shipments_log AS s
				join dbo.depositors d on s.depositor_id = d.id
				LEFT OUTER JOIN dbo.time_slot AS ts ON s.time_slot_id = ts.id 
				LEFT OUTER JOIN dbo.gateways AS g ON s.gate_id = g.id 
				LEFT OUTER JOIN dbo.delay_reasons AS dr ON s.delay_reasons_id = dr.id
				LEFT OUTER JOIN dbo.transport_company tc on s.transport_company_id = tc.id
				LEFT OUTER JOIN dbo.transport_type tt on s.transport_type_id = tt.id
				LEFT OUTER JOIN dbo.suppliers splr on s.supplier_id = splr.id
                LEFT OUTER JOIN dbo.custom_posts cpst on s.custom_post_id = cpst.id
                LEFT OUTER JOIN dbo.warehouses wh on s.warehouse_id = wh.id
                LEFT OUTER JOIN dbo.transport_view tw on s.transport_view_id = tw.id
	where
		cast(s.dml_date as date) >= @From and cast(s.dml_date as date) <= @Till
		and (@In = 0 or @In is NULL)
		and s.s_in = 0
		and s.shipment_id = isnull(@ShpID, s.shipment_id)
		and s.dml_user_name = isnull(@UserId,s.dml_user_name)
	union all
	select
				s.dml_id,s.dml_type, 
				case s.dml_type when 'I' then 'Создание' when 'U' then 'Изменение' when 'D' then 'Удаление' end dml_type,
				s.dml_date, s.dml_user_name, s.dml_comp_name, s.shipment_id, 
				(case isnull(s.sp_condition,0) when 0 then ts.slot_time else s.special_time end) slot_time, s.s_date,
				s.s_comment, s.o_comment, g.name gate_name, s.sp_condition, s.driver_phone, s.driver_fio,  
				s.vehicle_number, s.trailer_number, s.attorney_number, s.attorney_date,
				s.submission_time, s.start_time, s.end_time, s.leave_time, dr.name AS delay_reason_name, s.delay_comment,
				s.depositor_id dep_id,s.is_courier, s.forwarder_fio,
				s.stamp_number,s.attorney_issued, 
				s.s_in, s.is_add_lv, tc.name tc_name, tt.name transport_type_name,
				splr.name ,cpst.name, wh.name,tw.name,
				d.name, d.lv_id dep_lv_id, d.lv_base dep_lv_db, 
				0 FontColor,0 BackgroundColor,
				ROW_NUMBER() OVER(PARTITION BY s.shipment_id ORDER BY s.shipment_id,s.dml_date) AS log_num, N'вход' InOut
	FROM            dbo.shipments_log AS s
				join dbo.depositors d on s.depositor_id = d.id
				LEFT OUTER JOIN dbo.time_slot AS ts ON s.time_slot_id = ts.id 
				LEFT OUTER JOIN dbo.gateways AS g ON s.gate_id = g.id 
				LEFT OUTER JOIN dbo.delay_reasons AS dr ON s.delay_reasons_id = dr.id
				LEFT OUTER JOIN dbo.transport_company tc on s.transport_company_id = tc.id
				LEFT OUTER JOIN dbo.transport_type tt on s.transport_type_id = tt.id
				LEFT OUTER JOIN dbo.suppliers splr on s.supplier_id = splr.id
                LEFT OUTER JOIN dbo.custom_posts cpst on s.custom_post_id = cpst.id
                LEFT OUTER JOIN dbo.warehouses wh on s.warehouse_id = wh.id
                LEFT OUTER JOIN dbo.transport_view tw on s.transport_view_id = tw.id

	where
		cast(s.dml_date as date) >= @From and cast(s.dml_date as date) <= @Till
		and (@In = 1 or @In is NULL)
		and s.s_in = 1
		and s.shipment_id = isnull(@ShpID, s.shipment_id)
		and s.dml_user_name = isnull(@UserId,s.dml_user_name)
	union all
	select
				s.dml_id,s.dml_type, 
				case s.dml_type when 'I' then 'Создание' when 'U' then 'Изменение' when 'D' then 'Удаление' end dml_type,
				s.dml_date, s.dml_user_name, s.dml_comp_name, s.movement_id, 
				(case isnull(s.sp_condition,0) when 0 then ts.slot_time else s.special_time end) slot_time, s.m_date,
				s.comment, cast(NULL as varchar(500)) o_comment, cast(NULL as varchar(8)) gate_name, s.sp_condition, cast(NULL as varchar(30)) driver_phone, 
				cast(NULL as varchar(80)) driver_fio,  
				cast(NULL as varchar(20)) vehicle_number,  cast(NULL as varchar(20)) trailer_number, cast(NULL as varchar(30)) attorney_number, 
				cast(NULL as date) attorney_date,
				cast(NULL as datetime) submission_time, cast(NULL as datetime) start_time, cast(NULL as datetime) end_time, cast(NULL as datetime) leave_time, 
				dr.name AS delay_reason_name, s.delay_comment,
				cast(NULL as int) dep_id,cast(NULL as bit) is_courier, cast(NULL as varchar(80)) forwarder_fio,
				cast(NULL as varchar(25)) stamp_number,cast(NULL as varchar(150)) attorney_issued, 
				cast(NULL as bit) s_in, cast(NULL as bit)  is_add_lv, cast(NULL as varchar(254))  tc_name, 
				cast(NULL as varchar(50))  transport_type_name, 
				cast(NULL as varchar(254)) splr_name ,cast(NULL as varchar(254)) cpst_name, 
				cast(NULL as varchar(254)) wh_name,cast(NULL as varchar(50)) tw_name,
				cast(NULL as varchar(254)) dep_name, cast(NULL as int)  dep_lv_id, cast(NULL as varchar(254))  dep_lv_db,  
				0 FontColor,0 BackgroundColor,
				ROW_NUMBER() OVER(PARTITION BY s.movement_id ORDER BY s.movement_id,s.dml_date) AS log_num, N'перем' InOut
	FROM            
				dbo.movement_log AS s
				LEFT OUTER JOIN dbo.time_slot AS ts ON s.time_slot_id = ts.id 
				LEFT OUTER JOIN dbo.delay_reasons AS dr ON s.delay_reasons_id = dr.id
	where
		cast(s.dml_date as date) >= @From and cast(s.dml_date as date) <= @Till
		and (@In = 2 or @In is NULL)
		and s.movement_id = isnull(@ShpID, s.movement_id)
		and s.dml_user_name = isnull(@UserId,s.dml_user_name)

	select 
			dml_id as DmlType,dml_type as DmlType, dml_type_name as DmlTypeName,dml_date as DmlDate, dml_user_name as DmlUserName, 
			dml_comp_name as DmlCompName, shipment_id as ShipmentId,SlotTime as SlotTime, s_date as SDate,
			s_comment as SComment, o_comment as OComment, gate_name as GateName, sp_condition as SpCondition, 
			driver_phone as DriverPhone, driver_fio as DriverFio,vehicle_number as VehicleNumber, trailer_number as TrailerNumber,
			attorney_number as AttorneyNumber, attorney_date as AttorneyDate,submission_time as SubmissionTime, 
			start_time as StartTime, end_time as EndTime, leave_time as LeaveTime,delay_reasons_name as DelayReasonName, delay_comment as DelayComment,
			depositor_id as DepositorId,is_courier as IsCourier, forwarder_fio as ForwarderFio,
			stamp_number as StampNumber,attorney_issued as AttorneIssued, s_in as ShIn, is_add_lv as IsAddLv, transport_company_name as TransportCompanyName, 
			transport_type_name as TransportTypeName, supplier_name as SupplierName ,custom_post_name as CustomPostName, warehouse_name as WarehouseName,
			transport_view_name as TransportViewName, dep_name as DepositorName, dep_lv_id as DepLvId, dep_lv_db as DepLvDb, 
			0 FontColor,0 BackgroundColor,ROW_NUMBER() OVER(PARTITION BY shipment_id ORDER BY shipment_id,dml_date) AS log_num,InOut as InOut
	from @t
	order by shipment_id, dml_date

end
