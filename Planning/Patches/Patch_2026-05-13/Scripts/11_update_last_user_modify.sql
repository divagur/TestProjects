update shipment_order_parts set [last_modify_user] = 'sysadm', [last_modify_date] = GETDATE()
update shipment_orders set [last_modify_user] = 'sysadm', [last_modify_date] = GETDATE()
update shipments set [last_modify_user] = 'sysadm', [last_modify_date] = GETDATE()