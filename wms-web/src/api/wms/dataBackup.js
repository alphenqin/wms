import request from '@/utils/request'

export function listDataBackup(query) {
  return request({
    url: '/wms/dataBackup/list',
    method: 'get',
    params: query
  });
};

export function getDataBackup(id) {
  return request({
    url: '/wms/dataBackup/' + id,
    method: 'get'
  });
};

export function executeBackup(backupType, backupName) {
  return request({
    url: '/wms/dataBackup/execute',
    method: 'post',
    params: { backupType, backupName }
  });
};

export function restoreBackup(id) {
  return request({
    url: '/wms/dataBackup/' + id + '/restore',
    method: 'post'
  });
};

export function delDataBackup(id) {
  return request({
    url: '/wms/dataBackup/' + id,
    method: 'delete'
  });
};

