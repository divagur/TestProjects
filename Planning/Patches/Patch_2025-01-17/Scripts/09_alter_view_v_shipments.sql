
/****** Object:  View [dbo].[v_shipments]    Script Date: 16.01.2025 9:25:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
version: 1.3
*/
ALTER VIEW [dbo].[v_shipments]
AS
SELECT        s.id shp_id, s.lv_id,s.s_date, 
				(case isnull(s.sp_condition,0) when 0 then ts.slot_time else s.special_time end) slot_time, 
				NULL AS oper_type, NULL AS order_id,NULL as order_type,  NULL AS klient, NULL AS order_status, NULL AS prc_ready, 
				s.s_comment, s.o_comment, g.name gate_name, s.sp_condition, s.driver_phone, s.driver_fio, NULL AS transport_company, s.vehicle_number, s.trailer_number, s.attorney_number, 
				s.attorney_date,s.attorney_issued,s.stamp_number, s.submission_time, s.start_time, s.end_time, s.leave_time, dr.name AS delay_reason_name, s.delay_comment,
				s.forwarder_fio, s.s_in, d.lv_id dep_lv_id, d.lv_base dep_lv_db, s.time_slot_id, s.gate_id, s.is_courier, s.depositor_id dep_id, 
				d.name dep_name, s.is_add_lv, s.transport_company_id, s.transport_type_id, tc.name tc_name, tt.name transport_type_name,
				spl.name supplier_name,
				s.transport_view_id, tv.name as tv_name,s.warehouse_id, w.code warehouse_code,w.name warehouse_name,
				s.custom_post_id, cp.code custom_post_code, cp.name custom_post_name
FROM            dbo.shipments AS s
				join dbo.depositors d on s.depositor_id = d.id
				LEFT OUTER JOIN dbo.time_slot AS ts ON s.time_slot_id = ts.id 
				LEFT OUTER JOIN dbo.gateways AS g ON s.gate_id = g.id 
				LEFT OUTER JOIN dbo.delay_reasons AS dr ON s.delay_reasons_id = dr.id
				LEFT OUTER JOIN dbo.transport_company tc on s.transport_company_id = tc.id
				LEFT OUTER JOIN dbo.transport_type tt on s.transport_type_id = tt.id
				LEFT OUTER JOIN dbo.suppliers spl on s.supplier_id = spl.id
				LEFT OUTER JOIN dbo.transport_view tv on s.transport_view_id = tv.id
				LEFT OUTER JOIN dbo.warehouses w on s.warehouse_id = w.id
				LEFT OUTER JOIN dbo.custom_posts cp on s.custom_post_id = cp.id

GO


