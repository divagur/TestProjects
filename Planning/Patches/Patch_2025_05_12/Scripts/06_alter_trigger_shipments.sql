-- =============================================
-- Version:	1.4
-- =============================================
ALTER TRIGGER [dbo].[t_is_shipment_log] ON [dbo].[shipments]
FOR INSERT, UPDATE, DELETE AS
declare
	@OperType CHAR ( 1 ),
	@sUser VARCHAR(128),
	@sHost VARCHAR(128),
	@sQuestion CHAR ( 3 )
BEGIN
Set @sQuestion = '???'
SET @OperType = ''
 /* θο DML */
 IF EXISTS ( SELECT * FROM deleted  ) AND EXISTS ( SELECT * FROM inserted  )
	BEGIN
		SET @OperType = 'U'
	END 
ELSE IF EXISTS ( SELECT * FROM deleted  ) 
	BEGIN
		SET @OperType = 'D'
	END 
ELSE IF EXISTS ( SELECT * FROM inserted  )
	BEGIN
		SET @OperType = 'I'
	END 

Set @sUser = SUBSTRING(SYSTEM_USER, 1, 128)
Set @sHost = SUBSTRING(HOST_NAME ( ), 1, 128)
 IF @sUser = '' 
	begin
		Set @sUser = @sQuestion 
	end
IF @sHost = ''
	begin
		Set @sHost = @sQuestion 
	end
 IF @OperType = 'I' OR @OperType = 'U'
	BEGIN
 	INSERT INTO shipments_log
	( 
		 
		dml_type, dml_date, dml_user_name, dml_comp_name, 
		shipment_id, lv_id, time_slot_id, s_date, s_comment, o_comment, 
		gate_id, sp_condition, driver_phone, driver_fio, vehicle_number, trailer_number, 
		attorney_number, attorney_date, submission_time, start_time, end_time, 
		leave_time, delay_reasons_id, delay_comment, depositor_id, is_courier, 
		forwarder_fio, stamp_number, attorney_issued, s_in, special_time, is_add_lv,
		transport_company_id, transport_type_id,supplier_id, custom_post_id, warehouse_id, transport_view_id
 	)
	SELECT 
		@OperType, CURRENT_TIMESTAMP, @sUser, @sHost,
		ins.id, ins.lv_id, ins.time_slot_id, ins.s_date,ins.s_comment, ins.o_comment, ins.gate_id,
		ins.sp_condition, ins.driver_phone, ins.driver_fio, ins.vehicle_number, ins.trailer_number, ins.attorney_number, 
		ins.attorney_date, ins.submission_time, ins.start_time,
		ins.end_time, ins.leave_time, ins.delay_reasons_id, ins.delay_comment, 
		ins.depositor_id, ins.is_courier, ins.forwarder_fio, ins.stamp_number, ins.attorney_issued,
 		ins.s_in, ins.special_time,ins.is_add_lv,
		ins.transport_company_id, ins.transport_type_id,
		ins.supplier_id, ins.custom_post_id, ins.warehouse_id, ins.transport_view_id
    FROM inserted ins
	END
ELSE
	BEGIN
 	INSERT INTO shipments_log
	( 
		dml_type, dml_date, dml_user_name, dml_comp_name, 
		shipment_id, lv_id, time_slot_id, s_date, s_comment, o_comment, 
		gate_id, sp_condition, driver_phone, driver_fio, vehicle_number, trailer_number, 
		attorney_number, attorney_date, submission_time, start_time, end_time, 
		leave_time, delay_reasons_id, delay_comment, depositor_id, is_courier, 
		forwarder_fio, stamp_number, attorney_issued, s_in, special_time,is_add_lv,
		transport_company_id, transport_type_id,supplier_id, custom_post_id, warehouse_id, transport_view_id
 	)
	SELECT 
         @OperType, CURRENT_TIMESTAMP, @sUser, @sHost,
		ins.id, ins.lv_id, ins.time_slot_id, ins.s_date,ins.s_comment, ins.o_comment, ins.gate_id,
		ins.sp_condition, ins.driver_phone, ins.driver_fio, ins.vehicle_number, ins.trailer_number, ins.attorney_number, 
		ins.attorney_date, ins.submission_time, ins.start_time,
		ins.end_time, ins.leave_time, ins.delay_reasons_id, ins.delay_comment, 
		ins.depositor_id, ins.is_courier, ins.forwarder_fio, ins.stamp_number, ins.attorney_issued,
 		ins.s_in    , ins.special_time,ins.is_add_lv,
		ins.transport_company_id, ins.transport_type_id,
		ins.supplier_id, ins.custom_post_id, ins.warehouse_id, ins.transport_view_id
    FROM deleted ins

	END
END
