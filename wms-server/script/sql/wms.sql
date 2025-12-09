-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: wms
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` bigint NOT NULL COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2024-06-13 16:06:37','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2024-06-13 16:06:37','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-light','Y','admin','2024-06-13 16:06:37','admin','2024-07-16 11:25:33','深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2024-06-13 16:06:37','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2024-06-13 16:06:37','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(11,'OSS预览列表资源开关','sys.oss.previewListResource','true','Y','admin','2024-06-13 16:06:37','',NULL,'true:开启, false:关闭');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','若依科技',0,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(101,100,'0,100','深圳总公司',1,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(102,100,'0,100','长沙分公司',2,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(103,101,'0,100,101','研发部门',1,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(104,101,'0,100,101','市场部门',2,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(105,101,'0,100,101','测试部门',3,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(106,101,'0,100,101','财务部门',4,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(107,101,'0,100,101','运维部门',5,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','1','0','admin','2024-06-13 16:06:25','',NULL),(1811589666899832833,102,'0,100,102','测试部门2',0,'负责人','','','1','0','admin','2024-07-12 10:33:29','admin','2024-07-12 10:33:29');
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0停用 1正常）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','1','admin','2024-06-13 16:06:36','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','1','admin','2024-06-13 16:06:36','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','1','admin','2024-06-13 16:06:36','',NULL,'性别未知'),(4,1,'显示','1','sys_show_hide','','primary','Y','1','admin','2024-06-13 16:06:36','admin','2024-07-10 16:34:54','显示菜单'),(5,2,'隐藏','0','sys_show_hide','','danger','N','1','admin','2024-06-13 16:06:36','admin','2024-07-10 16:35:07','隐藏菜单'),(6,1,'正常','1','sys_normal_disable','','primary','Y','1','admin','2024-06-13 16:06:36','admin','2024-07-10 14:30:58','正常状态'),(7,2,'停用','0','sys_normal_disable','','danger','N','1','admin','2024-06-13 16:06:36','admin','2024-07-10 14:31:06','停用状态'),(12,1,'是','Y','sys_yes_no','','primary','Y','1','admin','2024-06-13 16:06:36','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','1','admin','2024-06-13 16:06:36','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','1','admin','2024-06-13 16:06:36','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','1','admin','2024-06-13 16:06:36','',NULL,'公告'),(16,1,'正常','1','sys_notice_status','','primary','Y','1','admin','2024-06-13 16:06:36','admin','2024-07-10 17:24:35','正常状态'),(17,2,'关闭','0','sys_notice_status','','danger','N','1','admin','2024-06-13 16:06:36','admin','2024-07-10 17:24:44','关闭状态'),(18,1,'新增','1','sys_oper_type','','info','N','1','admin','2024-06-13 16:06:36','',NULL,'新增操作'),(19,2,'修改','2','sys_oper_type','','info','N','1','admin','2024-06-13 16:06:36','',NULL,'修改操作'),(20,3,'删除','3','sys_oper_type','','danger','N','1','admin','2024-06-13 16:06:37','',NULL,'删除操作'),(21,4,'授权','4','sys_oper_type','','primary','N','1','admin','2024-06-13 16:06:37','',NULL,'授权操作'),(22,5,'导出','5','sys_oper_type','','warning','N','1','admin','2024-06-13 16:06:37','',NULL,'导出操作'),(23,6,'导入','6','sys_oper_type','','warning','N','1','admin','2024-06-13 16:06:37','',NULL,'导入操作'),(24,7,'强退','7','sys_oper_type','','danger','N','1','admin','2024-06-13 16:06:37','',NULL,'强退操作'),(25,8,'生成代码','8','sys_oper_type','','warning','N','1','admin','2024-06-13 16:06:37','',NULL,'生成操作'),(26,9,'清空数据','9','sys_oper_type','','danger','N','1','admin','2024-06-13 16:06:37','',NULL,'清空操作'),(27,1,'失败','0','sys_common_status','','danger','N','1','admin','2024-06-13 16:06:37','admin','2024-07-15 10:50:52','正常状态'),(28,2,'成功','1','sys_common_status','','success','N','1','admin','2024-06-13 16:06:37','admin','2024-07-15 10:51:05','停用状态'),(29,99,'其他','0','sys_oper_type','','info','N','1','admin','2024-06-13 16:06:36','',NULL,'其他操作'),(1001,1,'普通货区','1','wms_area_type','','default','N','0','admin','2025-12-05 10:54:01','',NULL,'普通货区'),(1002,2,'置换区','2','wms_area_type','','success','N','0','admin','2025-12-05 10:54:01','',NULL,'置换区'),(1003,3,'其他','3','wms_area_type','','info','N','0','admin','2025-12-05 10:54:01','',NULL,'其他类型'),(1011,1,'普通货位','1','wms_bin_type','','default','N','0','admin','2025-12-05 10:54:01','',NULL,'普通货位'),(1012,2,'暂存位','2','wms_bin_type','','warning','N','0','admin','2025-12-05 10:54:01','',NULL,'暂存位'),(1013,3,'其他','3','wms_bin_type','','info','N','0','admin','2025-12-05 10:54:01','',NULL,'其他类型'),(1021,1,'空闲','0','wms_bin_status','','success','N','0','admin','2025-12-05 10:54:01','',NULL,'空闲'),(1022,2,'占用','1','wms_bin_status','','warning','N','0','admin','2025-12-05 10:54:01','',NULL,'占用'),(1023,3,'禁用','2','wms_bin_status','','danger','N','0','admin','2025-12-05 10:54:01','',NULL,'禁用'),(1024,4,'锁定','3','wms_bin_status','','info','N','0','admin','2025-12-05 10:54:01','',NULL,'锁定'),(1031,1,'在库','0','wms_valve_status','','success','N','0','admin','2025-12-05 10:54:01','',NULL,'在库'),(1032,2,'检测中','1','wms_valve_status','','warning','N','0','admin','2025-12-05 10:54:01','',NULL,'检测中'),(1033,3,'已检测','2','wms_valve_status','','primary','N','0','admin','2025-12-05 10:54:01','',NULL,'已检测'),(1034,4,'已出库','3','wms_valve_status','','info','N','0','admin','2025-12-05 10:54:01','',NULL,'已出库'),(1041,1,'正常','0','wms_pallet_status','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'正常'),(1042,2,'禁用','1','wms_pallet_status','','danger','N','0','admin','2025-12-05 10:54:02','',NULL,'禁用'),(1051,1,'托盘条码','1','wms_barcode_type','','default','N','0','admin','2025-12-05 10:54:02','',NULL,'托盘条码'),(1052,2,'阀门条码','2','wms_barcode_type','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'阀门条码'),(1053,3,'库位条码','3','wms_barcode_type','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'库位条码'),(1061,1,'入库扫码','1','wms_scan_task_type','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'入库扫码'),(1062,2,'出库扫码','2','wms_scan_task_type','','warning','N','0','admin','2025-12-05 10:54:02','',NULL,'出库扫码'),(1063,3,'盘点扫码','3','wms_scan_task_type','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'盘点扫码'),(1071,1,'待执行','0','wms_scan_task_status','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'待执行'),(1072,2,'执行中','1','wms_scan_task_status','','warning','N','0','admin','2025-12-05 10:54:02','',NULL,'执行中'),(1073,3,'已完成','2','wms_scan_task_status','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'已完成'),(1074,4,'已取消','3','wms_scan_task_status','','default','N','0','admin','2025-12-05 10:54:02','',NULL,'已取消'),(1081,1,'入库','1','wms_agv_task_type','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'入库任务'),(1082,2,'出库','2','wms_agv_task_type','','warning','N','0','admin','2025-12-05 10:54:02','',NULL,'出库任务'),(1083,3,'送检','3','wms_agv_task_type','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'送检任务'),(1084,4,'回库','4','wms_agv_task_type','','primary','N','0','admin','2025-12-05 10:54:02','',NULL,'回库任务'),(1091,1,'待执行','0','wms_agv_task_status','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'待执行'),(1092,2,'执行中','1','wms_agv_task_status','','warning','N','0','admin','2025-12-05 10:54:02','',NULL,'执行中'),(1093,3,'已完成','2','wms_agv_task_status','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'已完成'),(1094,4,'已取消','3','wms_agv_task_status','','default','N','0','admin','2025-12-05 10:54:02','',NULL,'已取消'),(1095,5,'失败','4','wms_agv_task_status','','danger','N','0','admin','2025-12-05 10:54:02','',NULL,'失败'),(1101,1,'托盘扫码','1','wms_pda_operation_type','','default','N','0','admin','2025-12-05 10:54:02','',NULL,'托盘扫码'),(1102,2,'阀门扫码','2','wms_pda_operation_type','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'阀门扫码'),(1103,3,'库位扫码','3','wms_pda_operation_type','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'库位扫码'),(1104,4,'入库','4','wms_pda_operation_type','','warning','N','0','admin','2025-12-05 10:54:02','',NULL,'入库'),(1105,5,'出库','5','wms_pda_operation_type','','danger','N','0','admin','2025-12-05 10:54:02','',NULL,'出库'),(1106,6,'送检','6','wms_pda_operation_type','','primary','N','0','admin','2025-12-05 10:54:02','',NULL,'送检'),(1107,7,'回库','7','wms_pda_operation_type','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'回库'),(1108,8,'盘点','8','wms_pda_operation_type','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'盘点'),(1109,9,'任务取消','9','wms_pda_operation_type','','default','N','0','admin','2025-12-05 10:54:02','',NULL,'任务取消'),(1111,1,'操作记录','1','wms_pda_log_type','','default','N','0','admin','2025-12-05 10:54:02','',NULL,'操作记录'),(1112,2,'错误日志','2','wms_pda_log_type','','danger','N','0','admin','2025-12-05 10:54:02','',NULL,'错误日志'),(1113,3,'网络失败记录','3','wms_pda_log_type','','warning','N','0','admin','2025-12-05 10:54:02','',NULL,'网络失败记录'),(1114,4,'系统日志','4','wms_pda_log_type','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'系统日志'),(1121,1,'业务参数','1','wms_config_type','','default','N','0','admin','2025-12-05 10:54:02','',NULL,'业务参数'),(1122,2,'规则配置','2','wms_config_type','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'规则配置'),(1123,3,'系统配置','3','wms_config_type','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'系统配置'),(1124,4,'PDA配置','4','wms_config_type','','warning','N','0','admin','2025-12-05 10:54:02','',NULL,'PDA配置'),(1125,5,'AGV配置','5','wms_config_type','','danger','N','0','admin','2025-12-05 10:54:02','',NULL,'AGV配置'),(1131,1,'全量备份','1','wms_backup_type','','default','N','0','admin','2025-12-05 10:54:02','',NULL,'全量备份'),(1132,2,'增量备份','2','wms_backup_type','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'增量备份'),(1133,3,'指定表备份','3','wms_backup_type','','info','N','0','admin','2025-12-05 10:54:02','',NULL,'指定表备份'),(1141,1,'进行中','0','wms_backup_status','','warning','N','0','admin','2025-12-05 10:54:02','',NULL,'进行中'),(1142,2,'成功','1','wms_backup_status','','success','N','0','admin','2025-12-05 10:54:02','',NULL,'成功'),(1143,3,'失败','2','wms_backup_status','','danger','N','0','admin','2025-12-05 10:54:02','',NULL,'失败'),(1812692503272718338,0,'客户','1','merchant_type',NULL,'default','N','1','admin','2024-07-15 11:35:46','admin','2024-07-16 11:21:11',NULL),(1812694839395135489,1,'供应商','2','merchant_type',NULL,'default','N','1','admin','2024-07-15 11:45:03','admin','2024-07-16 11:21:29',''),(1813051377282904066,3,'客户/供应商','3','merchant_type',NULL,'default','N','1','admin','2024-07-16 11:21:48','admin','2024-07-16 11:21:48',NULL),(1813153852862160897,0,'未入库','0','wms_receipt_status',NULL,'info','N','1','admin','2024-07-16 18:09:00','admin','2024-07-22 09:38:14',NULL),(1813153899775451137,1,'已入库','1','wms_receipt_status',NULL,'primary','N','1','admin','2024-07-16 18:09:11','admin','2024-07-22 09:38:22',NULL),(1813397339171905537,3,'作废','-1','wms_receipt_status',NULL,'danger','N','1','admin','2024-07-17 10:16:32','admin','2024-07-22 09:38:29',NULL),(1814219171351085057,0,'生产入库','1','wms_receipt_type',NULL,'primary','N','1','admin','2024-07-19 16:42:12','admin','2024-07-22 09:38:50',NULL),(1814219220520910849,1,'采购入库','2','wms_receipt_type',NULL,'primary','N','1','admin','2024-07-19 16:42:23','admin','2024-07-22 09:38:56',NULL),(1814219269975949313,2,'退货入库','3','wms_receipt_type',NULL,'primary','N','1','admin','2024-07-19 16:42:35','admin','2024-07-22 09:39:01',NULL),(1814219304272773121,3,'归还入库','4','wms_receipt_type',NULL,'primary','N','1','admin','2024-07-19 16:42:43','admin','2024-07-22 09:39:06',NULL),(1818850397680640002,2,'作废','-1','wms_shipment_status',NULL,'danger','N','1','admin','2024-08-01 11:25:02','admin','2024-08-01 14:25:24',NULL),(1818850512650706945,0,'未出库','0','wms_shipment_status',NULL,'info','N','1','admin','2024-08-01 11:25:29','admin','2024-08-01 14:25:37',NULL),(1818850565389885441,1,'已出库','1','wms_shipment_status',NULL,'primary','N','1','admin','2024-08-01 11:25:42','admin','2024-08-01 14:25:32',NULL),(1818850814351187969,0,'退货出库','1','wms_shipment_type',NULL,'primary','N','1','admin','2024-08-01 11:26:41','wms2_admin','2024-09-25 18:45:02',NULL),(1818850852594851841,1,'销售出库','2','wms_shipment_type',NULL,'primary','N','1','admin','2024-08-01 11:26:51','wms2_admin','2024-09-25 18:45:13',NULL),(1818850884714831874,2,'生产出库','3','wms_shipment_type',NULL,'primary','N','1','admin','2024-08-01 11:26:58','wms2_admin','2024-09-25 18:45:23',NULL),(1821067084643434498,0,'入库','1','wms_inventory_history_type',NULL,'success','N','1','admin','2024-08-07 14:13:21','wms2_admin','2024-09-27 10:53:49',NULL),(1821067144441626625,1,'出库','2','wms_inventory_history_type',NULL,'danger','N','1','admin','2024-08-07 14:13:36','wms2_admin','2024-09-27 10:53:39',NULL),(1821067181917732866,2,'移库','3','wms_inventory_history_type',NULL,'warning','N','1','admin','2024-08-07 14:13:45','wms2_admin','2024-09-27 10:54:01',NULL),(1821067222455681026,3,'盘库','4','wms_inventory_history_type',NULL,'primary','N','1','admin','2024-08-07 14:13:54','admin','2024-08-07 14:58:06',NULL),(1822820748966006786,0,'未移库','0','wms_movement_status',NULL,'info','N','1','admin','2024-08-12 10:21:48','admin','2024-08-12 10:21:48',NULL),(1822820794864275457,1,'已移库','1','wms_movement_status',NULL,'primary','N','1','admin','2024-08-12 10:21:59','admin','2024-08-12 10:21:59',NULL),(1822820855526494210,2,'作废','-1','wms_movement_status',NULL,'danger','N','1','admin','2024-08-12 10:22:13','admin','2024-08-12 10:22:13',NULL),(1823182345731391489,0,'待盘库','0','wms_check_status',NULL,'info','N','1','admin','2024-08-13 10:18:39','admin','2024-08-13 10:18:39',NULL),(1823182400756465666,1,'已盘库','1','wms_check_status',NULL,'primary','N','1','admin','2024-08-13 10:18:52','admin','2024-08-13 10:18:52',NULL),(1823182471136886786,2,'作废','-1','wms_check_status',NULL,'danger','N','1','admin','2024-08-13 10:19:09','admin','2024-08-13 10:19:09',NULL);
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE KEY `dict_type` (`dict_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','1','admin','2024-06-13 16:06:35','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','1','admin','2024-06-13 16:06:35','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','1','admin','2024-06-13 16:06:35','',NULL,'系统开关列表'),(6,'系统是否','sys_yes_no','1','admin','2024-06-13 16:06:35','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','1','admin','2024-06-13 16:06:35','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','1','admin','2024-06-13 16:06:35','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','1','admin','2024-06-13 16:06:35','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','1','admin','2024-06-13 16:06:36','',NULL,'登录状态列表'),(100,'货区类型','wms_area_type','0','admin','2025-12-05 10:54:01','',NULL,'货区类型字典'),(101,'货位类型','wms_bin_type','0','admin','2025-12-05 10:54:01','',NULL,'货位类型字典'),(102,'货位状态','wms_bin_status','0','admin','2025-12-05 10:54:01','',NULL,'货位状态字典'),(103,'阀门状态','wms_valve_status','0','admin','2025-12-05 10:54:01','',NULL,'阀门状态字典'),(104,'托盘状态','wms_pallet_status','0','admin','2025-12-05 10:54:01','',NULL,'托盘状态字典'),(105,'条码类型','wms_barcode_type','0','admin','2025-12-05 10:54:01','',NULL,'条码类型字典'),(106,'扫码任务类型','wms_scan_task_type','0','admin','2025-12-05 10:54:01','',NULL,'扫码任务类型字典'),(107,'扫码任务状态','wms_scan_task_status','0','admin','2025-12-05 10:54:01','',NULL,'扫码任务状态字典'),(108,'AGV任务类型','wms_agv_task_type','0','admin','2025-12-05 10:54:01','',NULL,'AGV任务类型字典'),(109,'AGV任务状态','wms_agv_task_status','0','admin','2025-12-05 10:54:01','',NULL,'AGV任务状态字典'),(110,'PDA操作类型','wms_pda_operation_type','0','admin','2025-12-05 10:54:01','',NULL,'PDA操作类型字典'),(111,'PDA日志类型','wms_pda_log_type','0','admin','2025-12-05 10:54:01','',NULL,'PDA日志类型字典'),(112,'WMS配置类型','wms_config_type','0','admin','2025-12-05 10:54:01','',NULL,'WMS配置类型字典'),(113,'数据备份类型','wms_backup_type','0','admin','2025-12-05 10:54:01','',NULL,'数据备份类型字典'),(114,'数据备份状态','wms_backup_status','0','admin','2025-12-05 10:54:01','',NULL,'数据备份状态字典'),(1812692454547488770,'企业类型','merchant_type','1','admin','2024-07-15 11:35:34','admin','2024-07-16 17:41:32','企业类型'),(1813152108564373505,'入库状态','wms_receipt_status','1','admin','2024-07-16 18:02:04','admin','2024-07-16 18:02:17','入库状态'),(1814219082624778242,'入库类型','wms_receipt_type','1','admin','2024-07-19 16:41:51','admin','2024-07-19 16:41:51',NULL),(1818848671749709825,'出库状态','wms_shipment_status','1','admin','2024-08-01 11:18:11','admin','2024-08-01 11:18:11',NULL),(1818848738502057985,'出库类型','wms_shipment_type','1','admin','2024-08-01 11:18:26','admin','2024-08-01 11:18:26',NULL),(1821066855638630402,'库存记录操作类型','wms_inventory_history_type','1','admin','2024-08-07 14:12:27','admin','2024-08-07 14:12:27',NULL),(1822820566366982146,'移库状态','wms_movement_status','1','admin','2024-08-12 10:21:04','admin','2024-08-12 10:21:04',NULL),(1823182238898274306,'盘库状态','wms_check_status','1','admin','2024-08-13 10:18:14','admin','2024-08-13 10:18:14',NULL);
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  KEY `idx_sys_logininfor_s` (`status`) USING BTREE,
  KEY `idx_sys_logininfor_lt` (`login_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (1998236440179625986,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 11:41:07'),(1998290646672461825,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 15:16:31'),(1998290684182122497,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 15:16:40'),(1998294920164921345,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 15:33:30'),(1998294961411706881,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 15:33:40'),(1998297609472954370,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 15:44:11'),(1998297671963889666,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 15:44:26'),(1998298688931614722,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 15:48:29'),(1998298701124456450,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 15:48:32'),(1998299133402009602,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 15:50:15'),(1998299271692406786,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 15:50:48'),(1998299413652819970,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 15:51:21'),(1998315798642675714,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 16:56:28'),(1998315809673695233,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 16:56:31'),(1998323493353410561,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 17:27:03'),(1998323516170424321,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 17:27:08'),(1998326483598499842,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 17:38:55'),(1998326496449847298,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 17:38:59'),(1998340545216569345,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 18:34:48'),(1998343159937294338,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 18:45:11'),(1998343180904620033,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 18:45:16'),(1998343606903300098,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 18:46:58'),(1998343627606384642,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 18:47:03'),(1998345220624015362,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 18:53:23'),(1998345233592803329,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 18:53:26'),(1998345413880766466,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','退出成功','2025-12-09 18:54:09'),(1998345425205387265,'admin','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','登录成功','2025-12-09 18:54:11');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件路径',
  `query_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路由参数',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '显示状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,130,'system',NULL,'',0,0,'M','1','1','','system','admin','2024-06-13 16:06:26','admin','2025-12-09 16:42:52','系统管理目录'),(2,'系统监控',0,120,'monitor',NULL,'',0,0,'M','1','1','','monitor','admin','2024-06-13 16:06:26','admin','2024-08-20 13:45:57','系统监控目录'),(100,'用户管理',2001,10,'user','system/user/index','',0,0,'C','1','1','system:user:list','user','admin','2024-06-13 16:06:26','admin','2025-12-09 16:17:12','用户管理菜单'),(101,'角色管理',2001,20,'role','system/role/index','',0,0,'C','1','1','system:role:list','peoples','admin','2024-06-13 16:06:26','admin','2025-12-09 16:17:23','角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','',0,0,'C','1','1','system:menu:list','tree-table','admin','2024-06-13 16:06:26','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','',0,0,'C','1','1','system:dept:list','tree','admin','2024-06-13 16:06:26','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','',0,0,'C','1','1','system:post:list','post','admin','2024-06-13 16:06:26','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','',0,0,'C','1','1','system:dict:list','dict','admin','2024-06-13 16:06:26','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','',0,0,'C','1','1','system:config:list','edit','admin','2024-06-13 16:06:26','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','',0,0,'C','1','1','system:notice:list','message','admin','2024-06-13 16:06:26','',NULL,'通知公告菜单'),(108,'日志管理',0,140,'log','','',0,0,'M','1','1','','log','admin','2024-06-13 16:06:27','admin','2025-12-09 18:48:47','日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','',0,0,'C','1','1','monitor:online:list','online','admin','2024-06-13 16:06:27','',NULL,'在线用户菜单'),(112,'缓存列表',2,6,'cacheList','monitor/cache/list','',0,0,'C','1','1','monitor:cache:list','redis-list','admin','2024-06-13 16:06:27','',NULL,'缓存列表菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','',0,0,'C','1','1','monitor:cache:list','redis','admin','2024-06-13 16:06:27','',NULL,'缓存监控菜单'),(118,'文件管理',1,10,'oss','system/oss/index','',0,0,'C','1','1','system:oss:list','upload','admin','2024-06-13 16:06:27','',NULL,'文件管理菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','',0,0,'C','1','1','monitor:operlog:list','form','admin','2024-06-13 16:06:27','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','',0,0,'C','1','1','monitor:logininfor:list','logininfor','admin','2024-06-13 16:06:27','',NULL,'登录日志菜单'),(1001,'用户查询',100,1,'','','',0,0,'F','1','1','system:user:query','#','admin','2024-06-13 16:06:27','',NULL,''),(1002,'用户新增',100,2,'','','',0,0,'F','1','1','system:user:add','#','admin','2024-06-13 16:06:27','',NULL,''),(1003,'用户修改',100,3,'','','',0,0,'F','1','1','system:user:edit','#','admin','2024-06-13 16:06:27','',NULL,''),(1004,'用户删除',100,4,'','','',0,0,'F','1','1','system:user:remove','#','admin','2024-06-13 16:06:27','',NULL,''),(1005,'用户导出',100,5,'','','',0,0,'F','1','1','system:user:export','#','admin','2024-06-13 16:06:27','',NULL,''),(1006,'用户导入',100,6,'','','',0,0,'F','1','1','system:user:import','#','admin','2024-06-13 16:06:27','',NULL,''),(1007,'重置密码',100,7,'','','',0,0,'F','1','1','system:user:resetPwd','#','admin','2024-06-13 16:06:27','',NULL,''),(1008,'角色查询',101,1,'','','',0,0,'F','1','1','system:role:query','#','admin','2024-06-13 16:06:27','',NULL,''),(1009,'角色新增',101,2,'','','',0,0,'F','1','1','system:role:add','#','admin','2024-06-13 16:06:27','',NULL,''),(1010,'角色修改',101,3,'','','',0,0,'F','1','1','system:role:edit','#','admin','2024-06-13 16:06:28','',NULL,''),(1011,'角色删除',101,4,'','','',0,0,'F','1','1','system:role:remove','#','admin','2024-06-13 16:06:28','',NULL,''),(1012,'角色导出',101,5,'','','',0,0,'F','1','1','system:role:export','#','admin','2024-06-13 16:06:28','',NULL,''),(1013,'菜单查询',102,1,'','','',0,0,'F','1','1','system:menu:query','#','admin','2024-06-13 16:06:28','',NULL,''),(1014,'菜单新增',102,2,'','','',0,0,'F','1','1','system:menu:add','#','admin','2024-06-13 16:06:28','',NULL,''),(1015,'菜单修改',102,3,'','','',0,0,'F','1','1','system:menu:edit','#','admin','2024-06-13 16:06:28','',NULL,''),(1016,'菜单删除',102,4,'','','',0,0,'F','1','1','system:menu:remove','#','admin','2024-06-13 16:06:28','',NULL,''),(1017,'部门查询',103,1,'','','',0,0,'F','1','1','system:dept:query','#','admin','2024-06-13 16:06:28','',NULL,''),(1018,'部门新增',103,2,'','','',0,0,'F','1','1','system:dept:add','#','admin','2024-06-13 16:06:28','',NULL,''),(1019,'部门修改',103,3,'','','',0,0,'F','1','1','system:dept:edit','#','admin','2024-06-13 16:06:28','',NULL,''),(1020,'部门删除',103,4,'','','',0,0,'F','1','1','system:dept:remove','#','admin','2024-06-13 16:06:28','',NULL,''),(1021,'岗位查询',104,1,'','','',0,0,'F','1','1','system:post:query','#','admin','2024-06-13 16:06:28','',NULL,''),(1022,'岗位新增',104,2,'','','',0,0,'F','1','1','system:post:add','#','admin','2024-06-13 16:06:28','',NULL,''),(1023,'岗位修改',104,3,'','','',0,0,'F','1','1','system:post:edit','#','admin','2024-06-13 16:06:28','',NULL,''),(1024,'岗位删除',104,4,'','','',0,0,'F','1','1','system:post:remove','#','admin','2024-06-13 16:06:28','',NULL,''),(1025,'岗位导出',104,5,'','','',0,0,'F','1','1','system:post:export','#','admin','2024-06-13 16:06:28','',NULL,''),(1026,'字典查询',105,1,'#','','',0,0,'F','1','1','system:dict:query','#','admin','2024-06-13 16:06:28','',NULL,''),(1027,'字典新增',105,2,'#','','',0,0,'F','1','1','system:dict:add','#','admin','2024-06-13 16:06:28','',NULL,''),(1028,'字典修改',105,3,'#','','',0,0,'F','1','1','system:dict:edit','#','admin','2024-06-13 16:06:28','',NULL,''),(1029,'字典删除',105,4,'#','','',0,0,'F','1','1','system:dict:remove','#','admin','2024-06-13 16:06:28','',NULL,''),(1030,'字典导出',105,5,'#','','',0,0,'F','1','1','system:dict:export','#','admin','2024-06-13 16:06:29','',NULL,''),(1031,'参数查询',106,1,'#','','',0,0,'F','1','1','system:config:query','#','admin','2024-06-13 16:06:29','',NULL,''),(1032,'参数新增',106,2,'#','','',0,0,'F','1','1','system:config:add','#','admin','2024-06-13 16:06:29','',NULL,''),(1033,'参数修改',106,3,'#','','',0,0,'F','1','1','system:config:edit','#','admin','2024-06-13 16:06:29','',NULL,''),(1034,'参数删除',106,4,'#','','',0,0,'F','1','1','system:config:remove','#','admin','2024-06-13 16:06:29','',NULL,''),(1035,'参数导出',106,5,'#','','',0,0,'F','1','1','system:config:export','#','admin','2024-06-13 16:06:29','',NULL,''),(1036,'公告查询',107,1,'#','','',0,0,'F','1','1','system:notice:query','#','admin','2024-06-13 16:06:29','',NULL,''),(1037,'公告新增',107,2,'#','','',0,0,'F','1','1','system:notice:add','#','admin','2024-06-13 16:06:29','',NULL,''),(1038,'公告修改',107,3,'#','','',0,0,'F','1','1','system:notice:edit','#','admin','2024-06-13 16:06:29','',NULL,''),(1039,'公告删除',107,4,'#','','',0,0,'F','1','1','system:notice:remove','#','admin','2024-06-13 16:06:29','',NULL,''),(1040,'操作查询',500,1,'#','','',0,0,'F','1','1','monitor:operlog:query','#','admin','2024-06-13 16:06:29','',NULL,''),(1041,'操作删除',500,2,'#','','',0,0,'F','1','1','monitor:operlog:remove','#','admin','2024-06-13 16:06:29','',NULL,''),(1042,'日志导出',500,4,'#','','',0,0,'F','1','1','monitor:operlog:export','#','admin','2024-06-13 16:06:29','',NULL,''),(1043,'登录查询',501,1,'#','','',0,0,'F','1','1','monitor:logininfor:query','#','admin','2024-06-13 16:06:29','',NULL,''),(1044,'登录删除',501,2,'#','','',0,0,'F','1','1','monitor:logininfor:remove','#','admin','2024-06-13 16:06:29','',NULL,''),(1045,'日志导出',501,3,'#','','',0,0,'F','1','1','monitor:logininfor:export','#','admin','2024-06-13 16:06:29','',NULL,''),(1046,'在线查询',109,1,'#','','',0,0,'F','1','1','monitor:online:query','#','admin','2024-06-13 16:06:29','',NULL,''),(1047,'批量强退',109,2,'#','','',0,0,'F','1','1','monitor:online:batchLogout','#','admin','2024-06-13 16:06:29','',NULL,''),(1048,'单条强退',109,3,'#','','',0,0,'F','1','1','monitor:online:forceLogout','#','admin','2024-06-13 16:06:30','',NULL,''),(1050,'账户解锁',501,4,'#','','',0,0,'F','1','1','monitor:logininfor:unlock','#','admin','2024-06-13 16:06:29','',NULL,''),(1600,'文件查询',118,1,'#','','',0,0,'F','1','1','system:oss:query','#','admin','2024-06-13 16:06:30','',NULL,''),(1601,'文件上传',118,2,'#','','',0,0,'F','1','1','system:oss:upload','#','admin','2024-06-13 16:06:30','',NULL,''),(1602,'文件下载',118,3,'#','','',0,0,'F','1','1','system:oss:download','#','admin','2024-06-13 16:06:30','',NULL,''),(1603,'文件删除',118,4,'#','','',0,0,'F','1','1','system:oss:remove','#','admin','2024-06-13 16:06:30','',NULL,''),(1604,'配置添加',118,5,'#','','',0,0,'F','1','1','system:oss:add','#','admin','2024-06-13 16:06:30','',NULL,''),(1605,'配置编辑',118,6,'#','','',0,0,'F','1','1','system:oss:edit','#','admin','2024-06-13 16:06:30','',NULL,''),(2001,'new 基础数据',0,110,'basic',NULL,'',0,0,'M','1','1','','dict','admin','2025-12-05 10:54:01','admin','2025-12-09 16:40:47','基础数据管理'),(2010,'仓库管理',1998317351596314625,20,'warehouse','wms/basic/warehouse/index','',0,0,'C','1','1','wms:warehouse:list','date','admin','2025-12-05 10:54:01','admin','2025-12-09 17:02:57','仓库管理'),(2011,'货区管理',1998317351596314625,40,'area','wms/basic/area/index','',0,0,'C','1','1','wms:area:list','tree','admin','2025-12-05 10:54:01','admin','2025-12-09 17:03:08','货区管理'),(2012,'货位管理',1998317351596314625,50,'bin','wms/basic/bin/index','',0,0,'C','1','1','wms:bin:list','tree-table','admin','2025-12-05 10:54:01','admin','2025-12-09 17:03:21','货位管理'),(2013,'物料类型',1998308639817191425,60,'materialType','wms/basic/materialType/index','',0,0,'C','1','1','wms:materialType:list','list','admin','2025-12-05 10:54:01','admin','2025-12-09 16:45:01','物料类型管理'),(2014,'托盘类型',1998308639817191425,70,'palletType','wms/basic/palletType/index','',0,0,'C','1','1','wms:palletType:list','list','admin','2025-12-05 10:54:01','admin','2025-12-09 16:45:30','托盘类型管理'),(2015,'托盘管理',1998308639817191425,80,'pallet','wms/basic/pallet/index','',0,0,'C','1','1','wms:pallet:list','table','admin','2025-12-05 10:54:01','admin','2025-12-09 16:46:22','托盘管理'),(2016,'阀门管理',2001,90,'valve','wms/basic/valve/index','',0,0,'C','1','1','wms:valve:list','component','admin','2025-12-05 10:54:01','admin','2025-12-09 16:18:51','阀门管理'),(2017,'库管员管理',2001,100,'warehouseKeeper','wms/basic/warehouseKeeper/index','',0,0,'C','1','1','wms:warehouseKeeper:list','user','admin','2025-12-05 10:54:01','admin','2025-12-09 16:18:58','库管员管理'),(2020,'new 条码管理',0,60,'barcode',NULL,'',0,0,'M','1','1','','chart','admin','2025-12-05 10:54:01','admin','2025-12-09 16:28:16','条码管理'),(2021,'条码信息',2020,1,'barcode','wms/barcode/index','',0,0,'C','1','1','wms:barcode:list','cascader','admin','2025-12-05 10:54:01','admin','2025-12-09 14:15:02','条码信息管理'),(2022,'扫码任务',2020,2,'scanTask','wms/scanTask/index','',0,0,'C','1','1','wms:scanTask:list','guide','admin','2025-12-05 10:54:01','admin','2025-12-09 14:10:19','扫码任务管理'),(2030,'new 订单管理',0,30,'order',NULL,'',0,0,'M','1','1','','shopping','admin','2025-12-05 10:54:01','admin','2025-12-09 16:26:57','订单管理'),(2031,'入库单',2030,1,'receipt','wms/order/receipt/index','',0,0,'C','1','1','wms:receipt:list','upload','admin','2025-12-05 10:54:01','admin','2025-12-09 16:44:04','入库单管理'),(2032,'出库单',2030,2,'shipment','wms/order/shipment/index','',0,0,'C','1','1','wms:shipment:list','download','admin','2025-12-05 10:54:01','admin','2025-12-09 16:44:10','出库单管理'),(2033,'移库单',2030,3,'movement','wms/order/movement/index','',0,0,'C','1','1','wms:movement:list','drag','admin','2025-12-05 10:54:01','admin','2025-12-09 16:44:14','移库单管理'),(2034,'盘点单',2030,4,'check','wms/order/check/index','',0,0,'C','1','1','wms:check:list','edit','admin','2025-12-05 10:54:01','admin','2025-12-09 16:44:18','盘点单管理'),(2040,'new 库存管理',0,40,'inventory',NULL,'',0,0,'M','1','1','','chart','admin','2025-12-05 10:54:01','admin','2025-12-09 16:27:14','库存管理'),(2041,'库存统计',2040,1,'inventory','wms/inventory/statistic','',0,0,'C','1','1','wms:inventory:all','chart','admin','2025-12-05 10:54:01','admin','2025-12-09 15:45:57','库存统计'),(2042,'库存历史',2040,2,'history','wms/inventory/history','',0,0,'C','1','1','wms:inventoryHistory:all','log','admin','2025-12-05 10:54:01','admin','2025-12-09 15:54:23','库存历史'),(2043,'库存查询',2040,3,'query','wms/inventory/query/index','',0,0,'C','1','1','wms:inventory:query','search','admin','2025-12-05 10:54:01','admin','2025-12-09 14:12:25','库存查询'),(2050,'new 任务管理',0,80,'task',NULL,'',0,0,'M','1','1','wms:inventory:all','guide','admin','2025-12-05 10:54:01','admin','2025-12-09 16:29:39','任务管理'),(2051,'AGV任务',2050,1,'agvTask','wms/task/agvTask/index','',0,0,'C','1','1','wms:agvTask:list','guide','admin','2025-12-05 10:54:01','admin','2025-12-09 16:29:09','AGV任务管理'),(2060,'new PDA管理',0,90,'pda',NULL,'',0,0,'M','1','1','','phone','admin','2025-12-05 10:54:01','admin','2025-12-09 16:40:24','PDA管理'),(2061,'PDA操作记录',2060,1,'operation','wms/pda/operation/index','',0,0,'C','1','1','wms:pdaOperation:list','list','admin','2025-12-05 10:54:01','admin','2025-12-09 14:13:29','PDA操作记录'),(2062,'PDA日志',2060,2,'pda-log','wms/pda/log/index','',0,0,'C','1','1','wms:pdaLog:list','log','admin','2025-12-05 10:54:01','admin','2025-12-09 18:49:10','PDA日志'),(2070,'new 报表查询',0,70,'report','wms/report/index','',0,0,'C','1','1','wms:report:list','chart','admin','2025-12-05 10:54:01','admin','2025-12-09 17:08:15','报表查询'),(2080,'new 系统配置',0,100,'wms-config',NULL,'',0,0,'M','1','1','','system','admin','2025-12-05 10:54:01','admin','2025-12-09 18:56:00','系统配置'),(2081,'WMS配置',2080,1,'wms-config','wms/config/index','',0,0,'C','1','1','wms:config:list','edit','admin','2025-12-05 10:54:01','admin','2025-12-09 18:51:10','WMS配置管理'),(2082,'数据备份',2080,2,'data-backup','wms/dataBackup/index','',0,0,'C','1','1','wms:backup:list','color','admin','2025-12-05 10:54:01','admin','2025-12-09 18:52:23','数据备份管理'),(1809059968309743618,'old 往来单位',2001,1000,'merchant','wms/basic/merchant/index',NULL,0,0,'C','1','1','wms:merchant:list','documentation','admin','2024-07-05 11:58:12','admin','2025-12-09 16:19:23','往来单位菜单'),(1809059968309743619,'往来单位查询',1809059968309743618,1,'#','',NULL,0,0,'F','1','1','wms:merchant:list','#','admin','2024-07-05 11:58:12','admin','2024-08-30 10:43:54',''),(1809059968309743621,'往来单位修改',1809059968309743618,3,'#','',NULL,0,0,'F','1','1','wms:merchant:edit','#','admin','2024-07-05 11:58:12','',NULL,''),(1813820131794837506,'old 商品管理',2001,1001,'item','wms/basic/item/index',NULL,0,0,'C','1','1','wms:item:list','documentation','admin','2024-07-18 14:16:33','admin','2025-12-09 16:19:30',''),(1815207165755183105,'编辑入库单',0,1000,'receiptOrderEdit','wms/order/receipt/edit',NULL,0,0,'C','0','1','wms:receipt:edit','#','admin','2024-07-22 10:08:08','admin','2024-08-27 16:43:28',''),(1818123963605549057,'old 品牌管理',2001,1002,'itemBrand','wms/basic/itemBrand/index',NULL,0,0,'C','1','1','wms:itemBrand:list','documentation','admin','2024-07-30 11:18:27','admin','2025-12-09 16:19:36',''),(1818466281474822145,'入库',1998301986061406209,20,'receiptOrder','wms/order/receipt/index',NULL,0,0,'C','1','1','wms:receipt:all','exit-fullscreen','admin','2024-07-31 09:58:42','admin','2025-12-09 16:01:50',''),(1818854933803638785,'出库',1998301986061406209,30,'shipmentOrder','wms/order/shipment/index',NULL,0,0,'C','1','1','wms:shipment:all','fullscreen','admin','2024-08-01 11:43:04','admin','2025-12-09 16:01:58',''),(1818855673632727042,'编辑出库单',0,1000,'shipmentOrderEdit','wms/order/shipment/edit',NULL,0,0,'C','0','1','wms:shipment:edit','#','admin','2024-08-01 11:46:00','admin','2024-08-27 16:43:37',''),(1822820194307051521,'移库',1998301986061406209,40,'movementOrder','wms/order/movement/index',NULL,0,0,'C','1','1','wms:movement:all','drag','admin','2024-08-12 10:19:35','admin','2025-12-09 16:02:05',''),(1822862323595145218,'编辑移库单',0,1000,'movementOrderEdit','wms/order/movement/edit',NULL,0,0,'C','0','1','wms:movement:edit','#','admin','2024-08-12 13:07:00','admin','2024-08-27 16:43:50',''),(1823187248797270018,'盘库',1998301986061406209,50,'checkOrder','wms/order/check/index',NULL,0,0,'C','1','1','wms:check:all','example','admin','2024-08-13 10:38:08','admin','2025-12-09 16:02:11',''),(1823190638784757762,'编辑盘库单',0,1000,'checkOrderEdit','wms/order/check/edit',NULL,0,0,'C','0','1','wms:check:edit','#','admin','2024-08-13 10:51:36','admin','2024-08-27 16:43:44',''),(1829349433573822466,'仓库查询',2010,1,'',NULL,NULL,0,0,'F','1','1','wms:warehouse:list','#','admin','2024-08-30 10:44:27','admin','2025-12-09 16:05:59',''),(1829350022131142658,'仓库编辑',2010,2,'',NULL,NULL,0,0,'F','1','1','wms:warehouse:edit','#','admin','2024-08-30 10:46:48','admin','2025-12-09 16:06:14',''),(1829350164603260929,'品牌查询',1818123963605549057,1,'',NULL,NULL,0,0,'F','1','1','wms:itemBrand:list','#','admin','2024-08-30 10:47:22','admin','2024-08-30 10:47:22',''),(1829350944311791617,'品牌编辑',1818123963605549057,2,'',NULL,NULL,0,0,'F','1','1','wms:itemBrand:edit','#','admin','2024-08-30 10:50:27','admin','2024-08-30 10:50:27',''),(1829351081448755202,'商品查询',1813820131794837506,1,'',NULL,NULL,0,0,'F','1','1','wms:item:list','#','admin','2024-08-30 10:51:00','admin','2024-08-30 10:51:00',''),(1829351166857367553,'商品编辑',1813820131794837506,2,'',NULL,NULL,0,0,'F','1','1','wms:item:edit','#','admin','2024-08-30 10:51:21','admin','2024-08-30 10:51:21',''),(1998301986061406209,'new 出入库',0,10,'io',NULL,NULL,0,0,'M','1','1',NULL,'chart','admin','2025-12-09 16:01:35','admin','2025-12-09 16:20:34',''),(1998308639817191425,'new 托盘及物料管理',0,50,'dd',NULL,NULL,0,0,'M','1','1',NULL,'dashboard','admin','2025-12-09 16:28:01','admin','2025-12-09 16:41:20',''),(1998317351596314625,'new 仓库管理',0,20,'warehouse',NULL,NULL,0,0,'M','1','1',NULL,'drag','admin','2025-12-09 17:02:38','admin','2025-12-09 17:03:46','');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` bigint NOT NULL COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 新版本发布啦','2',_binary '新版本内容','1','admin','2024-06-13 16:06:38','',NULL,'管理员'),(2,'维护通知：2018-07-01 系统凌晨维护','1',_binary '维护内容','1','admin','2024-06-13 16:06:38','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0异常 1正常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  KEY `idx_sys_oper_log_bt` (`business_type`) USING BTREE,
  KEY `idx_sys_oper_log_s` (`status`) USING BTREE,
  KEY `idx_sys_oper_log_ot` (`oper_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (1998239913298219010,'角色管理',3,'com.ruoyi.system.controller.system.SysRoleController.remove()','DELETE',1,'admin','研发部门','/system/role/1829105952432427010','0:0:0:0:0:0:0:1','内网IP','{}','',0,'试用已分配，不能删除!','2025-12-09 11:54:55'),(1998239956151422977,'角色管理',4,'com.ruoyi.system.controller.system.SysRoleController.cancelAuthUser()','PUT',1,'admin','研发部门','/system/role/authUser/cancel','0:0:0:0:0:0:0:1','内网IP','{\"userId\":\"1829105396288688129\",\"roleId\":\"1829105952432427010\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 11:55:06'),(1998239986836951041,'角色管理',3,'com.ruoyi.system.controller.system.SysRoleController.remove()','DELETE',1,'admin','研发部门','/system/role/1829105952432427010','0:0:0:0:0:0:0:1','内网IP','{}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 11:55:13'),(1998240155557023746,'角色管理',1,'com.ruoyi.system.controller.system.SysRoleController.add()','POST',1,'admin','研发部门','/system/role','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"roleId\":\"1998240155494109186\",\"roleName\":\"库管员\",\"roleKey\":\"kadmin\",\"roleSort\":1,\"dataScope\":null,\"menuCheckStrictly\":true,\"deptCheckStrictly\":true,\"status\":\"1\",\"remark\":null,\"menuIds\":[],\"deptIds\":[],\"admin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 11:55:53'),(1998241861132996610,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2000,\"parentId\":0,\"menuName\":\"WMS仓储管理\",\"orderNum\":5,\"path\":\"wms\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"warehouse\",\"remark\":\"WMS仓储管理系统\"}','{\"code\":500,\"msg\":\"修改菜单\'WMS仓储管理\'失败，地址必须以http(s)://开头\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 12:02:40'),(1998242667144007681,'菜单管理',1,'com.ruoyi.system.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":null,\"parentId\":0,\"menuName\":\"基础数据\",\"orderNum\":0,\"path\":\"http://\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"icon\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 12:05:52'),(1998272411575111682,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2001,\"parentId\":0,\"menuName\":\"new 基础数据\",\"orderNum\":1,\"path\":\"http://basic\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"dict\",\"remark\":\"基础数据管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:04:04'),(1998272493854773249,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2001,\"parentId\":0,\"menuName\":\"基础数据\",\"orderNum\":1,\"path\":\"http://basic\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"dict\",\"remark\":\"基础数据管理\"}','{\"code\":500,\"msg\":\"修改菜单\'基础数据\'失败，菜单名称已存在\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:04:23'),(1998272533188956161,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2001,\"parentId\":0,\"menuName\":\"new 基础数据\",\"orderNum\":1,\"path\":\"http://basic\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"dict\",\"remark\":\"基础数据管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:04:33'),(1998272648343572482,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2010,\"parentId\":2001,\"menuName\":\"仓库管理\",\"orderNum\":1,\"path\":\"http://warehouse\",\"component\":\"wms/basic/warehouse/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"warehouse\",\"remark\":\"仓库管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:05:00'),(1998272900031172609,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2001,\"parentId\":0,\"menuName\":\"new 基础数据\",\"orderNum\":1,\"path\":\"http://basic\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"dict\",\"remark\":\"基础数据管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:06:00'),(1998273062728224769,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2001,\"parentId\":0,\"menuName\":\"new 基础数据\",\"orderNum\":1,\"path\":\"http://basic\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"dict\",\"remark\":\"基础数据管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:06:39'),(1998273104490909698,'菜单管理',3,'com.ruoyi.system.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1998242667076898818','0:0:0:0:0:0:0:1','内网IP','{}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:06:49'),(1998273168680538114,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2001,\"parentId\":0,\"menuName\":\"new 基础数据\",\"orderNum\":1,\"path\":\"http://basic\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"dict\",\"remark\":\"基础数据管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:07:04'),(1998273196358750210,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2001,\"parentId\":0,\"menuName\":\"new 基础数据\",\"orderNum\":1,\"path\":\"http://basic\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"dict\",\"remark\":\"基础数据管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:07:11'),(1998273453108875266,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2011,\"parentId\":2001,\"menuName\":\"货区管理\",\"orderNum\":2,\"path\":\"area\",\"component\":\"wms/basic/area/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:area:list\",\"icon\":\"tree\",\"remark\":\"货区管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:08:12'),(1998273497371365377,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2001,\"parentId\":0,\"menuName\":\"new 基础数据\",\"orderNum\":1,\"path\":\"basic\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"dict\",\"remark\":\"基础数据管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:08:23'),(1998273632759304193,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2020,\"parentId\":0,\"menuName\":\"条码管理\",\"orderNum\":2,\"path\":\"barcode\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"qrcode\",\"remark\":\"条码管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:08:55'),(1998273711125680130,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2020,\"parentId\":0,\"menuName\":\"new 条码管理\",\"orderNum\":2,\"path\":\"barcode\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"qrcode\",\"remark\":\"条码管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:09:14'),(1998273756986200066,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2012,\"parentId\":2001,\"menuName\":\"货位管理\",\"orderNum\":3,\"path\":\"bin\",\"component\":\"wms/basic/bin/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:bin:list\",\"icon\":\"tree-table\",\"remark\":\"货位管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:09:24'),(1998273784106569730,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2013,\"parentId\":2001,\"menuName\":\"物料类型\",\"orderNum\":4,\"path\":\"materialType\",\"component\":\"wms/basic/materialType/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:materialType:list\",\"icon\":\"list\",\"remark\":\"物料类型管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:09:31'),(1998273803899490305,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2014,\"parentId\":2001,\"menuName\":\"托盘类型\",\"orderNum\":5,\"path\":\"palletType\",\"component\":\"wms/basic/palletType/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:palletType:list\",\"icon\":\"list\",\"remark\":\"托盘类型管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:09:36'),(1998273823121985537,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2015,\"parentId\":2001,\"menuName\":\"托盘管理\",\"orderNum\":6,\"path\":\"pallet\",\"component\":\"wms/basic/pallet/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:pallet:list\",\"icon\":\"table\",\"remark\":\"托盘管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:09:40'),(1998273841354625026,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2016,\"parentId\":2001,\"menuName\":\"阀门管理\",\"orderNum\":7,\"path\":\"valve\",\"component\":\"wms/basic/valve/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:valve:list\",\"icon\":\"component\",\"remark\":\"阀门管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:09:45'),(1998273864490405890,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2017,\"parentId\":2001,\"menuName\":\"库管员管理\",\"orderNum\":8,\"path\":\"warehouseKeeper\",\"component\":\"wms/basic/warehouseKeeper/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouseKeeper:list\",\"icon\":\"user\",\"remark\":\"库管员管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:09:50'),(1998273966768508929,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2021,\"parentId\":2020,\"menuName\":\"条码信息\",\"orderNum\":1,\"path\":\"barcode\",\"component\":\"wms/barcode/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:barcode:list\",\"icon\":\"qrcode\",\"remark\":\"条码信息管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:10:14'),(1998273985919700993,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2022,\"parentId\":2020,\"menuName\":\"扫码任务\",\"orderNum\":2,\"path\":\"scanTask\",\"component\":\"wms/scanTask/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:scanTask:list\",\"icon\":\"guide\",\"remark\":\"扫码任务管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:10:19'),(1998274001086304257,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2030,\"parentId\":0,\"menuName\":\"订单管理\",\"orderNum\":3,\"path\":\"order\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"shopping\",\"remark\":\"订单管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:10:23'),(1998274039539683329,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2030,\"parentId\":0,\"menuName\":\"new 订单管理\",\"orderNum\":3,\"path\":\"order\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"shopping\",\"remark\":\"订单管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:10:32'),(1998274295597748226,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-08-06 15:50:30\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1820729144067321858\",\"parentId\":0,\"menuName\":\"库存统计\",\"orderNum\":10,\"path\":\"inventory\",\"component\":\"wms/inventory/statistic\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventory:all\",\"icon\":\"chart\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:11:33'),(1998274347888136194,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-08-07 14:46:13\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1821075355068559361\",\"parentId\":0,\"menuName\":\"库存记录\",\"orderNum\":11,\"path\":\"inventoryHistory\",\"component\":\"wms/inventory/history\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventoryHistory:all\",\"icon\":\"list\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:11:45'),(1998274415328350209,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2040,\"parentId\":0,\"menuName\":\"库存管理\",\"orderNum\":4,\"path\":\"inventory\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"chart\",\"remark\":\"库存管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:12:01'),(1998274436941598722,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2041,\"parentId\":2040,\"menuName\":\"库存统计\",\"orderNum\":1,\"path\":\"statistic\",\"component\":\"wms/inventory/statistic\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventory:list\",\"icon\":\"chart\",\"remark\":\"库存统计\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:12:07'),(1998274482995056641,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2042,\"parentId\":2040,\"menuName\":\"库存历史\",\"orderNum\":2,\"path\":\"history\",\"component\":\"wms/inventory/history\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventoryHistory:list\",\"icon\":\"log\",\"remark\":\"库存历史\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:12:18'),(1998274512212578305,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2043,\"parentId\":2040,\"menuName\":\"库存查询\",\"orderNum\":3,\"path\":\"query\",\"component\":\"wms/inventory/query/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventory:query\",\"icon\":\"search\",\"remark\":\"库存查询\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:12:25'),(1998274533129572353,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2050,\"parentId\":0,\"menuName\":\"任务管理\",\"orderNum\":5,\"path\":\"task\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"guide\",\"remark\":\"任务管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:12:30'),(1998274552075243522,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2060,\"parentId\":0,\"menuName\":\"PDA管理\",\"orderNum\":6,\"path\":\"pda\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"phone\",\"remark\":\"PDA管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:12:34'),(1998274576322514945,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2070,\"parentId\":0,\"menuName\":\"报表查询\",\"orderNum\":7,\"path\":\"report\",\"component\":\"wms/report/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:report:list\",\"icon\":\"chart\",\"remark\":\"报表查询\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:12:40'),(1998274594911670273,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2080,\"parentId\":0,\"menuName\":\"系统配置\",\"orderNum\":8,\"path\":\"config\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"system\",\"remark\":\"系统配置\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:12:44'),(1998274627631435777,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2051,\"parentId\":2050,\"menuName\":\"AGV任务\",\"orderNum\":1,\"path\":\"agvTask\",\"component\":\"wms/task/agvTask/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:agvTask:list\",\"icon\":\"guide\",\"remark\":\"AGV任务管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:12:52'),(1998274663215910914,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2050,\"parentId\":0,\"menuName\":\"new 任务管理\",\"orderNum\":5,\"path\":\"task\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"guide\",\"remark\":\"任务管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:13:01'),(1998274700343889921,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2040,\"parentId\":0,\"menuName\":\"new 库存管理\",\"orderNum\":4,\"path\":\"inventory\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"chart\",\"remark\":\"库存管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:13:09'),(1998274754936950785,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2060,\"parentId\":0,\"menuName\":\"new PDA管理\",\"orderNum\":6,\"path\":\"pda\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"phone\",\"remark\":\"PDA管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:13:22'),(1998274782137012225,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2061,\"parentId\":2060,\"menuName\":\"PDA操作记录\",\"orderNum\":1,\"path\":\"operation\",\"component\":\"wms/pda/operation/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:pdaOperation:list\",\"icon\":\"list\",\"remark\":\"PDA操作记录\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:13:29'),(1998274798184419329,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2062,\"parentId\":2060,\"menuName\":\"PDA日志\",\"orderNum\":2,\"path\":\"log\",\"component\":\"wms/pda/log/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:pdaLog:list\",\"icon\":\"log\",\"remark\":\"PDA日志\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:13:33'),(1998274836570689537,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2081,\"parentId\":2080,\"menuName\":\"WMS配置\",\"orderNum\":1,\"path\":\"wmsConfig\",\"component\":\"wms/config/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:config:list\",\"icon\":\"edit\",\"remark\":\"WMS配置管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:13:42'),(1998274854748803073,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2082,\"parentId\":2080,\"menuName\":\"数据备份\",\"orderNum\":2,\"path\":\"dataBackup\",\"component\":\"wms/dataBackup/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:backup:list\",\"icon\":\"backup\",\"remark\":\"数据备份管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:13:46'),(1998274882930331650,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2070,\"parentId\":0,\"menuName\":\"new 报表查询\",\"orderNum\":7,\"path\":\"report\",\"component\":\"wms/report/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:report:list\",\"icon\":\"chart\",\"remark\":\"报表查询\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:13:53'),(1998274905923506177,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2080,\"parentId\":0,\"menuName\":\"new 系统配置\",\"orderNum\":8,\"path\":\"config\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"system\",\"remark\":\"系统配置\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:13:58'),(1998275067592953858,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2020,\"parentId\":0,\"menuName\":\"new 条码管理\",\"orderNum\":2,\"path\":\"barcode\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"chart\",\"remark\":\"条码管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:14:37'),(1998275104205033474,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2082,\"parentId\":2080,\"menuName\":\"数据备份\",\"orderNum\":2,\"path\":\"dataBackup\",\"component\":\"wms/dataBackup/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:backup:list\",\"icon\":\"color\",\"remark\":\"数据备份管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:14:46'),(1998275173851451394,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2021,\"parentId\":2020,\"menuName\":\"条码信息\",\"orderNum\":1,\"path\":\"barcode\",\"component\":\"wms/barcode/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:barcode:list\",\"icon\":\"cascader\",\"remark\":\"条码信息管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:15:02'),(1998275200816631809,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2010,\"parentId\":2001,\"menuName\":\"仓库管理\",\"orderNum\":1,\"path\":\"http://warehouse\",\"component\":\"wms/basic/warehouse/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"date\",\"remark\":\"仓库管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:15:09'),(1998278500962127873,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2041,\"parentId\":2040,\"menuName\":\"库存统计\",\"orderNum\":1,\"path\":\"inventory\",\"component\":\"wms/inventory/statistic\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventory:all\",\"icon\":\"chart\",\"remark\":\"库存统计\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 14:28:16'),(1998297052045758465,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2041,\"parentId\":2040,\"menuName\":\"库存统计\",\"orderNum\":1,\"path\":\"/inventory/inventory\",\"component\":\"wms/inventory/statistic\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventory:all\",\"icon\":\"chart\",\"remark\":\"库存统计\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 15:41:58'),(1998297196774412289,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2041,\"parentId\":2040,\"menuName\":\"库存统计\",\"orderNum\":1,\"path\":\"inventory/inventory\",\"component\":\"wms/inventory/statistic\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventory:all\",\"icon\":\"chart\",\"remark\":\"库存统计\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 15:42:33'),(1998298052160770049,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2041,\"parentId\":2040,\"menuName\":\"库存统计\",\"orderNum\":1,\"path\":\"inventory\",\"component\":\"wms/inventory/statistic\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventory:all\",\"icon\":\"chart\",\"remark\":\"库存统计\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 15:45:57'),(1998298247065882626,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2040,\"parentId\":0,\"menuName\":\"new 库存管理\",\"orderNum\":4,\"path\":\"inventory\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"chart\",\"remark\":\"库存管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 15:46:43'),(1998299851601072130,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-08-06 15:50:30\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1820729144067321858\",\"parentId\":0,\"menuName\":\"库存统计\",\"orderNum\":10,\"path\":\"inventory\",\"component\":\"wms/inventory/statistic\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"0\",\"perms\":\"wms:inventory:all\",\"icon\":\"chart\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 15:53:06'),(1998299934627319809,'菜单管理',3,'com.ruoyi.system.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1820729144067321858','0:0:0:0:0:0:0:1','内网IP','{}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 15:53:26'),(1998300175313260545,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2042,\"parentId\":2040,\"menuName\":\"库存历史\",\"orderNum\":2,\"path\":\"history\",\"component\":\"wms/inventory/history\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventoryHistory:all\",\"icon\":\"log\",\"remark\":\"库存历史\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 15:54:23'),(1998300206967672833,'菜单管理',3,'com.ruoyi.system.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1821075355068559361','0:0:0:0:0:0:0:1','内网IP','{}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 15:54:31'),(1998301986124320769,'菜单管理',1,'com.ruoyi.system.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":null,\"parentId\":0,\"menuName\":\"出入库\",\"orderNum\":0,\"path\":\"io\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"icon\":\"chart\",\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:01:35'),(1998302049428951042,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-31 09:58:42\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1818466281474822145\",\"parentId\":\"1998301986061406209\",\"menuName\":\"入库\",\"orderNum\":20,\"path\":\"receiptOrder\",\"component\":\"wms/order/receipt/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:receipt:all\",\"icon\":\"exit-fullscreen\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:01:50'),(1998302084736602114,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-08-01 11:43:04\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1818854933803638785\",\"parentId\":\"1998301986061406209\",\"menuName\":\"出库\",\"orderNum\":30,\"path\":\"shipmentOrder\",\"component\":\"wms/order/shipment/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:shipment:all\",\"icon\":\"fullscreen\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:01:58'),(1998302111072636930,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-08-12 10:19:35\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1822820194307051521\",\"parentId\":\"1998301986061406209\",\"menuName\":\"移库\",\"orderNum\":40,\"path\":\"movementOrder\",\"component\":\"wms/order/movement/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:movement:all\",\"icon\":\"drag\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:02:05'),(1998302138478219265,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-08-13 10:38:08\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1823187248797270018\",\"parentId\":\"1998301986061406209\",\"menuName\":\"盘库\",\"orderNum\":50,\"path\":\"checkOrder\",\"component\":\"wms/order/check/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:check:all\",\"icon\":\"example\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:02:11'),(1998302206971203585,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-09 16:01:35\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1998301986061406209\",\"parentId\":0,\"menuName\":\"new 出入库\",\"orderNum\":0,\"path\":\"io\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"icon\":\"chart\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:02:27'),(1998302589126823937,'菜单管理',3,'com.ruoyi.system.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1813458070128599041','0:0:0:0:0:0:0:1','内网IP','{}','{\"code\":601,\"msg\":\"存在子菜单,不允许删除\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:03:59'),(1998302791179030530,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2010,\"parentId\":2001,\"menuName\":\"仓库管理\",\"orderNum\":1,\"path\":\"warehouse\",\"component\":\"wms/basic/warehouse/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"date\",\"remark\":\"仓库管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:04:47'),(1998303093143752705,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-08-30 10:44:27\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1829349433573822466\",\"parentId\":2010,\"menuName\":\"仓库查询\",\"orderNum\":1,\"path\":\"\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"F\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"#\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:05:59'),(1998303156511297537,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-08-30 10:46:48\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1829350022131142658\",\"parentId\":2010,\"menuName\":\"仓库编辑\",\"orderNum\":2,\"path\":\"\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"F\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:edit\",\"icon\":\"#\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:06:14'),(1998303183409369089,'菜单管理',3,'com.ruoyi.system.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1813458070128599041','0:0:0:0:0:0:0:1','内网IP','{}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:06:20'),(1998303367044386818,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-05 11:58:12\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1809059968309743618\",\"parentId\":2001,\"menuName\":\"old 往来单位\",\"orderNum\":1,\"path\":\"merchant\",\"component\":\"wms/basic/merchant/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:merchant:list\",\"icon\":\"documentation\",\"remark\":\"往来单位菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:07:04'),(1998303413609549825,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-30 11:18:27\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1818123963605549057\",\"parentId\":2001,\"menuName\":\"old 品牌管理\",\"orderNum\":3,\"path\":\"itemBrand\",\"component\":\"wms/basic/itemBrand/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:itemBrand:list\",\"icon\":\"documentation\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:07:15'),(1998303457163202562,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-18 14:16:33\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1813820131794837506\",\"parentId\":2001,\"menuName\":\"old 商品管理\",\"orderNum\":4,\"path\":\"item\",\"component\":\"wms/basic/item/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:item:list\",\"icon\":\"documentation\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:07:26'),(1998303477140672513,'菜单管理',3,'com.ruoyi.system.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1808758090157985794','0:0:0:0:0:0:0:1','内网IP','{}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:07:30'),(1998303715985313794,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-05 11:58:12\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1809059968309743618\",\"parentId\":2001,\"menuName\":\"old 往来单位\",\"orderNum\":9,\"path\":\"merchant\",\"component\":\"wms/basic/merchant/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:merchant:list\",\"icon\":\"documentation\",\"remark\":\"往来单位菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:08:27'),(1998303742329737217,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-18 14:16:33\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1813820131794837506\",\"parentId\":2001,\"menuName\":\"old 商品管理\",\"orderNum\":10,\"path\":\"item\",\"component\":\"wms/basic/item/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:item:list\",\"icon\":\"documentation\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:08:34'),(1998303791059161089,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-30 11:18:27\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1818123963605549057\",\"parentId\":2001,\"menuName\":\"old 品牌管理\",\"orderNum\":11,\"path\":\"itemBrand\",\"component\":\"wms/basic/itemBrand/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:itemBrand:list\",\"icon\":\"documentation\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:08:45'),(1998305720766156801,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-06-13 16:06:26\",\"updateBy\":null,\"updateTime\":null,\"menuId\":100,\"parentId\":2001,\"menuName\":\"用户管理\",\"orderNum\":1,\"path\":\"user\",\"component\":\"system/user/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"system:user:list\",\"icon\":\"user\",\"remark\":\"用户管理菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:16:25'),(1998305762117799937,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-06-13 16:06:26\",\"updateBy\":null,\"updateTime\":null,\"menuId\":101,\"parentId\":2001,\"menuName\":\"角色管理\",\"orderNum\":2,\"path\":\"role\",\"component\":\"system/role/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"system:role:list\",\"icon\":\"peoples\",\"remark\":\"角色管理菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:16:35'),(1998305918330458113,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-06-13 16:06:26\",\"updateBy\":null,\"updateTime\":null,\"menuId\":100,\"parentId\":2001,\"menuName\":\"用户管理\",\"orderNum\":10,\"path\":\"user\",\"component\":\"system/user/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"system:user:list\",\"icon\":\"user\",\"remark\":\"用户管理菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:17:12'),(1998305962114797570,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-06-13 16:06:26\",\"updateBy\":null,\"updateTime\":null,\"menuId\":101,\"parentId\":2001,\"menuName\":\"角色管理\",\"orderNum\":20,\"path\":\"role\",\"component\":\"system/role/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"system:role:list\",\"icon\":\"peoples\",\"remark\":\"角色管理菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:17:23'),(1998306197717241858,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2010,\"parentId\":2001,\"menuName\":\"仓库管理\",\"orderNum\":30,\"path\":\"warehouse\",\"component\":\"wms/basic/warehouse/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"date\",\"remark\":\"仓库管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:18:19'),(1998306223386382337,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2011,\"parentId\":2001,\"menuName\":\"货区管理\",\"orderNum\":40,\"path\":\"area\",\"component\":\"wms/basic/area/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:area:list\",\"icon\":\"tree\",\"remark\":\"货区管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:18:25'),(1998306247834980354,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2012,\"parentId\":2001,\"menuName\":\"货位管理\",\"orderNum\":50,\"path\":\"bin\",\"component\":\"wms/basic/bin/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:bin:list\",\"icon\":\"tree-table\",\"remark\":\"货位管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:18:31'),(1998306271507632129,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2013,\"parentId\":2001,\"menuName\":\"物料类型\",\"orderNum\":60,\"path\":\"materialType\",\"component\":\"wms/basic/materialType/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:materialType:list\",\"icon\":\"list\",\"remark\":\"物料类型管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:18:37'),(1998306294064599042,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2014,\"parentId\":2001,\"menuName\":\"托盘类型\",\"orderNum\":70,\"path\":\"palletType\",\"component\":\"wms/basic/palletType/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:palletType:list\",\"icon\":\"list\",\"remark\":\"托盘类型管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:18:42'),(1998306313920434177,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2015,\"parentId\":2001,\"menuName\":\"托盘管理\",\"orderNum\":80,\"path\":\"pallet\",\"component\":\"wms/basic/pallet/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:pallet:list\",\"icon\":\"table\",\"remark\":\"托盘管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:18:47'),(1998306333914681345,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2016,\"parentId\":2001,\"menuName\":\"阀门管理\",\"orderNum\":90,\"path\":\"valve\",\"component\":\"wms/basic/valve/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:valve:list\",\"icon\":\"component\",\"remark\":\"阀门管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:18:51'),(1998306361076994050,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2017,\"parentId\":2001,\"menuName\":\"库管员管理\",\"orderNum\":100,\"path\":\"warehouseKeeper\",\"component\":\"wms/basic/warehouseKeeper/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouseKeeper:list\",\"icon\":\"user\",\"remark\":\"库管员管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:18:58'),(1998306466920255490,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-05 11:58:12\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1809059968309743618\",\"parentId\":2001,\"menuName\":\"old 往来单位\",\"orderNum\":1000,\"path\":\"merchant\",\"component\":\"wms/basic/merchant/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:merchant:list\",\"icon\":\"documentation\",\"remark\":\"往来单位菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:19:23'),(1998306494296477698,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-18 14:16:33\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1813820131794837506\",\"parentId\":2001,\"menuName\":\"old 商品管理\",\"orderNum\":1001,\"path\":\"item\",\"component\":\"wms/basic/item/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:item:list\",\"icon\":\"documentation\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:19:30'),(1998306519659433985,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-07-30 11:18:27\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1818123963605549057\",\"parentId\":2001,\"menuName\":\"old 品牌管理\",\"orderNum\":1002,\"path\":\"itemBrand\",\"component\":\"wms/basic/itemBrand/index\",\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:itemBrand:list\",\"icon\":\"documentation\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:19:36'),(1998306763998613506,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-09 16:01:35\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1998301986061406209\",\"parentId\":0,\"menuName\":\"new 出入库\",\"orderNum\":10,\"path\":\"io\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"icon\":\"chart\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:20:34'),(1998306905610899458,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2010,\"parentId\":0,\"menuName\":\"仓库管理\",\"orderNum\":20,\"path\":\"warehouse\",\"component\":\"wms/basic/warehouse/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"date\",\"remark\":\"仓库管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:21:08'),(1998307061219577857,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2012,\"parentId\":2010,\"menuName\":\"货位管理\",\"orderNum\":50,\"path\":\"bin\",\"component\":\"wms/basic/bin/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:bin:list\",\"icon\":\"tree-table\",\"remark\":\"货位管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:21:45'),(1998307118702514177,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2011,\"parentId\":2010,\"menuName\":\"货区管理\",\"orderNum\":40,\"path\":\"area\",\"component\":\"wms/basic/area/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:area:list\",\"icon\":\"tree\",\"remark\":\"货区管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:21:59'),(1998308270168985602,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2030,\"parentId\":0,\"menuName\":\"new 订单管理\",\"orderNum\":20,\"path\":\"order\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"shopping\",\"remark\":\"订单管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:26:33'),(1998308317057110018,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2010,\"parentId\":0,\"menuName\":\"new 仓库管理\",\"orderNum\":20,\"path\":\"warehouse\",\"component\":\"wms/basic/warehouse/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"date\",\"remark\":\"仓库管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:26:44'),(1998308368970010626,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2030,\"parentId\":0,\"menuName\":\"new 订单管理\",\"orderNum\":30,\"path\":\"order\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"shopping\",\"remark\":\"订单管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:26:57'),(1998308440566779905,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2040,\"parentId\":0,\"menuName\":\"new 库存管理\",\"orderNum\":40,\"path\":\"inventory\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"chart\",\"remark\":\"库存管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:27:14'),(1998308639884300290,'菜单管理',1,'com.ruoyi.system.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":null,\"parentId\":0,\"menuName\":\"new 托盘及物料管理\",\"orderNum\":50,\"path\":\"dd\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"icon\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:28:01'),(1998308700286472194,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2020,\"parentId\":0,\"menuName\":\"new 条码管理\",\"orderNum\":60,\"path\":\"barcode\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"chart\",\"remark\":\"条码管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:28:16'),(1998308844260151298,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2051,\"parentId\":2060,\"menuName\":\"AGV任务\",\"orderNum\":1,\"path\":\"agvTask\",\"component\":\"wms/task/agvTask/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:agvTask:list\",\"icon\":\"guide\",\"remark\":\"AGV任务管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:28:50'),(1998308924916617218,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2051,\"parentId\":2050,\"menuName\":\"AGV任务\",\"orderNum\":1,\"path\":\"agvTask\",\"component\":\"wms/task/agvTask/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:agvTask:list\",\"icon\":\"guide\",\"remark\":\"AGV任务管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:29:09'),(1998309012837617665,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2070,\"parentId\":0,\"menuName\":\"new 报表查询\",\"orderNum\":70,\"path\":\"report\",\"component\":\"wms/report/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:report:list\",\"icon\":\"chart\",\"remark\":\"报表查询\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:29:30'),(1998309051047727106,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2050,\"parentId\":0,\"menuName\":\"new 任务管理\",\"orderNum\":80,\"path\":\"task\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:inventory:all\",\"icon\":\"guide\",\"remark\":\"任务管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:29:39'),(1998309101123522561,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2060,\"parentId\":0,\"menuName\":\"new PDA管理\",\"orderNum\":80,\"path\":\"pda\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"phone\",\"remark\":\"PDA管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:29:51'),(1998311754733834241,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2060,\"parentId\":0,\"menuName\":\"new PDA管理\",\"orderNum\":90,\"path\":\"pda\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"phone\",\"remark\":\"PDA管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:40:24'),(1998311833880350722,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2080,\"parentId\":0,\"menuName\":\"new 系统配置\",\"orderNum\":100,\"path\":\"config\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"system\",\"remark\":\"系统配置\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:40:43'),(1998311853438390273,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2001,\"parentId\":0,\"menuName\":\"new 基础数据\",\"orderNum\":110,\"path\":\"basic\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"dict\",\"remark\":\"基础数据管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:40:47'),(1998311989623246849,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-09 16:28:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1998308639817191425\",\"parentId\":0,\"menuName\":\"new 托盘及物料管理\",\"orderNum\":50,\"path\":\"dd\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"icon\":\"dashboard\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:41:20'),(1998312377931911169,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-06-13 16:06:26\",\"updateBy\":null,\"updateTime\":null,\"menuId\":1,\"parentId\":0,\"menuName\":\"系统管理\",\"orderNum\":130,\"path\":\"system\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"system\",\"remark\":\"系统管理目录\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:42:52'),(1998312679426871297,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2031,\"parentId\":2030,\"menuName\":\"入库单\",\"orderNum\":1,\"path\":\"receipt\",\"component\":\"wms/order/receipt/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:receipt:list\",\"icon\":\"upload\",\"remark\":\"入库单管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:44:04'),(1998312702369714177,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2032,\"parentId\":2030,\"menuName\":\"出库单\",\"orderNum\":2,\"path\":\"shipment\",\"component\":\"wms/order/shipment/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:shipment:list\",\"icon\":\"download\",\"remark\":\"出库单管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:44:10'),(1998312718786220033,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2033,\"parentId\":2030,\"menuName\":\"移库单\",\"orderNum\":3,\"path\":\"movement\",\"component\":\"wms/order/movement/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:movement:list\",\"icon\":\"drag\",\"remark\":\"移库单管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:44:14'),(1998312737304072194,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2034,\"parentId\":2030,\"menuName\":\"盘点单\",\"orderNum\":4,\"path\":\"check\",\"component\":\"wms/order/check/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:check:list\",\"icon\":\"edit\",\"remark\":\"盘点单管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:44:18'),(1998312771017887746,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2010,\"parentId\":0,\"menuName\":\"new 仓库管理\",\"orderNum\":20,\"path\":\"warehouse\",\"component\":\"wms/basic/warehouse/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"date\",\"remark\":\"仓库管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:44:26'),(1998312916614762498,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2013,\"parentId\":\"1998308639817191425\",\"menuName\":\"物料类型\",\"orderNum\":60,\"path\":\"materialType\",\"component\":\"wms/basic/materialType/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:materialType:list\",\"icon\":\"list\",\"remark\":\"物料类型管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:45:01'),(1998313040086683650,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2014,\"parentId\":\"1998308639817191425\",\"menuName\":\"托盘类型\",\"orderNum\":70,\"path\":\"palletType\",\"component\":\"wms/basic/palletType/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:palletType:list\",\"icon\":\"list\",\"remark\":\"托盘类型管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:45:30'),(1998313255984287745,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2015,\"parentId\":\"1998308639817191425\",\"menuName\":\"托盘管理\",\"orderNum\":80,\"path\":\"pallet\",\"component\":\"wms/basic/pallet/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:pallet:list\",\"icon\":\"table\",\"remark\":\"托盘管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:46:22'),(1998316363049193473,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2010,\"parentId\":0,\"menuName\":\"仓库管理\",\"orderNum\":20,\"path\":\"warehouse\",\"component\":\"wms/basic/warehouse/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"date\",\"remark\":\"仓库管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 16:58:43'),(1998317351755698177,'菜单管理',1,'com.ruoyi.system.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":null,\"parentId\":0,\"menuName\":\"new 仓库管理\",\"orderNum\":20,\"path\":\"wh\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"icon\":\"drag\",\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:02:38'),(1998317431657189377,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2010,\"parentId\":\"1998317351596314625\",\"menuName\":\"仓库管理\",\"orderNum\":20,\"path\":\"warehouse\",\"component\":\"wms/basic/warehouse/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:warehouse:list\",\"icon\":\"date\",\"remark\":\"仓库管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:02:57'),(1998317476305555458,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2011,\"parentId\":\"1998317351596314625\",\"menuName\":\"货区管理\",\"orderNum\":40,\"path\":\"area\",\"component\":\"wms/basic/area/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:area:list\",\"icon\":\"tree\",\"remark\":\"货区管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:03:08'),(1998317529724211202,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2012,\"parentId\":\"1998317351596314625\",\"menuName\":\"货位管理\",\"orderNum\":50,\"path\":\"bin\",\"component\":\"wms/basic/bin/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:bin:list\",\"icon\":\"tree-table\",\"remark\":\"货位管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:03:21'),(1998317636171452418,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-09 17:02:38\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"1998317351596314625\",\"parentId\":0,\"menuName\":\"new 仓库管理\",\"orderNum\":20,\"path\":\"warehouse\",\"component\":null,\"queryParam\":null,\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"icon\":\"drag\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:03:46'),(1998318763331932161,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2070,\"parentId\":0,\"menuName\":\"new 报表查询\",\"orderNum\":70,\"path\":\"report\",\"component\":\"wms/report/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:report:list\",\"icon\":\"chart\",\"remark\":\"报表查询\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:08:15'),(1998322323524276225,'托盘类型',1,'com.ruoyi.wms.controller.PalletTypeController.add()','POST',1,'admin','研发部门','/wms/palletType','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":null,\"typeCode\":\" 外网\",\"typeName\":\"外网\",\"fixedQuantity\":null,\"length\":null,\"width\":null,\"height\":null,\"loadCapacity\":null,\"agvVehicleType\":null,\"status\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:22:24'),(1998322446094422018,'托盘类型',2,'com.ruoyi.wms.controller.PalletTypeController.edit()','PUT',1,'admin','研发部门','/wms/palletType','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-12-09 17:22:23\",\"updateBy\":\"admin\",\"updateTime\":\"2025-12-09 17:22:23\",\"id\":\"1998322323461361665\",\"typeCode\":\"111\",\"typeName\":\"外网\",\"fixedQuantity\":null,\"length\":null,\"width\":null,\"height\":null,\"loadCapacity\":null,\"agvVehicleType\":null,\"status\":\"0\",\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:22:53'),(1998322602474852353,'托盘类型',2,'com.ruoyi.wms.controller.PalletTypeController.edit()','PUT',1,'admin','研发部门','/wms/palletType','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-12-09 17:22:23\",\"updateBy\":\"admin\",\"updateTime\":\"2025-12-09 17:22:52\",\"id\":\"1998322323461361665\",\"typeCode\":\"11\",\"typeName\":\"外网\",\"fixedQuantity\":null,\"length\":null,\"width\":null,\"height\":null,\"loadCapacity\":null,\"agvVehicleType\":null,\"status\":\"0\",\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:23:30'),(1998326228857446401,'用户管理',3,'com.ruoyi.system.controller.system.SysUserController.remove()','DELETE',1,'admin','研发部门','/system/user/1829105396288688129','0:0:0:0:0:0:0:1','内网IP','{}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 17:37:55'),(1998343541199527937,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2062,\"parentId\":2060,\"menuName\":\"PDA日志\",\"orderNum\":2,\"path\":\"log\",\"component\":\"wms/pda/log\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:pdaLog:list\",\"icon\":\"log\",\"remark\":\"PDA日志\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 18:46:42'),(1998343746871418882,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2062,\"parentId\":2060,\"menuName\":\"PDA日志\",\"orderNum\":2,\"path\":\"log\",\"component\":\"wms/pda/log/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:pdaLog:list\",\"icon\":\"log\",\"remark\":\"PDA日志\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 18:47:31'),(1998343784041340930,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2062,\"parentId\":2060,\"menuName\":\"PDA日志\",\"orderNum\":2,\"path\":\"log\",\"component\":\"wms/pda/log/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:pdaLog:list\",\"icon\":\"log\",\"remark\":\"PDA日志\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 18:47:40'),(1998343975028973570,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-06-13 16:06:27\",\"updateBy\":null,\"updateTime\":null,\"menuId\":108,\"parentId\":0,\"menuName\":\"日志管理\",\"orderNum\":140,\"path\":\"log1\",\"component\":\"\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"log\",\"remark\":\"日志管理菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 18:48:26'),(1998344065072291842,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2024-06-13 16:06:27\",\"updateBy\":null,\"updateTime\":null,\"menuId\":108,\"parentId\":0,\"menuName\":\"日志管理\",\"orderNum\":140,\"path\":\"log\",\"component\":\"\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"log\",\"remark\":\"日志管理菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 18:48:47'),(1998344158726905858,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2062,\"parentId\":2060,\"menuName\":\"PDA日志\",\"orderNum\":2,\"path\":\"pda-log\",\"component\":\"wms/pda/log/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:pdaLog:list\",\"icon\":\"log\",\"remark\":\"PDA日志\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 18:49:10'),(1998344664895512578,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2081,\"parentId\":2080,\"menuName\":\"WMS配置\",\"orderNum\":1,\"path\":\"wms-config\",\"component\":\"wms/config/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:config:list\",\"icon\":\"edit\",\"remark\":\"WMS配置管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 18:51:10'),(1998344971020984321,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2082,\"parentId\":2080,\"menuName\":\"数据备份\",\"orderNum\":2,\"path\":\"data-backup\",\"component\":\"wms/dataBackup/index\",\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"wms:backup:list\",\"icon\":\"color\",\"remark\":\"数据备份管理\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 18:52:23'),(1998345880975237121,'菜单管理',2,'com.ruoyi.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createBy\":null,\"createTime\":\"2025-12-05 10:54:01\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2080,\"parentId\":0,\"menuName\":\"new 系统配置\",\"orderNum\":100,\"path\":\"wms-config\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"system\",\"remark\":\"系统配置\"}','{\"code\":200,\"msg\":\"操作成功\",\"detailMessage\":null,\"data\":null}',1,'','2025-12-09 18:56:00');
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oss`
--

DROP TABLE IF EXISTS `sys_oss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oss` (
  `oss_id` bigint NOT NULL COMMENT '对象存储主键',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件名',
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '原名',
  `file_suffix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件后缀名',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'URL地址',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '上传人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新人',
  `service` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'minio' COMMENT '服务商',
  PRIMARY KEY (`oss_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='OSS对象存储表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oss`
--

LOCK TABLES `sys_oss` WRITE;
/*!40000 ALTER TABLE `sys_oss` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_oss` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oss_config`
--

DROP TABLE IF EXISTS `sys_oss_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oss_config` (
  `oss_config_id` bigint NOT NULL COMMENT '主建',
  `config_key` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配置key',
  `access_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'accessKey',
  `secret_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '秘钥',
  `bucket_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '桶名称',
  `prefix` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '前缀',
  `endpoint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '访问站点',
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '自定义域名',
  `is_https` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '是否https（Y=是,N=否）',
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '域',
  `access_policy` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '桶权限类型(0=private 1=public 2=custom)',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '是否默认（0=是,1=否）',
  `ext1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '扩展字段',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`oss_config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='对象存储配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oss_config`
--

LOCK TABLES `sys_oss_config` WRITE;
/*!40000 ALTER TABLE `sys_oss_config` DISABLE KEYS */;
INSERT INTO `sys_oss_config` VALUES (1,'minio','ruoyi','ruoyi123','ruoyi','','127.0.0.1:9000','','N','','1','0','','admin','2024-06-13 16:06:38','admin','2024-08-16 16:48:05',NULL),(2,'qiniu','XXXXXXXXXXXXXXX','XXXXXXXXXXXXXXX','ruoyi','','s3-cn-north-1.qiniucs.com','','N','','1','0','','admin','2024-06-13 16:06:38','admin','2024-06-13 16:06:38',NULL),(3,'aliyun','XXXXXXXXXXXXXXX','XXXXXXXXXXXXXXX','ruoyi','','oss-cn-beijing.aliyuncs.com','','N','','1','0','','admin','2024-06-13 16:06:38','admin','2024-07-10 17:50:41',NULL),(4,'qcloud','XXXXXXXXXXXXXXX','XXXXXXXXXXXXXXX','ruoyi-1250000000','','cos.ap-beijing.myqcloud.com','','N','ap-beijing','1','0','','admin','2024-06-13 16:06:38','admin','2024-06-13 16:06:38',NULL),(5,'image','ruoyi','ruoyi123','ruoyi','image','127.0.0.1:9000','','N','','1','0','','admin','2024-06-13 16:06:38','admin','2024-06-13 16:06:38',NULL);
/*!40000 ALTER TABLE `sys_oss_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'1','admin','2024-06-13 16:06:25','',NULL,''),(2,'se','项目经理',2,'1','admin','2024-06-13 16:06:25','',NULL,''),(3,'hr','人力资源',3,'1','admin','2024-06-13 16:06:25','',NULL,''),(4,'user','普通员工',4,'1','admin','2024-06-13 16:06:25','',NULL,''),(1811656351757385729,'caiwu8989','财务',5,'1','admin','2024-07-12 22:58:28','admin','2024-07-12 14:58:38',NULL);
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'1','0','admin','2024-06-13 16:06:26','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',1,1,'1','1','admin','2024-06-13 16:06:26','admin','2024-07-10 17:13:05','普通角色'),(1811607750859661314,'测试角色1','test1',2,'1',1,1,'1','1','admin','2024-07-12 11:45:21','admin','2024-07-12 11:45:21',NULL),(1811629311809396737,'测试角色2','test2',3,'1',1,1,'1','1','admin','2024-07-12 13:11:01','admin','2024-07-12 13:11:01',NULL),(1829105952432427010,'试用','trier',0,'1',1,1,'1','1','admin','2024-08-29 18:36:57','admin','2024-09-11 16:32:53',NULL),(1998240155494109186,'库管员','kadmin',1,'1',1,1,'1','0','admin','2025-12-09 11:55:53','admin','2025-12-09 11:55:53',NULL);
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'sys_user' COMMENT '用户类型（sys_user系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','程序员诚哥','sys_user','zccbbg@qq.com','18888888888','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','1','0','0:0:0:0:0:0:0:1','2025-12-09 18:54:11','admin','2024-06-13 16:06:25','admin','2025-12-09 18:54:11','管理员'),(1829105396288688129,105,'ck','ck','sys_user','','','0','','$2a$10$5ogFpqit10a8IpVFjKzosuz0whR0/tyQ4Nt9e6y3/MBodcDzwhCni','1','1','221.224.86.138','2024-10-09 15:40:16','admin','2024-08-29 18:34:44','ck','2024-10-09 15:40:16',NULL);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_agv_task`
--

DROP TABLE IF EXISTS `wms_agv_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_agv_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务编号（outID，由WMS生成）',
  `task_type` int NOT NULL COMMENT '任务类型（1:入库任务 2:送检任务 3:回库任务 4:出库任务）',
  `biz_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联业务单号（入库单号、出库单号等）',
  `biz_order_id` bigint DEFAULT NULL COMMENT '关联业务单ID',
  `pallet_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '托盘编号',
  `pallet_id` bigint DEFAULT NULL COMMENT '托盘ID',
  `from_bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '起始货位编号',
  `from_bin_id` bigint DEFAULT NULL COMMENT '起始货位ID',
  `to_bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目标货位编号',
  `to_bin_id` bigint DEFAULT NULL COMMENT '目标货位ID',
  `agv_task_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AGV调度系统返回的任务ID',
  `status` int DEFAULT '0' COMMENT '任务状态（0:PENDING待处理 1:EXECUTING执行中 2:FINISHED已完成 3:FAILED失败 4:CANCELLED已取消）',
  `agv_device_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AGV设备编号',
  `dispatch_time` datetime DEFAULT NULL COMMENT '下发时间',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误信息',
  `agv_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'AGV返回的详细信息',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_task_no` (`task_no`) USING BTREE,
  KEY `idx_task_type` (`task_type`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_biz_order_no` (`biz_order_no`) USING BTREE,
  KEY `idx_agv_task_id` (`agv_task_id`) USING BTREE,
  KEY `idx_pallet_code` (`pallet_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='AGV任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_agv_task`
--

LOCK TABLES `wms_agv_task` WRITE;
/*!40000 ALTER TABLE `wms_agv_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_agv_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_area`
--

DROP TABLE IF EXISTS `wms_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_area` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '货区编号',
  `area_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '货区名称',
  `warehouse_id` bigint NOT NULL COMMENT '所属仓库ID',
  `area_type` int DEFAULT '1' COMMENT '货区类型（1:普通货区 2:置换区 3:其他）',
  `order_num` bigint DEFAULT '0' COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_warehouse_id` (`warehouse_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='货区表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_area`
--

LOCK TABLES `wms_area` WRITE;
/*!40000 ALTER TABLE `wms_area` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_barcode`
--

DROP TABLE IF EXISTS `wms_barcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_barcode` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `barcode` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '条码编号',
  `barcode_type` int NOT NULL COMMENT '条码类型（1:托盘二维码 2:阀门二维码/条码 3:库位条码）',
  `object_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联对象类型（pallet/valve/bin）',
  `object_id` bigint DEFAULT NULL COMMENT '关联对象ID',
  `object_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联对象编号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_barcode` (`barcode`) USING BTREE,
  KEY `idx_barcode_type` (`barcode_type`) USING BTREE,
  KEY `idx_object_type` (`object_type`,`object_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='条码信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_barcode`
--

LOCK TABLES `wms_barcode` WRITE;
/*!40000 ALTER TABLE `wms_barcode` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_barcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_bin`
--

DROP TABLE IF EXISTS `wms_bin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_bin` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '货位编号（binCode）',
  `bin_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '货位名称',
  `warehouse_id` bigint NOT NULL COMMENT '所属仓库ID',
  `area_id` bigint DEFAULT NULL COMMENT '所属货区ID',
  `bin_type` int DEFAULT '1' COMMENT '货位类型（1:普通货位 2:暂存位 3:其他）',
  `temperature_zone` int DEFAULT '1' COMMENT '温区（1:常温 2:冷藏 3:冷冻 4:其他）',
  `capacity` decimal(10,2) DEFAULT NULL COMMENT '容量（单位：立方米或托盘数）',
  `used_capacity` decimal(10,2) DEFAULT '0.00' COMMENT '当前占用容量',
  `status` int DEFAULT '0' COMMENT '状态（0:空闲 1:占用 2:禁用 3:锁定-任务中）',
  `order_num` bigint DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_bin_code` (`bin_code`) USING BTREE,
  KEY `idx_warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `idx_area_id` (`area_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='货位表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_bin`
--

LOCK TABLES `wms_bin` WRITE;
/*!40000 ALTER TABLE `wms_bin` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_bin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_check_order`
--

DROP TABLE IF EXISTS `wms_check_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_check_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '盘点单号',
  `order_status` tinyint DEFAULT '11' COMMENT '库存盘点单状态 -1：作废 0：未盘库 1：已盘库',
  `total_quantity` decimal(20,2) DEFAULT NULL COMMENT '盈亏数',
  `total_amount` decimal(10,2) DEFAULT NULL,
  `warehouse_id` bigint DEFAULT NULL COMMENT '所属仓库',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920323943682050 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='库存盘点单据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_check_order`
--

LOCK TABLES `wms_check_order` WRITE;
/*!40000 ALTER TABLE `wms_check_order` DISABLE KEYS */;
INSERT INTO `wms_check_order` VALUES (1843920323943682049,'PK10091586',1,2.00,NULL,1828364740028174337,NULL,'ck','2024-10-09 15:43:58.273','ck','2024-10-09 15:43:58.273');
/*!40000 ALTER TABLE `wms_check_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_check_order_detail`
--

DROP TABLE IF EXISTS `wms_check_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_check_order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL COMMENT '盘点单id',
  `sku_id` bigint NOT NULL COMMENT '规格id',
  `quantity` decimal(20,2) DEFAULT NULL COMMENT '库存数量',
  `amount` decimal(10,2) DEFAULT NULL COMMENT '金额',
  `check_quantity` decimal(20,2) DEFAULT NULL COMMENT '盘点数量',
  `warehouse_id` bigint DEFAULT NULL COMMENT '所属仓库',
  `inventory_id` bigint DEFAULT NULL COMMENT '库存id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920323981430788 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='库存盘点单据详情';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_check_order_detail`
--

LOCK TABLES `wms_check_order_detail` WRITE;
/*!40000 ALTER TABLE `wms_check_order_detail` DISABLE KEYS */;
INSERT INTO `wms_check_order_detail` VALUES (1843920323981430786,1843920323943682049,1840282974696374273,0.00,NULL,1.00,1828364740028174337,NULL,NULL,'ck','2024-10-09 15:43:58.283','ck','2024-10-09 15:43:58.283'),(1843920323981430787,1843920323943682049,1840282974629265410,0.00,NULL,1.00,1828364740028174337,NULL,NULL,'ck','2024-10-09 15:43:58.287','ck','2024-10-09 15:43:58.287');
/*!40000 ALTER TABLE `wms_check_order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_config`
--

DROP TABLE IF EXISTS `wms_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置值',
  `config_type` int NOT NULL COMMENT '配置类型（1:业务参数 2:规则配置 3:系统配置 4:PDA配置 5:AGV配置）',
  `config_group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置分组（warehouse/pda/agv/system等）',
  `config_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置描述',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_config_key` (`config_key`) USING BTREE,
  KEY `idx_config_type` (`config_type`) USING BTREE,
  KEY `idx_config_group` (`config_group`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='WMS系统配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_config`
--

LOCK TABLES `wms_config` WRITE;
/*!40000 ALTER TABLE `wms_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_data_backup`
--

DROP TABLE IF EXISTS `wms_data_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_data_backup` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `backup_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备份编号',
  `backup_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备份名称',
  `backup_type` int DEFAULT NULL COMMENT '备份类型（1:全量备份 2:增量备份 3:指定表备份）',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备份文件路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小（MB）',
  `backup_time` datetime(3) DEFAULT NULL COMMENT '备份时间',
  `status` int DEFAULT NULL COMMENT '备份状态（0:进行中 1:成功 2:失败）',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误信息',
  `is_auto` int DEFAULT '0' COMMENT '是否自动备份（0:否 1:是）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_backup_no` (`backup_no`) USING BTREE,
  KEY `idx_backup_type` (`backup_type`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_backup_time` (`backup_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='数据备份表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_data_backup`
--

LOCK TABLES `wms_data_backup` WRITE;
/*!40000 ALTER TABLE `wms_data_backup` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_data_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_inventory`
--

DROP TABLE IF EXISTS `wms_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sku_id` bigint DEFAULT NULL COMMENT '规格ID',
  `warehouse_id` bigint DEFAULT NULL COMMENT '所属仓库',
  `quantity` decimal(20,2) DEFAULT NULL COMMENT '库存',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920324082094083 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='库存表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_inventory`
--

LOCK TABLES `wms_inventory` WRITE;
/*!40000 ALTER TABLE `wms_inventory` DISABLE KEYS */;
INSERT INTO `wms_inventory` VALUES (1843920012193648642,1840282974696374273,1828364609002311682,3.00,NULL,'ck','2024-10-09 15:42:43.944','ck','2024-10-09 15:43:42.419'),(1843920012193648643,1840282974629265410,1828364609002311682,3.00,NULL,'ck','2024-10-09 15:42:43.945','ck','2024-10-09 15:43:12.844'),(1843920257526878210,1840282974696374273,1840317750635581441,1.00,NULL,'ck','2024-10-09 15:43:42.434','ck','2024-10-09 15:43:42.434'),(1843920324082094081,1840282974696374273,1828364740028174337,1.00,NULL,'ck','2024-10-09 15:43:58.304','ck','2024-10-09 15:43:58.304'),(1843920324082094082,1840282974629265410,1828364740028174337,1.00,NULL,'ck','2024-10-09 15:43:58.306','ck','2024-10-09 15:43:58.306');
/*!40000 ALTER TABLE `wms_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_inventory_history`
--

DROP TABLE IF EXISTS `wms_inventory_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_inventory_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `warehouse_id` bigint DEFAULT NULL COMMENT '所属仓库',
  `sku_id` bigint DEFAULT NULL COMMENT '物料ID',
  `quantity` decimal(20,2) DEFAULT NULL COMMENT '库存变化',
  `before_quantity` decimal(20,2) DEFAULT NULL COMMENT '更新前数量',
  `after_quantity` decimal(20,2) DEFAULT NULL COMMENT '更新后数量',
  `amount` decimal(10,2) DEFAULT NULL COMMENT '金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `order_id` bigint DEFAULT NULL COMMENT '操作id（出库、入库、库存移动表单id）',
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作单号（入库、出库、移库、盘库单号）',
  `order_type` int DEFAULT NULL COMMENT '操作类型',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920324157591555 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='库存记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_inventory_history`
--

LOCK TABLES `wms_inventory_history` WRITE;
/*!40000 ALTER TABLE `wms_inventory_history` DISABLE KEYS */;
INSERT INTO `wms_inventory_history` VALUES (1843920012248174593,1828364609002311682,1840282974696374273,4.00,0.00,4.00,4000.00,NULL,1843920012030070785,'RK10098845',1,'2024-10-09 15:42:43.958'),(1843920012248174594,1828364609002311682,1840282974629265410,4.00,0.00,4.00,4000.00,NULL,1843920012030070785,'RK10098845',1,'2024-10-09 15:42:43.960'),(1843920133446782977,1828364609002311682,1840282974629265410,-1.00,4.00,3.00,NULL,NULL,1843920133316759553,'CK10094547',2,'2024-10-09 15:43:12.851'),(1843920257560432641,1828364609002311682,1840282974696374273,-1.00,4.00,3.00,NULL,NULL,1843920257199722498,'YK10096786',3,'2024-10-09 15:43:42.442'),(1843920257581404162,1840317750635581441,1840282974696374273,1.00,0.00,1.00,NULL,NULL,1843920257199722498,'YK10096786',3,'2024-10-09 15:43:42.448'),(1843920324149202945,1828364740028174337,1840282974696374273,1.00,0.00,1.00,NULL,NULL,NULL,'PK10091586',4,'2024-10-09 15:43:58.318'),(1843920324157591554,1828364740028174337,1840282974629265410,1.00,0.00,1.00,NULL,NULL,NULL,'PK10091586',4,'2024-10-09 15:43:58.320');
/*!40000 ALTER TABLE `wms_inventory_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_item`
--

DROP TABLE IF EXISTS `wms_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `item_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编号',
  `item_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `item_category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '单位类别',
  `item_brand` bigint DEFAULT NULL COMMENT '品牌',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1840308261127651331 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='物料';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_item`
--

LOCK TABLES `wms_item` WRITE;
/*!40000 ALTER TABLE `wms_item` DISABLE KEYS */;
INSERT INTO `wms_item` VALUES (1828402622516334594,NULL,'华为 nova flip','1828364988754595841',NULL,1828364927610032129,NULL,'admin','2024-08-27 20:02:09.948','admin','2024-09-02 21:45:27.127'),(1828406450112335874,NULL,'macbook','1828365043024695297',NULL,1828364873889386498,NULL,'admin','2024-08-27 20:17:22.521','admin','2024-08-27 20:17:22.521'),(1828407870173646849,NULL,'爱普生打印机','1828365014901886978',NULL,NULL,NULL,'admin','2024-08-27 20:23:01.096','admin','2024-08-27 20:23:01.096'),(1828408320146968578,NULL,'小米米家436L十字四门风冷无霜嵌入式家用冰箱','1828405773474631681',NULL,1828364846953566209,NULL,'admin','2024-08-27 20:24:48.375','admin','2024-08-27 20:24:48.375'),(1828408795734904833,NULL,'杠铃','1828408600515219457',NULL,NULL,NULL,'admin','2024-08-27 20:26:41.757','admin','2024-08-27 20:33:27.034'),(1829398192563351554,NULL,'舟山带鱼','1829398007993004034',NULL,NULL,NULL,'admin','2024-08-30 13:58:12.354','admin','2024-08-30 14:01:08.050'),(1829398333580046338,NULL,'青岛大虾','1829398007993004034',NULL,NULL,NULL,'admin','2024-08-30 13:58:45.971','admin','2024-08-30 14:00:49.686'),(1829398492388978689,NULL,'启东黄鱼','1829398007993004034',NULL,NULL,NULL,'admin','2024-08-30 13:59:23.834','admin','2024-08-30 14:00:32.373'),(1829398701680553985,NULL,'红富士苹果','1829397958923841538',NULL,NULL,NULL,'admin','2024-08-30 14:00:13.735','admin','2024-08-30 14:00:13.735'),(1829399118040723457,NULL,'树山梨','1829397958923841538',NULL,NULL,NULL,'admin','2024-08-30 14:01:52.989','admin','2024-08-30 14:01:52.989'),(1840282974297915394,NULL,'小米空调','1840282771834667010',NULL,1828364846953566209,NULL,'wms2_admin','2024-09-29 14:50:26.535','wms2_admin','2024-09-29 14:50:26.535');
/*!40000 ALTER TABLE `wms_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_item_brand`
--

DROP TABLE IF EXISTS `wms_item_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_item_brand` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '品牌名称',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建者',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime(3) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1828407291103842307 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='商品品牌表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_item_brand`
--

LOCK TABLES `wms_item_brand` WRITE;
/*!40000 ALTER TABLE `wms_item_brand` DISABLE KEYS */;
INSERT INTO `wms_item_brand` VALUES (1828364846953566209,'小米','admin','2024-08-27 17:32:03.551','admin','2024-08-27 17:32:03.551'),(1828364873889386498,'苹果','admin','2024-08-27 17:32:09.971','admin','2024-08-27 17:32:09.971'),(1828364927610032129,'华为','admin','2024-08-27 17:32:22.786','admin','2024-08-27 17:32:22.786'),(1828407151135723522,'爱普生','admin','2024-08-27 20:20:09.656','admin','2024-08-27 20:20:09.656'),(1828407291103842306,'惠普','admin','2024-08-27 20:20:43.031','admin','2024-08-27 20:20:43.031');
/*!40000 ALTER TABLE `wms_item_brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_item_category`
--

DROP TABLE IF EXISTS `wms_item_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_item_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '物料类型id',
  `parent_id` bigint DEFAULT '0' COMMENT '父物料类型id',
  `category_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '物料类型名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '物料类型状态（0停用 1正常）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建者',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime(3) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1840282771834667011 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='物料类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_item_category`
--

LOCK TABLES `wms_item_category` WRITE;
/*!40000 ALTER TABLE `wms_item_category` DISABLE KEYS */;
INSERT INTO `wms_item_category` VALUES (1828364988754595841,0,'手机',0,'1','admin','2024-08-27 17:32:37.357','admin','2024-08-27 20:14:12.100'),(1828365014901886978,0,'打印机',1,'1','admin','2024-08-27 17:32:43.598','admin','2024-08-27 20:14:12.447'),(1828365043024695297,0,'电脑',3,'1','admin','2024-08-27 17:32:50.301','admin','2024-08-27 20:14:12.704'),(1828405743737016322,0,'家电',4,'1','admin','2024-08-27 20:14:34.104','admin','2024-08-27 20:14:34.104'),(1828405773474631681,1828405743737016322,'冰箱',0,'1','admin','2024-08-27 20:14:41.195','admin','2024-08-27 20:14:41.195'),(1828405825714688001,1828405743737016322,'电视',1,'1','admin','2024-08-27 20:14:53.651','admin','2024-08-27 20:14:53.651'),(1828408600515219457,0,'健生器材',5,'1','admin','2024-08-27 20:25:55.213','admin','2024-08-27 20:25:55.213'),(1829397860466749441,0,'生鲜',6,'1','admin','2024-08-30 13:56:53.174','admin','2024-08-30 13:56:53.174'),(1829397958923841538,1829397860466749441,'水果',0,'1','admin','2024-08-30 13:57:16.644','admin','2024-08-30 13:57:16.644'),(1829398007993004034,1829397860466749441,'海鲜',1,'1','admin','2024-08-30 13:57:28.347','admin','2024-08-30 13:57:28.347'),(1840282771834667010,1828405743737016322,'空调',2,'1','wms2_admin','2024-09-29 14:49:38.274','wms2_admin','2024-09-29 14:49:38.274');
/*!40000 ALTER TABLE `wms_item_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_item_sku`
--

DROP TABLE IF EXISTS `wms_item_sku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_item_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规格名称',
  `item_id` bigint DEFAULT NULL,
  `barcode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '条码',
  `sku_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编码',
  `length` decimal(10,1) DEFAULT NULL COMMENT '长，单位cm',
  `width` decimal(10,1) DEFAULT NULL COMMENT '宽，单位cm',
  `height` decimal(10,1) DEFAULT NULL COMMENT '高，单位cm',
  `gross_weight` decimal(10,3) DEFAULT NULL COMMENT '毛重，单位kg',
  `net_weight` decimal(10,3) DEFAULT NULL COMMENT '净重，单位kg',
  `cost_price` decimal(10,2) DEFAULT NULL COMMENT '成本价（元）',
  `selling_price` decimal(10,2) DEFAULT NULL COMMENT '销售价（元）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1840308261463195650 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='sku信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_item_sku`
--

LOCK TABLES `wms_item_sku` WRITE;
/*!40000 ALTER TABLE `wms_item_sku` DISABLE KEYS */;
INSERT INTO `wms_item_sku` VALUES (1828402624005312514,'黑',1828402622516334594,'x00003','00001',NULL,NULL,NULL,NULL,NULL,5000.00,5288.00,'admin','2024-08-27 20:02:10.302','admin','2024-09-02 21:45:27.177'),(1828402624005312515,'白',1828402622516334594,'','000002',NULL,NULL,NULL,NULL,NULL,5000.00,5288.00,'admin','2024-08-27 20:02:10.304','admin','2024-09-02 21:45:27.184'),(1828402624005312516,'粉',1828402622516334594,'','00003',NULL,NULL,NULL,NULL,NULL,5000.00,5288.00,'admin','2024-08-27 20:02:10.305','admin','2024-09-02 21:45:27.190'),(1828406451399987201,'pro',1828406450112335874,'','mac0001',NULL,NULL,NULL,NULL,NULL,NULL,24999.00,'admin','2024-08-27 20:17:22.821','admin','2024-08-27 20:17:22.821'),(1828407871469686786,'l6468',1828407870173646849,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3188.00,'admin','2024-08-27 20:23:01.393','admin','2024-08-27 20:23:01.393'),(1828408321522700289,'白色',1828408320146968578,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2699.00,'admin','2024-08-27 20:24:48.697','admin','2024-08-27 20:24:48.697'),(1828408796968030210,'10kg',1828408795734904833,'102025115',NULL,NULL,NULL,NULL,NULL,10.000,NULL,NULL,'admin','2024-08-27 20:26:42.049','admin','2024-08-27 20:33:27.395'),(1828408796968030211,'20kg',1828408795734904833,'254523055',NULL,NULL,NULL,NULL,NULL,20.000,NULL,NULL,'admin','2024-08-27 20:26:42.052','admin','2024-08-27 20:33:27.515'),(1828408796968030212,'50kg',1828408795734904833,'5204862525',NULL,NULL,NULL,NULL,NULL,50.000,NULL,NULL,'admin','2024-08-27 20:26:42.052','admin','2024-08-27 20:33:27.634'),(1829398193024724993,'大',1829398192563351554,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-30 13:58:12.457','admin','2024-08-30 14:01:08.172'),(1829398193024724994,'中',1829398192563351554,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-30 13:58:12.458','admin','2024-08-30 14:01:08.328'),(1829398333903007745,'大',1829398333580046338,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-30 13:58:46.047','admin','2024-08-30 14:00:49.854'),(1829398333903007746,'中',1829398333580046338,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-30 13:58:46.048','admin','2024-08-30 14:00:50.001'),(1829398492779048962,'大',1829398492388978689,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-30 13:59:23.925','admin','2024-08-30 14:00:32.544'),(1829398492779048963,'中',1829398492388978689,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-30 13:59:23.925','admin','2024-08-30 14:00:32.683'),(1829398702011904001,'大',1829398701680553985,'',NULL,10.0,10.0,10.0,NULL,NULL,NULL,NULL,'admin','2024-08-30 14:00:13.810','admin','2024-08-30 14:00:13.810'),(1829398702011904002,'中',1829398701680553985,'',NULL,5.0,5.0,5.0,NULL,NULL,NULL,NULL,'admin','2024-08-30 14:00:13.812','admin','2024-08-30 14:00:13.812'),(1829399118304964609,'大',1829399118040723457,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-30 14:01:53.064','admin','2024-08-30 14:01:53.064'),(1829399118304964610,'中',1829399118040723457,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-30 14:01:53.064','admin','2024-08-30 14:01:53.064'),(1840282974629265410,'1P',1840282974297915394,'',NULL,NULL,NULL,NULL,NULL,NULL,2000.00,NULL,'wms2_admin','2024-09-29 14:50:26.627','wms2_admin','2024-09-29 14:50:26.627'),(1840282974696374273,'2P',1840282974297915394,'',NULL,NULL,NULL,NULL,NULL,NULL,3000.00,NULL,'wms2_admin','2024-09-29 14:50:26.628','wms2_admin','2024-09-29 14:50:26.628');
/*!40000 ALTER TABLE `wms_item_sku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_material_type`
--

DROP TABLE IF EXISTS `wms_material_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_material_type` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物料类型编号',
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '物料类型名称（如：阀门）',
  `order_num` bigint DEFAULT '0' COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='物料类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_material_type`
--

LOCK TABLES `wms_material_type` WRITE;
/*!40000 ALTER TABLE `wms_material_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_material_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_merchant`
--

DROP TABLE IF EXISTS `wms_merchant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_merchant` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编号',
  `merchant_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `merchant_type` tinyint DEFAULT NULL COMMENT '企业类型',
  `merchant_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '级别',
  `bank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开户行',
  `bank_account` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '银行账户',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '地址',
  `mobile` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号',
  `tel` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '座机号',
  `contact_person` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系人',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Email',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1828354284882399234 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='往来单位';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_merchant`
--

LOCK TABLES `wms_merchant` WRITE;
/*!40000 ALTER TABLE `wms_merchant` DISABLE KEYS */;
INSERT INTO `wms_merchant` VALUES (1828354016258199554,'c_0001','苏州XXXXXXX仓储管理有限公司',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-27 16:49:01.319','admin','2024-08-27 16:49:01.319'),(1828354153193836545,'s_0001','苏州XXXXX供应链有限公司',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-27 16:49:33.964','admin','2024-08-27 16:49:33.964'),(1828354284882399233,'c_s_0001','苏州CS有限公司',3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin','2024-08-27 16:50:05.367','admin','2024-08-27 16:50:05.367');
/*!40000 ALTER TABLE `wms_merchant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_movement_order`
--

DROP TABLE IF EXISTS `wms_movement_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_movement_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编号',
  `source_warehouse_id` bigint DEFAULT NULL COMMENT '源仓库',
  `target_warehouse_id` bigint DEFAULT NULL COMMENT '目标仓库',
  `order_status` tinyint DEFAULT NULL COMMENT '状态',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '总金额',
  `total_quantity` decimal(10,2) DEFAULT NULL COMMENT '总数量',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920257199722499 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='移库单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_movement_order`
--

LOCK TABLES `wms_movement_order` WRITE;
/*!40000 ALTER TABLE `wms_movement_order` DISABLE KEYS */;
INSERT INTO `wms_movement_order` VALUES (1843920257199722498,'YK10096786',1828364609002311682,1840317750635581441,1,NULL,1.00,NULL,'ck','2024-10-09 15:43:42.356','ck','2024-10-09 15:43:42.356');
/*!40000 ALTER TABLE `wms_movement_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_movement_order_detail`
--

DROP TABLE IF EXISTS `wms_movement_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_movement_order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL COMMENT '移库单Id',
  `sku_id` bigint DEFAULT NULL COMMENT '规格id',
  `quantity` decimal(20,2) DEFAULT NULL COMMENT '数量',
  `amount` decimal(10,2) DEFAULT NULL COMMENT '金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `source_warehouse_id` bigint DEFAULT NULL COMMENT '源仓库',
  `target_warehouse_id` bigint DEFAULT NULL COMMENT '目标仓库',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920257237471234 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='库存移动详情';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_movement_order_detail`
--

LOCK TABLES `wms_movement_order_detail` WRITE;
/*!40000 ALTER TABLE `wms_movement_order_detail` DISABLE KEYS */;
INSERT INTO `wms_movement_order_detail` VALUES (1843920257237471233,1843920257199722498,1840282974696374273,1.00,NULL,NULL,1828364609002311682,1840317750635581441,'ck','2024-10-09 15:43:42.365','ck','2024-10-09 15:43:42.365');
/*!40000 ALTER TABLE `wms_movement_order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_pallet`
--

DROP TABLE IF EXISTS `wms_pallet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_pallet` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `pallet_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '托盘编号',
  `pallet_type_id` bigint NOT NULL COMMENT '托盘类型ID',
  `current_bin_id` bigint DEFAULT NULL COMMENT '当前所在货位ID（binCode对应的ID）',
  `current_bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '当前所在货位编号（binCode）',
  `is_empty` int DEFAULT '1' COMMENT '是否为空托（0:否 1:是）',
  `is_bound` int DEFAULT '0' COMMENT '是否已绑定物料（0:否 1:是）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0:正常 1:禁用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_pallet_code` (`pallet_code`) USING BTREE,
  KEY `idx_pallet_type_id` (`pallet_type_id`) USING BTREE,
  KEY `idx_current_bin_id` (`current_bin_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='托盘表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_pallet`
--

LOCK TABLES `wms_pallet` WRITE;
/*!40000 ALTER TABLE `wms_pallet` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_pallet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_pallet_type`
--

DROP TABLE IF EXISTS `wms_pallet_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_pallet_type` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '托盘类型编号（如：SMALL、LARGE）',
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '托盘类型名称',
  `fixed_quantity` int DEFAULT NULL COMMENT '固定数量（如：1类托盘132个、2类托盘33个）',
  `length` decimal(10,2) DEFAULT NULL COMMENT '长度（cm）',
  `width` decimal(10,2) DEFAULT NULL COMMENT '宽度（cm）',
  `height` decimal(10,2) DEFAULT NULL COMMENT '高度（cm）',
  `load_capacity` decimal(10,2) DEFAULT NULL COMMENT '载重（kg）',
  `agv_vehicle_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AGV识别的载具类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_type_code` (`type_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1998322323461361666 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='托盘类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_pallet_type`
--

LOCK TABLES `wms_pallet_type` WRITE;
/*!40000 ALTER TABLE `wms_pallet_type` DISABLE KEYS */;
INSERT INTO `wms_pallet_type` VALUES (1998322323461361665,'11','外网',NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,'admin','2025-12-09 17:22:23.000','admin','2025-12-09 17:23:30.111');
/*!40000 ALTER TABLE `wms_pallet_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_pda_log`
--

DROP TABLE IF EXISTS `wms_pda_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_pda_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `log_type` int NOT NULL COMMENT '日志类型（1:操作记录 2:错误日志 3:网络失败记录 4:系统日志）',
  `pda_device_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'PDA设备编号',
  `operator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人',
  `log_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志级别（INFO/WARN/ERROR）',
  `log_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '日志内容',
  `error_stack` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '错误堆栈（仅错误日志）',
  `request_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '网络请求URL（仅网络失败记录）',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '网络请求方法（仅网络失败记录）',
  `network_error` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '网络错误信息（仅网络失败记录）',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'IP地址',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_log_type` (`log_type`) USING BTREE,
  KEY `idx_pda_device_no` (`pda_device_no`) USING BTREE,
  KEY `idx_log_level` (`log_level`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='PDA日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_pda_log`
--

LOCK TABLES `wms_pda_log` WRITE;
/*!40000 ALTER TABLE `wms_pda_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_pda_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_pda_operation`
--

DROP TABLE IF EXISTS `wms_pda_operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_pda_operation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `operation_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作编号',
  `operation_type` int NOT NULL COMMENT '操作类型（1:托盘扫码 2:阀门扫码 3:库位扫码 4:入库 5:出库 6:送检 7:回库 8:盘点 9:任务取消）',
  `operator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人',
  `pda_device_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'PDA设备编号',
  `scanned_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '扫描的条码/编号',
  `biz_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联业务单号',
  `biz_order_id` bigint DEFAULT NULL COMMENT '关联业务单ID',
  `result` int DEFAULT NULL COMMENT '操作结果（0:失败 1:成功）',
  `result_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作结果描述',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误信息',
  `operation_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '操作数据（JSON格式）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_operation_no` (`operation_no`) USING BTREE,
  KEY `idx_operation_type` (`operation_type`) USING BTREE,
  KEY `idx_operator` (`operator`) USING BTREE,
  KEY `idx_pda_device_no` (`pda_device_no`) USING BTREE,
  KEY `idx_biz_order_no` (`biz_order_no`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='PDA操作记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_pda_operation`
--

LOCK TABLES `wms_pda_operation` WRITE;
/*!40000 ALTER TABLE `wms_pda_operation` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_pda_operation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_receipt_order`
--

DROP TABLE IF EXISTS `wms_receipt_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_receipt_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '入库单号',
  `opt_type` int DEFAULT NULL COMMENT '入库类型',
  `merchant_id` bigint DEFAULT NULL COMMENT '供应商',
  `biz_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务订单号',
  `total_quantity` decimal(10,2) DEFAULT NULL COMMENT '商品总数',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '订单金额',
  `order_status` tinyint DEFAULT NULL COMMENT '入库状态',
  `warehouse_id` bigint DEFAULT NULL COMMENT '仓库id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920012030070786 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='入库单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_receipt_order`
--

LOCK TABLES `wms_receipt_order` WRITE;
/*!40000 ALTER TABLE `wms_receipt_order` DISABLE KEYS */;
INSERT INTO `wms_receipt_order` VALUES (1843920012030070785,'RK10098845',2,NULL,NULL,8.00,NULL,1,1828364609002311682,NULL,'ck','2024-10-09 15:42:43.905','ck','2024-10-09 15:42:43.905');
/*!40000 ALTER TABLE `wms_receipt_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_receipt_order_detail`
--

DROP TABLE IF EXISTS `wms_receipt_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_receipt_order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL COMMENT '入库单号',
  `sku_id` bigint DEFAULT NULL COMMENT '规格id',
  `quantity` decimal(20,2) DEFAULT NULL COMMENT '入库数量',
  `amount` decimal(10,2) DEFAULT NULL COMMENT '金额',
  `warehouse_id` bigint DEFAULT NULL COMMENT '所属仓库',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920012105568259 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='入库单详情';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_receipt_order_detail`
--

LOCK TABLES `wms_receipt_order_detail` WRITE;
/*!40000 ALTER TABLE `wms_receipt_order_detail` DISABLE KEYS */;
INSERT INTO `wms_receipt_order_detail` VALUES (1843920012088791042,1843920012030070785,1840282974696374273,4.00,4000.00,1828364609002311682,NULL,'ck','2024-10-09 15:42:43.920','ck','2024-10-09 15:42:43.920'),(1843920012105568258,1843920012030070785,1840282974629265410,4.00,4000.00,1828364609002311682,NULL,'ck','2024-10-09 15:42:43.922','ck','2024-10-09 15:42:43.922');
/*!40000 ALTER TABLE `wms_receipt_order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_scan_task`
--

DROP TABLE IF EXISTS `wms_scan_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_scan_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务编号',
  `task_type` int NOT NULL COMMENT '任务类型（1:托盘扫码 2:阀门扫码 3:库位扫码）',
  `barcode` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '扫描的条码',
  `operator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人',
  `pda_device_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'PDA设备编号',
  `status` int DEFAULT '0' COMMENT '任务状态（0:待处理 1:处理中 2:已完成 3:失败）',
  `result` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理结果',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误信息',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_task_no` (`task_no`) USING BTREE,
  KEY `idx_task_type` (`task_type`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_barcode` (`barcode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='扫码任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_scan_task`
--

LOCK TABLES `wms_scan_task` WRITE;
/*!40000 ALTER TABLE `wms_scan_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_scan_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_shipment_order`
--

DROP TABLE IF EXISTS `wms_shipment_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_shipment_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '出库单号，系统自动生成',
  `opt_type` int DEFAULT NULL COMMENT '出库类型',
  `biz_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务订单号',
  `merchant_id` bigint DEFAULT NULL COMMENT '客户',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '总金额',
  `total_quantity` decimal(10,2) DEFAULT NULL COMMENT '总数量',
  `order_status` tinyint DEFAULT NULL COMMENT '出库单状态',
  `warehouse_id` bigint DEFAULT NULL COMMENT '仓库id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920133316759554 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='出库单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_shipment_order`
--

LOCK TABLES `wms_shipment_order` WRITE;
/*!40000 ALTER TABLE `wms_shipment_order` DISABLE KEYS */;
INSERT INTO `wms_shipment_order` VALUES (1843920133316759553,'CK10094547',2,NULL,NULL,NULL,1.00,1,1828364609002311682,NULL,'ck','2024-10-09 15:43:12.821','ck','2024-10-09 15:43:12.821');
/*!40000 ALTER TABLE `wms_shipment_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_shipment_order_detail`
--

DROP TABLE IF EXISTS `wms_shipment_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_shipment_order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL COMMENT '出库单',
  `warehouse_id` bigint DEFAULT NULL COMMENT '所属仓库',
  `sku_id` bigint DEFAULT NULL COMMENT '规格id',
  `quantity` decimal(10,2) DEFAULT NULL COMMENT '数量',
  `amount` decimal(10,2) DEFAULT NULL COMMENT '金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1843920133354508290 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='出库单详情';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_shipment_order_detail`
--

LOCK TABLES `wms_shipment_order_detail` WRITE;
/*!40000 ALTER TABLE `wms_shipment_order_detail` DISABLE KEYS */;
INSERT INTO `wms_shipment_order_detail` VALUES (1843920133354508289,1843920133316759553,1828364609002311682,1840282974629265410,1.00,NULL,NULL,'ck','2024-10-09 15:43:12.830','ck','2024-10-09 15:43:12.830');
/*!40000 ALTER TABLE `wms_shipment_order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_valve`
--

DROP TABLE IF EXISTS `wms_valve`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_valve` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `valve_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '阀门编号（valveNo）',
  `material_type_id` bigint DEFAULT NULL COMMENT '物料类型ID（ValveType）',
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '型号（如：DN50、DN80）',
  `manufacturer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '厂家',
  `batch_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '批次',
  `pallet_id` bigint DEFAULT NULL COMMENT '所属托盘ID',
  `pallet_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属托盘编号',
  `current_bin_id` bigint DEFAULT NULL COMMENT '当前所在货位ID',
  `current_bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '当前所在货位编号',
  `status` int DEFAULT '0' COMMENT '状态（0:在库 1:检测中 2:已检测 3:已出库）',
  `production_date` date DEFAULT NULL COMMENT '生产日期',
  `expiry_date` date DEFAULT NULL COMMENT '过期日期',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_valve_no` (`valve_no`) USING BTREE,
  KEY `idx_material_type_id` (`material_type_id`) USING BTREE,
  KEY `idx_pallet_id` (`pallet_id`) USING BTREE,
  KEY `idx_current_bin_id` (`current_bin_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='阀门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_valve`
--

LOCK TABLES `wms_valve` WRITE;
/*!40000 ALTER TABLE `wms_valve` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_valve` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_warehouse`
--

DROP TABLE IF EXISTS `wms_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_warehouse` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `warehouse_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编号',
  `warehouse_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `order_num` bigint DEFAULT '0' COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1840317750635581442 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='仓库';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_warehouse`
--

LOCK TABLES `wms_warehouse` WRITE;
/*!40000 ALTER TABLE `wms_warehouse` DISABLE KEYS */;
INSERT INTO `wms_warehouse` VALUES (1828364609002311682,NULL,'苏州园区',NULL,1,'admin','2024-08-27 17:31:06.821','admin','2024-08-27 17:31:06.821'),(1828364740028174337,NULL,'常熟冷链仓',NULL,2,'admin','2024-08-27 17:31:38.066','admin','2024-08-30 13:55:34.766'),(1840317750635581441,NULL,'吴江仓',NULL,3,'wms2_admin','2024-09-29 17:08:37.859','wms2_admin','2024-09-29 17:08:37.859');
/*!40000 ALTER TABLE `wms_warehouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_warehouse_keeper`
--

DROP TABLE IF EXISTS `wms_warehouse_keeper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_warehouse_keeper` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `keeper_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '库管员编号',
  `keeper_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '库管员姓名',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID（关联sys_user）',
  `warehouse_id` bigint DEFAULT NULL COMMENT '所属仓库ID',
  `post` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '岗位',
  `join_date` date DEFAULT NULL COMMENT '入职日期',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_keeper_code` (`keeper_code`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='库管员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_warehouse_keeper`
--

LOCK TABLES `wms_warehouse_keeper` WRITE;
/*!40000 ALTER TABLE `wms_warehouse_keeper` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_warehouse_keeper` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'wms'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-09 18:56:59
