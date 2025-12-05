import request from '@/utils/request'

export function listBarcode(query) {
  return request({
    url: '/wms/barcode/list',
    method: 'get',
    params: query
  });
};

export function getBarcode(id) {
  return request({
    url: '/wms/barcode/' + id,
    method: 'get'
  });
};

export function addBarcode(data) {
  return request({
    url: '/wms/barcode',
    method: 'post',
    data: data
  });
};

export function updateBarcode(data) {
  return request({
    url: '/wms/barcode',
    method: 'put',
    data: data
  });
};

export function delBarcode(id) {
  return request({
    url: '/wms/barcode/' + id,
    method: 'delete'
  });
};

