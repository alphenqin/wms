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
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2024-06-13 16:06:37','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-light','Y','admin','2024-06-13 16:06:37','admin','2024-07-16 11:25:33','深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2024-06-13 16:06:37','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2024-06-13 16:06:37','',NULL,'是否开启注册用户功能（true开启，false关闭）');
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
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,130,'system',NULL,'',0,0,'M','1','1','','system','admin','2024-06-13 16:06:26','admin','2025-12-09 16:42:52','系统管理目录'),(100,'用户管理',2001,10,'user','system/user/index','',0,0,'C','1','1','system:user:list','user','admin','2024-06-13 16:06:26','admin','2025-12-09 16:17:12','用户管理菜单'),(101,'角色管理',2001,20,'role','system/role/index','',0,0,'C','1','1','system:role:list','peoples','admin','2024-06-13 16:06:26','admin','2025-12-09 16:17:23','角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','',0,0,'C','1','1','system:menu:list','tree-table','admin','2024-06-13 16:06:26','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','',0,0,'C','1','1','system:dept:list','tree','admin','2024-06-13 16:06:26','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','',0,0,'C','1','1','system:post:list','post','admin','2024-06-13 16:06:26','',NULL,'岗位管理菜单'),(1001,'用户查询',100,1,'','','',0,0,'F','1','1','system:user:query','#','admin','2024-06-13 16:06:27','',NULL,''),(1002,'用户新增',100,2,'','','',0,0,'F','1','1','system:user:add','#','admin','2024-06-13 16:06:27','',NULL,''),(1003,'用户修改',100,3,'','','',0,0,'F','1','1','system:user:edit','#','admin','2024-06-13 16:06:27','',NULL,''),(1004,'用户删除',100,4,'','','',0,0,'F','1','1','system:user:remove','#','admin','2024-06-13 16:06:27','',NULL,''),(1005,'用户导出',100,5,'','','',0,0,'F','1','1','system:user:export','#','admin','2024-06-13 16:06:27','',NULL,''),(1006,'用户导入',100,6,'','','',0,0,'F','1','1','system:user:import','#','admin','2024-06-13 16:06:27','',NULL,''),(1007,'重置密码',100,7,'','','',0,0,'F','1','1','system:user:resetPwd','#','admin','2024-06-13 16:06:27','',NULL,''),(1008,'角色查询',101,1,'','','',0,0,'F','1','1','system:role:query','#','admin','2024-06-13 16:06:27','',NULL,''),(1009,'角色新增',101,2,'','','',0,0,'F','1','1','system:role:add','#','admin','2024-06-13 16:06:27','',NULL,''),(1010,'角色修改',101,3,'','','',0,0,'F','1','1','system:role:edit','#','admin','2024-06-13 16:06:28','',NULL,''),(1011,'角色删除',101,4,'','','',0,0,'F','1','1','system:role:remove','#','admin','2024-06-13 16:06:28','',NULL,''),(1012,'角色导出',101,5,'','','',0,0,'F','1','1','system:role:export','#','admin','2024-06-13 16:06:28','',NULL,''),(1013,'菜单查询',102,1,'','','',0,0,'F','1','1','system:menu:query','#','admin','2024-06-13 16:06:28','',NULL,''),(1014,'菜单新增',102,2,'','','',0,0,'F','1','1','system:menu:add','#','admin','2024-06-13 16:06:28','',NULL,''),(1015,'菜单修改',102,3,'','','',0,0,'F','1','1','system:menu:edit','#','admin','2024-06-13 16:06:28','',NULL,''),(1016,'菜单删除',102,4,'','','',0,0,'F','1','1','system:menu:remove','#','admin','2024-06-13 16:06:28','',NULL,''),(1017,'部门查询',103,1,'','','',0,0,'F','1','1','system:dept:query','#','admin','2024-06-13 16:06:28','',NULL,''),(1018,'部门新增',103,2,'','','',0,0,'F','1','1','system:dept:add','#','admin','2024-06-13 16:06:28','',NULL,''),(1019,'部门修改',103,3,'','','',0,0,'F','1','1','system:dept:edit','#','admin','2024-06-13 16:06:28','',NULL,''),(1020,'部门删除',103,4,'','','',0,0,'F','1','1','system:dept:remove','#','admin','2024-06-13 16:06:28','',NULL,''),(1021,'岗位查询',104,1,'','','',0,0,'F','1','1','system:post:query','#','admin','2024-06-13 16:06:28','',NULL,''),(1022,'岗位新增',104,2,'','','',0,0,'F','1','1','system:post:add','#','admin','2024-06-13 16:06:28','',NULL,''),(1023,'岗位修改',104,3,'','','',0,0,'F','1','1','system:post:edit','#','admin','2024-06-13 16:06:28','',NULL,''),(1024,'岗位删除',104,4,'','','',0,0,'F','1','1','system:post:remove','#','admin','2024-06-13 16:06:28','',NULL,''),(1025,'岗位导出',104,5,'','','',0,0,'F','1','1','system:post:export','#','admin','2024-06-13 16:06:28','',NULL,''),(2001,'new 基础数据',0,110,'basic',NULL,'',0,0,'M','1','1','','dict','admin','2025-12-05 10:54:01','admin','2025-12-09 16:40:47','基础数据管理'),(2010,'仓库管理',1998317351596314625,20,'warehouse','wms/basic/warehouse/index','',0,0,'C','1','1','wms:warehouse:list','date','admin','2025-12-05 10:54:01','admin','2025-12-09 17:02:57','仓库管理'),(2011,'货区管理',1998317351596314625,40,'area','wms/basic/area/index','',0,0,'C','1','1','wms:area:list','tree','admin','2025-12-05 10:54:01','admin','2025-12-09 17:03:08','货区管理'),(2012,'货位管理',1998317351596314625,50,'bin','wms/basic/bin/index','',0,0,'C','1','1','wms:bin:list','tree-table','admin','2025-12-05 10:54:01','admin','2025-12-09 17:03:21','货位管理'),(2013,'物料类型',1998308639817191425,60,'materialType','wms/basic/materialType/index','',0,0,'C','1','1','wms:materialType:list','list','admin','2025-12-05 10:54:01','admin','2025-12-09 16:45:01','物料类型管理'),(2014,'托盘类型',1998308639817191425,70,'palletType','wms/basic/palletType/index','',0,0,'C','1','1','wms:palletType:list','list','admin','2025-12-05 10:54:01','admin','2025-12-09 16:45:30','托盘类型管理'),(2015,'托盘管理',1998308639817191425,80,'pallet','wms/basic/pallet/index','',0,0,'C','1','1','wms:pallet:list','table','admin','2025-12-05 10:54:01','admin','2025-12-09 16:46:22','托盘管理'),(2016,'阀门管理',2001,90,'valve','wms/basic/valve/index','',0,0,'C','1','1','wms:valve:list','component','admin','2025-12-05 10:54:01','admin','2025-12-09 16:18:51','阀门管理'),(2017,'库管员管理',2001,100,'warehouseKeeper','wms/basic/warehouseKeeper/index','',0,0,'C','1','1','wms:warehouseKeeper:list','user','admin','2025-12-05 10:54:01','admin','2025-12-09 16:18:58','库管员管理'),(2020,'new 条码管理',0,60,'barcode',NULL,'',0,0,'M','1','1','','chart','admin','2025-12-05 10:54:01','admin','2025-12-09 16:28:16','条码管理'),(2021,'条码信息',2020,1,'barcode','wms/barcode/index','',0,0,'C','1','1','wms:barcode:list','cascader','admin','2025-12-05 10:54:01','admin','2025-12-09 14:15:02','条码信息管理'),(2022,'扫码任务',2020,2,'scanTask','wms/scanTask/index','',0,0,'C','1','1','wms:scanTask:list','guide','admin','2025-12-05 10:54:01','admin','2025-12-09 14:10:19','扫码任务管理'),(2030,'new 订单管理',0,30,'order',NULL,'',0,0,'M','1','1','','shopping','admin','2025-12-05 10:54:01','admin','2025-12-09 16:26:57','订单管理'),(2031,'入库单',2030,1,'receipt','wms/order/receipt/index','',0,0,'C','1','1','wms:receipt:list','upload','admin','2025-12-05 10:54:01','admin','2025-12-09 16:44:04','入库单管理'),(2032,'出库单',2030,2,'shipment','wms/order/shipment/index','',0,0,'C','1','1','wms:shipment:list','download','admin','2025-12-05 10:54:01','admin','2025-12-09 16:44:10','出库单管理'),(2033,'移库单',2030,3,'movement','wms/order/movement/index','',0,0,'C','1','1','wms:movement:list','drag','admin','2025-12-05 10:54:01','admin','2025-12-09 16:44:14','移库单管理'),(2034,'盘点单',2030,4,'check','wms/order/check/index','',0,0,'C','1','1','wms:check:list','edit','admin','2025-12-05 10:54:01','admin','2025-12-09 16:44:18','盘点单管理'),(2040,'new 库存管理',0,40,'inventory',NULL,'',0,0,'M','1','1','','chart','admin','2025-12-05 10:54:01','admin','2025-12-09 16:27:14','库存管理'),(2041,'库存统计',2040,1,'inventory','wms/inventory/statistic','',0,0,'C','1','1','wms:inventory:all','chart','admin','2025-12-05 10:54:01','admin','2025-12-09 15:45:57','库存统计'),(2042,'库存历史',2040,2,'history','wms/inventory/history','',0,0,'C','1','1','wms:inventoryHistory:all','log','admin','2025-12-05 10:54:01','admin','2025-12-09 15:54:23','库存历史'),(2043,'库存查询',2040,3,'query','wms/inventory/query/index','',0,0,'C','1','1','wms:inventory:query','search','admin','2025-12-05 10:54:01','admin','2025-12-09 14:12:25','库存查询'),(2050,'new 任务管理',0,80,'task',NULL,'',0,0,'M','1','1','wms:inventory:all','guide','admin','2025-12-05 10:54:01','admin','2025-12-09 16:29:39','任务管理'),(2051,'AGV任务',2050,1,'agvTask','wms/task/agvTask/index','',0,0,'C','1','1','wms:agvTask:list','guide','admin','2025-12-05 10:54:01','admin','2025-12-09 16:29:09','AGV任务管理'),(2060,'new PDA管理',0,90,'pda',NULL,'',0,0,'M','1','1','','phone','admin','2025-12-05 10:54:01','admin','2025-12-09 16:40:24','PDA管理'),(2061,'PDA操作记录',2060,1,'operation','wms/pda/operation/index','',0,0,'C','1','1','wms:pdaOperation:list','list','admin','2025-12-05 10:54:01','admin','2025-12-09 14:13:29','PDA操作记录'),(2070,'new 报表查询',0,70,'report','wms/report/index','',0,0,'C','1','1','wms:report:list','chart','admin','2025-12-05 10:54:01','admin','2025-12-09 17:08:15','报表查询'),(2080,'new 系统配置',0,100,'wms-config',NULL,'',0,0,'M','1','1','','system','admin','2025-12-05 10:54:01','admin','2025-12-09 18:56:00','系统配置'),(2081,'WMS配置',2080,1,'wms-config','wms/config/index','',0,0,'C','1','1','wms:config:list','edit','admin','2025-12-05 10:54:01','admin','2025-12-09 18:51:10','WMS配置管理'),(2082,'数据备份',2080,2,'data-backup','wms/dataBackup/index','',0,0,'C','1','1','wms:backup:list','color','admin','2025-12-05 10:54:01','admin','2025-12-09 18:52:23','数据备份管理'),(1809059968309743618,'old 往来单位',2001,1000,'merchant','wms/basic/merchant/index',NULL,0,0,'C','1','1','wms:merchant:list','documentation','admin','2024-07-05 11:58:12','admin','2025-12-09 16:19:23','往来单位菜单'),(1809059968309743619,'往来单位查询',1809059968309743618,1,'#','',NULL,0,0,'F','1','1','wms:merchant:list','#','admin','2024-07-05 11:58:12','admin','2024-08-30 10:43:54',''),(1809059968309743621,'往来单位修改',1809059968309743618,3,'#','',NULL,0,0,'F','1','1','wms:merchant:edit','#','admin','2024-07-05 11:58:12','',NULL,''),(1813820131794837506,'old 商品管理',2001,1001,'item','wms/basic/item/index',NULL,0,0,'C','1','1','wms:item:list','documentation','admin','2024-07-18 14:16:33','admin','2025-12-09 16:19:30',''),(1815207165755183105,'编辑入库单',0,1000,'receiptOrderEdit','wms/order/receipt/edit',NULL,0,0,'C','0','1','wms:receipt:edit','#','admin','2024-07-22 10:08:08','admin','2024-08-27 16:43:28',''),(1818123963605549057,'old 品牌管理',2001,1002,'itemBrand','wms/basic/itemBrand/index',NULL,0,0,'C','1','1','wms:itemBrand:list','documentation','admin','2024-07-30 11:18:27','admin','2025-12-09 16:19:36',''),(1818466281474822145,'入库',1998301986061406209,20,'receiptOrder','wms/order/receipt/index',NULL,0,0,'C','1','1','wms:receipt:all','exit-fullscreen','admin','2024-07-31 09:58:42','admin','2025-12-09 16:01:50',''),(1818854933803638785,'出库',1998301986061406209,30,'shipmentOrder','wms/order/shipment/index',NULL,0,0,'C','1','1','wms:shipment:all','fullscreen','admin','2024-08-01 11:43:04','admin','2025-12-09 16:01:58',''),(1818855673632727042,'编辑出库单',0,1000,'shipmentOrderEdit','wms/order/shipment/edit',NULL,0,0,'C','0','1','wms:shipment:edit','#','admin','2024-08-01 11:46:00','admin','2024-08-27 16:43:37',''),(1822820194307051521,'移库',1998301986061406209,40,'movementOrder','wms/order/movement/index',NULL,0,0,'C','1','1','wms:movement:all','drag','admin','2024-08-12 10:19:35','admin','2025-12-09 16:02:05',''),(1822862323595145218,'编辑移库单',0,1000,'movementOrderEdit','wms/order/movement/edit',NULL,0,0,'C','0','1','wms:movement:edit','#','admin','2024-08-12 13:07:00','admin','2024-08-27 16:43:50',''),(1823187248797270018,'盘库',1998301986061406209,50,'checkOrder','wms/order/check/index',NULL,0,0,'C','1','1','wms:check:all','example','admin','2024-08-13 10:38:08','admin','2025-12-09 16:02:11',''),(1823190638784757762,'编辑盘库单',0,1000,'checkOrderEdit','wms/order/check/edit',NULL,0,0,'C','0','1','wms:check:edit','#','admin','2024-08-13 10:51:36','admin','2024-08-27 16:43:44',''),(1829349433573822466,'仓库查询',2010,1,'',NULL,NULL,0,0,'F','1','1','wms:warehouse:list','#','admin','2024-08-30 10:44:27','admin','2025-12-09 16:05:59',''),(1829350022131142658,'仓库编辑',2010,2,'',NULL,NULL,0,0,'F','1','1','wms:warehouse:edit','#','admin','2024-08-30 10:46:48','admin','2025-12-09 16:06:14',''),(1829350164603260929,'品牌查询',1818123963605549057,1,'',NULL,NULL,0,0,'F','1','1','wms:itemBrand:list','#','admin','2024-08-30 10:47:22','admin','2024-08-30 10:47:22',''),(1829350944311791617,'品牌编辑',1818123963605549057,2,'',NULL,NULL,0,0,'F','1','1','wms:itemBrand:edit','#','admin','2024-08-30 10:50:27','admin','2024-08-30 10:50:27',''),(1829351081448755202,'商品查询',1813820131794837506,1,'',NULL,NULL,0,0,'F','1','1','wms:item:list','#','admin','2024-08-30 10:51:00','admin','2024-08-30 10:51:00',''),(1829351166857367553,'商品编辑',1813820131794837506,2,'',NULL,NULL,0,0,'F','1','1','wms:item:edit','#','admin','2024-08-30 10:51:21','admin','2024-08-30 10:51:21',''),(1998301986061406209,'new 出入库',0,10,'io',NULL,NULL,0,0,'M','1','1',NULL,'chart','admin','2025-12-09 16:01:35','admin','2025-12-09 16:20:34',''),(1998308639817191425,'new 托盘及物料管理',0,50,'dd',NULL,NULL,0,0,'M','1','1',NULL,'dashboard','admin','2025-12-09 16:28:01','admin','2025-12-09 16:41:20',''),(1998317351596314625,'new 仓库管理',0,20,'warehouse',NULL,NULL,0,0,'M','1','1',NULL,'drag','admin','2025-12-09 17:02:38','admin','2025-12-09 17:03:46',''),(1998329000000000001,'AGV接口',2050,2,'agv-interface','wms/task/agvInterface/index','',0,0,'C','1','1','wms:agvOpen:task:list','guide','admin','2025-12-15 00:00:00','admin','2025-12-15 00:00:00','AGV调度接口'),(1998329000000000101,'任务下发',1998329000000000001,1,'','',NULL,0,0,'F','1','1','wms:agvOpen:task:send','#','admin','2025-12-15 00:00:00','admin','2025-12-15 00:00:00',''),(1998329000000000102,'结果查询',1998329000000000001,2,'','',NULL,0,0,'F','1','1','wms:agvOpen:task:result','#','admin','2025-12-15 00:00:00','admin','2025-12-15 00:00:00',''),(1998329000000000103,'分配库位',1998329000000000001,3,'','',NULL,0,0,'F','1','1','wms:agvOpen:bin:assign','#','admin','2025-12-15 00:00:00','admin','2025-12-15 00:00:00',''),(1998329000000000104,'查询库位',1998329000000000001,4,'','',NULL,0,0,'F','1','1','wms:agvOpen:bin:info','#','admin','2025-12-15 00:00:00','admin','2025-12-15 00:00:00',''),(1998329000000000105,'更新库位状态',1998329000000000001,5,'','',NULL,0,0,'F','1','1','wms:agvOpen:bin:update','#','admin','2025-12-15 00:00:00','admin','2025-12-15 00:00:00',''),(1998329000000000106,'AGV信息',1998329000000000001,6,'','',NULL,0,0,'F','1','1','wms:agvOpen:agvInfo','#','admin','2025-12-15 00:00:00','admin','2025-12-15 00:00:00','');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--

--

--

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
INSERT INTO `sys_role_menu` VALUES (1,1998329000000000001),(1,1998329000000000101),(1,1998329000000000102),(1,1998329000000000103),(1,1998329000000000104),(1,1998329000000000105),(1,1998329000000000106);
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
INSERT INTO `sys_user` VALUES (1,103,'admin','程序员诚哥','sys_user','zccbbg@qq.com','18888888888','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','1','0','127.0.0.1','2025-12-26 16:10:48','admin','2024-06-13 16:06:25','admin','2025-12-26 16:10:48','管理员'),(1829105396288688129,105,'ck','ck','sys_user','','','0','','$2a$10$5ogFpqit10a8IpVFjKzosuz0whR0/tyQ4Nt9e6y3/MBodcDzwhCni','1','1','221.224.86.138','2024-10-09 15:40:16','admin','2024-08-29 18:34:44','ck','2024-10-09 15:40:16',NULL);
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
-- Table structure for table `wms_agv_open_task`
--

DROP TABLE IF EXISTS `wms_agv_open_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_agv_open_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `out_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '外部业务id',
  `task_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '调度任务编号',
  `task_type` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务类型 01/05/10/12/13/18',
  `is_order` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否有序',
  `agv_range` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AGV范围',
  `level` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务级别',
  `clear_out_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '被清空的外部业务id',
  `points_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '作业点JSON',
  `status` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务状态',
  `agv_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行AGV编号',
  `response_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '接口返回码',
  `response_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '接口返回消息',
  `request_payload` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '最近一次请求报文',
  `last_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '最近一次结果报文',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_out_id` (`out_id`) USING BTREE,
  KEY `idx_task_type` (`task_type`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='AGV开放接口任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_agv_open_task`
--

LOCK TABLES `wms_agv_open_task` WRITE;
/*!40000 ALTER TABLE `wms_agv_open_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_agv_open_task` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2003015487549640712 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='WMS系统配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_config`
--

LOCK TABLES `wms_config` WRITE;
/*!40000 ALTER TABLE `wms_config` DISABLE KEYS */;
INSERT INTO `wms_config` VALUES (2003015487549640711,'pda.pallet_scan.enabled','true',4,'pda','PDA托盘扫码开关','0',NULL,'admin','2025-12-23 10:03:34.000','admin','2025-12-23 15:12:03.229');
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
  `barcode_enabled` int DEFAULT '1' COMMENT '条码是否启用（0:否 1:是）',
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
) ENGINE=InnoDB AUTO_INCREMENT=1998574183371882498 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='托盘表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_pallet`
--

LOCK TABLES `wms_pallet` WRITE;
/*!40000 ALTER TABLE `wms_pallet` DISABLE KEYS */;
INSERT INTO `wms_pallet` VALUES (1998574183371882497,'22',1998322323461361665,NULL,'test',1,0,1,'0','xx','admin','2025-12-10 10:03:11.000','admin','2025-12-26 16:17:48.169');
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
) ENGINE=InnoDB AUTO_INCREMENT=2004466396309803010 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='托盘类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_pallet_type`
--

LOCK TABLES `wms_pallet_type` WRITE;
/*!40000 ALTER TABLE `wms_pallet_type` DISABLE KEYS */;
INSERT INTO `wms_pallet_type` VALUES (1998322323461361665,'d','大托盘',NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,'admin','2025-12-09 17:22:23.000','admin','2025-12-26 16:16:31.079'),(2004466396309803009,'x','小托盘',NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,'admin','2025-12-26 16:16:44.738','admin','2025-12-26 16:16:44.738');
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

-- Dump completed on 2025-12-26 16:29:15
