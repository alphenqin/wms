<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="货位编号" prop="binCode">
          <el-input v-model="queryParams.binCode" placeholder="请输入货位编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="货位名称" prop="binName">
          <el-input v-model="queryParams.binName" placeholder="请输入货位名称" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="仓库" prop="warehouseId">
          <el-select
            v-model="queryParams.warehouseId"
            placeholder="请选择仓库"
            clearable
            @change="handleQueryWarehouseChange"
          >
            <el-option
              v-for="item in warehouseList"
              :key="item.id"
              :label="item.warehouseName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="货区" prop="areaId">
          <el-select v-model="queryParams.areaId" placeholder="请选择货区" clearable>
            <el-option
              v-for="item in areaList"
              :key="item.id"
              :label="item.areaName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
            <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button
            type="primary"
            plain
            icon="Plus"
            @click="handleAdd"
            v-hasPermi="['wms:bin:edit']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['wms:bin:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:bin:edit']"
          >删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="Download"
            @click="handleExport"
            v-hasPermi="['wms:bin:export']"
          >导出</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="binList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="120" />
        <el-table-column label="货位编号" prop="binCode" />
        <el-table-column label="货位名称" prop="binName" />
        <el-table-column label="所属仓库" prop="warehouseName" />
        <el-table-column label="所属货区" prop="areaName" />
        <el-table-column label="货位类型" prop="binType" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.binType === 1">普通货位</el-tag>
            <el-tag v-else-if="scope.row.binType === 2" type="warning">暂存位</el-tag>
            <el-tag v-else-if="scope.row.binType === 3" type="info">其他</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="温区" prop="temperatureZone" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.temperatureZone === 1">常温</el-tag>
            <el-tag v-else-if="scope.row.temperatureZone === 2" type="warning">冷藏</el-tag>
            <el-tag v-else-if="scope.row.temperatureZone === 3" type="info">冷冻</el-tag>
            <el-tag v-else-if="scope.row.temperatureZone === 4" type="info">其他</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="容量" prop="capacity" />
        <el-table-column label="已用容量" prop="usedCapacity" />
        <el-table-column label="状态" prop="status" width="120">
          <template #default="scope">
            <el-tag :type="getStatusTag(scope.row.status)">{{ getStatusLabel(scope.row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="排序" prop="orderNum" width="100" />
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:bin:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:bin:edit']">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <el-dialog :title="dialog.title" v-model="dialog.visible" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="binFormRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="货位编号" prop="binCode">
          <el-input v-model="form.binCode" placeholder="请输入货位编号" />
        </el-form-item>
        <el-form-item label="货位名称" prop="binName">
          <el-input v-model="form.binName" placeholder="请输入货位名称" />
        </el-form-item>
        <el-form-item label="所属仓库" prop="warehouseId">
          <el-select v-model="form.warehouseId" placeholder="请选择仓库" style="width: 100%" @change="handleFormWarehouseChange">
            <el-option
              v-for="item in warehouseList"
              :key="item.id"
              :label="item.warehouseName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="所属货区" prop="areaId">
          <el-select v-model="form.areaId" placeholder="请选择货区" style="width: 100%">
            <el-option
              v-for="item in formAreaList"
              :key="item.id"
              :label="item.areaName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="货位类型" prop="binType">
          <el-select v-model="form.binType" placeholder="请选择货位类型" style="width: 100%">
            <el-option v-for="item in binTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="温区" prop="temperatureZone">
          <el-select v-model="form.temperatureZone" placeholder="请选择温区" style="width: 100%">
            <el-option v-for="item in temperatureOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="容量" prop="capacity">
          <el-input-number v-model="form.capacity" :min="0" :precision="2" :controls="false" style="width: 100%" />
        </el-form-item>
        <el-form-item label="已用容量" prop="usedCapacity">
          <el-input-number v-model="form.usedCapacity" :min="0" :precision="2" :controls="false" style="width: 100%" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio v-for="item in statusOptions" :key="item.value" :label="item.value">{{ item.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="排序" prop="orderNum">
          <el-input-number v-model="form.orderNum" :min="0" :controls="false" style="width: 100%" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button :loading="buttonLoading" type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Bin">
import { listBin, getBin, delBin, delBins, addBin, updateBin, exportBin } from '@/api/wms/bin';
import { listAreaNoPage } from '@/api/wms/area';
import { listWarehouseNoPage } from '@/api/wms/warehouse';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';

const { proxy } = getCurrentInstance();

const binList = ref([]);
const warehouseList = ref([]);
const areaList = ref([]);
const formAreaList = ref([]);
const buttonLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const binFormRef = ref();

const dialog = reactive({
  visible: false,
  title: ''
});

const binTypeOptions = [
  { label: '普通货位', value: 1 },
  { label: '暂存位', value: 2 },
  { label: '其他', value: 3 }
];

const temperatureOptions = [
  { label: '常温', value: 1 },
  { label: '冷藏', value: 2 },
  { label: '冷冻', value: 3 },
  { label: '其他', value: 4 }
];

const statusOptions = [
  { label: '空闲', value: 0, tag: 'success' },
  { label: '占用', value: 1, tag: 'warning' },
  { label: '禁用', value: 2, tag: 'info' },
  { label: '锁定', value: 3, tag: 'danger' }
];

const initFormData = {
  id: undefined,
  binCode: undefined,
  binName: undefined,
  warehouseId: undefined,
  areaId: undefined,
  binType: 1,
  temperatureZone: 1,
  capacity: undefined,
  usedCapacity: 0,
  status: 0,
  orderNum: 0,
  remark: undefined,
};

const data = reactive({
  form: { ...initFormData },
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    binCode: undefined,
    binName: undefined,
    warehouseId: undefined,
    areaId: undefined,
    status: undefined,
  },
  rules: {
    binCode: [
      { required: true, message: "货位编号不能为空", trigger: "blur" }
    ],
    warehouseId: [
      { required: true, message: "所属仓库不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

const getStatusLabel = (status) => {
  const found = statusOptions.find((item) => item.value === status);
  return found ? found.label : status;
};

const getStatusTag = (status) => {
  const found = statusOptions.find((item) => item.value === status);
  return found ? found.tag : 'info';
};

/** 查询货位列表 */
const getList = async () => {
  loading.value = true;
  const res = await listBin(queryParams.value).finally(() => {
    loading.value = false;
  });
  binList.value = res.rows;
  total.value = res.total;
};

const getWarehouseList = async () => {
  const res = await listWarehouseNoPage({});
  warehouseList.value = res.data || [];
};

const getAreaList = async (warehouseId, target) => {
  const params = warehouseId ? { warehouseId } : {};
  const res = await listAreaNoPage(params);
  if (target === 'form') {
    formAreaList.value = res.data || [];
    return;
  }
  areaList.value = res.data || [];
};

const handleQueryWarehouseChange = async (value) => {
  queryParams.value.areaId = undefined;
  await getAreaList(value, 'query');
};

const handleFormWarehouseChange = async (value) => {
  form.value.areaId = undefined;
  await getAreaList(value, 'form');
};

/** 取消按钮 */
const cancel = () => {
  reset();
  dialog.visible = false;
};

/** 表单重置 */
const reset = async () => {
  form.value = { ...initFormData };
  binFormRef.value?.resetFields();
  await getAreaList(form.value.warehouseId, 'form');
};

/** 搜索按钮操作 */
const handleQuery = () => {
  queryParams.value.pageNum = 1;
  getList();
};

/** 重置按钮操作 */
const resetQuery = async () => {
  queryFormRef.value?.resetFields();
  await getAreaList(undefined, 'query');
  handleQuery();
};

/** 多选框选中数据 */
const handleSelectionChange = (selection) => {
  ids.value = selection.map(item => item.id);
  single.value = selection.length !== 1;
  multiple.value = !selection.length;
};

/** 新增按钮操作 */
const handleAdd = async () => {
  dialog.visible = true;
  dialog.title = "添加货位";
  await reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改货位";
  const _id = row.id || ids.value[0];
  const res = await getBin(_id);
  Object.assign(form.value, res.data);
  await getAreaList(form.value.warehouseId, 'form');
};

/** 提交按钮 */
const submitForm = () => {
  binFormRef.value?.validate(async (valid) => {
    if (valid) {
      buttonLoading.value = true;
      try {
        if (form.value.id) {
          await updateBin(form.value);
          proxy?.$modal.msgSuccess('修改成功');
        } else {
          await addBin(form.value);
          proxy?.$modal.msgSuccess('新增成功');
        }
        dialog.visible = false;
        await getList();
      } finally {
        buttonLoading.value = false;
      }
    }
  });
};

/** 删除按钮操作 */
const handleDelete = async (row) => {
  const _ids = row.id || ids.value;
  if (Array.isArray(_ids)) {
    await proxy?.$modal.confirm('是否确认删除共"' + _ids.length + '"条数据项？');
    await delBins(_ids);
  } else {
    await proxy?.$modal.confirm('是否确认删除货位编号为"' + _ids + '"的数据项？');
    await delBin(_ids);
  }
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

/** 导出按钮操作 */
const handleExport = () => {
  proxy?.download('wms/bin/export', {
    ...queryParams.value
  }, `bin_${new Date().getTime()}.xlsx`);
};

onMounted(async () => {
  await getWarehouseList();
  await getAreaList(undefined, 'query');
  await getList();
});
</script>
