CREATE TABLE IF NOT EXISTS `wms_outside_station` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `station_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '库外站点',
  `pallet_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '托盘类型：t1小托盘，t2大托盘',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'IDLE' COMMENT '状态：IDLE空闲，OCCUPIED占用，RETURNING回库中',
  `source_bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '空托盘原库位/回库目标库位',
  `pallet_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '托盘号',
  `source_task_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源任务号',
  `source_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源类型',
  `return_task_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '空托回库任务号',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '失败原因',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_station_code` (`station_code`),
  KEY `idx_pallet_type_status` (`pallet_type`,`status`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='库外站点状态表';

DELETE s1 FROM `wms_outside_station` s1 JOIN `wms_outside_station` s2 ON s1.`station_code` LIKE 'Z10%' AND s2.`station_code` LIKE 'Z10%' AND ((s1.`status` = 'IDLE' AND s2.`status` <> 'IDLE') OR (s1.`status` = s2.`status` AND s1.`id` > s2.`id`) OR (s1.`status` <> 'IDLE' AND s2.`status` <> 'IDLE' AND s1.`id` > s2.`id`));
DELETE s1 FROM `wms_outside_station` s1 JOIN `wms_outside_station` s2 ON s1.`station_code` LIKE 'Z6%' AND s2.`station_code` LIKE 'Z6%' AND ((s1.`status` = 'IDLE' AND s2.`status` <> 'IDLE') OR (s1.`status` = s2.`status` AND s1.`id` > s2.`id`) OR (s1.`status` <> 'IDLE' AND s2.`status` <> 'IDLE' AND s1.`id` > s2.`id`));
DELETE s1 FROM `wms_outside_station` s1 JOIN `wms_outside_station` s2 ON s1.`station_code` LIKE 'Z7%' AND s2.`station_code` LIKE 'Z7%' AND ((s1.`status` = 'IDLE' AND s2.`status` <> 'IDLE') OR (s1.`status` = s2.`status` AND s1.`id` > s2.`id`) OR (s1.`status` <> 'IDLE' AND s2.`status` <> 'IDLE' AND s1.`id` > s2.`id`));
DELETE s1 FROM `wms_outside_station` s1 JOIN `wms_outside_station` s2 ON s1.`station_code` LIKE 'Z8%' AND s2.`station_code` LIKE 'Z8%' AND ((s1.`status` = 'IDLE' AND s2.`status` <> 'IDLE') OR (s1.`status` = s2.`status` AND s1.`id` > s2.`id`) OR (s1.`status` <> 'IDLE' AND s2.`status` <> 'IDLE' AND s1.`id` > s2.`id`));
DELETE s1 FROM `wms_outside_station` s1 JOIN `wms_outside_station` s2 ON s1.`station_code` LIKE 'Z9%' AND s2.`station_code` LIKE 'Z9%' AND ((s1.`status` = 'IDLE' AND s2.`status` <> 'IDLE') OR (s1.`status` = s2.`status` AND s1.`id` > s2.`id`) OR (s1.`status` <> 'IDLE' AND s2.`status` <> 'IDLE' AND s1.`id` > s2.`id`));

UPDATE `wms_outside_station` SET `station_code` = 'Z10-装卸点', `pallet_type` = 't2' WHERE `station_code` LIKE 'Z10%';
UPDATE `wms_outside_station` SET `station_code` = 'Z6-装卸点', `pallet_type` = 't1' WHERE `station_code` LIKE 'Z6%';
UPDATE `wms_outside_station` SET `station_code` = 'Z7-装卸点', `pallet_type` = 't1' WHERE `station_code` LIKE 'Z7%';
UPDATE `wms_outside_station` SET `station_code` = 'Z8-装卸点', `pallet_type` = 't1' WHERE `station_code` LIKE 'Z8%';
UPDATE `wms_outside_station` SET `station_code` = 'Z9-装卸点', `pallet_type` = 't1' WHERE `station_code` LIKE 'Z9%';

INSERT INTO `wms_outside_station` (`station_code`, `pallet_type`, `status`)
SELECT 'Z6-装卸点', 't1', 'IDLE'
WHERE NOT EXISTS (SELECT 1 FROM `wms_outside_station` WHERE `station_code` = 'Z6-装卸点');
INSERT INTO `wms_outside_station` (`station_code`, `pallet_type`, `status`)
SELECT 'Z7-装卸点', 't1', 'IDLE'
WHERE NOT EXISTS (SELECT 1 FROM `wms_outside_station` WHERE `station_code` = 'Z7-装卸点');
INSERT INTO `wms_outside_station` (`station_code`, `pallet_type`, `status`)
SELECT 'Z8-装卸点', 't1', 'IDLE'
WHERE NOT EXISTS (SELECT 1 FROM `wms_outside_station` WHERE `station_code` = 'Z8-装卸点');
INSERT INTO `wms_outside_station` (`station_code`, `pallet_type`, `status`)
SELECT 'Z9-装卸点', 't1', 'IDLE'
WHERE NOT EXISTS (SELECT 1 FROM `wms_outside_station` WHERE `station_code` = 'Z9-装卸点');
INSERT INTO `wms_outside_station` (`station_code`, `pallet_type`, `status`)
SELECT 'Z10-装卸点', 't2', 'IDLE'
WHERE NOT EXISTS (SELECT 1 FROM `wms_outside_station` WHERE `station_code` = 'Z10-装卸点');
