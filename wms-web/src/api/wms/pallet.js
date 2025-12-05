import request from '@/utils/request'

export function listPallet(query) {
  return request({
    url: '/wms/pallet/list',
    method: 'get',
    params: query
  });
};

export function listPalletNoPage(query) {
  return request({
    url: '/wms/pallet/listNoPage',
    method: 'get',
    params: query
  });
};

export function getPallet(id) {
  return request({
    url: '/wms/pallet/' + id,
    method: 'get'
  });
};

export function getPalletByCode(palletCode) {
  return request({
    url: '/wms/pallet/code/' + palletCode,
    method: 'get'
  });
};

export function addPallet(data) {
  return request({
    url: '/wms/pallet',
    method: 'post',
    data: data
  });
};

export function updatePallet(data) {
  return request({
    url: '/wms/pallet',
    method: 'put',
    data: data
  });
};

export function delPallet(id) {
  return request({
    url: '/wms/pallet/' + id,
    method: 'delete'
  });
};

export function exportPallet(query) {
  return request({
    url: '/wms/pallet/export',
    method: 'post',
    params: query
  });
};

