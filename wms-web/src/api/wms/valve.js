import request from '@/utils/request'

export function listValve(query) {
  return request({
    url: '/wms/valve/list',
    method: 'get',
    params: query
  });
};

export function listValveNoPage(query) {
  return request({
    url: '/wms/valve/listNoPage',
    method: 'get',
    params: query
  });
};

export function getValve(id) {
  return request({
    url: '/wms/valve/' + id,
    method: 'get'
  });
};

export function getValveByNo(valveNo) {
  return request({
    url: '/wms/valve/code/' + valveNo,
    method: 'get'
  });
};

export function addValve(data) {
  return request({
    url: '/wms/valve',
    method: 'post',
    data: data
  });
};

export function updateValve(data) {
  return request({
    url: '/wms/valve',
    method: 'put',
    data: data
  });
};

export function delValve(id) {
  return request({
    url: '/wms/valve/' + id,
    method: 'delete'
  });
};

export function delValves(ids) {
  return request({
    url: '/wms/valve/batch/' + ids.join(','),
    method: 'delete'
  });
};

export function exportValve(query) {
  return request({
    url: '/wms/valve/export',
    method: 'post',
    params: query
  });
};

