/****** Object:  StoredProcedure [dbo].[sp_AddLoadingLVList]    Script Date: 25.06.2025 16:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_AddLoadingLVList] 
	@Split		bit,
	@In			bit = null,
	@DepID		int	= NULL, -- normal and movement parameter
	@LVID		int	= NULL, -- split and movement parameter
	@IsAll		bit = 0 -- все заказы или только те которых нет в планнинге
AS
BEGIN

declare @Ret table
	(
		LVID		int,
		LVCode		nvarchar(32),
		OstID		int,
		OstCode		varchar(26), 
		LVStatus	nvarchar(255),
		ExpDate		datetime,
		Company		nvarchar(30),
		InputDate	datetime,
		DepLVID		int,
		IsEDM		bit,
		OperatorComment	varchar(500),
		WarehouseComment	varchar(256)
	);


	declare @Sql	nvarchar(max),
	 @LVBase	nvarchar(128) = NULL,
	 @DepLVID int;
	
	select @LVBase = lv_base, @DepLVID = lv_id
	from depositors with(nolock)
	where id = @DepID;

	if (@LVBase is not null)
	begin

		if(@In is not NULL)
		begin

				-- normal
				if(@In = 0)
				begin
					set @Sql = N'
						select distinct ord_ID, ord_Code, ost_ID,ost_Code, msg_Greek, ord_ExpShipDate, cmp_ShortName, ord_InputDate, @DepLVID, ctv_value isEDM, 
						ord_Memo OperatorComment,oav_Value WarehouseComment
						from ' + @LVBase + N'.dbo.LV_Order with(nolock)
						inner join ' + @LVBase +'.dbo.LV_OrderShipment with(nolock) on ost_OrderID = ord_ID
						left join ' + @LVBase + N'.dbo.LV_Customer with(nolock) on cus_ID = ord_CustomerID
						left join ' + @LVBase + N'.dbo.LV_Company with (nolock) on cmp_ID = cus_CompanyID
						left join ' + @LVBase + N'.dbo.LV_ProgressStatus with(nolock) on pst_ID = ord_StatusID
						left join ' + @LVBase + N'.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and msg_languageID = 4
						left join '+@LVBase+N'.dbo.LV_CustomerAttributeValues with (nolock) on ctv_CustomerID = cus_ID and ctv_AttributeID = 37
						left join '+@LVBase+N'.dbo.LV_OrderAttributesValues with (nolock) on oav_OrderID =  ord_ID and oav_AttributeID = 47
						where ord_StatusID not in (3, 4)
								and ord_DepositorID = @DepLVID '
						if (@LVID is not null)
						set @Sql = @Sql+ ' and ord_ID = @LVID '
						if (@IsAll = 0)
							set @Sql = @Sql+
							   ' and not exists(
												select 1 
												from 
													shipments s
													inner join shipment_orders so on s.id = so.shipment_id 
													inner join shipment_order_parts sop on so.id = sop.sh_order_id 
													inner join depositors d on d.id = s.depositor_id
												where s_in = @In and d.lv_id = @DepLVID and lv_order_id = ord_ID and os_lvid = ost_ID
											);';
						  --and not exists(select 1 from PL_Con inner join PL_Ldg on ldg_ID = con_LdgID where ldg_In = @In and ldg_DepLVID = @DepLVID and con_LVID = ord_ID)
				end
				else
				begin
					set @Sql = N'
						select distinct rct_ID, rct_Code,null ost_ID, null ost_Code, msg_Greek, rct_ExpectedDate, cmp_ShortName Comp, rct_InputDate, @DepLVID, 0 isEDM, 
						rct_Memo OperatorComment,rav_Value WarehouseComment
						from ' + @LVBase + N'.dbo.LV_Receipt with(nolock)
						left join ' + @LVBase + N'.dbo.LV_Supplier with(nolock) on spl_ID = rct_SupplierID
						left join ' + @LVBase + N'.dbo.LV_Company with (nolock) on cmp_ID = spl_CompanyID
						left join ' + @LVBase + N'.dbo.LV_ProgressStatus with(nolock) on pst_ID = rct_ProgressID
						left join ' + @LVBase + N'.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and msg_languageID = 4
						left join ' + @LVBase + N'.dbo.LV_ReceiptAttributesValues with (nolock) on rav_ReceiptID = rct_ID and rav_AttributeID = 47
						where rct_ProgressID not in (3, 4)
						  and rct_DepositorID = @DepLVID '
						  if (@IsAll = 0)
							set @Sql = @Sql+
										' and not exists(
											select 1 
											from 
												shipments s
												inner join shipment_orders so on s.id = so.shipment_id 
												inner join depositors d on d.id = s.depositor_id
											where s_in = @In and d.lv_id = @DepLVID and lv_order_id = rct_ID
										);';
						  --and not exists(select 1 from PL_Con inner join PL_Ldg on ldg_ID = con_LdgID where ldg_In = @In and ldg_DepLVID = @DepLVID and con_LVID = rct_ID);';
				end
				
				insert into @Ret(LVID, LVCode,OstID, OstCode, LVStatus, ExpDate, Company, InputDate, DepLVID,IsEDM,OperatorComment,WarehouseComment)
				exec sp_executesql @Sql, N'@In bit, @DepLVID int,@LVID int', @In, @DepLVID,@LVID;

		end
		else -- Movement
		begin

			set @Sql = N'
				select distinct tkl_ID, tkl_Code, null ost_ID, null ost_Code, msg_Greek, NULL, N''BAXI'', tkl_CreateDate, @DepLVID, 0 isEDM, 
				null OperatorComment, null WarehouseComment
				from ' + @LVBase + N'.dbo.LV_TaskList with(nolock)
				join ' + @LVBase + N'.dbo.LV_Task with(nolock) on tsk_TaskListID = tkl_ID
				join ' + @LVBase + N'.dbo.LV_ProgressStatus with(nolock) on pst_ID = tkl_StatusID
				left join ' + @LVBase + N'.dbo.LV_Messages with(nolock) on msg_code = pst_MessageCode and msg_languageID = 4
				where tkl_TransactionTypeID not in(1 /*Receipt*/, 4 /*ReceiptChange*/, 3 /*Picking*/, 27 /*CancelPick*/, 10 /*Loading*/, 25 /*Unloading*/)
				  and tsk_DepositorID = @DepLVID
				  and tkl_StatusID in (1,2,5) '
				  if (@IsAll = 0)
							set @Sql = @Sql+
							' and not exists(
									select 1 
									from 
										movement_item with(nolock) inner join depositors on (movement_item.depositor_id = depositors.id)
									where depositors.lv_id = tsk_DepositorID and TklLVID = tkl_ID and movement_id <> isnull(@LVID, 0))
				  --and tkl_ID not in (select til_LVID from @Inserted where til_DepLVID = @DepLVID);';

			insert into @Ret(LVID, LVCode,OstID, OstCode, LVStatus, ExpDate, Company, InputDate, DepLVID,IsEDM,OperatorComment,WarehouseComment)
			exec sp_executesql @Sql, N'@DepLVID int, @LVID int', @DepLVID, @LVID;

		end --Movement
	end


	select LVID, LVCode, LVStatus, ExpDate, Company, DepLVID,OstID, OstCode, IsEDM, OperatorComment,WarehouseComment
	from @Ret
	order by InputDate;

END
