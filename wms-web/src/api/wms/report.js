import request from '@/utils/request'

export function queryInboundReport(params) {
  return request({
    url: '/wms/report/inbound',
    method: 'get',
    params: params
  });
};

export function queryInboundSummary(params) {
  return request({
    url: '/wms/report/inbound/summary',
    method: 'get',
    params: params
  });
};

export function queryOutboundReport(params) {
  return request({
    url: '/wms/report/outbound',
    method: 'get',
    params: params
  });
};

export function queryOutboundSummary(params) {
  return request({
    url: '/wms/report/outbound/summary',
    method: 'get',
    params: params
  });
};

export function queryCheckReport(params) {
  return request({
    url: '/wms/report/check',
    method: 'get',
    params: params
  });
};

export function queryInventoryStatistics(params) {
  return request({
    url: '/wms/report/inventory',
    method: 'get',
    params: params
  });
};

