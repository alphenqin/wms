<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="出厂编号" prop="valveNo">
          <el-input v-model="queryParams.valveNo" placeholder="请输入出厂编号" clearable class="query-input" @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="厂家" prop="manufacturer">
          <el-input v-model="queryParams.manufacturer" placeholder="请输入厂家" clearable class="query-input" @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="当前库位" prop="currentBinCode">
          <el-input v-model="queryParams.currentBinCode" placeholder="请输入当前库位" clearable class="query-input" @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择状态" clearable class="query-select">
            <el-option label="待检测" value="0" />
            <el-option label="检测中" value="1" />
            <el-option label="已检测" value="2" />
            <el-option label="已出库" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="入库日期" prop="createTimeRange">
          <el-date-picker
            v-model="queryParams.createTimeRange"
            type="daterange"
            range-separator="至"
            value-format="YYYY-MM-DD"
            format="YYYY-MM-DD"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            class="query-date-range"
            clearable
          />
        </el-form-item>
        <el-form-item label="出库日期" prop="outboundTimeRange">
          <el-date-picker
            v-model="queryParams.outboundTimeRange"
            type="daterange"
            range-separator="至"
            value-format="YYYY-MM-DD"
            format="YYYY-MM-DD"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            class="query-date-range"
            clearable
          />
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
            v-hasPermi="['wms:valve:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['wms:valve:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:valve:remove']"
          >删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="Download"
            @click="handleExport"
            v-hasPermi="['wms:valve:export']"
          >导出</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="valveList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:valve:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:valve:remove']">删除</el-button>
          </template>
        </el-table-column>
        <el-table-column label="出厂编号" prop="valveNo" min-width="220" class-name="factory-no-column" />
        <el-table-column label="状态" prop="status">
          <template #default="scope">
            <dict-tag :options="dict.type.wms_valve_status" :value="scope.row.status" />
          </template>
        </el-table-column>
        <el-table-column label="当前库位" prop="currentBinCode" />
        <el-table-column label="送检日期" prop="inspectionDate" width="170">
          <template #default="scope">
            {{ formatDate(scope.row.inspectionDate) }}
          </template>
        </el-table-column>
        <el-table-column label="回库日期" prop="returnDate" width="170">
          <template #default="scope">
            {{ formatDate(scope.row.returnDate) }}
          </template>
        </el-table-column>
        <el-table-column label="入库日期" prop="createTime" width="170">
          <template #default="scope">
            {{ formatDate(scope.row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="出库日期" prop="outboundTime" width="170">
          <template #default="scope">
            {{ formatDate(scope.row.outboundTime) }}
          </template>
        </el-table-column>
        <el-table-column label="备注" prop="remark" min-width="160" show-overflow-tooltip />
        <el-table-column label="厂家" prop="manufacturer" />
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 添加或修改阀门对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="valveFormRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="出厂编号" prop="valveNo">
          <el-input v-model="form.valveNo" placeholder="请输入出厂编号" />
        </el-form-item>
        <el-form-item label="厂家" prop="manufacturer">
          <el-input v-model="form.manufacturer" placeholder="请输入厂家" />
        </el-form-item>
        <el-form-item label="入库日期" prop="createTime">
          <el-date-picker
            v-model="form.createTime"
            type="date"
            value-format="YYYY-MM-DD 00:00:00"
            format="YYYY-MM-DD"
            placeholder="请选择入库日期"
            style="width: 100%"
            clearable
          />
        </el-form-item>
        <el-form-item label="出库日期" prop="outboundTime">
          <el-date-picker
            v-model="form.outboundTime"
            type="date"
            value-format="YYYY-MM-DD 00:00:00"
            format="YYYY-MM-DD"
            placeholder="请选择出库日期"
            style="width: 100%"
            clearable
          />
        </el-form-item>
        <el-form-item label="送检日期" prop="inspectionDate">
          <el-date-picker
            v-model="form.inspectionDate"
            type="date"
            value-format="YYYY-MM-DD 00:00:00"
            format="YYYY-MM-DD"
            placeholder="请选择送检日期"
            style="width: 100%"
            clearable
          />
        </el-form-item>
        <el-form-item label="回库日期" prop="returnDate">
          <el-date-picker
            v-model="form.returnDate"
            type="date"
            value-format="YYYY-MM-DD 00:00:00"
            format="YYYY-MM-DD"
            placeholder="请选择回库日期"
            style="width: 100%"
            clearable
          />
        </el-form-item>
        <el-form-item label="当前库位" prop="currentBinCode">
          <el-input v-model="form.currentBinCode" placeholder="请输入当前库位" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="0">待检测</el-radio>
            <el-radio :label="1">检测中</el-radio>
            <el-radio :label="2">已检测</el-radio>
            <el-radio :label="3">已出库</el-radio>
          </el-radio-group>
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

<script setup name="Valve">
import { listValve, getValve, delValve, delValves, addValve, updateValve, exportValve } from '@/api/wms/valve';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';
import { useDict } from '@/utils/dict';

const { proxy } = getCurrentInstance();
const { wms_valve_status } = useDict('wms_valve_status');

const valveList = ref([]);
const buttonLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const valveFormRef = ref();
const dict = reactive({ type: { wms_valve_status } });

const dialog = reactive({
  visible: false,
  title: ''
});

const initFormData = {
  id: undefined,
  valveNo: undefined,
  manufacturer: undefined,
  createTime: undefined,
  outboundTime: undefined,
  palletId: undefined,
  inspectionDate: undefined,
  returnDate: undefined,
  currentBinId: undefined,
  currentBinCode: undefined,
  status: 0,
  remark: undefined,
};

const data = reactive({
  form: {...initFormData},
  queryParams: {
    pageNum: 1,
    pageSize: 50,
    valveNo: undefined,
    manufacturer: undefined,
    status: undefined,
    currentBinCode: undefined,
    createTimeRange: undefined,
    outboundTimeRange: undefined,
  },
  rules: {}
});

const { queryParams, form, rules } = toRefs(data);

const formatDate = (value) => {
  if (!value) {
    return '-';
  }
  return String(value).replace('T', ' ').slice(0, 10);
};

const buildQueryParams = () => {
  const query = { ...queryParams.value };
  query.params = {};
  if (query.createTimeRange?.length === 2) {
    query.params.beginCreateTime = query.createTimeRange[0];
    query.params.endCreateTime = query.createTimeRange[1];
  }
  if (query.outboundTimeRange?.length === 2) {
    query.params.beginOutboundTime = query.outboundTimeRange[0];
    query.params.endOutboundTime = query.outboundTimeRange[1];
  }
  delete query.createTimeRange;
  delete query.outboundTimeRange;
  return query;
};

/** 查询阀门列表 */
const getList = async () => {
  loading.value = true;
  const res = await listValve(buildQueryParams()).finally(() => {
    loading.value = false;
  });
  valveList.value = res.rows;
  total.value = res.total;
};

/** 取消按钮 */
const cancel = () => {
  reset();
  dialog.visible = false;
};

/** 表单重置 */
const reset = () => {
  form.value = {...initFormData};
  valveFormRef.value?.resetFields();
};

/** 搜索按钮操作 */
const handleQuery = () => {
  queryParams.value.pageNum = 1;
  getList();
};

/** 重置按钮操作 */
const resetQuery = () => {
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
const handleAdd = () => {
  dialog.visible = true;
  dialog.title = "添加样品";
  reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改样品";
  const _id = row.id || ids.value[0];
  const res = await getValve(_id);
  Object.assign(form.value, res.data);
};

/** 提交按钮 */
const submitForm = () => {
  valveFormRef.value?.validate(async (valid) => {
    if (valid) {
      buttonLoading.value = true;
      try {
        if (form.value.id) {
          await updateValve(form.value);
          proxy?.$modal.msgSuccess('修改成功');
        } else {
          await addValve(form.value);
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
  const _ids = row?.id ?? ids.value;
  if (Array.isArray(_ids)) {
    if (!_ids.length) {
      proxy?.$modal.msgError('请选择要删除的数据');
      return;
    }
    await proxy?.$modal.confirm('是否确认删除共"' + _ids.length + '"条数据项？');
    await delValves(_ids);
  } else {
    await proxy?.$modal.confirm('是否确认删除出厂编号为"' + _ids + '"的数据项？');
    await delValve(_ids);
  }
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

/** 导出按钮操作 */
const handleExport = () => {
  proxy?.download('wms/valve/export', buildQueryParams(), `valve_${new Date().getTime()}.xlsx`);
};

onMounted(async () => {
  await getList();
});
</script>

<style scoped>
.query-input {
  width: 180px;
}

.query-select {
  width: 140px;
}

.query-date-range {
  width: 340px;
}

:deep(.factory-no-column .cell) {
  white-space: nowrap;
}
</style>
