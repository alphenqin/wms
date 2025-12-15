import request from '@/utils/request'

// 任务下发
export function sendAgvTask(data) {
  return request({
    url: '/wms/agv/open/task/send',
    method: 'post',
    data
  });
}

// 列表查询
export function listAgvOpenTask(query) {
  return request({
    url: '/wms/agv/open/task/list',
    method: 'get',
    params: query
  });
}

// 查询任务结果并回写
export function queryAgvTaskResult(data) {
  return request({
    url: '/wms/agv/open/task/result',
    method: 'post',
    data
  });
}

// 分配库位
export function assignAgvBin(data) {
  return request({
    url: '/wms/agv/open/bin/assign',
    method: 'post',
    data
  });
}

// 查询库位
export function fetchBinInfo(data) {
  return request({
    url: '/wms/agv/open/bin/info',
    method: 'post',
    data
  });
}

// 更新库位状态
export function updateBinStatus(data) {
  return request({
    url: '/wms/agv/open/bin/status',
    method: 'post',
    data
  });
}

// 获取AGV信息
export function fetchAgvInfo() {
  return request({
    url: '/wms/agv/open/agv/info',
    method: 'post'
  });
}

