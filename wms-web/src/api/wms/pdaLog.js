import request from '@/utils/request'

export function listPdaLog(query) {
  return request({
    url: '/wms/pdaLog/list',
    method: 'get',
    params: query
  });
};

export function getPdaLog(id) {
  return request({
    url: '/wms/pdaLog/' + id,
    method: 'get'
  });
};

