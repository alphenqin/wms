import request from '@/utils/request'

/**
 * 查询货位列表
 * @param query
 * @returns {*}
 */
export function listBin(query) {
  return request({
    url: '/wms/bin/list',
    method: 'get',
    params: query
  });
};

/**
 * 查询货位列表（不分页）
 * @param query
 * @returns {*}
 */
export function listBinNoPage(query) {
  return request({
    url: '/wms/bin/listNoPage',
    method: 'get',
    params: query
  });
};

/**
 * 查询货位详细
 * @param id
 */
export function getBin(id) {
  return request({
    url: '/wms/bin/' + id,
    method: 'get'
  });
};

/**
 * 根据货位编号查询
 * @param binCode
 */
export function getBinByCode(binCode) {
  return request({
    url: '/wms/bin/code/' + binCode,
    method: 'get'
  });
};

/**
 * 新增货位
 * @param data
 */
export function addBin(data) {
  return request({
    url: '/wms/bin',
    method: 'post',
    data: data
  });
};

/**
 * 修改货位
 * @param data
 */
export function updateBin(data) {
  return request({
    url: '/wms/bin',
    method: 'put',
    data: data
  });
};

/**
 * 删除货位
 * @param id
 */
export function delBin(id) {
  return request({
    url: '/wms/bin/' + id,
    method: 'delete'
  });
};

/**
 * 导出货位
 * @param query
 */
export function exportBin(query) {
  return request({
    url: '/wms/bin/export',
    method: 'post',
    params: query
  });
};

