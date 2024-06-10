

select distinct
		ord_ID
		, (shc_ID) 
		, sum (isnull(a1.TotNetWeght, a.TotNetWeght) ) totNetWeght
		, (isnull(a1.PalWeght, a.PalWeght) ) PalWeght
from
		LV_Order with (nolock)
join	LV_OrderShipment with (nolock) on ost_OrderID = ord_ID
join	LV_ShipContainer with (nolock) on ost_id =  shc_OrderShipmentID
left join 	(
			select shs_ProductID, shs_ContainerID ContainerID,  (shs_CUQuantity * ipt_NetWeight) TotNetWeght, sdp_DeadWeight PalWeght
			from
					LV_ShipStock
			join	LV_ItemPackType with (nolock) on ipt_ID = shs_CUItemUnitID
			join	LV_ShipContainer with (nolock) on shc_id = shs_ContainerID
			join V_StandardPackType  with(nolock) on  sdp_UnitID = shc_UnitID
		)a on a.ContainerID = shc_ID

left join 	(
			select stk_ProductID, stk_ContainerID ContainerID, ( stk_CUQuantity * ipt_NetWeight) TotNetWeght, sdp_DeadWeight PalWeght 
			from
					LV_Stock
			join	LV_ItemPackType with (nolock) on ipt_ID = stk_CUItemUnitID
			join	LV_StockContainer with (nolock) on stc_ID = stk_ContainerID
			join V_StandardPackType  with(nolock) on  sdp_UnitID = stc_UnitID
		) a1 on a1.ContainerID = shc_ContainerID
where
		ord_id =  46450
group by ord_ID, shc_ID, (isnull(a1.PalWeght, a.PalWeght) )