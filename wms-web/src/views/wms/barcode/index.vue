<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="条码编号" prop="barcodeNo">
          <el-input v-model="queryParams.barcodeNo" placeholder="请输入条码编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="条码类型" prop="barcodeType">
          <el-select v-model="queryParams.barcodeType" placeholder="请选择条码类型" clearable>
            <el-option label="托盘条码" value="1" />
            <el-option label="阀门条码" value="2" />
            <el-option label="库位条码" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
            <el-option label="正常" value="0" />
            <el-option label="停用" value="1" />
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
            v-hasPermi="['wms:barcode:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['wms:barcode:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:barcode:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="barcodeList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="条码编号" prop="barcodeNo" />
        <el-table-column label="条码类型" prop="barcodeType" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.barcodeType === 1">托盘条码</el-tag>
            <el-tag v-else-if="scope.row.barcodeType === 2" type="success">阀门条码</el-tag>
            <el-tag v-else-if="scope.row.barcodeType === 3" type="info">库位条码</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="关联对象" prop="relatedObject" />
        <el-table-column label="关联对象ID" prop="relatedObjectId" />
        <el-table-column label="状态" prop="status">
          <template #default="scope">
            <el-tag v-if="scope.row.status === '0'" type="success">正常</el-tag>
            <el-tag v-else-if="scope.row.status === '1'" type="danger">停用</el-tag>
            <span v-else>{{ scope.row.status }}</span>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:barcode:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:barcode:remove']">删除</el-button>
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

    <!-- 添加或修改条码对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="barcodeFormRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="条码编号" prop="barcodeNo">
          <el-input v-model="form.barcodeNo" placeholder="请输入条码编号" />
        </el-form-item>
        <el-form-item label="条码类型" prop="barcodeType">
          <el-select v-model="form.barcodeType" placeholder="请选择条码类型" style="width: 100%">
            <el-option label="托盘条码" :value="1" />
            <el-option label="阀门条码" :value="2" />
            <el-option label="库位条码" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="关联对象" prop="relatedObject">
          <el-input v-model="form.relatedObject" placeholder="请输入关联对象" />
        </el-form-item>
        <el-form-item label="关联对象ID" prop="relatedObjectId">
          <el-input-number v-model="form.relatedObjectId" :min="0" style="width: 100%" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio label="0">正常</el-radio>
            <el-radio label="1">停用</el-radio>
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

<script setup name="Barcode">
import { listBarcode, getBarcode, delBarcode, addBarcode, updateBarcode } from '@/api/wms/barcode';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';

const { proxy } = getCurrentInstance();

const barcodeList = ref([]);
const buttonLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const barcodeFormRef = ref();

const dialog = reactive({
  visible: false,
  title: ''
});

const initFormData = {
  id: undefined,
  barcodeNo: undefined,
  barcodeType: undefined,
  relatedObject: undefined,
  relatedObjectId: undefined,
  status: '0',
  remark: undefined,
};

const data = reactive({
  form: {...initFormData},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    barcodeNo: undefined,
    barcodeType: undefined,
    status: undefined,
  },
  rules: {
    barcodeNo: [
      { required: true, message: "条码编号不能为空", trigger: "blur" }
    ],
    barcodeType: [
      { required: true, message: "条码类型不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询条码列表 */
const getList = async () => {
  loading.value = true;
  const res = await listBarcode(queryParams.value).finally(() => {
    loading.value = false;
  });
  barcodeList.value = res.rows;
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
  barcodeFormRef.value?.resetFields();
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
  dialog.title = "添加条码";
  reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改条码";
  const _id = row.id || ids.value[0];
  const res = await getBarcode(_id);
  Object.assign(form.value, res.data);
};

/** 提交按钮 */
const submitForm = () => {
  barcodeFormRef.value?.validate(async (valid) => {
    if (valid) {
      buttonLoading.value = true;
      try {
        if (form.value.id) {
          await updateBarcode(form.value);
          proxy?.$modal.msgSuccess('修改成功');
        } else {
          await addBarcode(form.value);
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
  await proxy?.$modal.confirm('是否确认删除条码编号为"' + _ids + '"的数据项？');
  await delBarcode(_ids);
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

onMounted(async () => {
  await getList();
});
</script>

