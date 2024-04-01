update pl_query
set qry_Repeating = '

select ord_ID lv_order_id,ISNULL( vs.s_date, ISNULL(ord_ExpExecuteDate, ord_InputDate)) s_date,	     
		vs.slot_time,  ISNULL(vs.s_in,0) s_in, N''выход'' InOut, ord_Code lv_order_code,ost_Code as os_lvcode, 
		vs.gate_name,cmp_ShortName,     
		case when ActPcs <> 0 then cast(cast(round(cast(ActPcs as numeric(10, 2)) / ExpPcs * 100, 2) as numeric(10, 2)) as varchar(7)) + N''%'' end Done,      
		case when ActPcs <> 0 then cast(ActPcs as numeric(10, 2)) / ExpPcs end DoneShare,   
		ShpPlaceNumber shipping_places_number,
		order_deposit.deposit_count,
		(
			SELECT count(loc_StorageSystemID) PicCount
			FROM          
			   {DB}.dbo.lv_order ord_in with (nolock)
			inner join {DB}.dbo.LV_OrderShipment with (nolock) on ord_id = ost_OrderID
			inner join {DB}.dbo.LV_OrderShipItem  with (nolock) on osi_OrderShipmentID = ost_ID
			inner join {DB}.dbo.LV_OrderShipItemStock with (nolock) on oss_OrderShipItemID = osi_ID 
			inner join {DB}.dbo.LV_Task with (nolock) on tsk_id = oss_TaskID and tsk_StatusID in (1,2)
			inner join {DB}.dbo.LV_Location with (nolock) on loc_id = tsk_FromLocationID and loc_DepositorID = 59
			where
			  ord_StatusID <> 3 
			and  ord_DepositorID = 59 
			and  oss_TaskID is not null
			and loc_StorageSystemID = 1
			and ord_ID = ord_out.ord_ID
			group by ord_ID, loc_StorageSystemID
		) assembly_picking,
		(
			SELECT count(loc_StorageSystemID) PicCount
			FROM          
			   {DB}.dbo.lv_order ord_in with (nolock)
			inner join {DB}.dbo.LV_OrderShipment with (nolock) on ord_id = ost_OrderID
			inner join {DB}.dbo.LV_OrderShipItem  with (nolock) on osi_OrderShipmentID = ost_ID
			inner join {DB}.dbo.LV_OrderShipItemStock with (nolock) on oss_OrderShipItemID = osi_ID 
			inner join {DB}.dbo.LV_Task with (nolock) on tsk_id = oss_TaskID and tsk_StatusID in (1,2)
			inner join {DB}.dbo.LV_Location with (nolock) on loc_id = tsk_FromLocationID and loc_DepositorID = 59
			where
			  ord_StatusID <> 3 
			and  ord_DepositorID = 59 
			and  oss_TaskID is not null
			and loc_StorageSystemID in (3,14)
			and ord_ID = ord_out.ord_ID
			group by ord_ID, loc_StorageSystemID
		) assembly_pallet,
		(
			SELECT count(loc_StorageSystemID) PicCount
			FROM          
			   {DB}.dbo.lv_order ord_in with (nolock)
			inner join {DB}.dbo.LV_OrderShipment with (nolock) on ord_id = ost_OrderID
			inner join {DB}.dbo.LV_OrderShipItem  with (nolock) on osi_OrderShipmentID = ost_ID
			inner join {DB}.dbo.LV_OrderShipItemStock with (nolock) on oss_OrderShipItemID = osi_ID 
			inner join {DB}.dbo.LV_Task with (nolock) on tsk_id = oss_TaskID and tsk_StatusID in (1,2)
			inner join {DB}.dbo.LV_Location with (nolock) on loc_id = tsk_FromLocationID and loc_DepositorID = 59
			where
			  ord_StatusID <> 3 
			and  ord_DepositorID = 59 
			and  oss_TaskID is not null
			and loc_StorageSystemID = 16
			and ord_ID = ord_out.ord_ID
			group by ord_ID, loc_StorageSystemID
		) assembly_mezzanine
		from      
		
			{DB}.dbo.LV_Order ord_out with(nolock)
			left join shipment_orders so on  ord_ID = so.lv_order_id 
			left join shipment_order_parts sop on so.id = sop.sh_order_id
			left join v_shipments vs with(nolock) on (vs.shp_id = so.shipment_id and vs.s_in = 0 )   
			left join {DB}.dbo.LV_OrderShipment with (nolock) on ost_OrderID = ord_ID
			left join
			(
				SELECT ost_OrderID, count(tkd_PrereqTaskID) deposit_count
				FROM          
				    {DB}.dbo.LV_OrderShipItemStock with (nolock)
				inner join  {DB}.dbo.LV_OrderShipItem with (nolock) ON LV_OrderShipItemStock.oss_OrderShipItemID = LV_OrderShipItem.osi_ID 
				inner join  {DB}.dbo.LV_OrderShipment with (nolock) ON LV_OrderShipItem.osi_OrderShipmentID = LV_OrderShipment.ost_ID
				inner join  {DB}.dbo.LV_Order with (nolock) on ord_id = ost_OrderID
				left join  {DB}.dbo.LV_TaskDependency with (nolock) on tkd_TaskID = oss_TaskID
				where ord_StatusID <> 3
				group by ost_OrderID, ord_code

			)order_deposit on order_deposit.ost_OrderID = ord_ID
			left join 
			(
				select order_id,count (distinct stc_SSCC) ShpPlaceNumber
							from (
									select 
										stc_SSCC, ord_id order_ID 
									from {DB}.dbo.LV_StockContainer with(nolock)
									left join {DB}.dbo.LV_Stock with(nolock) on stk_ContainerID = stc_ID
									left join {DB}.dbo.LV_StockPackType with(nolock) on spt_StockID = stk_ID
									left join {DB}.dbo.LV_OrderShipItemStock with(nolock) on stk_ID= oss_StockID 
									left join {DB}.dbo.LV_OrderShipItem with(nolock) on osi_ID = oss_OrderShipItemID 
									left join {DB}.dbo.LV_OrderItem  with(nolock) on osi_OrderItemID = ori_ID
									left join {DB}.dbo.LV_Order with(nolock)on ord_ID=ori_OrderID 
									join {DB}.dbo.V_StandardPackType  with(nolock) on  sdp_UnitID = stc_UnitID
									group by 
									ord_id,ord_Code, 
									stc_SSCC 
							)t
							where order_id is not null
							group by order_id
			)order_place_number on order_place_number.order_id = ord_ID
			outer apply    
			(
				select       sum(       cast(         case           when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)          
				else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty)          end        / Box.iuc_Conversion as int)      ) ExpBox,       
				sum(cast((        case when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)        
				else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty) end       % Pal.iuc_Conversion) / Box.iuc_Conversion as int)) ExpBoxMix,       
				ceiling(sum(        case when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)        
				else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty) end       / Pal.iuc_Conversion)) ExpPal,       
				sum(cast(floor(        case when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)        
				else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty) end       / Pal.iuc_Conversion) as int)) ExpPalMon,       
				sum(cast(        case when oia_PickListQty = 0 then isnull(osi_Quantity * ExpPcs.iuc_Conversion, osi_Quantity)        
				else isnull(oia_PickListQty * ActPcs.iuc_Conversion, oia_PickListQty) end       as int)) ExpPcs,       sum(cast(isnull(oia_PickedQty * ActPcs.iuc_Conversion, oia_PickedQty) as int)) ActPcs,       
				count(distinct ori_ID) NumOfLines,       sum(cast(isnull(oia_PackedQty * ActPcs.iuc_Conversion, oia_PackedQty) as int)) PackedPcs     from 
					{DB}.dbo.LV_OrderItem with(nolock)      
					join {DB}.dbo.LV_OrderShipItem with(nolock) on osi_OrderItemID = ori_ID and osi_StatusID <> 11 /*calcelled*/      
					join {DB}.dbo.LV_ItemUnit ExpIU with(nolock) on ExpIU.itu_ID = ori_ItemUnitID      
					left join {DB}.dbo.LV_OrderShipItemAnalysis with(nolock) on oia_OrderShipItemID = osi_ID      
					left join {DB}.dbo.LV_ItemUnitConversion ExpPcs with(nolock) on ExpPcs.iuc_ProductID = ori_ProductID and ExpPcs.iuc_ConvertedUnitID = ExpIU.itu_UnitID and ExpPcs.iuc_ReferenceUnitID=5      
					left join {DB}.dbo.LV_ItemUnitConversion Box with(nolock) on Box.iuc_ProductID = ori_ProductID and Box.iuc_ConvertedUnitID = 6 and Box.iuc_ReferenceUnitID = 5      
					left join {DB}.dbo.LV_ItemUnitConversion Pal with(nolock) on Pal.iuc_ProductID = ori_ProductID and Pal.iuc_ConvertedUnitID = 24 and Pal.iuc_ReferenceUnitID = 5      
					left join {DB}.dbo.LV_ItemUnit ActIU with(nolock) on ActIU.itu_ID = oia_ItemUnitID      
					left join {DB}.dbo.LV_ItemUnitConversion ActPcs with(nolock) on ActPcs.iuc_ProductID = ori_ProductID and ActPcs.iuc_ConvertedUnitID = ActIU.itu_UnitID and ActPcs.iuc_ReferenceUnitID=5     
				where ori_OrderID = ord_out.ord_ID   
			) a1
			left join {DB}.dbo.LV_Customer with(nolock) on cus_ID = ord_CustomerID   
			left join {DB}.dbo.LV_Company with (nolock) on cmp_ID = cus_CompanyID   
			left join {DB}.dbo.LV_OrderType with (nolock) on ort_ID = ord_TypeID   /*left join PL_Slot with(nolock) on slt_ID = ldg_SlotID*/   
			left join {DB}.dbo.LV_ProgressStatus with(nolock) on pst_ID = ord_StatusID   
			left join {DB}.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and  msg_languageID = 4    
		where     
			--(@In = 0 or @In is NULL)
			(CHARINDEX(''0'', @filter)>0 or @filter is NULL)
			and (vs.dep_lv_db = N''{DB}'' or ({i} = 1 and vs.dep_lv_db is NULL))    
			and ord_StatusID in (1,2,3,4,5,6,7)
			and ost_StatusID < 8
		union all      

		select
				so.lv_order_id, vs.s_date,     
				vs.slot_time,  vs.s_in, N''вход'' InOut, so.lv_order_code,null as os_lvcode, 
				vs.gate_name,cmp_ShortName, 
				(case when a1.lsk_CUQuantity <> 0 then cast(cast(round(cast(a1.lsk_CUQuantity as numeric(10, 2)) / rci_ExpQuantity * 100, 2) as numeric(10, 2)) as varchar(7)) + N''%'' end) Done,  
				(case when a1.lsk_CUQuantity <> 0 then cast(a1.lsk_CUQuantity as numeric(10, 2)) / rci_ExpQuantity end) DoneShare,            
				sop.shipping_places_number,
				0 deposit_count,
				0 assembly_picking,
				0 assembly_pallet,
				0 assembly_mezzanine
		from      
			v_shipments vs with(nolock)     
			left join shipment_orders so on (vs.shp_id = so.shipment_id)    
			left join shipment_order_parts sop on sop.sh_order_id = so.id
			left join {DB}.dbo.LV_Receipt with(nolock) on rct_ID = so.lv_order_id     
			left join {DB}.dbo.LV_Supplier with(nolock) on spl_ID = rct_SupplierID     
			left join {DB}.dbo.LV_Company with (nolock) on cmp_ID = spl_CompanyID     
			left join {DB}.dbo.LV_ReceiptType with (nolock) on rtt_ID = rct_TypeID     /*left join PL_Slot with(nolock) on slt_ID = ldg_SlotID*/     
			left join {DB}.dbo.LV_ProgressStatus with(nolock) on pst_ID = rct_ProgressID     
			left join {DB}.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and msg_languageID = 4     
			left join (       
						select         rct_id          ,sum(rci_ExpQuantity) as rci_ExpQuantity        ,sum(rci_ActQuantity) as rci_ActQuantity        ,a.lsk_CUQuantity       
						from 
							{DB}.dbo.LV_Receipt with(nolock)       
							inner join {DB}.dbo.LV_ReceiptItem with (nolock) on rci_ReceiptID = rct_ID        
							inner join (             
											SELECT log_ReceiptID, sum(lsk_CUQuantity) as lsk_CUQuantity           
											FROM 
													{DB}.[dbo].[LV_LogStock]             
													inner join {DB}.dbo.LV_Log  on  log_ID = lsk_LogID             
											group by log_ReceiptID          
										) a on log_ReceiptID = rci_ReceiptID        
						group by rct_id,lsk_CUQuantity     
					) a1 on a1.rct_id = LV_Receipt.rct_ID   
		where      
				--(@In = 1 or @In is NULL)
				(CHARINDEX(''1'', @filter)>0 or @filter is NULL)
				and vs.s_in <> 0     
				and (vs.dep_lv_db = N''{DB}'' or ({i} = 1 and vs.dep_lv_db is NULL))     
				and rct_ProgressID <> 3 

	union all  

	select 
			tsk_ID lv_order_id, tsk_CreateTime,      
			null SlotTime, 
			cast(NULL as bit) s_in, N''перемещение'' InOut, tsk_Code lv_order_code,null as os_lvcode, 
			cast(NULL as nvarchar(8)) gate_name,
			N''BAXI'' cmp_ShortName,      
			N''0%''  Done,
			0 DoneShare,
			0 shipping_places_number,
			0 deposit_count,
			0 assembly_picking,
			0 assembly_pallet,
			0 assembly_mezzanine
		
	from 
		{DB}.dbo.LV_Task with(nolock) 
		left join {DB}.dbo.LV_ProgressStatus with(nolock) on pst_ID = tsk_StatusID  
		left join {DB}.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and msg_languageID = 4    
	where
			(CHARINDEX(''2'', @filter)>0 or @filter is NULL)   
			and tsk_TransactionTypeID = 2
			and tsk_StatusID in (1,2)
union all
select 
			tsk_ID lv_order_id, tsk_CreateTime,      
			null SlotTime, 
			cast(NULL as bit) s_in, N''размещение'' InOut, tsk_Code lv_order_code,null as os_lvcode, 
			cast(NULL as nvarchar(8)) gate_name,
			N''BAXI'' cmp_ShortName,      
			N''0%''  Done,
			0 DoneShare,
			0 shipping_places_number,
			0 deposit_count,
			0 assembly_picking,
			0 assembly_pallet,
			0 assembly_mezzanine
		
	from 
		{DB}.dbo.LV_Task with(nolock) 
		left join {DB}.dbo.LV_ProgressStatus with(nolock) on pst_ID = tsk_StatusID  
		left join {DB}.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and msg_languageID = 4    
	where
			(CHARINDEX(''3'', @filter)>0 or @filter is NULL)   
			and tsk_TransactionTypeID = 7
			and tsk_StatusID in (1,2)

',
qry_Last = ') q order by s_date, isnull(slot_time, ''23:59:59'')'
where qry_ID = 2