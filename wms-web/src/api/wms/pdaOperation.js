import request from '@/utils/request'

export function listPdaOperation(query) {
  return request({
    url: '/wms/pda/operation/list',
    method: 'get',
    params: query
  });
};

export function getPdaOperation(id) {
  return request({
    url: '/wms/pda/operation/' + id,
    method: 'get'
  });
};

export function addPdaOperation(data) {
  return request({
    url: '/wms/pda/operation',
    method: 'post',
    data: data
  });
};

