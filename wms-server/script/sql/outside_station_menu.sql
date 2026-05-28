-- 库外站点管理菜单及按钮权限
INSERT IGNORE INTO `sys_menu`
(`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES
(2090, '库外站点', 1998308639817191425, 85, 'outsideStation', 'wms/basic/outsideStation/index', '', 0, 0, 'C', '1', '1', 'wms:outsideStation:list', 'list', 'admin', NOW(), '', NULL, '库外站点管理'),
(2091, '库外站点查询', 2090, 1, '', '', '', 0, 0, 'F', '1', '1', 'wms:outsideStation:list', '#', 'admin', NOW(), '', NULL, ''),
(2092, '库外站点新增', 2090, 2, '', '', '', 0, 0, 'F', '1', '1', 'wms:outsideStation:add', '#', 'admin', NOW(), '', NULL, ''),
(2093, '库外站点修改', 2090, 3, '', '', '', 0, 0, 'F', '1', '1', 'wms:outsideStation:edit', '#', 'admin', NOW(), '', NULL, ''),
(2094, '库外站点删除', 2090, 4, '', '', '', 0, 0, 'F', '1', '1', 'wms:outsideStation:remove', '#', 'admin', NOW(), '', NULL, ''),
(2095, '库外站点导出', 2090, 5, '', '', '', 0, 0, 'F', '1', '1', 'wms:outsideStation:export', '#', 'admin', NOW(), '', NULL, '');
