CREATE TABLE IF NOT EXISTS `wms_outside_station` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `station_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '库外站点',
  `pallet_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '托盘类型：t1小托盘，t2大托盘',
  `status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'IDLE' COMMENT '状态：IDLE空闲，OCCUPIED占用，RETURNING回库中',
  `source_bin_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '空托盘原库位/回库目标库位',
  `pallet_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '托盘号',
  `source_task_no` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源任务号',
  `source_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源类型',
  `return_task_no` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '空托回库任务号',
  `error_msg` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '失败原因',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_station_code` (`station_code`),
  KEY `idx_pallet_type_status` (`pallet_type`,`status`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='库外站点状态表';

INSERT INTO `wms_outside_station` (`station_code`, `pallet_type`, `status`)
VALUES
  ('Z6-装卸点','t1','IDLE'),
  ('Z7-装卸点','t1','IDLE'),
  ('Z8-装卸点','t1','IDLE'),
  ('Z9-装卸点','t1','IDLE'),
  ('Z10-装卸点','t2','IDLE')
ON DUPLICATE KEY UPDATE
  `pallet_type` = VALUES(`pallet_type`);

ALTER TABLE `wms_valve`
  MODIFY COLUMN `valve_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '阀门编号（valveNo）';
