declare
		@ShpId int = null, 
	@OrdId int = null,
	@DepId int = NULL

select distinct lv_order_id
					into #OrdList
					from shipment_orders
					inner join DD.dbo.LV_Order with (nolock) on ord_id = lv_order_id and ord_StatusID not in (3,4)
					where
						@OrdId is null or id = @OrdId

select * from #OrdList
/*
select ord_id,sum(GrossWight) OrderWight, count (distinct stc_SSCC) ShpPlaceNumber
							from (*/
									select 
										cast(SUM(ISNULL(isnull(ipt_NetWeight,0)* unt_Conversion,0)*spt_Quantity )as numeric(18,2)) + sdp_DeadWeight as GrossWight,
										stc_SSCC, ord_id 
									from DD.dbo.LV_StockContainer with(nolock)
									left join DD.dbo.LV_Stock with(nolock) on stk_ContainerID = stc_ID
									left join DD.dbo.LV_StockPackType with(nolock) on spt_StockID = stk_ID
									left join DD.dbo.LV_ItemPackType with(nolock) on ipt_ItemUnitID = spt_ItemUnitID and spt_ParentID is null
									left join DD.dbo.LV_Unit with(nolock) on unt_ID = ipt_WeightUnitID 
									left join DD.dbo.LV_OrderShipItemStock with(nolock) on stk_ID= oss_StockID 
									left join DD.dbo.LV_OrderShipItem with(nolock) on osi_ID = oss_OrderShipItemID 
									left join DD.dbo.LV_OrderItem  with(nolock) on osi_OrderItemID = ori_ID
									left join DD.dbo.LV_Order with(nolock)on ord_ID=ori_OrderID 
									join DD.dbo.V_StandardPackType  with(nolock) on  sdp_UnitID = stc_UnitID
									where ord_id in (select lv_order_id from #OrdList where lv_order_id = 54123)
									group by ord_id,ord_Code, stc_SSCC ,sdp_DeadWeight
							/*)t
							group by ord_id*/

							/*
							select ord_id, ost_ID, sum(GrossWight) OrderWight, count (distinct stc_SSCC) ShpPlaceNumber
							from (*/
								select 
										cast(SUM(ISNULL(isnull(ipt_NetWeight,0)* unt_Conversion,0)*spt_Quantity )as numeric(18,2)) + sdp_DeadWeight as GrossWight,
										stc_SSCC, ord_id, ost_ID, ost_Code
									from  
											DD.dbo.LV_StockContainer with(nolock)
											 join DD.dbo.LV_Stock with(nolock) on stk_ContainerID = stc_ID and stk_DepositorID = 59
											 join DD.dbo.LV_StockPackType with(nolock) on spt_StockID = stk_ID
											 join DD.dbo.LV_ItemPackType with(nolock) on ipt_ItemUnitID = spt_ItemUnitID and spt_ParentID is null
											 join DD.dbo.LV_Unit with(nolock) on unt_ID = ipt_WeightUnitID 
											 join DD.dbo.LV_OrderShipItemStock with(nolock) on stk_ID= oss_StockID 
											 join DD.dbo.LV_OrderShipItem with(nolock) on osi_ID = oss_OrderShipItemID 		
											 join DD.dbo.LV_OrderItem  with(nolock) on osi_OrderItemID = ori_ID
											 join DD.dbo.LV_Order with(nolock)on ord_ID=ori_OrderID 
											 join DD.dbo.LV_OrderShipment with(nolock) on ost_OrderID = ord_ID
											 join DD.dbo.V_StandardPackType  with(nolock) on  sdp_UnitID = stc_UnitID
									where ord_id in (select lv_order_id from #OrdList where lv_order_id = 54123)
									group by ord_id,ord_Code,ost_Code, stc_SSCC ,sdp_DeadWeight, ost_ID
									order by ost_Code,stc_SSCC
							/*)t
							group by ord_id, ost_ID*/


drop table #OrdList