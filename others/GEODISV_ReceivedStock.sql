ALTER view [dbo].[GEODISV_ReceivedStock]
as
	
				select	max(log_DateTime) MaxLogDT,
					--log_DateTime,
					rct_DepositorID DepositorID, VehicleNo, rct_ID ReceiptID, rct_Code ReceiptCode, CompleteDate,
					prd_PrimaryCode SKU, prd_SecondaryCode SKU2, prdl_Description Product, loc_Code Location, 
					sum(lsp_Quantity) Quantity,
					untlBox.untl_Description Unit, untlBoxEng.untl_Description UnitEng,
					sum(lsk_CUQuantity) PcsQuantity, Lsc_SSCC SSCC,
					untlPal.untl_Description PalType, untlPalEng.untl_Description PalTypeEng,
					unr_Description UnsuitReason, srr_Description ReserveReason, 
					lsk_ToStockID, 
					lsk_ProductID ProductID, BaxiSN, BarCode,
					lsk_UnsuitReasonID UnsuitReasonID, lsk_ReserveReasonID ReserveReasonID,
					spl_Code SupplierCode, cmp_FullName Supplier, 
					Seal,
					Posex, rct_TypeID ReceiptTypeID,
					all38.all_Value Urgency, all15.all_Value BaxiGroup,
					checksum_agg(log_ReceiptItemID) ReceiptItemChecksum,
					sum(rci_ExpQuantity) ExpQuantity,								-- Must be shown in reports within the ReceiptItemChecksum group !!!
					untlExpEng.untl_Description ExpUnitEng,							-- Must be shown in reports within the ReceiptItemChecksum group !!!
					sum(rci_ExpQuantity * iucExp.iuc_Conversion) ExpPcsQuantity,		-- Must be shown in reports within the ReceiptItemChecksum group !!!
					manufacturer
					,RecType
					,lsa30.Complect as 'Complect'
	
				from LV_Receipt with(nolock)
				join LV_Log with(nolock) on log_ReceiptID = rct_ID 
				join LV_LogStock with(nolock) on lsk_LogID = log_ID and lsk_DepositorID = 59
				join LV_LogStockPackType with(nolock) on lsp_LogStockID = lsk_ID
				left join LV_ItemUnit ituBox with(nolock) on ituBox.itu_ID = lsp_ItemUnitID
				left join LV_UnitLang untlBox with(nolock) on untlBox.untl_UnitID = ituBox.itu_UnitID and untlBox.untl_LanguageID = 4
				left join LV_UnitLang untlBoxEng with(nolock) on untlBoxEng.untl_UnitID = ituBox.itu_UnitID and untlBoxEng.untl_LanguageID = 1
				join LV_Product with(nolock) on prd_ID = lsk_ProductID 
				join LV_ProductLang with(nolock) on prdl_ProductID = lsk_ProductID and prdl_LanguageID = 4
				----left join LV_Location with(nolock) on loc_ID = lsk_LocationID and loc_DepositorID = 59
				join LV_Location with(nolock) on loc_ID = lsk_LocationID and loc_DepositorID = 59
				join LV_ReceiptItem with(nolock) on rci_ID = log_ReceiptItemID
				join LV_ItemUnit ituExp with(nolock) on ituExp.itu_ID = rci_InputItemUnitID
				left join LV_LogStockContainer with(nolock) on lsc_ID = lsk_FromContainerID
				left join LV_UnitLang untlPal with(nolock) on untlPal.untl_UnitID = lsc_UnitID and untlPal.untl_LanguageID = 4
				left join LV_UnitLang untlPalEng with(nolock) on untlPalEng.untl_UnitID = lsc_UnitID and untlPalEng.untl_LanguageID = 1
				left join LV_UnsuitabilityReason with(nolock) on unr_ID = lsk_UnsuitReasonID
				left join LV_StockReserveReason with(nolock) on srr_ID = lsk_ReserveReasonID

				outer apply (select top 1 rav_Value VehicleNo from LV_ReceiptAttributesValues with(nolock) where rav_AttributeID = 8 and rav_ReceiptID = rct_ID order by rav_ID desc) rav8
				outer apply (select top 1 lrt_Date CompleteDate from LOG_Receipt with(nolock) where lrt_ReceiptID = rct_ID and lrt_NewStatusID = 3 order by lrt_Date desc) lrt
				outer apply (select top 1 lsa_Value BaxiSN from LV_LogStockAttrValue with(nolock) where lsa_AttributeID = 14 and lsa_LogStockID = lsk_ID order by lsa_ID desc) lsa14
				outer apply (select top 1 lsa_Value Complect from LV_LogStockAttrValue with(nolock) where lsa_AttributeID = 30 and lsa_LogStockID = lsk_ID order by lsa_ID desc) lsa30
				outer apply (select top 1 pbc_String BarCode from LV_ProductBarcode with(nolock) where pbc_ProductID = lsk_ProductID order by pbc_ID desc) bc
				left join LV_Supplier with(nolock) on spl_ID = rct_SupplierID
				left join LV_Company with(nolock) on cmp_ID = spl_CompanyID
				outer apply (select top 1 rav_Value Seal from LV_ReceiptAttributesValues with(nolock) where rav_AttributeID = 19 and rav_ReceiptID = rct_ID order by rav_ID desc) rav19
				outer apply (select top 1 rrv_Value Posex from LV_ReceiptItemRctAttrValue with(nolock) where rrv_ReceiptAttributeID = 28 and rrv_ReceiptItemID = log_ReceiptItemID order by rrv_ID desc) rrv28
				outer apply (select top 1 pav_Value ProdDescr1 from LV_ProductAttributesValues with(nolock) where pav_attributeID = 35 and pav_ProductID = lsk_ProductID order by pav_ID desc) pav35
				outer apply (select top 1 rav_Value UrgencyTxt from LV_ReceiptAttributesValues with(nolock) where rav_AttributeID = 38 and rav_ReceiptID = rct_ID order by rav_ID desc) rav38
				left join LV_ReceiptAttributeList ral38 with(nolock) on ral38.ral_AttributeID = 38 and ral38.ral_Code = UrgencyTxt
				left join LV_AttributeListValue all38 with(nolock) on all38.all_RecAttrListID = ral38.ral_ID and all38.all_LanguageID = 1

				outer apply (select top 1 rav_Value manufacturer from LV_ReceiptAttributesValues with(nolock) where rav_AttributeID = 4 and rav_ReceiptID = rct_ID order by rav_ID desc) rav4
				outer apply (select top 1 rav_Value RecType from LV_ReceiptAttributesValues with(nolock) where rav_AttributeID = 5 and rav_ReceiptID = rct_ID order by rav_ID desc) rav5

				outer apply (select top 1 pav_Value BaxiGroupIDTxt from LV_ProductAttributesValues with(nolock) where pav_attributeID = 15 and pav_ProductID = lsk_ProductID order by pav_ID desc) pav15
				left join LV_ProductAttributeList pal15 with(nolock) on pal15.pal_AttributeID = 15 and pal15.pal_Code = BaxiGroupIDTxt
				left join LV_AttributeListValue all15 with(nolock) on all15.all_PrdAttrListID = pal15.pal_ID and all15.all_LanguageID = 1

				left join LV_UnitLang untlExpEng with(nolock) on untlExpEng.untl_UnitID = ituExp.itu_UnitID and untlExpEng.untl_LanguageID = 1
				left join LV_ItemUnitConversion iucExp with(nolock) on iucExp.iuc_ProductID = rci_ProductID and iucExp.iuc_ConvertedUnitID = ituExp.itu_UnitID and iucExp.iuc_ReferenceUnitID = 5

				where rct_DepositorID = 59  and lsp_ParentID is NULL

				group by rct_DepositorID, VehicleNo, rct_ID, rct_Code, CompleteDate, prd_PrimaryCode, prd_SecondaryCode, prdl_Description, loc_Code,
					untlBox.untl_Description, untlBoxEng.untl_Description, Lsc_SSCC,
					untlPal.untl_Description, untlPalEng.untl_Description, unr_Description, srr_Description,
					lsk_ToStockID, lsk_ProductID, BaxiSN,BarCode,  
					lsk_UnsuitReasonID, lsk_ReserveReasonID, spl_Code,
					cmp_FullName,    Seal,   Posex,
					rct_TypeID,   ProdDescr1, all38.all_Value, all15.all_Value, 
					untlExpEng.untl_Description,rav4.manufacturer, rav5.RecType, lsa30.Complect
					--,log_DateTime
				having sum(lsk_CUQuantity) <> 0

GO


