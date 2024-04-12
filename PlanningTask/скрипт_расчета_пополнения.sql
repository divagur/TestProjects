SELECT ost_OrderID, count(distinct tkd_PrereqTaskID) 'Кол-во пополнений'
FROM          
			LV_OrderShipItemStock with (nolock)
inner join LV_OrderShipItem with (nolock) ON LV_OrderShipItemStock.oss_OrderShipItemID = LV_OrderShipItem.osi_ID 
inner join LV_OrderShipment with (nolock) ON LV_OrderShipItem.osi_OrderShipmentID = LV_OrderShipment.ost_ID
inner join LV_Order with (nolock) on ord_id = ost_OrderID
inner join LV_TaskDependency with (nolock) on tkd_TaskID = oss_TaskID
inner join LV_Task with (nolock) on tsk_ID = tkd_PrereqTaskID  and tsk_StatusID in (1,2)
where ord_StatusID <> 3
group by ost_OrderID, ord_code