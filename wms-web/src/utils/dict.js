import { ref, toRefs } from 'vue'

/**
 * 获取字典数据
 */
export function useDict(...args) {
  const res = ref({});
  const dictData = {
    sys_normal_disable: [
      { label: '正常', value: '0', elTagType: 'success' },
      { label: '停用', value: '1', elTagType: 'danger' }
    ],
    sys_show_hide: [
      { label: '显示', value: '0' },
      { label: '隐藏', value: '1' }
    ],
    sys_user_sex: [
      { label: '男', value: '0' },
      { label: '女', value: '1' },
      { label: '未知', value: '2' }
    ],
    merchant_type: [
      { label: '客户', value: '1' },
      { label: '供应商', value: '2' },
      { label: '客户/供应商', value: '3' }
    ],
    wms_valve_status: [
      { label: '在库', value: '0' },
      { label: '检测中', value: '1' },
      { label: '已检测', value: '2' },
      { label: '已出库', value: '3' }
    ],
    wms_receipt_status: [
      { label: '作废', value: '-1' },
      { label: '待入库', value: '0' },
      { label: '已入库', value: '1' }
    ],
    wms_receipt_type: [
      { label: '采购入库', value: '1' },
      { label: '生产入库', value: '2' },
      { label: '其他入库', value: '3' }
    ],
    wms_shipment_status: [
      { label: '作废', value: '-1' },
      { label: '待出库', value: '0' },
      { label: '已出库', value: '1' }
    ],
    wms_shipment_type: [
      { label: '销售出库', value: '1' },
      { label: '生产领料', value: '2' },
      { label: '其他出库', value: '3' }
    ],
    wms_movement_status: [
      { label: '作废', value: '-1' },
      { label: '待移库', value: '0' },
      { label: '已移库', value: '1' }
    ],
    wms_check_status: [
      { label: '作废', value: '-1' },
      { label: '未盘库', value: '0' },
      { label: '已盘库', value: '1' }
    ],
    wms_inventory_history_type: [
      { label: '入库', value: '1' },
      { label: '出库', value: '2' },
      { label: '移库', value: '3' },
      { label: '盘点', value: '4' }
    ]
  };
  return (() => {
    args.forEach((dictType) => {
      res.value[dictType] = dictData[dictType] || [];
    })
    return toRefs(res.value);
  })()
}
