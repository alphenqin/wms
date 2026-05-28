import request from '@/utils/request'

export function listOutsideStation(query) {
  return request({
    url: '/wms/outsideStation/list',
    method: 'get',
    params: query
  });
};

export function listOutsideStationNoPage(query) {
  return request({
    url: '/wms/outsideStation/listNoPage',
    method: 'get',
    params: query
  });
};

export function getOutsideStation(id) {
  return request({
    url: '/wms/outsideStation/' + id,
    method: 'get'
  });
};

export function addOutsideStation(data) {
  return request({
    url: '/wms/outsideStation',
    method: 'post',
    data: data
  });
};

export function updateOutsideStation(data) {
  return request({
    url: '/wms/outsideStation',
    method: 'put',
    data: data
  });
};

export function delOutsideStation(id) {
  return request({
    url: '/wms/outsideStation/' + id,
    method: 'delete'
  });
};

export function delOutsideStations(ids) {
  return request({
    url: '/wms/outsideStation/batch/' + ids.join(','),
    method: 'delete'
  });
};

export function exportOutsideStation(query) {
  return request({
    url: '/wms/outsideStation/export',
    method: 'post',
    params: query
  });
};
