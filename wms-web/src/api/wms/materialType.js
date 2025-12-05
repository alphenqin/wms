import request from '@/utils/request'

export function listMaterialType(query) {
  return request({
    url: '/wms/materialType/list',
    method: 'get',
    params: query
  });
};

export function listMaterialTypeNoPage(query) {
  return request({
    url: '/wms/materialType/listNoPage',
    method: 'get',
    params: query
  });
};

export function getMaterialType(id) {
  return request({
    url: '/wms/materialType/' + id,
    method: 'get'
  });
};

export function addMaterialType(data) {
  return request({
    url: '/wms/materialType',
    method: 'post',
    data: data
  });
};

export function updateMaterialType(data) {
  return request({
    url: '/wms/materialType',
    method: 'put',
    data: data
  });
};

export function delMaterialType(id) {
  return request({
    url: '/wms/materialType/' + id,
    method: 'delete'
  });
};

export function exportMaterialType(query) {
  return request({
    url: '/wms/materialType/export',
    method: 'post',
    params: query
  });
};

