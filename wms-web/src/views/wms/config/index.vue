<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="配置键" prop="configKey">
          <el-input v-model="queryParams.configKey" placeholder="请输入配置键" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="配置类型" prop="configType">
          <el-select v-model="queryParams.configType" placeholder="请选择配置类型" clearable>
            <el-option label="业务参数" :value="1" />
            <el-option label="规则配置" :value="2" />
            <el-option label="系统配置" :value="3" />
            <el-option label="PDA配置" :value="4" />
            <el-option label="AGV配置" :value="5" />
          </el-select>
        </el-form-item>
        <el-form-item label="配置分组" prop="configGroup">
          <el-input v-model="queryParams.configGroup" placeholder="请输入配置分组" clearable @keyup.enter="handleQuery" />
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
            v-hasPermi="['wms:config:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['wms:config:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:config:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="configList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="配置键" prop="configKey" />
        <el-table-column label="配置值" prop="configValue" show-overflow-tooltip />
        <el-table-column label="配置类型" prop="configType" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.configType === 1">业务参数</el-tag>
            <el-tag v-else-if="scope.row.configType === 2" type="success">规则配置</el-tag>
            <el-tag v-else-if="scope.row.configType === 3" type="info">系统配置</el-tag>
            <el-tag v-else-if="scope.row.configType === 4" type="warning">PDA配置</el-tag>
            <el-tag v-else-if="scope.row.configType === 5" type="danger">AGV配置</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="配置分组" prop="configGroup" />
        <el-table-column label="配置描述" prop="configDesc" show-overflow-tooltip />
        <el-table-column label="状态" prop="status">
          <template #default="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:config:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:config:remove']">删除</el-button>
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

    <!-- 添加或修改配置对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="configFormRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="配置键" prop="configKey">
          <el-input v-model="form.configKey" placeholder="请输入配置键" />
        </el-form-item>
        <el-form-item label="配置值" prop="configValue">
          <el-input v-model="form.configValue" type="textarea" :rows="4" placeholder="请输入配置值" />
        </el-form-item>
        <el-form-item label="配置类型" prop="configType">
          <el-select v-model="form.configType" placeholder="请选择配置类型" style="width: 100%">
            <el-option label="业务参数" :value="1" />
            <el-option label="规则配置" :value="2" />
            <el-option label="系统配置" :value="3" />
            <el-option label="PDA配置" :value="4" />
            <el-option label="AGV配置" :value="5" />
          </el-select>
        </el-form-item>
        <el-form-item label="配置分组" prop="configGroup">
          <el-input v-model="form.configGroup" placeholder="请输入配置分组（如：warehouse/pda/agv/system）" />
        </el-form-item>
        <el-form-item label="配置描述" prop="configDesc">
          <el-input v-model="form.configDesc" type="textarea" placeholder="请输入配置描述" />
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

<script setup name="WmsConfig">
import { listWmsConfig, getWmsConfig, delWmsConfig, addWmsConfig, updateWmsConfig } from '@/api/wms/wmsConfig';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';
import { useDict } from '@/utils/dict';

const { proxy } = getCurrentInstance();
const { sys_normal_disable } = useDict('sys_normal_disable');

const configList = ref([]);
const buttonLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const configFormRef = ref();
const dict = reactive({ type: { sys_normal_disable } });

const dialog = reactive({
  visible: false,
  title: ''
});

const initFormData = {
  id: undefined,
  configKey: undefined,
  configValue: undefined,
  configType: undefined,
  configGroup: undefined,
  configDesc: undefined,
  status: '0',
  remark: undefined,
};

const data = reactive({
  form: {...initFormData},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    configKey: undefined,
    configType: undefined,
    configGroup: undefined,
  },
  rules: {
    configKey: [
      { required: true, message: "配置键不能为空", trigger: "blur" }
    ],
    configValue: [
      { required: true, message: "配置值不能为空", trigger: "blur" }
    ],
    configType: [
      { required: true, message: "配置类型不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询配置列表 */
const getList = async () => {
  loading.value = true;
  const res = await listWmsConfig(queryParams.value).finally(() => {
    loading.value = false;
  });
  configList.value = res.rows;
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
  configFormRef.value?.resetFields();
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
  dialog.title = "添加配置";
  reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改配置";
  const _id = row.id || ids.value[0];
  const res = await getWmsConfig(_id);
  Object.assign(form.value, res.data);
};

/** 提交按钮 */
const submitForm = () => {
  configFormRef.value?.validate(async (valid) => {
    if (valid) {
      buttonLoading.value = true;
      try {
        if (form.value.id) {
          await updateWmsConfig(form.value);
          proxy?.$modal.msgSuccess('修改成功');
        } else {
          await addWmsConfig(form.value);
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
  await proxy?.$modal.confirm('是否确认删除配置编号为"' + _ids + '"的数据项？');
  await delWmsConfig(_ids);
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

onMounted(async () => {
  await getList();
});
</script>

