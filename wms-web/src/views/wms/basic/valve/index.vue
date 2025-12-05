<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="阀门编号" prop="valveNo">
          <el-input v-model="queryParams.valveNo" placeholder="请输入阀门编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="型号" prop="model">
          <el-input v-model="queryParams.model" placeholder="请输入型号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
            <el-option label="在库" value="0" />
            <el-option label="检测中" value="1" />
            <el-option label="已检测" value="2" />
            <el-option label="已出库" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="托盘编号" prop="palletCode">
          <el-input v-model="queryParams.palletCode" placeholder="请输入托盘编号" clearable @keyup.enter="handleQuery" />
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
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="阀门编号" prop="valveNo" />
        <el-table-column label="型号" prop="model" />
        <el-table-column label="厂家" prop="manufacturer" />
        <el-table-column label="批次号" prop="batchNo" />
        <el-table-column label="托盘编号" prop="palletCode" />
        <el-table-column label="当前库位" prop="currentBinCode" />
        <el-table-column label="状态" prop="status">
          <template #default="scope">
            <dict-tag :options="dict.type.wms_valve_status" :value="scope.row.status" />
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:valve:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:valve:remove']">删除</el-button>
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

    <!-- 添加或修改阀门对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="valveFormRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="阀门编号" prop="valveNo">
          <el-input v-model="form.valveNo" placeholder="请输入阀门编号" />
        </el-form-item>
        <el-form-item label="型号" prop="model">
          <el-input v-model="form.model" placeholder="请输入型号" />
        </el-form-item>
        <el-form-item label="厂家" prop="manufacturer">
          <el-input v-model="form.manufacturer" placeholder="请输入厂家" />
        </el-form-item>
        <el-form-item label="批次号" prop="batchNo">
          <el-input v-model="form.batchNo" placeholder="请输入批次号" />
        </el-form-item>
        <el-form-item label="物料类型" prop="materialTypeId">
          <el-select v-model="form.materialTypeId" placeholder="请选择物料类型" style="width: 100%">
            <el-option
              v-for="item in materialTypeList"
              :key="item.id"
              :label="item.typeName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="托盘编号" prop="palletCode">
          <el-input v-model="form.palletCode" placeholder="请输入托盘编号" />
        </el-form-item>
        <el-form-item label="当前库位" prop="currentBinCode">
          <el-input v-model="form.currentBinCode" placeholder="请输入当前库位" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="0">在库</el-radio>
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
import { listValve, getValve, delValve, addValve, updateValve, exportValve } from '@/api/wms/valve';
import { listMaterialTypeNoPage } from '@/api/wms/materialType';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';
import { useDict } from '@/utils/dict';

const { proxy } = getCurrentInstance();
const { wms_valve_status } = useDict('wms_valve_status');

const valveList = ref([]);
const materialTypeList = ref([]);
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
  model: undefined,
  manufacturer: undefined,
  batchNo: undefined,
  materialTypeId: undefined,
  palletId: undefined,
  palletCode: undefined,
  currentBinId: undefined,
  currentBinCode: undefined,
  status: 0,
  remark: undefined,
};

const data = reactive({
  form: {...initFormData},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    valveNo: undefined,
    model: undefined,
    status: undefined,
    palletCode: undefined,
  },
  rules: {
    valveNo: [
      { required: true, message: "阀门编号不能为空", trigger: "blur" }
    ],
    model: [
      { required: true, message: "型号不能为空", trigger: "blur" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询阀门列表 */
const getList = async () => {
  loading.value = true;
  const res = await listValve(queryParams.value).finally(() => {
    loading.value = false;
  });
  valveList.value = res.rows;
  total.value = res.total;
};

/** 查询物料类型列表 */
const getMaterialTypeList = async () => {
  const res = await listMaterialTypeNoPage({});
  materialTypeList.value = res.data;
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
  dialog.title = "添加阀门";
  reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改阀门";
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
  const _ids = row.id || ids.value;
  await proxy?.$modal.confirm('是否确认删除阀门编号为"' + _ids + '"的数据项？');
  await delValve(_ids);
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

/** 导出按钮操作 */
const handleExport = () => {
  proxy?.download('wms/valve/export', {
    ...queryParams.value
  }, `valve_${new Date().getTime()}.xlsx`);
};

onMounted(async () => {
  await getMaterialTypeList();
  await getList();
});
</script>

