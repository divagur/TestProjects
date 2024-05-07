	select ost_OrderID OrderID , GCR.dbo.concat(distinct osg_Code) OSGCodes
	from LV_OrderShipment with(nolock)
	left join LV_OrderShipItem with(nolock) on osi_OrderShipmentID = ost_ID
	left join LV_OrderShipGroupItem with(nolock) on ogi_ID = osi_GroupitemID
	join LV_OrderShipmentGroup with(nolock) on osg_ID in (ost_GroupID, ogi_GroupID)
	group by ost_OrderID;
