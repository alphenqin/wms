import request from '@/utils/request'

export function listAgvTask(query) {
  return request({
    url: '/wms/agvTask/list',
    method: 'get',
    params: query
  });
};

export function getAgvTask(id) {
  return request({
    url: '/wms/agvTask/' + id,
    method: 'get'
  });
};

export function cancelAgvTask(taskNo) {
  return request({
    url: '/wms/agvTask/cancel/' + taskNo,
    method: 'post'
  });
};

export function queryByTaskNo(taskNo) {
  return request({
    url: '/wms/agvTask/taskNo/' + taskNo,
    method: 'get'
  });
};

