import request from '@/utils/request'

export function listWmsConfig(query) {
  return request({
    url: '/wms/config/list',
    method: 'get',
    params: query
  });
};

export function getWmsConfig(id) {
  return request({
    url: '/wms/config/' + id,
    method: 'get'
  });
};

export function getWmsConfigByKey(configKey) {
  return request({
    url: '/wms/config/key/' + configKey,
    method: 'get'
  });
};

export function getWmsConfigByGroup(configGroup) {
  return request({
    url: '/wms/config/group/' + configGroup,
    method: 'get'
  });
};

export function addWmsConfig(data) {
  return request({
    url: '/wms/config',
    method: 'post',
    data: data
  });
};

export function updateWmsConfig(data) {
  return request({
    url: '/wms/config',
    method: 'put',
    data: data
  });
};

export function delWmsConfig(id) {
  return request({
    url: '/wms/config/' + id,
    method: 'delete'
  });
};

