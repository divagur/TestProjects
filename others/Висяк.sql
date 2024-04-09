exec sp_executesql N'select *, 
ISNULL(Attributes0.lsa_Value,'''') "Код клиента доставки" , 
Attributes0.lsa_AttributeID "Код клиента доставки_ID" , 
Attributes0.ListCode "Код клиента доставки_Code" , 
ISNULL(Attributes1.lsa_Value,'''') "Серийный номер" , 
Attributes1.lsa_AttributeID "Серийный номер_ID" , 
Attributes1.ListCode "Серийный номер_Code" , 
ISNULL(Attributes2.lsa_Value,'''') "Высота BAXI" , 
Attributes2.lsa_AttributeID "Высота BAXI_ID" , 
Attributes2.ListCode "Высота BAXI_Code" , 
ISNULL(Attributes3.lsa_Value,'''') "Код комплекта" , 
Attributes3.lsa_AttributeID "Код комплекта_ID" , 
Attributes3.ListCode "Код комплекта_Code"  from V_LogStock WITH (NOLOCK)  left outer join 
	(select NULL ListCode, lsa_Value, lsa_LogStockID, lsa_AttributeID  from LV_LogStockAttrValue  WITH (NOLOCK)  where lsa_AttributeID = @Param_0 ) Attributes0 
	on V_LogStock.ID = Attributes0.lsa_LogStockID 
 left outer join 
	(select NULL ListCode, lsa_Value, lsa_LogStockID, lsa_AttributeID  from LV_LogStockAttrValue  WITH (NOLOCK)  where lsa_AttributeID = @Param_1 ) Attributes1 
	on V_LogStock.ID = Attributes1.lsa_LogStockID 
 left outer join 
	(select ListCode, ListValue lsa_Value, lsa_LogStockID, lsa_AttributeID  from V_LogStockAttrValue  WITH (NOLOCK)  where lsa_AttributeID = @Param_2  And (LanguageID = @Param_3  or LanguageID IS NULL)) Attributes2 
	on V_LogStock.ID = Attributes2.lsa_LogStockID 
 left outer join 
	(select NULL ListCode, lsa_Value, lsa_LogStockID, lsa_AttributeID  from LV_LogStockAttrValue  WITH (NOLOCK)  where lsa_AttributeID = @Param_4 ) Attributes3 
	on V_LogStock.ID = Attributes3.lsa_LogStockID 
  WHERE  log_ReceiptID = @Param_5   AND  LanguageID = @Param_6  AND LanguageID1 = @Param_6  AND (LanguageID2 = @Param_6  OR LanguageID2 IS NULL) AND (LanguageID3 = @Param_6  OR LanguageID3 IS NULL) AND pls_LogisticSiteID = 2',N'@Param_0 int,@Param_1 int,@Param_2 int,@Param_3 int,@Param_4 int,@Param_5 int,@Param_6 int',@Param_0=13,@Param_1=14,@Param_2=21,@Param_3=4,@Param_4=30,@Param_5=12081,@Param_6=4