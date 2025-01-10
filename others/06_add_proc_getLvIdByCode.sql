
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE SP_PL_GetShipmentLvIdByCode 
(
	@LvCode varchar(32),
	@In bit,
	@DepId int
)
AS
BEGIN
declare 
		@LvId int,
		@Sql	nvarchar(max),
		@LVBase	nvarchar(128) = NULL,
		@DepLVID int
	
	select @LVBase = lv_base, @DepLVID = lv_id
	from depositors with(nolock)
	where id = @DepId


	if (@LVBase is not null)
	begin
		if @In = 0
		begin
			set @sql = 'select @LvId = ord_ID				
						from '+@LVBase+N'.dbo.LV_Order
						where
							ord_Code = @LvCode'
		end
		else
		begin
			set @Sql = 'select @LvId = rct_ID				
						from '+@LVBase+N'.dbo.LV_Receipt
						where
							rct_Code = @LvCode'
		end

		exec sp_executesql @Sql, N'@LvId int OUTPUT, @LvCode varchar(32)',  @LvId output, @LvCode;
	end
	SELECT @LvId
END
GO
