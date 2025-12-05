import request from '@/utils/request'

export function listPalletType(query) {
  return request({
    url: '/wms/palletType/list',
    method: 'get',
    params: query
  });
};

export function listPalletTypeNoPage(query) {
  return request({
    url: '/wms/palletType/listNoPage',
    method: 'get',
    params: query
  });
};

export function getPalletType(id) {
  return request({
    url: '/wms/palletType/' + id,
    method: 'get'
  });
};

export function addPalletType(data) {
  return request({
    url: '/wms/palletType',
    method: 'post',
    data: data
  });
};

export function updatePalletType(data) {
  return request({
    url: '/wms/palletType',
    method: 'put',
    data: data
  });
};

export function delPalletType(id) {
  return request({
    url: '/wms/palletType/' + id,
    method: 'delete'
  });
};

export function exportPalletType(query) {
  return request({
    url: '/wms/palletType/export',
    method: 'post',
    params: query
  });
};

