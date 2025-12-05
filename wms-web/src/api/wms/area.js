import request from '@/utils/request'

/**
 * 查询货区列表
 * @param query
 * @returns {*}
 */
export function listArea(query) {
  return request({
    url: '/wms/area/list',
    method: 'get',
    params: query
  });
};

/**
 * 查询货区列表（不分页）
 * @param query
 * @returns {*}
 */
export function listAreaNoPage(query) {
  return request({
    url: '/wms/area/listNoPage',
    method: 'get',
    params: query
  });
};

/**
 * 查询货区详细
 * @param id
 */
export function getArea(id) {
  return request({
    url: '/wms/area/' + id,
    method: 'get'
  });
};

/**
 * 新增货区
 * @param data
 */
export function addArea(data) {
  return request({
    url: '/wms/area',
    method: 'post',
    data: data
  });
};

/**
 * 修改货区
 * @param data
 */
export function updateArea(data) {
  return request({
    url: '/wms/area',
    method: 'put',
    data: data
  });
};

/**
 * 删除货区
 * @param id
 */
export function delArea(id) {
  return request({
    url: '/wms/area/' + id,
    method: 'delete'
  });
};

/**
 * 导出货区
 * @param query
 */
export function exportArea(query) {
  return request({
    url: '/wms/area/export',
    method: 'post',
    params: query
  });
};

