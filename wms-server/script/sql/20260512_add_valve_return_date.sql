ALTER TABLE `wms_valve`
  ADD COLUMN `return_date` date DEFAULT NULL COMMENT '回库日期' AFTER `inspection_date`;
