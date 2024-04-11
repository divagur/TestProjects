SELECT ord_id, 
		case when loc_StorageSystemID = 1 then count( loc_ID) end as 'Pic',
		case when loc_StorageSystemID = 16 then count(distinct loc_ID) end as 'Mez',
		case when loc_StorageSystemID in (3,14) then count( distinct tsk_ContainerID ) end as 'Pal'
FROM          
			lv_order with (nolock)
inner join	LV_OrderShipment with (nolock) on ord_id = ost_OrderID
inner join	LV_OrderShipItem  with (nolock) on osi_OrderShipmentID = ost_ID
inner join	LV_OrderShipItemStock with (nolock) on oss_OrderShipItemID = osi_ID 
inner join LV_Task with (nolock) on tsk_id = oss_TaskID and tsk_StatusID <> 3
inner join LV_Location with (nolock) on loc_id = tsk_FromLocationID and loc_DepositorID = 59
where
		ord_StatusID not in (3)	
and		ord_DepositorID = 59	
and		oss_TaskID is not null

group by ord_ID, loc_StorageSystemID 
order by ord_ID