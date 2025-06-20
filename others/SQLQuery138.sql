exec sp_executesql N'
select   sum(V_StockControlHard.stk_CUQuantityFree) as SUMQTY, 
ISNULL(Attributes0.sav_value,'''') "Код клиента доставки" , ISNULL(Attributes0.OriginalValue,'''') "Код клиента доставки_OV" , 
ISNULL(Attributes1.sav_value,'''') "Высота BAXI" , ISNULL(Attributes1.OriginalValue,'''') "Высота BAXI_OV" , 
ISNULL(Attributes2.sav_value,'''') "Серийный номер" , ISNULL(Attributes2.OriginalValue,'''') "Серийный номер_OV" 
 from 
			V_StockControlHard  WITH (NOLOCK) 
 INNER JOIN 
	(select sav_stockID, sav_Value, sav_AttributeID, sav_Value as OriginalValue from LV_StockAttributesValues  WITH (NOLOCK)  where sav_AttributeID = @Param_0 ) Attributes0 
	on V_StockControlHard.stk_ID = Attributes0.sav_StockID 
 INNER JOIN 
	(select sav_stockID, ListValue as sav_Value, sav_AttributeID, sav_Value as OriginalValue from V_StockAttributesValuesList  WITH (NOLOCK)  WHERE sav_AttributeID = @Param_1  AND LanguageID = @Param_2 ) Attributes1 
	on V_StockControlHard.stk_ID = Attributes1.sav_StockID 
 INNER JOIN 
	(select sav_stockID, sav_Value, sav_AttributeID, sav_Value as OriginalValue from LV_StockAttributesValues  WITH (NOLOCK)  where sav_AttributeID = @Param_3 ) Attributes2 
	on V_StockControlHard.stk_ID = Attributes2.sav_StockID 
  where  V_StockControlHard.stk_ProductID = @Param_4 
 And V_StockControlHard.stk_CUItemUnitID = @Param_5 
 And V_StockControlHard.stk_DepositorID = @Param_6 
 and V_StockControlHard.stk_LogisticUnitID = @Param_7 
 And V_StockControlHard.stk_UnsuitReasonID IS NULL 
 And V_StockControlHard.stk_ReserveReasonID IS NULL
 And V_StockControlHard.loc_StockControlLED = 1 
 And (V_StockControlHard.loc_LockLED = 0 OR V_StockControlHard.loc_LockLED IS NULL) 
 And (V_StockControlHard.stc_RetainLED = 0 OR V_StockControlHard.stc_RetainLED IS NULL) 
 And V_StockControlHard.stk_CUQuantityFree > 0 
 And  (stk_ContainerID not in (
									select stc_ID from LV_StockContainer with(nolock)  
									join LV_Receipt with(nolock) on rct_ID=stc_ReceiptID and rct_DepositorID = 59 and rct_id > 14397  
									where rct_ProgressID in (1,2,4,5)) or stk_ContainerID is NULL)  

-- And  stk_id not in (select stk_id from LV_Stock a with(nolock) where a.stk_ID = stk_ID and stk_LocationID in (29072,29073,
--34410,32363,32366,32365,32364,36157,36166,36167,36168,36169,36170,36171,36158,36159,36160,36161,36162,36163,36164,36165) ) 

and stk_LocationID not in (29072,29073,34410,32363,32366,32365,32364,36157,36166,36167,36168,36169,36170,36171,36158,36159,36160,36161,36162,36163,36164,36165)
And  (stk_id in (select stk_id from f_OrderReservLimitRowCheck (8484))) 

 GROUP BY Attributes0.sav_value,Attributes0.OriginalValue,Attributes1.sav_value,Attributes1.OriginalValue,
 Attributes2.sav_value,Attributes2.OriginalValue'
 ,N'@Param_0 int,@Param_1 int,@Param_2 int,@Param_3 int,@Param_4 int,@Param_5 int,@Param_6 int,@Param_7 int',
 @Param_0=13,@Param_1=21,@Param_2=4,@Param_3=14,@Param_4=8484,@Param_5=25450,@Param_6=59,@Param_7=7

 --select stk_id from f_OrderReservLimitRowCheck (8484)


--stk_id not in (select stk_id from LV_Stock a with(nolock) where a.stk_ID = stk_ID and stk_LocationID in (29072,29073,
--34410,32363,32366,32365,32364,36157,36166,36167,36168,36169,36170,36171,36158,36159,36160,36161,36162,36163,36164,36165) )

