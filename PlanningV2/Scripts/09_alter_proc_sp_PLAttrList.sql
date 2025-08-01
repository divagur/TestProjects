/****** Object:  StoredProcedure [dbo].[sp_PLAttrList]    Script Date: 16.07.2025 14:08:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_PLAttrList] 
	@DepId	int
AS
BEGIN

declare @Ret table
	(
		Id			int,
		spa_ID		int,
		spa_Name	nvarchar(64),
		PLFieldId	int,
		PLField		nvarchar(255),
		lva_in		bit, 
		lva_type	nvarchar(20)
	);


	declare @Sql	nvarchar(max),
	@LVBase	nvarchar(128),
	 @DepLVID int;

	 select @LVBase = lv_base from depositors where id = @DepId

	if (@LVBase is not null)
	begin

		set @Sql = N'select la.id, vsa.spa_ID, vsa.spa_Name,se.id PLFiledId, se.field_name PLField,0 lva_in, ''Отгрузка'' lva_type
					from	lv_attr la 
							inner join '+@LVBase+'.dbo.V_ShipmentAttributes vsa on (vsa.spa_ID = la.lva_attr_lv_id and la.lva_in = 0)
							inner join shipment_element se on (la.pl_elem_id = se.id)
					where vsa.LanguageID = 4 and vsa.LanguageID1 = 4
					union all
					select la.id, vra.rat_ID, vra.rat_Name,se.id PLFiledId, se.field_name PLField,1 lva_in, ''Приход'' lva_type
					from	lv_attr la 
							inner join '+@LVBase+'.dbo.V_ReceiptAttributes vra on (vra.rat_ID = la.lva_attr_lv_id and la.lva_in = 1)
							inner join shipment_element se on (la.pl_elem_id = se.id)
					where vra.LanguageID = 4 and vra.LanguageID1 = 4
					order by 6
					'
		insert into @Ret(Id, spa_ID, spa_Name,PLFieldId, PLField, lva_in, lva_type)
		exec sp_executesql @Sql,N'@LVBase nvarchar(128)', @LVBase;

	end


	select Id, spa_ID as SpaId, spa_Name as SpaName, PLFieldId as PLFieldId, PLField as PLField, lva_in as LvaIn, lva_type as LvaType
	from @Ret
	order by lva_type;

END
