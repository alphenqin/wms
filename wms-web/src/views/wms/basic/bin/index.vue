<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="库位编号" prop="binCode">
          <el-input v-model="queryParams.binCode" placeholder="请输入库位编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="出厂编号" prop="boundFactoryNo">
          <el-input v-model="queryParams.boundFactoryNo" placeholder="请输入绑定出厂编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="库位类型" prop="binType">
          <el-select v-model="queryParams.binType" placeholder="请选择库位类型" clearable>
            <el-option v-for="item in binTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="作业状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择作业状态" clearable>
            <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="库位状态" prop="storageStatus">
          <el-select v-model="queryParams.storageStatus" placeholder="请选择库位状态" clearable>
            <el-option v-for="item in storageStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
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
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:bin:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:bin:edit']">删除</el-button>
          </template>
        </el-table-column>
        <el-table-column label="库位编号" prop="binCode" />
        <el-table-column label="库位类型" prop="binType" width="120">
          <template #default="scope">
            {{ getBinTypeLabel(scope.row.binType) }}
          </template>
        </el-table-column>
        <el-table-column label="库位状态" prop="storageStatus" width="120">
          <template #default="scope">
            <el-tag :type="getStorageStatusTag(scope.row.storageStatus)">{{ getStorageStatusLabel(scope.row.storageStatus) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="作业状态" prop="status" width="120">
          <template #default="scope">
            <el-tag :type="getStatusTag(scope.row.status)">{{ getStatusLabel(scope.row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="绑定出厂编号" prop="boundFactoryNo" min-width="140" />
        <el-table-column label="排序" prop="orderNum" width="100" />
        <el-table-column label="创建时间" prop="createTime" width="180" />
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <el-dialog :title="dialog.title" v-model="dialog.visible" width="900px" append-to-body :close-on-click-modal="false">
      <el-form ref="binFormRef" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="库位编号" prop="binCode">
              <el-input v-model="form.binCode" placeholder="请输入库位编号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="库位名称" prop="binName">
              <el-input v-model="form.binName" placeholder="请输入库位名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
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
          </el-col>
          <el-col :span="12">
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
          </el-col>
          <el-col :span="12">
            <el-form-item label="库位类型" prop="binType">
              <el-select v-model="form.binType" placeholder="请选择库位类型" style="width: 100%">
                <el-option v-for="item in binTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作业状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio v-for="item in statusOptions" :key="item.value" :label="item.value">{{ item.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="库位状态" prop="storageStatus">
              <el-radio-group v-model="form.storageStatus" @change="handleStorageStatusChange">
                <el-radio v-for="item in storageStatusOptions" :key="item.value" :label="item.value">{{ item.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="绑定出厂编号" prop="boundFactoryNo">
              <el-input v-model="form.boundFactoryNo" placeholder="满托盘库位绑定出厂编号" clearable @clear="handleBoundFactoryNoClear" @input="handleBoundFactoryNoInput" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="排序" prop="orderNum">
              <el-input-number v-model="form.orderNum" :min="0" :controls="false" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
            </el-form-item>
          </el-col>
        </el-row>
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
  { label: '小托盘', value: 1 },
  { label: '大托盘', value: 2 }
];

const statusOptions = [
  { label: '空闲', value: 0, tag: 'success' },
  { label: '占用', value: 1, tag: 'warning' },
  { label: '禁用', value: 2, tag: 'info' },
  { label: '锁定', value: 3, tag: 'danger' }
];

const storageStatusOptions = [
  { label: '空库位', value: 0, tag: 'success' },
  { label: '空托盘', value: 1, tag: 'warning' },
  { label: '满托盘', value: 2, tag: 'danger' }
];

const validateBoundFactoryNo = (_rule, value, callback) => {
  if (form.value.storageStatus === 2 && !value) {
    callback(new Error('满托盘库位必须绑定出厂编号'));
    return;
  }
  callback();
};

const initFormData = {
  id: undefined,
  binCode: undefined,
  binName: undefined,
  warehouseId: undefined,
  areaId: undefined,
  binType: 1,
  temperatureZone: 1,
  capacity: 1,
  usedCapacity: 0,
  status: 0,
  storageStatus: 0,
  boundFactoryNo: undefined,
  orderNum: 0,
  remark: undefined,
};

const data = reactive({
  form: { ...initFormData },
  queryParams: {
    pageNum: 1,
    pageSize: 50,
    binCode: undefined,
    binType: undefined,
    status: undefined,
    storageStatus: undefined,
    boundFactoryNo: undefined,
  },
  rules: {
    binCode: [
      { required: true, message: "库位编号不能为空", trigger: "blur" }
    ],
    warehouseId: [
      { required: true, message: "所属仓库不能为空", trigger: "change" }
    ],
    boundFactoryNo: [
      { validator: validateBoundFactoryNo, trigger: "blur" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

const getStatusLabel = (status) => {
  const found = statusOptions.find((item) => item.value === status);
  return found ? found.label : status;
};

const getBinTypeLabel = (type) => {
  const found = binTypeOptions.find((item) => item.value === type);
  return found ? found.label : type;
};

const getStatusTag = (status) => {
  const found = statusOptions.find((item) => item.value === status);
  return found ? found.tag : 'info';
};

const getStorageStatusLabel = (status) => {
  const found = storageStatusOptions.find((item) => item.value === status);
  return found ? found.label : status;
};

const getStorageStatusTag = (status) => {
  const found = storageStatusOptions.find((item) => item.value === status);
  return found ? found.tag : 'info';
};

const handleStorageStatusChange = () => {
  binFormRef.value?.validateField('boundFactoryNo');
};

const handleBoundFactoryNoClear = () => {
  if (form.value.storageStatus === 2) {
    form.value.storageStatus = 0;
  }
  binFormRef.value?.validateField('boundFactoryNo');
};

const handleBoundFactoryNoInput = (value) => {
  if (!value && form.value.storageStatus === 2) {
    form.value.storageStatus = 0;
  }
};

/** 查询库位列表 */
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
  }
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
  dialog.title = "添加库位";
  await reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改库位";
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
    await proxy?.$modal.confirm('是否确认删除库位编号为"' + _ids + '"的数据项？');
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
  await getList();
});
</script>
