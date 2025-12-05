SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(20) NOT NULL COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(20) NOT NULL COMMENT '编号',
  `table_id` bigint(20) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` bigint(20) NOT NULL COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-06-13 16:06:37', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2024-06-13 16:06:37', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-light', 'Y', 'admin', '2024-06-13 16:06:37', 'admin', '2024-07-16 11:25:33', '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-06-13 16:06:37', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2024-06-13 16:06:37', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (11, 'OSS预览列表资源开关', 'sys.oss.previewListResource', 'true', 'Y', 'admin', '2024-06-13 16:06:37', '', NULL, 'true:开启, false:关闭');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '1', '0', 'admin', '2024-06-13 16:06:25', '', NULL);
INSERT INTO `sys_dept` VALUES (1811589666899832833, 102, '0,100,102', '测试部门2', 0, '负责人', '', '', '1', '0', 'admin', '2024-07-12 10:33:29', 'admin', '2024-07-12 10:33:29');

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(20) NOT NULL COMMENT '字典编码',
  `dict_sort` int(4) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0停用 1正常）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '1', 'sys_show_hide', '', 'primary', 'Y', '1', 'admin', '2024-06-13 16:06:36', 'admin', '2024-07-10 16:34:54', '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '0', 'sys_show_hide', '', 'danger', 'N', '1', 'admin', '2024-06-13 16:06:36', 'admin', '2024-07-10 16:35:07', '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '1', 'sys_normal_disable', '', 'primary', 'Y', '1', 'admin', '2024-06-13 16:06:36', 'admin', '2024-07-10 14:30:58', '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '0', 'sys_normal_disable', '', 'danger', 'N', '1', 'admin', '2024-06-13 16:06:36', 'admin', '2024-07-10 14:31:06', '停用状态');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '1', 'sys_notice_status', '', 'primary', 'Y', '1', 'admin', '2024-06-13 16:06:36', 'admin', '2024-07-10 17:24:35', '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '0', 'sys_notice_status', '', 'danger', 'N', '1', 'admin', '2024-06-13 16:06:36', 'admin', '2024-07-10 17:24:44', '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (19, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (20, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '1', 'admin', '2024-06-13 16:06:37', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (21, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '1', 'admin', '2024-06-13 16:06:37', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (22, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '1', 'admin', '2024-06-13 16:06:37', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (23, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '1', 'admin', '2024-06-13 16:06:37', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (24, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '1', 'admin', '2024-06-13 16:06:37', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (25, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '1', 'admin', '2024-06-13 16:06:37', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (26, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '1', 'admin', '2024-06-13 16:06:37', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (27, 1, '失败', '0', 'sys_common_status', '', 'danger', 'N', '1', 'admin', '2024-06-13 16:06:37', 'admin', '2024-07-15 10:50:52', '正常状态');
INSERT INTO `sys_dict_data` VALUES (28, 2, '成功', '1', 'sys_common_status', '', 'success', 'N', '1', 'admin', '2024-06-13 16:06:37', 'admin', '2024-07-15 10:51:05', '停用状态');
INSERT INTO `sys_dict_data` VALUES (29, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (1812692503272718338, 0, '客户', '1', 'merchant_type', NULL, 'default', 'N', '1', 'admin', '2024-07-15 11:35:46', 'admin', '2024-07-16 11:21:11', NULL);
INSERT INTO `sys_dict_data` VALUES (1812694839395135489, 1, '供应商', '2', 'merchant_type', NULL, 'default', 'N', '1', 'admin', '2024-07-15 11:45:03', 'admin', '2024-07-16 11:21:29', '');
INSERT INTO `sys_dict_data` VALUES (1813051377282904066, 3, '客户/供应商', '3', 'merchant_type', NULL, 'default', 'N', '1', 'admin', '2024-07-16 11:21:48', 'admin', '2024-07-16 11:21:48', NULL);
INSERT INTO `sys_dict_data` VALUES (1813153852862160897, 0, '未入库', '0', 'wms_receipt_status', NULL, 'info', 'N', '1', 'admin', '2024-07-16 18:09:00', 'admin', '2024-07-22 09:38:14', NULL);
INSERT INTO `sys_dict_data` VALUES (1813153899775451137, 1, '已入库', '1', 'wms_receipt_status', NULL, 'primary', 'N', '1', 'admin', '2024-07-16 18:09:11', 'admin', '2024-07-22 09:38:22', NULL);
INSERT INTO `sys_dict_data` VALUES (1813397339171905537, 3, '作废', '-1', 'wms_receipt_status', NULL, 'danger', 'N', '1', 'admin', '2024-07-17 10:16:32', 'admin', '2024-07-22 09:38:29', NULL);
INSERT INTO `sys_dict_data` VALUES (1814219171351085057, 0, '生产入库', '1', 'wms_receipt_type', NULL, 'primary', 'N', '1', 'admin', '2024-07-19 16:42:12', 'admin', '2024-07-22 09:38:50', NULL);
INSERT INTO `sys_dict_data` VALUES (1814219220520910849, 1, '采购入库', '2', 'wms_receipt_type', NULL, 'primary', 'N', '1', 'admin', '2024-07-19 16:42:23', 'admin', '2024-07-22 09:38:56', NULL);
INSERT INTO `sys_dict_data` VALUES (1814219269975949313, 2, '退货入库', '3', 'wms_receipt_type', NULL, 'primary', 'N', '1', 'admin', '2024-07-19 16:42:35', 'admin', '2024-07-22 09:39:01', NULL);
INSERT INTO `sys_dict_data` VALUES (1814219304272773121, 3, '归还入库', '4', 'wms_receipt_type', NULL, 'primary', 'N', '1', 'admin', '2024-07-19 16:42:43', 'admin', '2024-07-22 09:39:06', NULL);
INSERT INTO `sys_dict_data` VALUES (1818850397680640002, 2, '作废', '-1', 'wms_shipment_status', NULL, 'danger', 'N', '1', 'admin', '2024-08-01 11:25:02', 'admin', '2024-08-01 14:25:24', NULL);
INSERT INTO `sys_dict_data` VALUES (1818850512650706945, 0, '未出库', '0', 'wms_shipment_status', NULL, 'info', 'N', '1', 'admin', '2024-08-01 11:25:29', 'admin', '2024-08-01 14:25:37', NULL);
INSERT INTO `sys_dict_data` VALUES (1818850565389885441, 1, '已出库', '1', 'wms_shipment_status', NULL, 'primary', 'N', '1', 'admin', '2024-08-01 11:25:42', 'admin', '2024-08-01 14:25:32', NULL);
INSERT INTO `sys_dict_data` VALUES (1818850814351187969, 0, '退货出库', '1', 'wms_shipment_type', NULL, 'primary', 'N', '1', 'admin', '2024-08-01 11:26:41', 'wms2_admin', '2024-09-25 18:45:02', NULL);
INSERT INTO `sys_dict_data` VALUES (1818850852594851841, 1, '销售出库', '2', 'wms_shipment_type', NULL, 'primary', 'N', '1', 'admin', '2024-08-01 11:26:51', 'wms2_admin', '2024-09-25 18:45:13', NULL);
INSERT INTO `sys_dict_data` VALUES (1818850884714831874, 2, '生产出库', '3', 'wms_shipment_type', NULL, 'primary', 'N', '1', 'admin', '2024-08-01 11:26:58', 'wms2_admin', '2024-09-25 18:45:23', NULL);
INSERT INTO `sys_dict_data` VALUES (1821067084643434498, 0, '入库', '1', 'wms_inventory_history_type', NULL, 'success', 'N', '1', 'admin', '2024-08-07 14:13:21', 'wms2_admin', '2024-09-27 10:53:49', NULL);
INSERT INTO `sys_dict_data` VALUES (1821067144441626625, 1, '出库', '2', 'wms_inventory_history_type', NULL, 'danger', 'N', '1', 'admin', '2024-08-07 14:13:36', 'wms2_admin', '2024-09-27 10:53:39', NULL);
INSERT INTO `sys_dict_data` VALUES (1821067181917732866, 2, '移库', '3', 'wms_inventory_history_type', NULL, 'warning', 'N', '1', 'admin', '2024-08-07 14:13:45', 'wms2_admin', '2024-09-27 10:54:01', NULL);
INSERT INTO `sys_dict_data` VALUES (1821067222455681026, 3, '盘库', '4', 'wms_inventory_history_type', NULL, 'primary', 'N', '1', 'admin', '2024-08-07 14:13:54', 'admin', '2024-08-07 14:58:06', NULL);
INSERT INTO `sys_dict_data` VALUES (1822820748966006786, 0, '未移库', '0', 'wms_movement_status', NULL, 'info', 'N', '1', 'admin', '2024-08-12 10:21:48', 'admin', '2024-08-12 10:21:48', NULL);
INSERT INTO `sys_dict_data` VALUES (1822820794864275457, 1, '已移库', '1', 'wms_movement_status', NULL, 'primary', 'N', '1', 'admin', '2024-08-12 10:21:59', 'admin', '2024-08-12 10:21:59', NULL);
INSERT INTO `sys_dict_data` VALUES (1822820855526494210, 2, '作废', '-1', 'wms_movement_status', NULL, 'danger', 'N', '1', 'admin', '2024-08-12 10:22:13', 'admin', '2024-08-12 10:22:13', NULL);
INSERT INTO `sys_dict_data` VALUES (1823182345731391489, 0, '待盘库', '0', 'wms_check_status', NULL, 'info', 'N', '1', 'admin', '2024-08-13 10:18:39', 'admin', '2024-08-13 10:18:39', NULL);
INSERT INTO `sys_dict_data` VALUES (1823182400756465666, 1, '已盘库', '1', 'wms_check_status', NULL, 'primary', 'N', '1', 'admin', '2024-08-13 10:18:52', 'admin', '2024-08-13 10:18:52', NULL);
INSERT INTO `sys_dict_data` VALUES (1823182471136886786, 2, '作废', '-1', 'wms_check_status', NULL, 'danger', 'N', '1', 'admin', '2024-08-13 10:19:09', 'admin', '2024-08-13 10:19:09', NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(20) NOT NULL COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '1', 'admin', '2024-06-13 16:06:35', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '1', 'admin', '2024-06-13 16:06:35', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '1', 'admin', '2024-06-13 16:06:35', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '1', 'admin', '2024-06-13 16:06:35', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '1', 'admin', '2024-06-13 16:06:35', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '1', 'admin', '2024-06-13 16:06:35', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '1', 'admin', '2024-06-13 16:06:35', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '1', 'admin', '2024-06-13 16:06:36', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (1812692454547488770, '企业类型', 'merchant_type', '1', 'admin', '2024-07-15 11:35:34', 'admin', '2024-07-16 17:41:32', '企业类型');
INSERT INTO `sys_dict_type` VALUES (1813152108564373505, '入库状态', 'wms_receipt_status', '1', 'admin', '2024-07-16 18:02:04', 'admin', '2024-07-16 18:02:17', '入库状态');
INSERT INTO `sys_dict_type` VALUES (1814219082624778242, '入库类型', 'wms_receipt_type', '1', 'admin', '2024-07-19 16:41:51', 'admin', '2024-07-19 16:41:51', NULL);
INSERT INTO `sys_dict_type` VALUES (1818848671749709825, '出库状态', 'wms_shipment_status', '1', 'admin', '2024-08-01 11:18:11', 'admin', '2024-08-01 11:18:11', NULL);
INSERT INTO `sys_dict_type` VALUES (1818848738502057985, '出库类型', 'wms_shipment_type', '1', 'admin', '2024-08-01 11:18:26', 'admin', '2024-08-01 11:18:26', NULL);
INSERT INTO `sys_dict_type` VALUES (1821066855638630402, '库存记录操作类型', 'wms_inventory_history_type', '1', 'admin', '2024-08-07 14:12:27', 'admin', '2024-08-07 14:12:27', NULL);
INSERT INTO `sys_dict_type` VALUES (1822820566366982146, '移库状态', 'wms_movement_status', '1', 'admin', '2024-08-12 10:21:04', 'admin', '2024-08-12 10:21:04', NULL);
INSERT INTO `sys_dict_type` VALUES (1823182238898274306, '盘库状态', 'wms_check_status', '1', 'admin', '2024-08-13 10:18:14', 'admin', '2024-08-13 10:18:14', NULL);

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(20) NOT NULL COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `is_frame` int(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '显示状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 110, 'system', NULL, '', 0, 0, 'M', '1', '1', '', 'system', 'admin', '2024-06-13 16:06:26', 'admin', '2024-08-20 13:45:48', '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 120, 'monitor', NULL, '', 0, 0, 'M', '1', '1', '', 'monitor', 'admin', '2024-06-13 16:06:26', 'admin', '2024-08-20 13:45:57', '系统监控目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 0, 0, 'C', '1', '1', 'system:user:list', 'user', 'admin', '2024-06-13 16:06:26', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 0, 0, 'C', '1', '1', 'system:role:list', 'peoples', 'admin', '2024-06-13 16:06:26', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', 0, 0, 'C', '1', '1', 'system:menu:list', 'tree-table', 'admin', '2024-06-13 16:06:26', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', 0, 0, 'C', '1', '1', 'system:dept:list', 'tree', 'admin', '2024-06-13 16:06:26', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', 0, 0, 'C', '1', '1', 'system:post:list', 'post', 'admin', '2024-06-13 16:06:26', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 0, 0, 'C', '1', '1', 'system:dict:list', 'dict', 'admin', '2024-06-13 16:06:26', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 0, 0, 'C', '1', '1', 'system:config:list', 'edit', 'admin', '2024-06-13 16:06:26', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', 0, 0, 'C', '1', '1', 'system:notice:list', 'message', 'admin', '2024-06-13 16:06:26', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 0, 140, 'log', '', '', 0, 0, 'M', '1', '1', '', 'log', 'admin', '2024-06-13 16:06:27', 'admin', '2024-08-20 13:46:16', '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 0, 0, 'C', '1', '1', 'monitor:online:list', 'online', 'admin', '2024-06-13 16:06:27', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (112, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', 0, 0, 'C', '1', '1', 'monitor:cache:list', 'redis-list', 'admin', '2024-06-13 16:06:27', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 0, 0, 'C', '1', '1', 'monitor:cache:list', 'redis', 'admin', '2024-06-13 16:06:27', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (115, '代码生成', 0, 130, 'gen', 'tool/gen/index', '', 0, 0, 'C', '1', '1', 'tool:gen:list', 'code', 'admin', '2024-06-13 16:06:27', 'admin', '2024-08-20 13:46:06', '代码生成菜单');
INSERT INTO `sys_menu` VALUES (118, '文件管理', 1, 10, 'oss', 'system/oss/index', '', 0, 0, 'C', '1', '1', 'system:oss:list', 'upload', 'admin', '2024-06-13 16:06:27', '', NULL, '文件管理菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', 0, 0, 'C', '1', '1', 'monitor:operlog:list', 'form', 'admin', '2024-06-13 16:06:27', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', 0, 0, 'C', '1', '1', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-06-13 16:06:27', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1001, '用户查询', 100, 1, '', '', '', 0, 0, 'F', '1', '1', 'system:user:query', '#', 'admin', '2024-06-13 16:06:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户新增', 100, 2, '', '', '', 0, 0, 'F', '1', '1', 'system:user:add', '#', 'admin', '2024-06-13 16:06:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户修改', 100, 3, '', '', '', 0, 0, 'F', '1', '1', 'system:user:edit', '#', 'admin', '2024-06-13 16:06:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户删除', 100, 4, '', '', '', 0, 0, 'F', '1', '1', 'system:user:remove', '#', 'admin', '2024-06-13 16:06:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导出', 100, 5, '', '', '', 0, 0, 'F', '1', '1', 'system:user:export', '#', 'admin', '2024-06-13 16:06:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '用户导入', 100, 6, '', '', '', 0, 0, 'F', '1', '1', 'system:user:import', '#', 'admin', '2024-06-13 16:06:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '重置密码', 100, 7, '', '', '', 0, 0, 'F', '1', '1', 'system:user:resetPwd', '#', 'admin', '2024-06-13 16:06:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色查询', 101, 1, '', '', '', 0, 0, 'F', '1', '1', 'system:role:query', '#', 'admin', '2024-06-13 16:06:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色新增', 101, 2, '', '', '', 0, 0, 'F', '1', '1', 'system:role:add', '#', 'admin', '2024-06-13 16:06:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色修改', 101, 3, '', '', '', 0, 0, 'F', '1', '1', 'system:role:edit', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色删除', 101, 4, '', '', '', 0, 0, 'F', '1', '1', 'system:role:remove', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '角色导出', 101, 5, '', '', '', 0, 0, 'F', '1', '1', 'system:role:export', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单查询', 102, 1, '', '', '', 0, 0, 'F', '1', '1', 'system:menu:query', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单新增', 102, 2, '', '', '', 0, 0, 'F', '1', '1', 'system:menu:add', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单修改', 102, 3, '', '', '', 0, 0, 'F', '1', '1', 'system:menu:edit', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '菜单删除', 102, 4, '', '', '', 0, 0, 'F', '1', '1', 'system:menu:remove', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门查询', 103, 1, '', '', '', 0, 0, 'F', '1', '1', 'system:dept:query', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门新增', 103, 2, '', '', '', 0, 0, 'F', '1', '1', 'system:dept:add', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门修改', 103, 3, '', '', '', 0, 0, 'F', '1', '1', 'system:dept:edit', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '部门删除', 103, 4, '', '', '', 0, 0, 'F', '1', '1', 'system:dept:remove', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位查询', 104, 1, '', '', '', 0, 0, 'F', '1', '1', 'system:post:query', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位新增', 104, 2, '', '', '', 0, 0, 'F', '1', '1', 'system:post:add', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位修改', 104, 3, '', '', '', 0, 0, 'F', '1', '1', 'system:post:edit', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位删除', 104, 4, '', '', '', 0, 0, 'F', '1', '1', 'system:post:remove', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '岗位导出', 104, 5, '', '', '', 0, 0, 'F', '1', '1', 'system:post:export', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典查询', 105, 1, '#', '', '', 0, 0, 'F', '1', '1', 'system:dict:query', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典新增', 105, 2, '#', '', '', 0, 0, 'F', '1', '1', 'system:dict:add', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典修改', 105, 3, '#', '', '', 0, 0, 'F', '1', '1', 'system:dict:edit', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典删除', 105, 4, '#', '', '', 0, 0, 'F', '1', '1', 'system:dict:remove', '#', 'admin', '2024-06-13 16:06:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '字典导出', 105, 5, '#', '', '', 0, 0, 'F', '1', '1', 'system:dict:export', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数查询', 106, 1, '#', '', '', 0, 0, 'F', '1', '1', 'system:config:query', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数新增', 106, 2, '#', '', '', 0, 0, 'F', '1', '1', 'system:config:add', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数修改', 106, 3, '#', '', '', 0, 0, 'F', '1', '1', 'system:config:edit', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数删除', 106, 4, '#', '', '', 0, 0, 'F', '1', '1', 'system:config:remove', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '参数导出', 106, 5, '#', '', '', 0, 0, 'F', '1', '1', 'system:config:export', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告查询', 107, 1, '#', '', '', 0, 0, 'F', '1', '1', 'system:notice:query', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告新增', 107, 2, '#', '', '', 0, 0, 'F', '1', '1', 'system:notice:add', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告修改', 107, 3, '#', '', '', 0, 0, 'F', '1', '1', 'system:notice:edit', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '公告删除', 107, 4, '#', '', '', 0, 0, 'F', '1', '1', 'system:notice:remove', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作查询', 500, 1, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:operlog:query', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '操作删除', 500, 2, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:operlog:remove', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '日志导出', 500, 4, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:operlog:export', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录查询', 501, 1, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:logininfor:query', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '登录删除', 501, 2, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:logininfor:remove', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '日志导出', 501, 3, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:logininfor:export', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:online:query', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:online:batchLogout', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:online:forceLogout', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '账户解锁', 501, 4, '#', '', '', 0, 0, 'F', '1', '1', 'monitor:logininfor:unlock', '#', 'admin', '2024-06-13 16:06:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 115, 1, '#', '', '', 0, 0, 'F', '1', '1', 'tool:gen:query', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 115, 2, '#', '', '', 0, 0, 'F', '1', '1', 'tool:gen:edit', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 115, 3, '#', '', '', 0, 0, 'F', '1', '1', 'tool:gen:remove', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 115, 2, '#', '', '', 0, 0, 'F', '1', '1', 'tool:gen:import', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 115, 4, '#', '', '', 0, 0, 'F', '1', '1', 'tool:gen:preview', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 115, 5, '#', '', '', 0, 0, 'F', '1', '1', 'tool:gen:code', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1600, '文件查询', 118, 1, '#', '', '', 0, 0, 'F', '1', '1', 'system:oss:query', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1601, '文件上传', 118, 2, '#', '', '', 0, 0, 'F', '1', '1', 'system:oss:upload', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1602, '文件下载', 118, 3, '#', '', '', 0, 0, 'F', '1', '1', 'system:oss:download', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1603, '文件删除', 118, 4, '#', '', '', 0, 0, 'F', '1', '1', 'system:oss:remove', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1604, '配置添加', 118, 5, '#', '', '', 0, 0, 'F', '1', '1', 'system:oss:add', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1605, '配置编辑', 118, 6, '#', '', '', 0, 0, 'F', '1', '1', 'system:oss:edit', '#', 'admin', '2024-06-13 16:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1808758090157985794, '基础资料', 0, 100, 'basic', NULL, NULL, 0, 0, 'M', '1', '1', NULL, 'excel', 'admin', '2024-07-04 15:01:48', 'admin', '2024-08-20 13:45:39', '');
INSERT INTO `sys_menu` VALUES (1809059968309743618, '往来单位', 1808758090157985794, 1, 'merchant', 'wms/basic/merchant/index', NULL, 0, 0, 'C', '1', '1', 'wms:merchant:list', 'documentation', 'admin', '2024-07-05 11:58:12', 'admin', '2024-08-27 16:41:53', '往来单位菜单');
INSERT INTO `sys_menu` VALUES (1809059968309743619, '往来单位查询', 1809059968309743618, 1, '#', '', NULL, 0, 0, 'F', '1', '1', 'wms:merchant:list', '#', 'admin', '2024-07-05 11:58:12', 'admin', '2024-08-30 10:43:54', '');
INSERT INTO `sys_menu` VALUES (1809059968309743621, '往来单位修改', 1809059968309743618, 3, '#', '', NULL, 0, 0, 'F', '1', '1', 'wms:merchant:edit', '#', 'admin', '2024-07-05 11:58:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1813458070128599041, '仓库管理', 1808758090157985794, 2, 'warehouse', 'wms/basic/warehouse/index', NULL, 0, 0, 'C', '1', '1', 'wms:warehouse:list', 'documentation', 'admin', '2024-07-17 14:17:51', 'wms2_admin', '2024-09-10 13:38:53', '');
INSERT INTO `sys_menu` VALUES (1813820131794837506, '商品管理', 1808758090157985794, 4, 'item', 'wms/basic/item/index', NULL, 0, 0, 'C', '1', '1', 'wms:item:list', 'documentation', 'admin', '2024-07-18 14:16:33', 'admin', '2024-08-27 16:43:06', '');
INSERT INTO `sys_menu` VALUES (1815207165755183105, '编辑入库单', 0, 1000, 'receiptOrderEdit', 'wms/order/receipt/edit', NULL, 0, 0, 'C', '0', '1', 'wms:receipt:edit', '#', 'admin', '2024-07-22 10:08:08', 'admin', '2024-08-27 16:43:28', '');
INSERT INTO `sys_menu` VALUES (1818123963605549057, '品牌管理', 1808758090157985794, 3, 'itemBrand', 'wms/basic/itemBrand/index', NULL, 0, 0, 'C', '1', '1', 'wms:itemBrand:list', 'documentation', 'admin', '2024-07-30 11:18:27', 'admin', '2024-08-27 16:42:55', '');
INSERT INTO `sys_menu` VALUES (1818466281474822145, '入库', 0, 20, 'receiptOrder', 'wms/order/receipt/index', NULL, 0, 0, 'C', '1', '1', 'wms:receipt:all', 'exit-fullscreen', 'admin', '2024-07-31 09:58:42', 'admin', '2024-08-30 08:58:25', '');
INSERT INTO `sys_menu` VALUES (1818854933803638785, '出库', 0, 30, 'shipmentOrder', 'wms/order/shipment/index', NULL, 0, 0, 'C', '1', '1', 'wms:shipment:all', 'fullscreen', 'admin', '2024-08-01 11:43:04', 'admin', '2024-08-30 08:58:35', '');
INSERT INTO `sys_menu` VALUES (1818855673632727042, '编辑出库单', 0, 1000, 'shipmentOrderEdit', 'wms/order/shipment/edit', NULL, 0, 0, 'C', '0', '1', 'wms:shipment:edit', '#', 'admin', '2024-08-01 11:46:00', 'admin', '2024-08-27 16:43:37', '');
INSERT INTO `sys_menu` VALUES (1820729144067321858, '库存统计', 0, 0, 'inventory', 'wms/inventory/statistic', NULL, 0, 0, 'C', '1', '1', 'wms:inventory:all', 'chart', 'admin', '2024-08-06 15:50:30', 'admin', '2024-08-30 08:57:48', '');
INSERT INTO `sys_menu` VALUES (1821075355068559361, '库存记录', 0, 3, 'inventoryHistory', 'wms/inventory/history', NULL, 0, 0, 'C', '1', '1', 'wms:inventoryHistory:all', 'list', 'admin', '2024-08-07 14:46:13', 'admin', '2024-08-30 08:58:13', '');
INSERT INTO `sys_menu` VALUES (1822820194307051521, '移库', 0, 40, 'movementOrder', 'wms/order/movement/index', NULL, 0, 0, 'C', '1', '1', 'wms:movement:all', 'drag', 'admin', '2024-08-12 10:19:35', 'admin', '2024-08-30 08:58:44', '');
INSERT INTO `sys_menu` VALUES (1822862323595145218, '编辑移库单', 0, 1000, 'movementOrderEdit', 'wms/order/movement/edit', NULL, 0, 0, 'C', '0', '1', 'wms:movement:edit', '#', 'admin', '2024-08-12 13:07:00', 'admin', '2024-08-27 16:43:50', '');
INSERT INTO `sys_menu` VALUES (1823187248797270018, '盘库', 0, 50, 'checkOrder', 'wms/order/check/index', NULL, 0, 0, 'C', '1', '1', 'wms:check:all', 'example', 'admin', '2024-08-13 10:38:08', 'admin', '2024-08-30 08:58:57', '');
INSERT INTO `sys_menu` VALUES (1823190638784757762, '编辑盘库单', 0, 1000, 'checkOrderEdit', 'wms/order/check/edit', NULL, 0, 0, 'C', '0', '1', 'wms:check:edit', '#', 'admin', '2024-08-13 10:51:36', 'admin', '2024-08-27 16:43:44', '');
INSERT INTO `sys_menu` VALUES (1829349433573822466, '仓库查询', 1813458070128599041, 1, '', NULL, NULL, 0, 0, 'F', '1', '1', 'wms:warehouse:list', '#', 'admin', '2024-08-30 10:44:27', 'wms2_admin', '2024-09-10 13:39:02', '');
INSERT INTO `sys_menu` VALUES (1829350022131142658, '仓库编辑', 1813458070128599041, 2, '', NULL, NULL, 0, 0, 'F', '1', '1', 'wms:warehouse:edit', '#', 'admin', '2024-08-30 10:46:48', 'wms2_admin', '2024-09-10 13:39:10', '');
INSERT INTO `sys_menu` VALUES (1829350164603260929, '品牌查询', 1818123963605549057, 1, '', NULL, NULL, 0, 0, 'F', '1', '1', 'wms:itemBrand:list', '#', 'admin', '2024-08-30 10:47:22', 'admin', '2024-08-30 10:47:22', '');
INSERT INTO `sys_menu` VALUES (1829350944311791617, '品牌编辑', 1818123963605549057, 2, '', NULL, NULL, 0, 0, 'F', '1', '1', 'wms:itemBrand:edit', '#', 'admin', '2024-08-30 10:50:27', 'admin', '2024-08-30 10:50:27', '');
INSERT INTO `sys_menu` VALUES (1829351081448755202, '商品查询', 1813820131794837506, 1, '', NULL, NULL, 0, 0, 'F', '1', '1', 'wms:item:list', '#', 'admin', '2024-08-30 10:51:00', 'admin', '2024-08-30 10:51:00', '');
INSERT INTO `sys_menu` VALUES (1829351166857367553, '商品编辑', 1813820131794837506, 2, '', NULL, NULL, 0, 0, 'F', '1', '1', 'wms:item:edit', '#', 'admin', '2024-08-30 10:51:21', 'admin', '2024-08-30 10:51:21', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` bigint(20) NOT NULL COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '1', 'admin', '2024-06-13 16:06:38', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '1', 'admin', '2024-06-13 16:06:38', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(20) NOT NULL COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(1) NULL DEFAULT 0 COMMENT '操作状态（0异常 1正常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_oss
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss`;
CREATE TABLE `sys_oss`  (
  `oss_id` bigint(20) NOT NULL COMMENT '对象存储主键',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件名',
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '原名',
  `file_suffix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件后缀名',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'URL地址',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '上传人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新人',
  `service` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'minio' COMMENT '服务商',
  PRIMARY KEY (`oss_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OSS对象存储表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_oss_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss_config`;
CREATE TABLE `sys_oss_config`  (
  `oss_config_id` bigint(20) NOT NULL COMMENT '主建',
  `config_key` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配置key',
  `access_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'accessKey',
  `secret_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '秘钥',
  `bucket_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '桶名称',
  `prefix` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '前缀',
  `endpoint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '访问站点',
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '自定义域名',
  `is_https` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否https（Y=是,N=否）',
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '域',
  `access_policy` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '桶权限类型(0=private 1=public 2=custom)',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否默认（0=是,1=否）',
  `ext1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '扩展字段',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`oss_config_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '对象存储配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oss_config
-- ----------------------------
INSERT INTO `sys_oss_config` VALUES (1, 'minio', 'ruoyi', 'ruoyi123', 'ruoyi', '', '127.0.0.1:9000', '', 'N', '', '1', '0', '', 'admin', '2024-06-13 16:06:38', 'admin', '2024-08-16 16:48:05', NULL);
INSERT INTO `sys_oss_config` VALUES (2, 'qiniu', 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXX', 'ruoyi', '', 's3-cn-north-1.qiniucs.com', '', 'N', '', '1', '0', '', 'admin', '2024-06-13 16:06:38', 'admin', '2024-06-13 16:06:38', NULL);
INSERT INTO `sys_oss_config` VALUES (3, 'aliyun', 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXX', 'ruoyi', '', 'oss-cn-beijing.aliyuncs.com', '', 'N', '', '1', '0', '', 'admin', '2024-06-13 16:06:38', 'admin', '2024-07-10 17:50:41', NULL);
INSERT INTO `sys_oss_config` VALUES (4, 'qcloud', 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXX', 'ruoyi-1250000000', '', 'cos.ap-beijing.myqcloud.com', '', 'N', 'ap-beijing', '1', '0', '', 'admin', '2024-06-13 16:06:38', 'admin', '2024-06-13 16:06:38', NULL);
INSERT INTO `sys_oss_config` VALUES (5, 'image', 'ruoyi', 'ruoyi123', 'ruoyi', 'image', '127.0.0.1:9000', '', 'N', '', '1', '0', '', 'admin', '2024-06-13 16:06:38', 'admin', '2024-06-13 16:06:38', NULL);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '1', 'admin', '2024-06-13 16:06:25', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '1', 'admin', '2024-06-13 16:06:25', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '1', 'admin', '2024-06-13 16:06:25', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '1', 'admin', '2024-06-13 16:06:25', '', NULL, '');
INSERT INTO `sys_post` VALUES (1811656351757385729, 'caiwu8989', '财务', 5, '1', 'admin', '2024-07-12 22:58:28', 'admin', '2024-07-12 14:58:38', NULL);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '1', '0', 'admin', '2024-06-13 16:06:26', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '1', '1', 'admin', '2024-06-13 16:06:26', 'admin', '2024-07-10 17:13:05', '普通角色');
INSERT INTO `sys_role` VALUES (1811607750859661314, '测试角色1', 'test1', 2, '1', 1, 1, '1', '1', 'admin', '2024-07-12 11:45:21', 'admin', '2024-07-12 11:45:21', NULL);
INSERT INTO `sys_role` VALUES (1811629311809396737, '测试角色2', 'test2', 3, '1', 1, 1, '1', '1', 'admin', '2024-07-12 13:11:01', 'admin', '2024-07-12 13:11:01', NULL);
INSERT INTO `sys_role` VALUES (1829105952432427010, '试用', 'trier', 0, '1', 1, 1, '1', '0', 'admin', '2024-08-29 18:36:57', 'admin', '2024-09-11 16:32:53', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1808758090157985794);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1809059968309743618);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1809059968309743619);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1813458070128599041);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1813820131794837506);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1815207165755183105);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1818123963605549057);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1818466281474822145);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1818854933803638785);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1818855673632727042);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1820729144067321858);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1821075355068559361);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1822820194307051521);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1822862323595145218);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1823187248797270018);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1823190638784757762);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1829349433573822466);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1829350164603260929);
INSERT INTO `sys_role_menu` VALUES (1829105952432427010, 1829351081448755202);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'sys_user' COMMENT '用户类型（sys_user系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '程序员诚哥', 'sys_user', 'zccbbg@qq.com', '18888888888', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '1', '0', '221.224.86.138', '2024-10-09 15:21:06', 'admin', '2024-06-13 16:06:25', 'wms2_admin', '2024-10-09 15:21:06', '管理员');
INSERT INTO `sys_user` VALUES (1829105396288688129, 105, 'ck', 'ck', 'sys_user', '', '', '0', '', '$2a$10$5ogFpqit10a8IpVFjKzosuz0whR0/tyQ4Nt9e6y3/MBodcDzwhCni', '1', '0', '221.224.86.138', '2024-10-09 15:40:16', 'admin', '2024-08-29 18:34:44', 'ck', '2024-10-09 15:40:16', NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (1829105396288688129, 1829105952432427010);

-- ----------------------------
-- Table structure for wms_check_order
-- ----------------------------
DROP TABLE IF EXISTS `wms_check_order`;
CREATE TABLE `wms_check_order`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '盘点单号',
  `order_status` tinyint(4) NULL DEFAULT 11 COMMENT '库存盘点单状态 -1：作废 0：未盘库 1：已盘库',
  `total_quantity` decimal(20, 2) NULL DEFAULT NULL COMMENT '盈亏数',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL,
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '所属仓库',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920323943682050 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '库存盘点单据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_check_order
-- ----------------------------
INSERT INTO `wms_check_order` VALUES (1843920323943682049, 'PK10091586', 1, 2.00, NULL, 1828364740028174337, NULL, 'ck', '2024-10-09 15:43:58.273', 'ck', '2024-10-09 15:43:58.273');

-- ----------------------------
-- Table structure for wms_check_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `wms_check_order_detail`;
CREATE TABLE `wms_check_order_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL COMMENT '盘点单id',
  `sku_id` bigint(20) NOT NULL COMMENT '规格id',
  `quantity` decimal(20, 2) NULL DEFAULT NULL COMMENT '库存数量',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额',
  `check_quantity` decimal(20, 2) NULL DEFAULT NULL COMMENT '盘点数量',
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '所属仓库',
  `inventory_id` bigint(20) NULL DEFAULT NULL COMMENT '库存id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920323981430788 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '库存盘点单据详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_check_order_detail
-- ----------------------------
INSERT INTO `wms_check_order_detail` VALUES (1843920323981430786, 1843920323943682049, 1840282974696374273, 0.00, NULL, 1.00, 1828364740028174337, NULL, NULL, 'ck', '2024-10-09 15:43:58.283', 'ck', '2024-10-09 15:43:58.283');
INSERT INTO `wms_check_order_detail` VALUES (1843920323981430787, 1843920323943682049, 1840282974629265410, 0.00, NULL, 1.00, 1828364740028174337, NULL, NULL, 'ck', '2024-10-09 15:43:58.287', 'ck', '2024-10-09 15:43:58.287');

-- ----------------------------
-- Table structure for wms_inventory
-- ----------------------------
DROP TABLE IF EXISTS `wms_inventory`;
CREATE TABLE `wms_inventory`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT '规格ID',
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '所属仓库',
  `quantity` decimal(20, 2) NULL DEFAULT NULL COMMENT '库存',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920324082094083 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '库存表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_inventory
-- ----------------------------
INSERT INTO `wms_inventory` VALUES (1843920012193648642, 1840282974696374273, 1828364609002311682, 3.00, NULL, 'ck', '2024-10-09 15:42:43.944', 'ck', '2024-10-09 15:43:42.419');
INSERT INTO `wms_inventory` VALUES (1843920012193648643, 1840282974629265410, 1828364609002311682, 3.00, NULL, 'ck', '2024-10-09 15:42:43.945', 'ck', '2024-10-09 15:43:12.844');
INSERT INTO `wms_inventory` VALUES (1843920257526878210, 1840282974696374273, 1840317750635581441, 1.00, NULL, 'ck', '2024-10-09 15:43:42.434', 'ck', '2024-10-09 15:43:42.434');
INSERT INTO `wms_inventory` VALUES (1843920324082094081, 1840282974696374273, 1828364740028174337, 1.00, NULL, 'ck', '2024-10-09 15:43:58.304', 'ck', '2024-10-09 15:43:58.304');
INSERT INTO `wms_inventory` VALUES (1843920324082094082, 1840282974629265410, 1828364740028174337, 1.00, NULL, 'ck', '2024-10-09 15:43:58.306', 'ck', '2024-10-09 15:43:58.306');

-- ----------------------------
-- Table structure for wms_inventory_history
-- ----------------------------
DROP TABLE IF EXISTS `wms_inventory_history`;
CREATE TABLE `wms_inventory_history`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '所属仓库',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT '物料ID',
  `quantity` decimal(20, 2) NULL DEFAULT NULL COMMENT '库存变化',
  `before_quantity` decimal(20, 2) NULL DEFAULT NULL COMMENT '更新前数量',
  `after_quantity` decimal(20, 2) NULL DEFAULT NULL COMMENT '更新后数量',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '操作id（出库、入库、库存移动表单id）',
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作单号（入库、出库、移库、盘库单号）',
  `order_type` int(11) NULL DEFAULT NULL COMMENT '操作类型',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920324157591555 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '库存记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_inventory_history
-- ----------------------------
INSERT INTO `wms_inventory_history` VALUES (1843920012248174593, 1828364609002311682, 1840282974696374273, 4.00, 0.00, 4.00, 4000.00, NULL, 1843920012030070785, 'RK10098845', 1, '2024-10-09 15:42:43.958');
INSERT INTO `wms_inventory_history` VALUES (1843920012248174594, 1828364609002311682, 1840282974629265410, 4.00, 0.00, 4.00, 4000.00, NULL, 1843920012030070785, 'RK10098845', 1, '2024-10-09 15:42:43.960');
INSERT INTO `wms_inventory_history` VALUES (1843920133446782977, 1828364609002311682, 1840282974629265410, -1.00, 4.00, 3.00, NULL, NULL, 1843920133316759553, 'CK10094547', 2, '2024-10-09 15:43:12.851');
INSERT INTO `wms_inventory_history` VALUES (1843920257560432641, 1828364609002311682, 1840282974696374273, -1.00, 4.00, 3.00, NULL, NULL, 1843920257199722498, 'YK10096786', 3, '2024-10-09 15:43:42.442');
INSERT INTO `wms_inventory_history` VALUES (1843920257581404162, 1840317750635581441, 1840282974696374273, 1.00, 0.00, 1.00, NULL, NULL, 1843920257199722498, 'YK10096786', 3, '2024-10-09 15:43:42.448');
INSERT INTO `wms_inventory_history` VALUES (1843920324149202945, 1828364740028174337, 1840282974696374273, 1.00, 0.00, 1.00, NULL, NULL, NULL, 'PK10091586', 4, '2024-10-09 15:43:58.318');
INSERT INTO `wms_inventory_history` VALUES (1843920324157591554, 1828364740028174337, 1840282974629265410, 1.00, 0.00, 1.00, NULL, NULL, NULL, 'PK10091586', 4, '2024-10-09 15:43:58.320');

-- ----------------------------
-- Table structure for wms_item
-- ----------------------------
DROP TABLE IF EXISTS `wms_item`;
CREATE TABLE `wms_item`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '编号',
  `item_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `item_category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位类别',
  `item_brand` bigint(20) NULL DEFAULT NULL COMMENT '品牌',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1840308261127651331 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '物料' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_item
-- ----------------------------
INSERT INTO `wms_item` VALUES (1828402622516334594, NULL, '华为 nova flip', '1828364988754595841', NULL, 1828364927610032129, NULL, 'admin', '2024-08-27 20:02:09.948', 'admin', '2024-09-02 21:45:27.127');
INSERT INTO `wms_item` VALUES (1828406450112335874, NULL, 'macbook', '1828365043024695297', NULL, 1828364873889386498, NULL, 'admin', '2024-08-27 20:17:22.521', 'admin', '2024-08-27 20:17:22.521');
INSERT INTO `wms_item` VALUES (1828407870173646849, NULL, '爱普生打印机', '1828365014901886978', NULL, NULL, NULL, 'admin', '2024-08-27 20:23:01.096', 'admin', '2024-08-27 20:23:01.096');
INSERT INTO `wms_item` VALUES (1828408320146968578, NULL, '小米米家436L十字四门风冷无霜嵌入式家用冰箱', '1828405773474631681', NULL, 1828364846953566209, NULL, 'admin', '2024-08-27 20:24:48.375', 'admin', '2024-08-27 20:24:48.375');
INSERT INTO `wms_item` VALUES (1828408795734904833, NULL, '杠铃', '1828408600515219457', NULL, NULL, NULL, 'admin', '2024-08-27 20:26:41.757', 'admin', '2024-08-27 20:33:27.034');
INSERT INTO `wms_item` VALUES (1829398192563351554, NULL, '舟山带鱼', '1829398007993004034', NULL, NULL, NULL, 'admin', '2024-08-30 13:58:12.354', 'admin', '2024-08-30 14:01:08.050');
INSERT INTO `wms_item` VALUES (1829398333580046338, NULL, '青岛大虾', '1829398007993004034', NULL, NULL, NULL, 'admin', '2024-08-30 13:58:45.971', 'admin', '2024-08-30 14:00:49.686');
INSERT INTO `wms_item` VALUES (1829398492388978689, NULL, '启东黄鱼', '1829398007993004034', NULL, NULL, NULL, 'admin', '2024-08-30 13:59:23.834', 'admin', '2024-08-30 14:00:32.373');
INSERT INTO `wms_item` VALUES (1829398701680553985, NULL, '红富士苹果', '1829397958923841538', NULL, NULL, NULL, 'admin', '2024-08-30 14:00:13.735', 'admin', '2024-08-30 14:00:13.735');
INSERT INTO `wms_item` VALUES (1829399118040723457, NULL, '树山梨', '1829397958923841538', NULL, NULL, NULL, 'admin', '2024-08-30 14:01:52.989', 'admin', '2024-08-30 14:01:52.989');
INSERT INTO `wms_item` VALUES (1840282974297915394, NULL, '小米空调', '1840282771834667010', NULL, 1828364846953566209, NULL, 'wms2_admin', '2024-09-29 14:50:26.535', 'wms2_admin', '2024-09-29 14:50:26.535');

-- ----------------------------
-- Table structure for wms_item_brand
-- ----------------------------
DROP TABLE IF EXISTS `wms_item_brand`;
CREATE TABLE `wms_item_brand`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '品牌名称',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1828407291103842307 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品品牌表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_item_brand
-- ----------------------------
INSERT INTO `wms_item_brand` VALUES (1828364846953566209, '小米', 'admin', '2024-08-27 17:32:03.551', 'admin', '2024-08-27 17:32:03.551');
INSERT INTO `wms_item_brand` VALUES (1828364873889386498, '苹果', 'admin', '2024-08-27 17:32:09.971', 'admin', '2024-08-27 17:32:09.971');
INSERT INTO `wms_item_brand` VALUES (1828364927610032129, '华为', 'admin', '2024-08-27 17:32:22.786', 'admin', '2024-08-27 17:32:22.786');
INSERT INTO `wms_item_brand` VALUES (1828407151135723522, '爱普生', 'admin', '2024-08-27 20:20:09.656', 'admin', '2024-08-27 20:20:09.656');
INSERT INTO `wms_item_brand` VALUES (1828407291103842306, '惠普', 'admin', '2024-08-27 20:20:43.031', 'admin', '2024-08-27 20:20:43.031');

-- ----------------------------
-- Table structure for wms_item_category
-- ----------------------------
DROP TABLE IF EXISTS `wms_item_category`;
CREATE TABLE `wms_item_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '物料类型id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父物料类型id',
  `category_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '物料类型名称',
  `order_num` int(11) NULL DEFAULT 0 COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '物料类型状态（0停用 1正常）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1840282771834667011 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '物料类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_item_category
-- ----------------------------
INSERT INTO `wms_item_category` VALUES (1828364988754595841, 0, '手机', 0, '1', 'admin', '2024-08-27 17:32:37.357', 'admin', '2024-08-27 20:14:12.100');
INSERT INTO `wms_item_category` VALUES (1828365014901886978, 0, '打印机', 1, '1', 'admin', '2024-08-27 17:32:43.598', 'admin', '2024-08-27 20:14:12.447');
INSERT INTO `wms_item_category` VALUES (1828365043024695297, 0, '电脑', 3, '1', 'admin', '2024-08-27 17:32:50.301', 'admin', '2024-08-27 20:14:12.704');
INSERT INTO `wms_item_category` VALUES (1828405743737016322, 0, '家电', 4, '1', 'admin', '2024-08-27 20:14:34.104', 'admin', '2024-08-27 20:14:34.104');
INSERT INTO `wms_item_category` VALUES (1828405773474631681, 1828405743737016322, '冰箱', 0, '1', 'admin', '2024-08-27 20:14:41.195', 'admin', '2024-08-27 20:14:41.195');
INSERT INTO `wms_item_category` VALUES (1828405825714688001, 1828405743737016322, '电视', 1, '1', 'admin', '2024-08-27 20:14:53.651', 'admin', '2024-08-27 20:14:53.651');
INSERT INTO `wms_item_category` VALUES (1828408600515219457, 0, '健生器材', 5, '1', 'admin', '2024-08-27 20:25:55.213', 'admin', '2024-08-27 20:25:55.213');
INSERT INTO `wms_item_category` VALUES (1829397860466749441, 0, '生鲜', 6, '1', 'admin', '2024-08-30 13:56:53.174', 'admin', '2024-08-30 13:56:53.174');
INSERT INTO `wms_item_category` VALUES (1829397958923841538, 1829397860466749441, '水果', 0, '1', 'admin', '2024-08-30 13:57:16.644', 'admin', '2024-08-30 13:57:16.644');
INSERT INTO `wms_item_category` VALUES (1829398007993004034, 1829397860466749441, '海鲜', 1, '1', 'admin', '2024-08-30 13:57:28.347', 'admin', '2024-08-30 13:57:28.347');
INSERT INTO `wms_item_category` VALUES (1840282771834667010, 1828405743737016322, '空调', 2, '1', 'wms2_admin', '2024-09-29 14:49:38.274', 'wms2_admin', '2024-09-29 14:49:38.274');

-- ----------------------------
-- Table structure for wms_item_sku
-- ----------------------------
DROP TABLE IF EXISTS `wms_item_sku`;
CREATE TABLE `wms_item_sku`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规格名称',
  `item_id` bigint(20) NULL DEFAULT NULL,
  `barcode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '条码',
  `sku_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '编码',
  `length` decimal(10, 1) NULL DEFAULT NULL COMMENT '长，单位cm',
  `width` decimal(10, 1) NULL DEFAULT NULL COMMENT '宽，单位cm',
  `height` decimal(10, 1) NULL DEFAULT NULL COMMENT '高，单位cm',
  `gross_weight` decimal(10, 3) NULL DEFAULT NULL COMMENT '毛重，单位kg',
  `net_weight` decimal(10, 3) NULL DEFAULT NULL COMMENT '净重，单位kg',
  `cost_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '成本价（元）',
  `selling_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售价（元）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1840308261463195650 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'sku信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_item_sku
-- ----------------------------
INSERT INTO `wms_item_sku` VALUES (1828402624005312514, '黑', 1828402622516334594, 'x00003', '00001', NULL, NULL, NULL, NULL, NULL, 5000.00, 5288.00, 'admin', '2024-08-27 20:02:10.302', 'admin', '2024-09-02 21:45:27.177');
INSERT INTO `wms_item_sku` VALUES (1828402624005312515, '白', 1828402622516334594, '', '000002', NULL, NULL, NULL, NULL, NULL, 5000.00, 5288.00, 'admin', '2024-08-27 20:02:10.304', 'admin', '2024-09-02 21:45:27.184');
INSERT INTO `wms_item_sku` VALUES (1828402624005312516, '粉', 1828402622516334594, '', '00003', NULL, NULL, NULL, NULL, NULL, 5000.00, 5288.00, 'admin', '2024-08-27 20:02:10.305', 'admin', '2024-09-02 21:45:27.190');
INSERT INTO `wms_item_sku` VALUES (1828406451399987201, 'pro', 1828406450112335874, '', 'mac0001', NULL, NULL, NULL, NULL, NULL, NULL, 24999.00, 'admin', '2024-08-27 20:17:22.821', 'admin', '2024-08-27 20:17:22.821');
INSERT INTO `wms_item_sku` VALUES (1828407871469686786, 'l6468', 1828407870173646849, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3188.00, 'admin', '2024-08-27 20:23:01.393', 'admin', '2024-08-27 20:23:01.393');
INSERT INTO `wms_item_sku` VALUES (1828408321522700289, '白色', 1828408320146968578, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2699.00, 'admin', '2024-08-27 20:24:48.697', 'admin', '2024-08-27 20:24:48.697');
INSERT INTO `wms_item_sku` VALUES (1828408796968030210, '10kg', 1828408795734904833, '102025115', NULL, NULL, NULL, NULL, NULL, 10.000, NULL, NULL, 'admin', '2024-08-27 20:26:42.049', 'admin', '2024-08-27 20:33:27.395');
INSERT INTO `wms_item_sku` VALUES (1828408796968030211, '20kg', 1828408795734904833, '254523055', NULL, NULL, NULL, NULL, NULL, 20.000, NULL, NULL, 'admin', '2024-08-27 20:26:42.052', 'admin', '2024-08-27 20:33:27.515');
INSERT INTO `wms_item_sku` VALUES (1828408796968030212, '50kg', 1828408795734904833, '5204862525', NULL, NULL, NULL, NULL, NULL, 50.000, NULL, NULL, 'admin', '2024-08-27 20:26:42.052', 'admin', '2024-08-27 20:33:27.634');
INSERT INTO `wms_item_sku` VALUES (1829398193024724993, '大', 1829398192563351554, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 13:58:12.457', 'admin', '2024-08-30 14:01:08.172');
INSERT INTO `wms_item_sku` VALUES (1829398193024724994, '中', 1829398192563351554, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 13:58:12.458', 'admin', '2024-08-30 14:01:08.328');
INSERT INTO `wms_item_sku` VALUES (1829398333903007745, '大', 1829398333580046338, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 13:58:46.047', 'admin', '2024-08-30 14:00:49.854');
INSERT INTO `wms_item_sku` VALUES (1829398333903007746, '中', 1829398333580046338, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 13:58:46.048', 'admin', '2024-08-30 14:00:50.001');
INSERT INTO `wms_item_sku` VALUES (1829398492779048962, '大', 1829398492388978689, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 13:59:23.925', 'admin', '2024-08-30 14:00:32.544');
INSERT INTO `wms_item_sku` VALUES (1829398492779048963, '中', 1829398492388978689, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 13:59:23.925', 'admin', '2024-08-30 14:00:32.683');
INSERT INTO `wms_item_sku` VALUES (1829398702011904001, '大', 1829398701680553985, '', NULL, 10.0, 10.0, 10.0, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 14:00:13.810', 'admin', '2024-08-30 14:00:13.810');
INSERT INTO `wms_item_sku` VALUES (1829398702011904002, '中', 1829398701680553985, '', NULL, 5.0, 5.0, 5.0, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 14:00:13.812', 'admin', '2024-08-30 14:00:13.812');
INSERT INTO `wms_item_sku` VALUES (1829399118304964609, '大', 1829399118040723457, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 14:01:53.064', 'admin', '2024-08-30 14:01:53.064');
INSERT INTO `wms_item_sku` VALUES (1829399118304964610, '中', 1829399118040723457, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-30 14:01:53.064', 'admin', '2024-08-30 14:01:53.064');
INSERT INTO `wms_item_sku` VALUES (1840282974629265410, '1P', 1840282974297915394, '', NULL, NULL, NULL, NULL, NULL, NULL, 2000.00, NULL, 'wms2_admin', '2024-09-29 14:50:26.627', 'wms2_admin', '2024-09-29 14:50:26.627');
INSERT INTO `wms_item_sku` VALUES (1840282974696374273, '2P', 1840282974297915394, '', NULL, NULL, NULL, NULL, NULL, NULL, 3000.00, NULL, 'wms2_admin', '2024-09-29 14:50:26.628', 'wms2_admin', '2024-09-29 14:50:26.628');

-- ----------------------------
-- Table structure for wms_merchant
-- ----------------------------
DROP TABLE IF EXISTS `wms_merchant`;
CREATE TABLE `wms_merchant`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `merchant_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编号',
  `merchant_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `merchant_type` tinyint(4) NULL DEFAULT NULL COMMENT '企业类型',
  `merchant_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '级别',
  `bank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `bank_account` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行账户',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `mobile` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `tel` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '座机号',
  `contact_person` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Email',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1828354284882399234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '往来单位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_merchant
-- ----------------------------
INSERT INTO `wms_merchant` VALUES (1828354016258199554, 'c_0001', '苏州XXXXXXX仓储管理有限公司', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-27 16:49:01.319', 'admin', '2024-08-27 16:49:01.319');
INSERT INTO `wms_merchant` VALUES (1828354153193836545, 's_0001', '苏州XXXXX供应链有限公司', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-27 16:49:33.964', 'admin', '2024-08-27 16:49:33.964');
INSERT INTO `wms_merchant` VALUES (1828354284882399233, 'c_s_0001', '苏州CS有限公司', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', '2024-08-27 16:50:05.367', 'admin', '2024-08-27 16:50:05.367');

-- ----------------------------
-- Table structure for wms_movement_order
-- ----------------------------
DROP TABLE IF EXISTS `wms_movement_order`;
CREATE TABLE `wms_movement_order`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '编号',
  `source_warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '源仓库',
  `target_warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '目标仓库',
  `order_status` tinyint(4) NULL DEFAULT NULL COMMENT '状态',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '总金额',
  `total_quantity` decimal(10, 2) NULL DEFAULT NULL COMMENT '总数量',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920257199722499 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '移库单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_movement_order
-- ----------------------------
INSERT INTO `wms_movement_order` VALUES (1843920257199722498, 'YK10096786', 1828364609002311682, 1840317750635581441, 1, NULL, 1.00, NULL, 'ck', '2024-10-09 15:43:42.356', 'ck', '2024-10-09 15:43:42.356');

-- ----------------------------
-- Table structure for wms_movement_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `wms_movement_order_detail`;
CREATE TABLE `wms_movement_order_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '移库单Id',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT '规格id',
  `quantity` decimal(20, 2) NULL DEFAULT NULL COMMENT '数量',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `source_warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '源仓库',
  `target_warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '目标仓库',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920257237471234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '库存移动详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_movement_order_detail
-- ----------------------------
INSERT INTO `wms_movement_order_detail` VALUES (1843920257237471233, 1843920257199722498, 1840282974696374273, 1.00, NULL, NULL, 1828364609002311682, 1840317750635581441, 'ck', '2024-10-09 15:43:42.365', 'ck', '2024-10-09 15:43:42.365');

-- ----------------------------
-- Table structure for wms_receipt_order
-- ----------------------------
DROP TABLE IF EXISTS `wms_receipt_order`;
CREATE TABLE `wms_receipt_order`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '入库单号',
  `opt_type` int(11) NULL DEFAULT NULL COMMENT '入库类型',
  `merchant_id` bigint(20) NULL DEFAULT NULL COMMENT '供应商',
  `biz_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `total_quantity` decimal(10, 2) NULL DEFAULT NULL COMMENT '商品总数',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '订单金额',
  `order_status` tinyint(4) NULL DEFAULT NULL COMMENT '入库状态',
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '仓库id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920012030070786 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '入库单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_receipt_order
-- ----------------------------
INSERT INTO `wms_receipt_order` VALUES (1843920012030070785, 'RK10098845', 2, NULL, NULL, 8.00, NULL, 1, 1828364609002311682, NULL, 'ck', '2024-10-09 15:42:43.905', 'ck', '2024-10-09 15:42:43.905');

-- ----------------------------
-- Table structure for wms_receipt_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `wms_receipt_order_detail`;
CREATE TABLE `wms_receipt_order_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '入库单号',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT '规格id',
  `quantity` decimal(20, 2) NULL DEFAULT NULL COMMENT '入库数量',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额',
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '所属仓库',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920012105568259 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '入库单详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_receipt_order_detail
-- ----------------------------
INSERT INTO `wms_receipt_order_detail` VALUES (1843920012088791042, 1843920012030070785, 1840282974696374273, 4.00, 4000.00, 1828364609002311682, NULL, 'ck', '2024-10-09 15:42:43.920', 'ck', '2024-10-09 15:42:43.920');
INSERT INTO `wms_receipt_order_detail` VALUES (1843920012105568258, 1843920012030070785, 1840282974629265410, 4.00, 4000.00, 1828364609002311682, NULL, 'ck', '2024-10-09 15:42:43.922', 'ck', '2024-10-09 15:42:43.922');

-- ----------------------------
-- Table structure for wms_shipment_order
-- ----------------------------
DROP TABLE IF EXISTS `wms_shipment_order`;
CREATE TABLE `wms_shipment_order`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出库单号，系统自动生成',
  `opt_type` int(11) NULL DEFAULT NULL COMMENT '出库类型',
  `biz_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `merchant_id` bigint(20) NULL DEFAULT NULL COMMENT '客户',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '总金额',
  `total_quantity` decimal(10, 2) NULL DEFAULT NULL COMMENT '总数量',
  `order_status` tinyint(4) NULL DEFAULT NULL COMMENT '出库单状态',
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '仓库id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920133316759554 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '出库单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_shipment_order
-- ----------------------------
INSERT INTO `wms_shipment_order` VALUES (1843920133316759553, 'CK10094547', 2, NULL, NULL, NULL, 1.00, 1, 1828364609002311682, NULL, 'ck', '2024-10-09 15:43:12.821', 'ck', '2024-10-09 15:43:12.821');

-- ----------------------------
-- Table structure for wms_shipment_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `wms_shipment_order_detail`;
CREATE TABLE `wms_shipment_order_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '出库单',
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '所属仓库',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT '规格id',
  `quantity` decimal(10, 2) NULL DEFAULT NULL COMMENT '数量',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1843920133354508290 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '出库单详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_shipment_order_detail
-- ----------------------------
INSERT INTO `wms_shipment_order_detail` VALUES (1843920133354508289, 1843920133316759553, 1828364609002311682, 1840282974629265410, 1.00, NULL, NULL, 'ck', '2024-10-09 15:43:12.830', 'ck', '2024-10-09 15:43:12.830');

-- ----------------------------
-- Table structure for wms_warehouse
-- ----------------------------
DROP TABLE IF EXISTS `wms_warehouse`;
CREATE TABLE `wms_warehouse`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `warehouse_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '编号',
  `warehouse_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `order_num` bigint(20) NULL DEFAULT 0 COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1840317750635581442 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '仓库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wms_warehouse
-- ----------------------------
INSERT INTO `wms_warehouse` VALUES (1828364609002311682, NULL, '苏州园区', NULL, 1, 'admin', '2024-08-27 17:31:06.821', 'admin', '2024-08-27 17:31:06.821');
INSERT INTO `wms_warehouse` VALUES (1828364740028174337, NULL, '常熟冷链仓', NULL, 2, 'admin', '2024-08-27 17:31:38.066', 'admin', '2024-08-30 13:55:34.766');
INSERT INTO `wms_warehouse` VALUES (1840317750635581441, NULL, '吴江仓', NULL, 3, 'wms2_admin', '2024-09-29 17:08:37.859', 'wms2_admin', '2024-09-29 17:08:37.859');

-- ----------------------------
-- Table structure for wms_area
-- ----------------------------
DROP TABLE IF EXISTS `wms_area`;
CREATE TABLE `wms_area`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '货区编号',
  `area_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '货区名称',
  `warehouse_id` bigint(20) NOT NULL COMMENT '所属仓库ID',
  `area_type` int(11) NULL DEFAULT 1 COMMENT '货区类型（1:普通货区 2:置换区 3:其他）',
  `order_num` bigint(20) NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_warehouse_id` (`warehouse_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '货区表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_bin
-- ----------------------------
DROP TABLE IF EXISTS `wms_bin`;
CREATE TABLE `wms_bin`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '货位编号（binCode）',
  `bin_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '货位名称',
  `warehouse_id` bigint(20) NOT NULL COMMENT '所属仓库ID',
  `area_id` bigint(20) NULL DEFAULT NULL COMMENT '所属货区ID',
  `bin_type` int(11) NULL DEFAULT 1 COMMENT '货位类型（1:普通货位 2:暂存位 3:其他）',
  `temperature_zone` int(11) NULL DEFAULT 1 COMMENT '温区（1:常温 2:冷藏 3:冷冻 4:其他）',
  `capacity` decimal(10, 2) NULL DEFAULT NULL COMMENT '容量（单位：立方米或托盘数）',
  `used_capacity` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '当前占用容量',
  `status` int(11) NULL DEFAULT 0 COMMENT '状态（0:空闲 1:占用 2:禁用 3:锁定-任务中）',
  `order_num` bigint(20) NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_bin_code` (`bin_code`) USING BTREE,
  INDEX `idx_warehouse_id` (`warehouse_id`) USING BTREE,
  INDEX `idx_area_id` (`area_id`) USING BTREE,
  INDEX `idx_status` (`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '货位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_material_type
-- ----------------------------
DROP TABLE IF EXISTS `wms_material_type`;
CREATE TABLE `wms_material_type`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物料类型编号',
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '物料类型名称（如：阀门）',
  `order_num` bigint(20) NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '物料类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_pallet_type
-- ----------------------------
DROP TABLE IF EXISTS `wms_pallet_type`;
CREATE TABLE `wms_pallet_type`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '托盘类型编号（如：SMALL、LARGE）',
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '托盘类型名称',
  `fixed_quantity` int(11) NULL DEFAULT NULL COMMENT '固定数量（如：1类托盘132个、2类托盘33个）',
  `length` decimal(10, 2) NULL DEFAULT NULL COMMENT '长度（cm）',
  `width` decimal(10, 2) NULL DEFAULT NULL COMMENT '宽度（cm）',
  `height` decimal(10, 2) NULL DEFAULT NULL COMMENT '高度（cm）',
  `load_capacity` decimal(10, 2) NULL DEFAULT NULL COMMENT '载重（kg）',
  `agv_vehicle_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'AGV识别的载具类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_type_code` (`type_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '托盘类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_pallet
-- ----------------------------
DROP TABLE IF EXISTS `wms_pallet`;
CREATE TABLE `wms_pallet`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pallet_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '托盘编号',
  `pallet_type_id` bigint(20) NOT NULL COMMENT '托盘类型ID',
  `current_bin_id` bigint(20) NULL DEFAULT NULL COMMENT '当前所在货位ID（binCode对应的ID）',
  `current_bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '当前所在货位编号（binCode）',
  `is_empty` int(11) NULL DEFAULT 1 COMMENT '是否为空托（0:否 1:是）',
  `is_bound` int(11) NULL DEFAULT 0 COMMENT '是否已绑定物料（0:否 1:是）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0:正常 1:禁用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pallet_code` (`pallet_code`) USING BTREE,
  INDEX `idx_pallet_type_id` (`pallet_type_id`) USING BTREE,
  INDEX `idx_current_bin_id` (`current_bin_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '托盘表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_valve
-- ----------------------------
DROP TABLE IF EXISTS `wms_valve`;
CREATE TABLE `wms_valve`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `valve_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '阀门编号（valveNo）',
  `material_type_id` bigint(20) NULL DEFAULT NULL COMMENT '物料类型ID（ValveType）',
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '型号（如：DN50、DN80）',
  `manufacturer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '厂家',
  `batch_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '批次',
  `pallet_id` bigint(20) NULL DEFAULT NULL COMMENT '所属托盘ID',
  `pallet_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属托盘编号',
  `current_bin_id` bigint(20) NULL DEFAULT NULL COMMENT '当前所在货位ID',
  `current_bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '当前所在货位编号',
  `status` int(11) NULL DEFAULT 0 COMMENT '状态（0:在库 1:检测中 2:已检测 3:已出库）',
  `production_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `expiry_date` date NULL DEFAULT NULL COMMENT '过期日期',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_valve_no` (`valve_no`) USING BTREE,
  INDEX `idx_material_type_id` (`material_type_id`) USING BTREE,
  INDEX `idx_pallet_id` (`pallet_id`) USING BTREE,
  INDEX `idx_current_bin_id` (`current_bin_id`) USING BTREE,
  INDEX `idx_status` (`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '阀门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_barcode
-- ----------------------------
DROP TABLE IF EXISTS `wms_barcode`;
CREATE TABLE `wms_barcode`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `barcode` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '条码编号',
  `barcode_type` int(11) NOT NULL COMMENT '条码类型（1:托盘二维码 2:阀门二维码/条码 3:库位条码）',
  `object_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联对象类型（pallet/valve/bin）',
  `object_id` bigint(20) NULL DEFAULT NULL COMMENT '关联对象ID',
  `object_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联对象编号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_barcode` (`barcode`) USING BTREE,
  INDEX `idx_barcode_type` (`barcode_type`) USING BTREE,
  INDEX `idx_object_type` (`object_type`, `object_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '条码信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_scan_task
-- ----------------------------
DROP TABLE IF EXISTS `wms_scan_task`;
CREATE TABLE `wms_scan_task`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务编号',
  `task_type` int(11) NOT NULL COMMENT '任务类型（1:托盘扫码 2:阀门扫码 3:库位扫码）',
  `barcode` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '扫描的条码',
  `operator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作人',
  `pda_device_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'PDA设备编号',
  `status` int(11) NULL DEFAULT 0 COMMENT '任务状态（0:待处理 1:处理中 2:已完成 3:失败）',
  `result` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '处理结果',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '错误信息',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task_no` (`task_no`) USING BTREE,
  INDEX `idx_task_type` (`task_type`) USING BTREE,
  INDEX `idx_status` (`status`) USING BTREE,
  INDEX `idx_barcode` (`barcode`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '扫码任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_agv_task
-- ----------------------------
DROP TABLE IF EXISTS `wms_agv_task`;
CREATE TABLE `wms_agv_task`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务编号（outID，由WMS生成）',
  `task_type` int(11) NOT NULL COMMENT '任务类型（1:入库任务 2:送检任务 3:回库任务 4:出库任务）',
  `biz_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联业务单号（入库单号、出库单号等）',
  `biz_order_id` bigint(20) NULL DEFAULT NULL COMMENT '关联业务单ID',
  `pallet_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '托盘编号',
  `pallet_id` bigint(20) NULL DEFAULT NULL COMMENT '托盘ID',
  `from_bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '起始货位编号',
  `from_bin_id` bigint(20) NULL DEFAULT NULL COMMENT '起始货位ID',
  `to_bin_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '目标货位编号',
  `to_bin_id` bigint(20) NULL DEFAULT NULL COMMENT '目标货位ID',
  `agv_task_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'AGV调度系统返回的任务ID',
  `status` int(11) NULL DEFAULT 0 COMMENT '任务状态（0:PENDING待处理 1:EXECUTING执行中 2:FINISHED已完成 3:FAILED失败 4:CANCELLED已取消）',
  `agv_device_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'AGV设备编号',
  `dispatch_time` datetime NULL DEFAULT NULL COMMENT '下发时间',
  `finish_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '错误信息',
  `agv_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'AGV返回的详细信息',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_task_no` (`task_no`) USING BTREE,
  INDEX `idx_task_type` (`task_type`) USING BTREE,
  INDEX `idx_status` (`status`) USING BTREE,
  INDEX `idx_biz_order_no` (`biz_order_no`) USING BTREE,
  INDEX `idx_agv_task_id` (`agv_task_id`) USING BTREE,
  INDEX `idx_pallet_code` (`pallet_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AGV任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_pda_operation
-- ----------------------------
DROP TABLE IF EXISTS `wms_pda_operation`;
CREATE TABLE `wms_pda_operation`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `operation_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作编号',
  `operation_type` int(11) NOT NULL COMMENT '操作类型（1:托盘扫码 2:阀门扫码 3:库位扫码 4:入库 5:出库 6:送检 7:回库 8:盘点 9:任务取消）',
  `operator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作人',
  `pda_device_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'PDA设备编号',
  `scanned_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '扫描的条码/编号',
  `biz_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联业务单号',
  `biz_order_id` bigint(20) NULL DEFAULT NULL COMMENT '关联业务单ID',
  `result` int(11) NULL DEFAULT NULL COMMENT '操作结果（0:失败 1:成功）',
  `result_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作结果描述',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '错误信息',
  `operation_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作数据（JSON格式）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_operation_no` (`operation_no`) USING BTREE,
  INDEX `idx_operation_type` (`operation_type`) USING BTREE,
  INDEX `idx_operator` (`operator`) USING BTREE,
  INDEX `idx_pda_device_no` (`pda_device_no`) USING BTREE,
  INDEX `idx_biz_order_no` (`biz_order_no`) USING BTREE,
  INDEX `idx_create_time` (`create_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'PDA操作记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_pda_log
-- ----------------------------
DROP TABLE IF EXISTS `wms_pda_log`;
CREATE TABLE `wms_pda_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `log_type` int(11) NOT NULL COMMENT '日志类型（1:操作记录 2:错误日志 3:网络失败记录 4:系统日志）',
  `pda_device_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'PDA设备编号',
  `operator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作人',
  `log_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日志级别（INFO/WARN/ERROR）',
  `log_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '日志内容',
  `error_stack` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误堆栈（仅错误日志）',
  `request_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网络请求URL（仅网络失败记录）',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网络请求方法（仅网络失败记录）',
  `network_error` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网络错误信息（仅网络失败记录）',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_log_type` (`log_type`) USING BTREE,
  INDEX `idx_pda_device_no` (`pda_device_no`) USING BTREE,
  INDEX `idx_log_level` (`log_level`) USING BTREE,
  INDEX `idx_create_time` (`create_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'PDA日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_warehouse_keeper
-- ----------------------------
DROP TABLE IF EXISTS `wms_warehouse_keeper`;
CREATE TABLE `wms_warehouse_keeper`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `keeper_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '库管员编号',
  `keeper_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '库管员姓名',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户ID（关联sys_user）',
  `warehouse_id` bigint(20) NULL DEFAULT NULL COMMENT '所属仓库ID',
  `post` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '岗位',
  `join_date` date NULL DEFAULT NULL COMMENT '入职日期',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_keeper_code` (`keeper_code`) USING BTREE,
  INDEX `idx_user_id` (`user_id`) USING BTREE,
  INDEX `idx_warehouse_id` (`warehouse_id`) USING BTREE,
  INDEX `idx_status` (`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '库管员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_config
-- ----------------------------
DROP TABLE IF EXISTS `wms_config`;
CREATE TABLE `wms_config`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置值',
  `config_type` int(11) NOT NULL COMMENT '配置类型（1:业务参数 2:规则配置 3:系统配置 4:PDA配置 5:AGV配置）',
  `config_group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置分组（warehouse/pda/agv/system等）',
  `config_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置描述',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0:正常 1:停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_config_key` (`config_key`) USING BTREE,
  INDEX `idx_config_type` (`config_type`) USING BTREE,
  INDEX `idx_config_group` (`config_group`) USING BTREE,
  INDEX `idx_status` (`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'WMS系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wms_data_backup
-- ----------------------------
DROP TABLE IF EXISTS `wms_data_backup`;
CREATE TABLE `wms_data_backup`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `backup_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备份编号',
  `backup_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备份名称',
  `backup_type` int(11) NULL DEFAULT NULL COMMENT '备份类型（1:全量备份 2:增量备份 3:指定表备份）',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备份文件路径',
  `file_size` bigint(20) NULL DEFAULT NULL COMMENT '文件大小（MB）',
  `backup_time` datetime(3) NULL DEFAULT NULL COMMENT '备份时间',
  `status` int(11) NULL DEFAULT NULL COMMENT '备份状态（0:进行中 1:成功 2:失败）',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '错误信息',
  `is_auto` int(11) NULL DEFAULT 0 COMMENT '是否自动备份（0:否 1:是）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(3) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_backup_no` (`backup_no`) USING BTREE,
  INDEX `idx_backup_type` (`backup_type`) USING BTREE,
  INDEX `idx_status` (`status`) USING BTREE,
  INDEX `idx_backup_time` (`backup_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据备份表' ROW_FORMAT = Dynamic;

-- ==================== WMS菜单配置 ====================
-- 注意：菜单ID从2000开始，避免与系统菜单冲突

-- WMS主菜单
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2000, 'WMS仓储管理', 0, 5, 'wms', NULL, '', 1, 0, 'M', '0', '0', '', 'warehouse', 'admin', NOW(), '', NULL, 'WMS仓储管理系统');

-- 基础数据管理
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2001, '基础数据', 2000, 1, 'basic', NULL, '', 1, 0, 'M', '0', '0', '', 'dict', 'admin', NOW(), '', NULL, '基础数据管理'),
(2010, '仓库管理', 2001, 1, 'warehouse', 'wms/basic/warehouse/index', '', 1, 0, 'C', '0', '0', 'wms:warehouse:list', 'warehouse', 'admin', NOW(), '', NULL, '仓库管理'),
(2011, '货区管理', 2001, 2, 'area', 'wms/basic/area/index', '', 1, 0, 'C', '0', '0', 'wms:area:list', 'tree', 'admin', NOW(), '', NULL, '货区管理'),
(2012, '货位管理', 2001, 3, 'bin', 'wms/basic/bin/index', '', 1, 0, 'C', '0', '0', 'wms:bin:list', 'tree-table', 'admin', NOW(), '', NULL, '货位管理'),
(2013, '物料类型', 2001, 4, 'materialType', 'wms/basic/materialType/index', '', 1, 0, 'C', '0', '0', 'wms:materialType:list', 'list', 'admin', NOW(), '', NULL, '物料类型管理'),
(2014, '托盘类型', 2001, 5, 'palletType', 'wms/basic/palletType/index', '', 1, 0, 'C', '0', '0', 'wms:palletType:list', 'list', 'admin', NOW(), '', NULL, '托盘类型管理'),
(2015, '托盘管理', 2001, 6, 'pallet', 'wms/basic/pallet/index', '', 1, 0, 'C', '0', '0', 'wms:pallet:list', 'table', 'admin', NOW(), '', NULL, '托盘管理'),
(2016, '阀门管理', 2001, 7, 'valve', 'wms/basic/valve/index', '', 1, 0, 'C', '0', '0', 'wms:valve:list', 'component', 'admin', NOW(), '', NULL, '阀门管理'),
(2017, '库管员管理', 2001, 8, 'warehouseKeeper', 'wms/basic/warehouseKeeper/index', '', 1, 0, 'C', '0', '0', 'wms:warehouseKeeper:list', 'user', 'admin', NOW(), '', NULL, '库管员管理');

-- 条码管理
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2020, '条码管理', 2000, 2, 'barcode', NULL, '', 1, 0, 'M', '0', '0', '', 'qrcode', 'admin', NOW(), '', NULL, '条码管理'),
(2021, '条码信息', 2020, 1, 'barcode', 'wms/barcode/index', '', 1, 0, 'C', '0', '0', 'wms:barcode:list', 'qrcode', 'admin', NOW(), '', NULL, '条码信息管理'),
(2022, '扫码任务', 2020, 2, 'scanTask', 'wms/scanTask/index', '', 1, 0, 'C', '0', '0', 'wms:scanTask:list', 'guide', 'admin', NOW(), '', NULL, '扫码任务管理');

-- 订单管理
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2030, '订单管理', 2000, 3, 'order', NULL, '', 1, 0, 'M', '0', '0', '', 'shopping', 'admin', NOW(), '', NULL, '订单管理'),
(2031, '入库单', 2030, 1, 'receipt', 'wms/order/receipt/index', '', 1, 0, 'C', '0', '0', 'wms:receipt:list', 'upload', 'admin', NOW(), '', NULL, '入库单管理'),
(2032, '出库单', 2030, 2, 'shipment', 'wms/order/shipment/index', '', 1, 0, 'C', '0', '0', 'wms:shipment:list', 'download', 'admin', NOW(), '', NULL, '出库单管理'),
(2033, '移库单', 2030, 3, 'movement', 'wms/order/movement/index', '', 1, 0, 'C', '0', '0', 'wms:movement:list', 'drag', 'admin', NOW(), '', NULL, '移库单管理'),
(2034, '盘点单', 2030, 4, 'check', 'wms/order/check/index', '', 1, 0, 'C', '0', '0', 'wms:check:list', 'edit', 'admin', NOW(), '', NULL, '盘点单管理');

-- 库存管理
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2040, '库存管理', 2000, 4, 'inventory', NULL, '', 1, 0, 'M', '0', '0', '', 'chart', 'admin', NOW(), '', NULL, '库存管理'),
(2041, '库存统计', 2040, 1, 'statistic', 'wms/inventory/statistic', '', 1, 0, 'C', '0', '0', 'wms:inventory:list', 'chart', 'admin', NOW(), '', NULL, '库存统计'),
(2042, '库存历史', 2040, 2, 'history', 'wms/inventory/history', '', 1, 0, 'C', '0', '0', 'wms:inventoryHistory:list', 'log', 'admin', NOW(), '', NULL, '库存历史'),
(2043, '库存查询', 2040, 3, 'query', 'wms/inventory/query/index', '', 1, 0, 'C', '0', '0', 'wms:inventory:query', 'search', 'admin', NOW(), '', NULL, '库存查询');

-- 任务管理
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2050, '任务管理', 2000, 5, 'task', NULL, '', 1, 0, 'M', '0', '0', '', 'guide', 'admin', NOW(), '', NULL, '任务管理'),
(2051, 'AGV任务', 2050, 1, 'agvTask', 'wms/task/agvTask/index', '', 1, 0, 'C', '0', '0', 'wms:agvTask:list', 'guide', 'admin', NOW(), '', NULL, 'AGV任务管理');

-- PDA管理
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2060, 'PDA管理', 2000, 6, 'pda', NULL, '', 1, 0, 'M', '0', '0', '', 'phone', 'admin', NOW(), '', NULL, 'PDA管理'),
(2061, 'PDA操作记录', 2060, 1, 'operation', 'wms/pda/operation/index', '', 1, 0, 'C', '0', '0', 'wms:pdaOperation:list', 'list', 'admin', NOW(), '', NULL, 'PDA操作记录'),
(2062, 'PDA日志', 2060, 2, 'log', 'wms/pda/log/index', '', 1, 0, 'C', '0', '0', 'wms:pdaLog:list', 'log', 'admin', NOW(), '', NULL, 'PDA日志');

-- 报表查询
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2070, '报表查询', 2000, 7, 'report', 'wms/report/index', '', 1, 0, 'C', '0', '0', 'wms:report:list', 'chart', 'admin', NOW(), '', NULL, '报表查询');

-- 系统配置
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2080, '系统配置', 2000, 8, 'config', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 'admin', NOW(), '', NULL, '系统配置'),
(2081, 'WMS配置', 2080, 1, 'wmsConfig', 'wms/config/index', '', 1, 0, 'C', '0', '0', 'wms:config:list', 'edit', 'admin', NOW(), '', NULL, 'WMS配置管理'),
(2082, '数据备份', 2080, 2, 'dataBackup', 'wms/dataBackup/index', '', 1, 0, 'C', '0', '0', 'wms:backup:list', 'backup', 'admin', NOW(), '', NULL, '数据备份管理');

-- ==================== WMS字典配置 ====================
-- 注意：字典类型ID从100开始，字典数据ID从1001开始

-- 字典类型
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`) VALUES
(100, '货区类型', 'wms_area_type', '0', 'admin', NOW(), '货区类型字典'),
(101, '货位类型', 'wms_bin_type', '0', 'admin', NOW(), '货位类型字典'),
(102, '货位状态', 'wms_bin_status', '0', 'admin', NOW(), '货位状态字典'),
(103, '阀门状态', 'wms_valve_status', '0', 'admin', NOW(), '阀门状态字典'),
(104, '托盘状态', 'wms_pallet_status', '0', 'admin', NOW(), '托盘状态字典'),
(105, '条码类型', 'wms_barcode_type', '0', 'admin', NOW(), '条码类型字典'),
(106, '扫码任务类型', 'wms_scan_task_type', '0', 'admin', NOW(), '扫码任务类型字典'),
(107, '扫码任务状态', 'wms_scan_task_status', '0', 'admin', NOW(), '扫码任务状态字典'),
(108, 'AGV任务类型', 'wms_agv_task_type', '0', 'admin', NOW(), 'AGV任务类型字典'),
(109, 'AGV任务状态', 'wms_agv_task_status', '0', 'admin', NOW(), 'AGV任务状态字典'),
(110, 'PDA操作类型', 'wms_pda_operation_type', '0', 'admin', NOW(), 'PDA操作类型字典'),
(111, 'PDA日志类型', 'wms_pda_log_type', '0', 'admin', NOW(), 'PDA日志类型字典'),
(112, 'WMS配置类型', 'wms_config_type', '0', 'admin', NOW(), 'WMS配置类型字典'),
(113, '数据备份类型', 'wms_backup_type', '0', 'admin', NOW(), '数据备份类型字典'),
(114, '数据备份状态', 'wms_backup_status', '0', 'admin', NOW(), '数据备份状态字典');

-- 字典数据

-- 货区类型
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1001, 1, '普通货区', '1', 'wms_area_type', '', 'default', 'N', '0', 'admin', NOW(), '普通货区'),
(1002, 2, '置换区', '2', 'wms_area_type', '', 'success', 'N', '0', 'admin', NOW(), '置换区'),
(1003, 3, '其他', '3', 'wms_area_type', '', 'info', 'N', '0', 'admin', NOW(), '其他类型');

-- 货位类型
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1011, 1, '普通货位', '1', 'wms_bin_type', '', 'default', 'N', '0', 'admin', NOW(), '普通货位'),
(1012, 2, '暂存位', '2', 'wms_bin_type', '', 'warning', 'N', '0', 'admin', NOW(), '暂存位'),
(1013, 3, '其他', '3', 'wms_bin_type', '', 'info', 'N', '0', 'admin', NOW(), '其他类型');

-- 货位状态
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1021, 1, '空闲', '0', 'wms_bin_status', '', 'success', 'N', '0', 'admin', NOW(), '空闲'),
(1022, 2, '占用', '1', 'wms_bin_status', '', 'warning', 'N', '0', 'admin', NOW(), '占用'),
(1023, 3, '禁用', '2', 'wms_bin_status', '', 'danger', 'N', '0', 'admin', NOW(), '禁用'),
(1024, 4, '锁定', '3', 'wms_bin_status', '', 'info', 'N', '0', 'admin', NOW(), '锁定');

-- 阀门状态
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1031, 1, '在库', '0', 'wms_valve_status', '', 'success', 'N', '0', 'admin', NOW(), '在库'),
(1032, 2, '检测中', '1', 'wms_valve_status', '', 'warning', 'N', '0', 'admin', NOW(), '检测中'),
(1033, 3, '已检测', '2', 'wms_valve_status', '', 'primary', 'N', '0', 'admin', NOW(), '已检测'),
(1034, 4, '已出库', '3', 'wms_valve_status', '', 'info', 'N', '0', 'admin', NOW(), '已出库');

-- 托盘状态
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1041, 1, '正常', '0', 'wms_pallet_status', '', 'success', 'N', '0', 'admin', NOW(), '正常'),
(1042, 2, '禁用', '1', 'wms_pallet_status', '', 'danger', 'N', '0', 'admin', NOW(), '禁用');

-- 条码类型
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1051, 1, '托盘条码', '1', 'wms_barcode_type', '', 'default', 'N', '0', 'admin', NOW(), '托盘条码'),
(1052, 2, '阀门条码', '2', 'wms_barcode_type', '', 'success', 'N', '0', 'admin', NOW(), '阀门条码'),
(1053, 3, '库位条码', '3', 'wms_barcode_type', '', 'info', 'N', '0', 'admin', NOW(), '库位条码');

-- 扫码任务类型
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1061, 1, '入库扫码', '1', 'wms_scan_task_type', '', 'success', 'N', '0', 'admin', NOW(), '入库扫码'),
(1062, 2, '出库扫码', '2', 'wms_scan_task_type', '', 'warning', 'N', '0', 'admin', NOW(), '出库扫码'),
(1063, 3, '盘点扫码', '3', 'wms_scan_task_type', '', 'info', 'N', '0', 'admin', NOW(), '盘点扫码');

-- 扫码任务状态
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1071, 1, '待执行', '0', 'wms_scan_task_status', '', 'info', 'N', '0', 'admin', NOW(), '待执行'),
(1072, 2, '执行中', '1', 'wms_scan_task_status', '', 'warning', 'N', '0', 'admin', NOW(), '执行中'),
(1073, 3, '已完成', '2', 'wms_scan_task_status', '', 'success', 'N', '0', 'admin', NOW(), '已完成'),
(1074, 4, '已取消', '3', 'wms_scan_task_status', '', 'default', 'N', '0', 'admin', NOW(), '已取消');

-- AGV任务类型
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1081, 1, '入库', '1', 'wms_agv_task_type', '', 'success', 'N', '0', 'admin', NOW(), '入库任务'),
(1082, 2, '出库', '2', 'wms_agv_task_type', '', 'warning', 'N', '0', 'admin', NOW(), '出库任务'),
(1083, 3, '送检', '3', 'wms_agv_task_type', '', 'info', 'N', '0', 'admin', NOW(), '送检任务'),
(1084, 4, '回库', '4', 'wms_agv_task_type', '', 'primary', 'N', '0', 'admin', NOW(), '回库任务');

-- AGV任务状态
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1091, 1, '待执行', '0', 'wms_agv_task_status', '', 'info', 'N', '0', 'admin', NOW(), '待执行'),
(1092, 2, '执行中', '1', 'wms_agv_task_status', '', 'warning', 'N', '0', 'admin', NOW(), '执行中'),
(1093, 3, '已完成', '2', 'wms_agv_task_status', '', 'success', 'N', '0', 'admin', NOW(), '已完成'),
(1094, 4, '已取消', '3', 'wms_agv_task_status', '', 'default', 'N', '0', 'admin', NOW(), '已取消'),
(1095, 5, '失败', '4', 'wms_agv_task_status', '', 'danger', 'N', '0', 'admin', NOW(), '失败');

-- PDA操作类型
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1101, 1, '托盘扫码', '1', 'wms_pda_operation_type', '', 'default', 'N', '0', 'admin', NOW(), '托盘扫码'),
(1102, 2, '阀门扫码', '2', 'wms_pda_operation_type', '', 'success', 'N', '0', 'admin', NOW(), '阀门扫码'),
(1103, 3, '库位扫码', '3', 'wms_pda_operation_type', '', 'info', 'N', '0', 'admin', NOW(), '库位扫码'),
(1104, 4, '入库', '4', 'wms_pda_operation_type', '', 'warning', 'N', '0', 'admin', NOW(), '入库'),
(1105, 5, '出库', '5', 'wms_pda_operation_type', '', 'danger', 'N', '0', 'admin', NOW(), '出库'),
(1106, 6, '送检', '6', 'wms_pda_operation_type', '', 'primary', 'N', '0', 'admin', NOW(), '送检'),
(1107, 7, '回库', '7', 'wms_pda_operation_type', '', 'success', 'N', '0', 'admin', NOW(), '回库'),
(1108, 8, '盘点', '8', 'wms_pda_operation_type', '', 'info', 'N', '0', 'admin', NOW(), '盘点'),
(1109, 9, '任务取消', '9', 'wms_pda_operation_type', '', 'default', 'N', '0', 'admin', NOW(), '任务取消');

-- PDA日志类型
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1111, 1, '操作记录', '1', 'wms_pda_log_type', '', 'default', 'N', '0', 'admin', NOW(), '操作记录'),
(1112, 2, '错误日志', '2', 'wms_pda_log_type', '', 'danger', 'N', '0', 'admin', NOW(), '错误日志'),
(1113, 3, '网络失败记录', '3', 'wms_pda_log_type', '', 'warning', 'N', '0', 'admin', NOW(), '网络失败记录'),
(1114, 4, '系统日志', '4', 'wms_pda_log_type', '', 'info', 'N', '0', 'admin', NOW(), '系统日志');

-- WMS配置类型
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1121, 1, '业务参数', '1', 'wms_config_type', '', 'default', 'N', '0', 'admin', NOW(), '业务参数'),
(1122, 2, '规则配置', '2', 'wms_config_type', '', 'success', 'N', '0', 'admin', NOW(), '规则配置'),
(1123, 3, '系统配置', '3', 'wms_config_type', '', 'info', 'N', '0', 'admin', NOW(), '系统配置'),
(1124, 4, 'PDA配置', '4', 'wms_config_type', '', 'warning', 'N', '0', 'admin', NOW(), 'PDA配置'),
(1125, 5, 'AGV配置', '5', 'wms_config_type', '', 'danger', 'N', '0', 'admin', NOW(), 'AGV配置');

-- 数据备份类型
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1131, 1, '全量备份', '1', 'wms_backup_type', '', 'default', 'N', '0', 'admin', NOW(), '全量备份'),
(1132, 2, '增量备份', '2', 'wms_backup_type', '', 'success', 'N', '0', 'admin', NOW(), '增量备份'),
(1133, 3, '指定表备份', '3', 'wms_backup_type', '', 'info', 'N', '0', 'admin', NOW(), '指定表备份');

-- 数据备份状态
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1141, 1, '进行中', '0', 'wms_backup_status', '', 'warning', 'N', '0', 'admin', NOW(), '进行中'),
(1142, 2, '成功', '1', 'wms_backup_status', '', 'success', 'N', '0', 'admin', NOW(), '成功'),
(1143, 3, '失败', '2', 'wms_backup_status', '', 'danger', 'N', '0', 'admin', NOW(), '失败');

SET FOREIGN_KEY_CHECKS = 1;
