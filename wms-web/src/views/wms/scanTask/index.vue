<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="任务编号" prop="taskNo">
          <el-input v-model="queryParams.taskNo" placeholder="请输入任务编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="任务类型" prop="taskType">
          <el-select v-model="queryParams.taskType" placeholder="请选择任务类型" clearable>
            <el-option label="入库扫码" value="1" />
            <el-option label="出库扫码" value="2" />
            <el-option label="盘点扫码" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="任务状态" prop="taskStatus">
          <el-select v-model="queryParams.taskStatus" placeholder="请选择任务状态" clearable>
            <el-option label="待执行" value="0" />
            <el-option label="执行中" value="1" />
            <el-option label="已完成" value="2" />
            <el-option label="已取消" value="3" />
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
            v-hasPermi="['wms:scanTask:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['wms:scanTask:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:scanTask:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="scanTaskList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="任务编号" prop="taskNo" />
        <el-table-column label="任务类型" prop="taskType" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.taskType === 1">入库扫码</el-tag>
            <el-tag v-else-if="scope.row.taskType === 2" type="warning">出库扫码</el-tag>
            <el-tag v-else-if="scope.row.taskType === 3" type="info">盘点扫码</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="业务单号" prop="bizOrderNo" />
        <el-table-column label="任务状态" prop="taskStatus" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.taskStatus === 0" type="info">待执行</el-tag>
            <el-tag v-else-if="scope.row.taskStatus === 1" type="warning">执行中</el-tag>
            <el-tag v-else-if="scope.row.taskStatus === 2" type="success">已完成</el-tag>
            <el-tag v-else-if="scope.row.taskStatus === 3">已取消</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="扫码数量" prop="scanCount" />
        <el-table-column label="目标数量" prop="targetCount" />
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:scanTask:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:scanTask:remove']">删除</el-button>
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

    <!-- 添加或修改扫码任务对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="scanTaskFormRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="任务编号" prop="taskNo">
          <el-input v-model="form.taskNo" placeholder="请输入任务编号" />
        </el-form-item>
        <el-form-item label="任务类型" prop="taskType">
          <el-select v-model="form.taskType" placeholder="请选择任务类型" style="width: 100%">
            <el-option label="入库扫码" :value="1" />
            <el-option label="出库扫码" :value="2" />
            <el-option label="盘点扫码" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="业务单号" prop="bizOrderNo">
          <el-input v-model="form.bizOrderNo" placeholder="请输入业务单号" />
        </el-form-item>
        <el-form-item label="目标数量" prop="targetCount">
          <el-input-number v-model="form.targetCount" :min="0" style="width: 100%" />
        </el-form-item>
        <el-form-item label="任务状态" prop="taskStatus">
          <el-radio-group v-model="form.taskStatus">
            <el-radio :label="0">待执行</el-radio>
            <el-radio :label="1">执行中</el-radio>
            <el-radio :label="2">已完成</el-radio>
            <el-radio :label="3">已取消</el-radio>
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

<script setup name="ScanTask">
import { listScanTask, getScanTask, delScanTask, addScanTask, updateScanTask } from '@/api/wms/scanTask';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';

const { proxy } = getCurrentInstance();

const scanTaskList = ref([]);
const buttonLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const scanTaskFormRef = ref();

const dialog = reactive({
  visible: false,
  title: ''
});

const initFormData = {
  id: undefined,
  taskNo: undefined,
  taskType: undefined,
  bizOrderNo: undefined,
  targetCount: undefined,
  scanCount: 0,
  taskStatus: 0,
  remark: undefined,
};

const data = reactive({
  form: {...initFormData},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    taskNo: undefined,
    taskType: undefined,
    taskStatus: undefined,
  },
  rules: {
    taskNo: [
      { required: true, message: "任务编号不能为空", trigger: "blur" }
    ],
    taskType: [
      { required: true, message: "任务类型不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询扫码任务列表 */
const getList = async () => {
  loading.value = true;
  const res = await listScanTask(queryParams.value).finally(() => {
    loading.value = false;
  });
  scanTaskList.value = res.rows;
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
  scanTaskFormRef.value?.resetFields();
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
  dialog.title = "添加扫码任务";
  reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改扫码任务";
  const _id = row.id || ids.value[0];
  const res = await getScanTask(_id);
  Object.assign(form.value, res.data);
};

/** 提交按钮 */
const submitForm = () => {
  scanTaskFormRef.value?.validate(async (valid) => {
    if (valid) {
      buttonLoading.value = true;
      try {
        if (form.value.id) {
          await updateScanTask(form.value);
          proxy?.$modal.msgSuccess('修改成功');
        } else {
          await addScanTask(form.value);
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
  await proxy?.$modal.confirm('是否确认删除扫码任务编号为"' + _ids + '"的数据项？');
  await delScanTask(_ids);
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

onMounted(async () => {
  await getList();
});
</script>

