CREATE INDEX shipment_log_shp_id_idx ON dbo.shipments_log (shipment_id);
CREATE INDEX shipment_log_date_idx ON dbo.shipments_log (dml_date,s_in);

CREATE INDEX movement_log_shp_id_idx ON dbo.movement_log (movement_id);
CREATE INDEX movement_log_date_idx ON dbo.shipments_log (dml_date,s_in);

CREATE INDEX shp_ord_log_shp_id_idx ON dbo.shipment_orders_log (shipment_id);
CREATE INDEX mvm_itm_log_mvm_id_idx ON dbo.movement_item_log (movement_id);