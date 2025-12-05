import request from '@/utils/request'

export function queryByDate(params) {
  return request({
    url: '/wms/inventory/query/byDate',
    method: 'get',
    params: params
  });
};

export function queryByBatch(params) {
  return request({
    url: '/wms/inventory/query/byBatch',
    method: 'get',
    params: params
  });
};

export function queryByMaterial(params) {
  return request({
    url: '/wms/inventory/query/byMaterial',
    method: 'get',
    params: params
  });
};

export function queryByValveModel(params) {
  return request({
    url: '/wms/inventory/query/byValveModel',
    method: 'get',
    params: params
  });
};

export function queryByBin(params) {
  return request({
    url: '/wms/inventory/query/byBin',
    method: 'get',
    params: params
  });
};

export function queryByPallet(params) {
  return request({
    url: '/wms/inventory/query/byPallet',
    method: 'get',
    params: params
  });
};

export function queryComprehensive(params) {
  return request({
    url: '/wms/inventory/query/comprehensive',
    method: 'get',
    params: params
  });
};

export function queryStatusSummary(params) {
  return request({
    url: '/wms/inventory/query/statusSummary',
    method: 'get',
    params: params
  });
};

