<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="库管员编号" prop="keeperCode">
          <el-input v-model="queryParams.keeperCode" placeholder="请输入库管员编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="库管员姓名" prop="keeperName">
          <el-input v-model="queryParams.keeperName" placeholder="请输入库管员姓名" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="仓库" prop="warehouseId">
          <el-select v-model="queryParams.warehouseId" placeholder="请选择仓库" clearable>
            <el-option
              v-for="item in warehouseList"
              :key="item.id"
              :label="item.warehouseName"
              :value="item.id"
            />
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
            v-hasPermi="['wms:warehouseKeeper:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['wms:warehouseKeeper:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:warehouseKeeper:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="warehouseKeeperList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="库管员编号" prop="keeperCode" />
        <el-table-column label="库管员姓名" prop="keeperName" />
        <el-table-column label="所属仓库" prop="warehouseName" />
        <el-table-column label="岗位" prop="post" />
        <el-table-column label="入职日期" prop="joinDate" width="120" />
        <el-table-column label="状态" prop="status">
          <template #default="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:warehouseKeeper:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:warehouseKeeper:remove']">删除</el-button>
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

    <!-- 添加或修改库管员对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="warehouseKeeperFormRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="库管员编号" prop="keeperCode">
          <el-input v-model="form.keeperCode" placeholder="请输入库管员编号" />
        </el-form-item>
        <el-form-item label="库管员姓名" prop="keeperName">
          <el-input v-model="form.keeperName" placeholder="请输入库管员姓名" />
        </el-form-item>
        <el-form-item label="关联用户" prop="userId">
          <el-select v-model="form.userId" placeholder="请选择用户" filterable style="width: 100%">
            <!-- 这里需要调用用户列表接口 -->
            <el-option label="待实现" value="" />
          </el-select>
        </el-form-item>
        <el-form-item label="所属仓库" prop="warehouseId">
          <el-select v-model="form.warehouseId" placeholder="请选择仓库" style="width: 100%">
            <el-option
              v-for="item in warehouseList"
              :key="item.id"
              :label="item.warehouseName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="岗位" prop="post">
          <el-input v-model="form.post" placeholder="请输入岗位" />
        </el-form-item>
        <el-form-item label="入职日期" prop="joinDate">
          <el-date-picker
            v-model="form.joinDate"
            type="date"
            placeholder="选择入职日期"
            style="width: 100%"
            value-format="YYYY-MM-DD"
          />
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

<script setup name="WarehouseKeeper">
import { listWarehouseKeeper, getWarehouseKeeper, delWarehouseKeeper, addWarehouseKeeper, updateWarehouseKeeper } from '@/api/wms/warehouseKeeper';
import { listWarehouseNoPage } from '@/api/wms/warehouse';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';
import { useDict } from '@/utils/dict';

const { proxy } = getCurrentInstance();
const { sys_normal_disable } = useDict('sys_normal_disable');

const warehouseKeeperList = ref([]);
const warehouseList = ref([]);
const buttonLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const warehouseKeeperFormRef = ref();
const dict = reactive({ type: { sys_normal_disable } });

const dialog = reactive({
  visible: false,
  title: ''
});

const initFormData = {
  id: undefined,
  keeperCode: undefined,
  keeperName: undefined,
  userId: undefined,
  warehouseId: undefined,
  post: undefined,
  joinDate: undefined,
  status: '0',
  remark: undefined,
};

const data = reactive({
  form: {...initFormData},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    keeperCode: undefined,
    keeperName: undefined,
    warehouseId: undefined,
  },
  rules: {
    keeperName: [
      { required: true, message: "库管员姓名不能为空", trigger: "blur" }
    ],
    warehouseId: [
      { required: true, message: "所属仓库不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询库管员列表 */
const getList = async () => {
  loading.value = true;
  const res = await listWarehouseKeeper(queryParams.value).finally(() => {
    loading.value = false;
  });
  warehouseKeeperList.value = res.rows;
  total.value = res.total;
};

/** 查询仓库列表 */
const getWarehouseList = async () => {
  const res = await listWarehouseNoPage({});
  warehouseList.value = res.data;
};

/** 取消按钮 */
const cancel = () => {
  reset();
  dialog.visible = false;
};

/** 表单重置 */
const reset = () => {
  form.value = {...initFormData};
  warehouseKeeperFormRef.value?.resetFields();
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
  dialog.title = "添加库管员";
  reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改库管员";
  const _id = row.id || ids.value[0];
  const res = await getWarehouseKeeper(_id);
  Object.assign(form.value, res.data);
};

/** 提交按钮 */
const submitForm = () => {
  warehouseKeeperFormRef.value?.validate(async (valid) => {
    if (valid) {
      buttonLoading.value = true;
      try {
        if (form.value.id) {
          await updateWarehouseKeeper(form.value);
          proxy?.$modal.msgSuccess('修改成功');
        } else {
          await addWarehouseKeeper(form.value);
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
  await proxy?.$modal.confirm('是否确认删除库管员编号为"' + _ids + '"的数据项？');
  await delWarehouseKeeper(_ids);
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

onMounted(async () => {
  await getWarehouseList();
  await getList();
});
</script>

