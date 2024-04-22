update pl_query set qry_Repeating = '
 
select vs.shp_id, so.id, so.lv_order_id, vs.s_date, vs.time_slot_id,
				vs.slot_time,
				vs.s_in, N''выход'' InOut, so.lv_order_code,sop.os_lvcode, vs.dep_lv_id, vs.dep_name, vs.sp_condition, vs.is_courier,
				vs.gate_id, vs.gate_name,cmp_ShortName,
				cast(ord_StatusID as nvarchar(11)) + N'' - '' + isnull(msg_Greek, N'''') OrdStatusText,
				(
					case when ActPcs <> 0 then cast(cast(round(cast(ActPcs as numeric(10, 2)) / ExpPcs * 100, 2) as numeric(10, 2)) as varchar(7)) + N''%'' end
				) Done,
				(case when ActPcs <> 0 then cast(ActPcs as numeric(10, 2)) / ExpPcs end) DoneShare,
				vs.s_comment, so.comment,
				vs.driver_phone,vs.driver_fio,vs.tc_name tc, vs.transport_type_name tt_name,
				vs.vehicle_number, vs.trailer_number,
				vs.attorney_number, vs.attorney_date,
				vs.submission_time, 
				vs.start_time, vs.end_time, vs.leave_time,
				vs.delay_reason_name, vs.delay_comment,
				vs.forwarder_fio,ort_Code + N'' - '' + ort_Description OrdLVType,
				vs.stamp_number,
				vs.is_add_lv,
				sop.shipping_places_number,
				sop.order_part_weight,vs.supplier_name
				
		from 
			v_shipments vs with(nolock)
			left join shipment_orders so on (vs.shp_id = so.shipment_id) 
			left join shipment_order_parts sop on sop.sh_order_id = so.id
			left join {DB}.dbo.LV_Order with(nolock) on ord_ID = so.lv_order_id
			outer apply
		(
		 select
			  sum(
					cast(
							case 
								when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)
								else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty) 
							end
						/ Box.iuc_Conversion as int)
				) ExpBox,
			  sum(cast((
			   case when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)
			   else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty) end
			  % Pal.iuc_Conversion) / Box.iuc_Conversion as int)) ExpBoxMix,
			  ceiling(sum(
			   case when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)
			   else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty) end
			  / Pal.iuc_Conversion)) ExpPal,
			  sum(cast(floor(
			   case when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)
			   else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty) end
			  / Pal.iuc_Conversion) as int)) ExpPalMon,
			  sum(cast(
			   case when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)
			   else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty) end
			  as int)) ExpPcs,
			  sum(cast(isnull(oia_PickedQty * ActPcs.iuc_Conversion, oia_PickedQty) as int)) ActPcs,
			  count(distinct ori_ID) NumOfLines,
			  sum(cast(isnull(oia_PackedQty * ActPcs.iuc_Conversion, oia_PackedQty) as int)) PackedPcs
		 from 
				{DB}.dbo.LV_OrderItem with(nolock)
				join {DB}.dbo.LV_OrderShipItem with(nolock) on osi_OrderItemID = ori_ID and osi_StatusID <> 11 /*calcelled*/
				join {DB}.dbo.LV_ItemUnit ExpIU with(nolock) on ExpIU.itu_ID = ori_ItemUnitID
				left join {DB}.dbo.LV_OrderShipItemAnalysis with(nolock) on oia_OrderShipItemID = osi_ID
				left join {DB}.dbo.LV_ItemUnitConversion ExpPcs with(nolock) on ExpPcs.iuc_ProductID = ori_ProductID and ExpPcs.iuc_ConvertedUnitID = ExpIU.itu_UnitID and ExpPcs.iuc_ReferenceUnitID = 5
				left join {DB}.dbo.LV_ItemUnitConversion Box with(nolock) on Box.iuc_ProductID = ori_ProductID and Box.iuc_ConvertedUnitID = 6 and Box.iuc_ReferenceUnitID = 5
				left join {DB}.dbo.LV_ItemUnitConversion Pal with(nolock) on Pal.iuc_ProductID = ori_ProductID and Pal.iuc_ConvertedUnitID = 24 and Pal.iuc_ReferenceUnitID = 5
				left join {DB}.dbo.LV_ItemUnit ActIU with(nolock) on ActIU.itu_ID = oia_ItemUnitID
				left join {DB}.dbo.LV_ItemUnitConversion ActPcs with(nolock) on ActPcs.iuc_ProductID = ori_ProductID and ActPcs.iuc_ConvertedUnitID = ActIU.itu_UnitID and ActPcs.iuc_ReferenceUnitID = 5
		 where ori_OrderID = lv_order_id
	) a1
	left join {DB}.dbo.LV_Customer with(nolock) on cus_ID = ord_CustomerID
	left join {DB}.dbo.LV_Company with (nolock) on cmp_ID = cus_CompanyID
	left join {DB}.dbo.LV_OrderType with (nolock) on ort_ID = ord_TypeID
	/*left join PL_Slot with(nolock) on slt_ID = ldg_SlotID*/
	left join {DB}.dbo.LV_ProgressStatus with(nolock) on pst_ID = ord_StatusID
	left join {DB}.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and  msg_languageID = 4
	where 
		(@In = 0 or @In is NULL)
		and vs.s_in = 0
		and (vs.dep_lv_db = N''{DB}'' or ({i} = 1 and vs.dep_lv_db is NULL))
		and (
				(vs.s_date >= @From and vs.s_date <= @Till) 
				/*or (con_ID is NULL and ldg_DepLVID in (63, 66, 59, 65, 61, 62, 21) and ldg_D >= dateadd(day, -7, @From) and ldg_D < @From) */
				or (
						(
							(
								vs.leave_time is NULL 
								and (ord_StatusID <> 4 or ord_StatusID is NULL)
							) 
							or ord_StatusID in (1, 2)
						) 
						and vs.s_date < @From and vs.s_date < cast(getdate() as date)
					)
			)
		and vs.shp_id = isnull(@ShpID, vs.shp_id)
		and (so.id = isnull(@OrdID, so.id) or so.id is NULL)
	union all
	
	select 
				vs.shp_id, so.id, so.lv_order_id,  vs.s_date, vs.time_slot_id,
				vs.slot_time,
				vs.s_in, N''вход'' InOut, so.lv_order_code,null as os_lvcode, vs.dep_lv_id, vs.dep_name, vs.sp_condition, vs.is_courier,
				vs.gate_id, vs.gate_name,cmp_ShortName,
				cast(rct_ProgressID as nvarchar(11)) + N'' - '' + isnull(msg_Greek, N'''') StatusText,
				--(       case         when a1.lsk_CUQuantity <> 0 then cast(cast(round(cast(a1.lsk_CUQuantity as numeric(10, 2)) / rci_ExpQuantity * 100, 2) as numeric(10, 2)) as varchar(7)) + N''%''        end       ) Done,      
				--(       case         when a1.lsk_CUQuantity <> 0 then cast(a1.lsk_CUQuantity as numeric(10, 2)) / rci_ExpQuantity        end      ) DoneShare,      
				(case when a1.rci_ActQuantity <> 0 then cast(cast(round(cast(a1.rci_ActQuantity as numeric(10, 2)) / rci_ExpQuantity * 100, 2) as numeric(10, 2)) as varchar(7)) + N''%'' end) Done,  
				(case when a1.rci_ActQuantity <> 0 then cast(a1.rci_ActQuantity as numeric(10, 2)) / rci_ExpQuantity end) DoneShare, 
				vs.s_comment, so.comment,
				vs.driver_phone,vs.driver_fio,vs.tc_name tc, vs.transport_type_name tt_name,
				vs.vehicle_number, vs.trailer_number,
				vs.attorney_number, vs.attorney_date,
				vs.submission_time, 
				vs.start_time, vs.end_time, vs.leave_time,
				vs.delay_reason_name, vs.delay_comment,
				vs.forwarder_fio,
				 rtt_Code + N'' - '' + rtt_Description OrdLVType,
				 vs.stamp_number,
				vs.is_add_lv,
				so.shipping_places_number,
				so.order_weight,vs.supplier_name
	from 
			v_shipments vs with(nolock)
			left join shipment_orders so on (vs.shp_id = so.shipment_id) 
			left join {DB}.dbo.LV_Receipt with(nolock) on rct_ID = so.lv_order_id
			left join {DB}.dbo.LV_Supplier with(nolock) on spl_ID = rct_SupplierID
			left join {DB}.dbo.LV_Company with (nolock) on cmp_ID = spl_CompanyID
			left join {DB}.dbo.LV_ReceiptType with (nolock) on rtt_ID = rct_TypeID
			/*left join PL_Slot with(nolock) on slt_ID = ldg_SlotID*/
			left join {DB}.dbo.LV_ProgressStatus with(nolock) on pst_ID = rct_ProgressID
			left join {DB}.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and msg_languageID = 4
			left join (
					select  
								rct_id, 
								sum(rci_ExpQuantity) as rci_ExpQuantity,
								sum(rci_ActQuantity) as rci_ActQuantity        
								--,a.lsk_CUQuantity       
						from 
							{DB}.dbo.LV_Receipt with(nolock)       
							inner join {DB}.dbo.LV_ReceiptItem with (nolock) on rci_ReceiptID = rct_ID        
							/*inner join (             
											SELECT log_ReceiptID, sum(lsk_CUQuantity) as lsk_CUQuantity           
											FROM 
													{DB}.[dbo].[LV_LogStock]             
													inner join {DB}.dbo.LV_Log  on  log_ID = lsk_LogID             
											group by log_ReceiptID          
										) a on log_ReceiptID = rci_ReceiptID*/        
						group by rct_id --,lsk_CUQuantity 
		) a1 on a1.rct_id = LV_Receipt.rct_ID
	where 
			(@In = 1 or @In is NULL)
			and vs.s_in = 1
			and (vs.dep_lv_db = N''{DB}'' or ({i} = 1 and vs.dep_lv_db is NULL))
			and (
					 (vs.s_date >= @From and vs.s_date <= @Till) or
					 /*(con_ID is NULL and ldg_DepLVID in (63, 66, 59, 65, 61, 62, 21) and ldg_D >= dateadd(day, -7, @From) and ldg_D < @From) or*/
					 (((vs.leave_time is NULL and (rct_ProgressID <> 4 or rct_ProgressID is NULL)) or rct_ProgressID in (1, 2)) and vs.s_date < @From and vs.s_date < cast(getdate() as date))
				)
			and vs.shp_id = isnull(@ShpID, vs.shp_id)
			and (so.id = isnull(@OrdID, so.id) or so.id is NULL)
union all
select m.id shp_id, mi.id ord_id, mi.TklLVID lv_order_id, m.m_date, m.time_slot_id,
				(case m.sp_condition when 0 then ts.slot_time else m.special_time end) SlotTime,
				cast(NULL as bit) s_in, N''перем'' InOut, tkl_Code lv_order_code,null as os_lvcode, d.lv_id dep_lv_id, d.name dep_name,  m.sp_condition, 
				cast(NULL as bit) is_courier, cast(NULL as int) gate_id, cast(NULL as nvarchar(8)) gate_name,
				(case when m.def_customer = 0 then d.name else N''BAXI'' end) cmp_ShortName,
				isnull(pst_Code, N'''') + N'' - '' + isnull(msg_Greek, N'''') StatusText,
				(case when CntDone <> 0 then cast(cast(round(cast(CntDone as numeric(10, 2)) / CntOverall * 100, 2) as numeric(10, 2)) as varchar(6)) + N''%'' end) Done,
				(case when CntDone <> 0 then cast(CntDone as numeric(10, 2)) / CntOverall end) DoneShare,    
				m.comment s_comment, cast(NULL as varchar(500)) so_comment,
				cast(NULL as varchar(30)) driver_phone,m.performer driver_fio,cast(NULL as varchar(80)) tc_name, 
				cast(NULL as varchar(80)) transport_type_name, cast(NULL as varchar(20)) vehicle_number, 
				cast(NULL as varchar(20)) trailer_number,cast(NULL as varchar(30)) attorney_number, cast(NULL as date) attorney_date,
				cast(NULL as datetime) submission_time, cast(NULL as datetime) start_time, cast(NULL as datetime) end_time, 
				cast(NULL as datetime) leave_time,cast(NULL as varchar(254)) delay_reason_name, cast(NULL as varchar(200)) delay_comment,
				cast(NULL as varchar(80)) forwarder_fio, cast(NULL as varchar(77)) OrdLVType, cast(NULL as varchar(25)) stamp_number,
				1 is_add_lv,
				null shipping_places_number,
				null order_weight, null supplier_name
from movement m with(nolock)
left join movement_item mi with(nolock) on mi.movement_id = m.id
left join depositors d with(nolock) on d.id = mi.depositor_id
left join time_slot ts with(nolock) on ts.id = m.time_slot_id
left join delay_reasons dr with(nolock) on dr.id = m.delay_reasons_id
left join {DB}.dbo.LV_TaskList with(nolock) on tkl_ID = mi.TklLVID
left join {DB}.dbo.LV_ProgressStatus with(nolock) on pst_ID = tkl_StatusID
left join {DB}.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and msg_languageID = 4
outer apply
(
	select cast(min(tsk_ActualTime) as smalldatetime) ldg_Began, cast(max(tsk_ActualTime) as smalldatetime) ldg_Ended,
	sum(case when tsk_StatusID in (3, 4) then 1 else 0 end) CntDone, count(*) CntOverall
	from {DB}.dbo.LV_Task with(nolock)
	where tsk_TaskListID = mi.TklLVID
) a1

where (@In = 2 or @In is NULL)
  and (d.lv_base = N''{DB}'' or ({i} = 1 and d.lv_base is NULL))
  and (
	(m.m_date >= @From and m.m_date <= @Till) or
	(m.m_date < @From and m.m_date < cast(getdate() as date) and (tkl_StatusID not in (3, 4) or tkl_StatusID is NULL))
  )
  and m.id = isnull(@ShpID, m.id)
  and (mi.id = isnull(@OrdID, mi.id) or mi.id is NULL)

'
where qry_ID = 1