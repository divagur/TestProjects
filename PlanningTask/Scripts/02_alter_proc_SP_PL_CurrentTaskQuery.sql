/****** Object:  StoredProcedure [dbo].[SP_PL_CurrentTaskQuery]    Script Date: 13.03.2024 15:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_PL_CurrentTaskQuery]
	@From		date = getdate,
	@Till		date = NULL,
	@In			int	= NULL,
	@filter		varchar(10) = null
as
begin

	set nocount on;

	declare @t		T_PL_CurrentTask;
	declare @Sql	nvarchar(max);

	set @Till = isnull(@Till, @From);
	set @Sql = dbo.F_PL_AssembleQuery(2, NULL, 0);
	
	--insert into @t
	exec sp_executesql @Sql, N'@From date, @Till date, @In int, @Filter varchar(10)', @From, @Till, @In, @filter;
	/*
	select *
	from @t
	order by ShpDate, isnull(SlotTime, '23:59:59');
	*/
end
