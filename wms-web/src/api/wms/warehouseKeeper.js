import request from '@/utils/request'

export function listWarehouseKeeper(query) {
  return request({
    url: '/wms/warehouseKeeper/list',
    method: 'get',
    params: query
  });
};

export function getWarehouseKeeper(id) {
  return request({
    url: '/wms/warehouseKeeper/' + id,
    method: 'get'
  });
};

export function addWarehouseKeeper(data) {
  return request({
    url: '/wms/warehouseKeeper',
    method: 'post',
    data: data
  });
};

export function updateWarehouseKeeper(data) {
  return request({
    url: '/wms/warehouseKeeper',
    method: 'put',
    data: data
  });
};

export function delWarehouseKeeper(id) {
  return request({
    url: '/wms/warehouseKeeper/' + id,
    method: 'delete'
  });
};

