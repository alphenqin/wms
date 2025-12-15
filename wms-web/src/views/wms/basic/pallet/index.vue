<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="托盘编号" prop="palletCode">
          <el-input v-model="queryParams.palletCode" placeholder="请输入托盘编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="托盘类型" prop="palletTypeId">
          <el-select v-model="queryParams.palletTypeId" placeholder="请选择托盘类型" clearable>
            <el-option
              v-for="item in palletTypeList"
              :key="item.id"
              :label="item.typeName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="是否空托" prop="isEmpty">
          <el-select v-model="queryParams.isEmpty" placeholder="请选择" clearable>
            <el-option label="是" :value="1" />
            <el-option label="否" :value="0" />
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
            v-hasPermi="['wms:pallet:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['wms:pallet:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:pallet:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="palletList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="托盘编号" prop="palletCode" />
        <el-table-column label="托盘类型" prop="palletTypeName" />
        <el-table-column label="是否空托" prop="isEmpty">
          <template #default="scope">
            <el-tag :type="scope.row.isEmpty === 1 ? 'success' : 'info'">
              {{ scope.row.isEmpty === 1 ? '是' : '否' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="条码是否启用" prop="barcodeEnabled">
          <template #default="scope">
            <el-tag :type="scope.row.barcodeEnabled === 1 ? 'success' : 'info'">
              {{ scope.row.barcodeEnabled === 1 ? '是' : '否' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="当前库位" prop="currentBinCode" />
        <el-table-column label="状态" prop="status">
          <template #default="scope">
            <dict-tag :options="dict.type.wms_pallet_status" :value="scope.row.status" />
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:pallet:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:pallet:remove']">删除</el-button>
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

    <!-- 添加或修改托盘对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="palletFormRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="托盘编号" prop="palletCode">
          <el-input v-model="form.palletCode" placeholder="请输入托盘编号" />
        </el-form-item>
        <el-form-item label="托盘类型" prop="palletTypeId">
          <el-select v-model="form.palletTypeId" placeholder="请选择托盘类型" style="width: 100%">
            <el-option
              v-for="item in palletTypeList"
              :key="item.id"
              :label="item.typeName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="是否空托" prop="isEmpty">
          <el-radio-group v-model="form.isEmpty">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="0">否</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="条码是否启用" prop="barcodeEnabled">
          <el-radio-group v-model="form.barcodeEnabled">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="0">否</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="当前库位" prop="currentBinCode">
          <el-input v-model="form.currentBinCode" placeholder="请输入当前库位" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="0">正常</el-radio>
            <el-radio :label="1">禁用</el-radio>
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

<script setup name="Pallet">
import { listPallet, getPallet, delPallet, addPallet, updatePallet } from '@/api/wms/pallet';
import { listPalletTypeNoPage } from '@/api/wms/palletType';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';
import { useDict } from '@/utils/dict';

const { proxy } = getCurrentInstance();
const { wms_pallet_status } = useDict('wms_pallet_status');

const palletList = ref([]);
const palletTypeList = ref([]);
const buttonLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const palletFormRef = ref();
const dict = reactive({ type: { wms_pallet_status } });

const dialog = reactive({
  visible: false,
  title: ''
});

const initFormData = {
  id: undefined,
  palletCode: undefined,
  palletTypeId: undefined,
  isEmpty: 1,
  barcodeEnabled: 1,
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
    palletCode: undefined,
    palletTypeId: undefined,
    isEmpty: undefined,
  },
  rules: {
    palletCode: [
      { required: true, message: "托盘编号不能为空", trigger: "blur" }
    ],
    palletTypeId: [
      { required: true, message: "托盘类型不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询托盘列表 */
const getList = async () => {
  loading.value = true;
  const res = await listPallet(queryParams.value).finally(() => {
    loading.value = false;
  });
  palletList.value = res.rows;
  total.value = res.total;
};

/** 查询托盘类型列表 */
const getPalletTypeList = async () => {
  const res = await listPalletTypeNoPage({});
  palletTypeList.value = res.data;
};

/** 取消按钮 */
const cancel = () => {
  reset();
  dialog.visible = false;
};

/** 表单重置 */
const reset = () => {
  form.value = {...initFormData};
  palletFormRef.value?.resetFields();
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
  dialog.title = "添加托盘";
  reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改托盘";
  const _id = row.id || ids.value[0];
  const res = await getPallet(_id);
  Object.assign(form.value, res.data);
};

/** 提交按钮 */
const submitForm = () => {
  palletFormRef.value?.validate(async (valid) => {
    if (valid) {
      buttonLoading.value = true;
      try {
        if (form.value.id) {
          await updatePallet(form.value);
          proxy?.$modal.msgSuccess('修改成功');
        } else {
          await addPallet(form.value);
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
  await proxy?.$modal.confirm('是否确认删除托盘编号为"' + _ids + '"的数据项？');
  await delPallet(_ids);
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

onMounted(async () => {
  await getPalletTypeList();
  await getList();
});
</script>

