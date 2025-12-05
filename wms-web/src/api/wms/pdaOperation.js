import request from '@/utils/request'

export function listPdaOperation(query) {
  return request({
    url: '/wms/pdaOperation/list',
    method: 'get',
    params: query
  });
};

export function getPdaOperation(id) {
  return request({
    url: '/wms/pdaOperation/' + id,
    method: 'get'
  });
};

export function addPdaOperation(data) {
  return request({
    url: '/wms/pdaOperation',
    method: 'post',
    data: data
  });
};

