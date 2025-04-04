USE [Planning]
GO
/****** Object:  StoredProcedure [dbo].[SP_PL_GetOrderWight]    Script Date: 18.11.2024 12:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 17.02.2023
-- Description:	Запись количества отгрузочных мест и веса заказа 
-- =============================================
ALTER PROCEDURE [dbo].[SP_PL_GetOrderWight]
	@ShpId int = null, 
	@OrdId int = null,
	@DepId int = NULL
AS
BEGIN
	declare @Sql	nvarchar(max),
	 @LVBase	nvarchar(128) = NULL,
	 @DepLVID int


	 select @LVBase = lv_base, @DepLVID = lv_id
	from depositors with(nolock)
	where id = 1;

	/*
	select distinct lv_order_id
	into #OrdList
	from shipment_orders
	inner join Lvision..LV_Order with (nolock) on ord_id = lv_order_id and ord_StatusID not in (3,4) -- ВЖ добавил 15.11.24
	where
		@OrdId is null or id = @OrdId


	select distinct os_lvid
	into #OrdPartList
	from shipment_order_parts
	inner join Lvision..LV_OrderShipment with (nolock) on ost_ID = os_lvid  and ost_StatusID not in (10,11) -- ВЖ добавил 15.11.24
	where
		@OrdId is null or sh_order_id = @OrdId
		*/

	if (@LVBase is not null)
	begin
	/*
		set @Sql = ''
		exec sp_executesql @Sql, N'@OrdId int',  @OrdId;


		set @Sql = '	'
		exec sp_executesql @Sql, N'@OrdId int',  @OrdId;
		*/
		--exec sp_executesql @Sql, N'@OrdId int',  @OrdId;
		set @Sql = N'
		
					select distinct lv_order_id
					into #OrdList
					from shipment_orders
					inner join '+ @LVBase +N'.dbo.LV_Order with (nolock) on ord_id = lv_order_id and ord_StatusID not in (3,4)
					where
						@OrdId is null or id = @OrdId
		

					select distinct os_lvid
					into #OrdPartList
					from shipment_order_parts
					inner join '+@LVBase+N'.dbo.LV_OrderShipment with (nolock) on ost_ID = os_lvid  and ost_StatusID not in (10,11) -- ВЖ добавил 15.11.24
					where
						@OrdId is null or sh_order_id = @OrdId

					update shipment_orders set shipping_places_number = t_u.ShpPlaceNumber, order_weight = t_u.OrderWight
					from (

							select ord_id,sum(GrossWight) OrderWight, count (distinct stc_SSCC) ShpPlaceNumber
							from (
									select 
										cast(SUM(ISNULL(isnull(ipt_NetWeight,0)* unt_Conversion,0)*spt_Quantity )as numeric(18,2)) + sdp_DeadWeight as GrossWight,
										stc_SSCC, ord_id 
									from ' + @LVBase + N'.dbo.LV_StockContainer with(nolock)
									left join ' + @LVBase + N'.dbo.LV_Stock with(nolock) on stk_ContainerID = stc_ID
									left join ' + @LVBase + N'.dbo.LV_StockPackType with(nolock) on spt_StockID = stk_ID
									left join ' + @LVBase + N'.dbo.LV_ItemPackType with(nolock) on ipt_ItemUnitID = spt_ItemUnitID and spt_ParentID is null
									left join ' + @LVBase + N'.dbo.LV_Unit with(nolock) on unt_ID = ipt_WeightUnitID 
									left join ' + @LVBase + N'.dbo.LV_OrderShipItemStock with(nolock) on stk_ID= oss_StockID 
									left join ' + @LVBase + N'.dbo.LV_OrderShipItem with(nolock) on osi_ID = oss_OrderShipItemID 
									left join ' + @LVBase + N'.dbo.LV_OrderItem  with(nolock) on osi_OrderItemID = ori_ID
									left join ' + @LVBase + N'.dbo.LV_Order with(nolock)on ord_ID=ori_OrderID 
									join ' + @LVBase + N'.dbo.V_StandardPackType  with(nolock) on  sdp_UnitID = stc_UnitID
									where ord_id in (select lv_order_id from #OrdList)
									group by ord_id,ord_Code, stc_SSCC ,sdp_DeadWeight
							)t
							group by ord_id
					) t_u
					where 
						lv_order_id = t_u.ord_id
	
				update shipment_order_parts set shipping_places_number = t_u.ShpPlaceNumber, order_part_weight = t_u.OrderWight
					from (

							select ord_id, ost_ID, sum(GrossWight) OrderWight, count (distinct stc_SSCC) ShpPlaceNumber
							from (
								select 
										cast(SUM(ISNULL(isnull(ipt_NetWeight,0)* unt_Conversion,0)*spt_Quantity )as numeric(18,2)) + sdp_DeadWeight as GrossWight,
										stc_SSCC, ord_id, ost_ID
									from  
											' + @LVBase + N'.dbo.LV_StockContainer with(nolock)
											 join ' + @LVBase + N'.dbo.LV_Stock with(nolock) on stk_ContainerID = stc_ID and stk_DepositorID = 59
											 join ' + @LVBase + N'.dbo.LV_StockPackType with(nolock) on spt_StockID = stk_ID
											 join ' + @LVBase + N'.dbo.LV_ItemPackType with(nolock) on ipt_ItemUnitID = spt_ItemUnitID and spt_ParentID is null
											 join ' + @LVBase + N'.dbo.LV_Unit with(nolock) on unt_ID = ipt_WeightUnitID 
											 join ' + @LVBase + N'.dbo.LV_OrderShipItemStock with(nolock) on stk_ID= oss_StockID 
											 join ' + @LVBase + N'.dbo.LV_OrderShipItem with(nolock) on osi_ID = oss_OrderShipItemID 		
											 join ' + @LVBase + N'.dbo.LV_OrderItem  with(nolock) on osi_OrderItemID = ori_ID
											 join ' + @LVBase + N'.dbo.LV_Order with(nolock)on ord_ID=ori_OrderID 
											 join ' + @LVBase + N'.dbo.LV_OrderShipment with(nolock) on ost_OrderID = ord_ID
											 join ' + @LVBase + N'.dbo.V_StandardPackType  with(nolock) on  sdp_UnitID = stc_UnitID
									where ord_id in (select lv_order_id from #OrdList)
									group by ord_id,ord_Code, stc_SSCC ,sdp_DeadWeight, ost_ID
							)t
							group by ord_id, ost_ID
						) t_u
						where 
							os_lvid = t_u.ost_ID
							
							drop table #OrdList
							
							';

		


		
				exec sp_executesql @Sql, N'@OrdId int',  @OrdId;


	end
	--drop table #OrdList
END
