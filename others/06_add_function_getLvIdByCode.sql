-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION GetShipmentLvIdByCode
(
	@LvCode varchar(32),
	@In bit,
	@DepId int
)
RETURNS int
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

	if @In = 0
	begin
		select @LvId = 
		from LV
	end
	else
	begin
	end

	RETURN <@ResultVar, sysname, @Result>

END
GO

