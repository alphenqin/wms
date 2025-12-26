/**
 * 获取字典数据
 */
export function useDict(...args) {
  const res = ref({});
  return (() => {
    // 字典功能已关闭，返回空数组占位，避免组件报错
    args.forEach((dictType) => {
      res.value[dictType] = [];
    })
    return toRefs(res.value);
  })()
}
