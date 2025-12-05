<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="货区编号" prop="areaCode">
          <el-input v-model="queryParams.areaCode" placeholder="请输入货区编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="货区名称" prop="areaName">
          <el-input v-model="queryParams.areaName" placeholder="请输入货区名称" clearable @keyup.enter="handleQuery" />
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
            v-hasPermi="['wms:area:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['wms:area:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:area:remove']"
          >删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="Download"
            @click="handleExport"
            v-hasPermi="['wms:area:export']"
          >导出</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="areaList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="货区编号" prop="areaCode" />
        <el-table-column label="货区名称" prop="areaName" />
        <el-table-column label="所属仓库" prop="warehouseName" />
        <el-table-column label="货区类型" prop="areaType">
          <template #default="scope">
            <dict-tag :options="dict.type.wms_area_type" :value="scope.row.areaType" />
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:area:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:area:remove']">删除</el-button>
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

    <!-- 添加或修改货区对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="500px" append-to-body :close-on-click-modal="false">
      <el-form ref="areaFormRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="货区编号" prop="areaCode">
          <el-input v-model="form.areaCode" placeholder="请输入货区编号" />
        </el-form-item>
        <el-form-item label="货区名称" prop="areaName">
          <el-input v-model="form.areaName" placeholder="请输入货区名称" />
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
        <el-form-item label="货区类型" prop="areaType">
          <el-select v-model="form.areaType" placeholder="请选择货区类型" style="width: 100%">
            <el-option label="普通货区" value="1" />
            <el-option label="置换区" value="2" />
            <el-option label="其他" value="3" />
          </el-select>
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

<script setup name="Area">
import { listArea, getArea, delArea, addArea, updateArea, exportArea, listAreaNoPage } from '@/api/wms/area';
import { listWarehouseNoPage } from '@/api/wms/warehouse';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';
import { useDict } from '@/utils/dict';

const { proxy } = getCurrentInstance();
const { wms_area_type } = useDict('wms_area_type');

const areaList = ref([]);
const warehouseList = ref([]);
const buttonLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const areaFormRef = ref();
const dict = reactive({ type: { wms_area_type } });

const dialog = reactive({
  visible: false,
  title: ''
});

const initFormData = {
  id: undefined,
  areaCode: undefined,
  areaName: undefined,
  warehouseId: undefined,
  areaType: undefined,
  remark: undefined,
};

const data = reactive({
  form: {...initFormData},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    areaCode: undefined,
    areaName: undefined,
    warehouseId: undefined,
  },
  rules: {
    areaName: [
      { required: true, message: "货区名称不能为空", trigger: "blur" }
    ],
    warehouseId: [
      { required: true, message: "所属仓库不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询货区列表 */
const getList = async () => {
  loading.value = true;
  const res = await listArea(queryParams.value).finally(() => {
    loading.value = false;
  });
  areaList.value = res.rows;
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
  areaFormRef.value?.resetFields();
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
  dialog.title = "添加货区";
  reset();
};

/** 修改按钮操作 */
const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = "修改货区";
  const _id = row.id || ids.value[0];
  const res = await getArea(_id);
  Object.assign(form.value, res.data);
};

/** 提交按钮 */
const submitForm = () => {
  areaFormRef.value?.validate(async (valid) => {
    if (valid) {
      buttonLoading.value = true;
      try {
        if (form.value.id) {
          await updateArea(form.value);
          proxy?.$modal.msgSuccess('修改成功');
        } else {
          await addArea(form.value);
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
  await proxy?.$modal.confirm('是否确认删除货区编号为"' + _ids + '"的数据项？');
  await delArea(_ids);
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

/** 导出按钮操作 */
const handleExport = () => {
  proxy?.download('wms/area/export', {
    ...queryParams.value
  }, `area_${new Date().getTime()}.xlsx`);
};

onMounted(async () => {
  await getWarehouseList();
  await getList();
});
</script>

