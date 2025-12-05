import request from '@/utils/request'

export function listScanTask(query) {
  return request({
    url: '/wms/scanTask/list',
    method: 'get',
    params: query
  });
};

export function getScanTask(id) {
  return request({
    url: '/wms/scanTask/' + id,
    method: 'get'
  });
};

export function addScanTask(data) {
  return request({
    url: '/wms/scanTask',
    method: 'post',
    data: data
  });
};

export function updateScanTask(data) {
  return request({
    url: '/wms/scanTask',
    method: 'put',
    data: data
  });
};

export function delScanTask(id) {
  return request({
    url: '/wms/scanTask/' + id,
    method: 'delete'
  });
};

