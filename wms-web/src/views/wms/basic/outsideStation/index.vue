<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="80px">
        <el-form-item label="库外站点" prop="stationCode">
          <el-input v-model="queryParams.stationCode" placeholder="请输入库外站点" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="托盘类型" prop="palletType">
          <el-select v-model="queryParams.palletType" placeholder="请选择托盘类型" clearable>
            <el-option label="小托盘" value="t1" />
            <el-option label="大托盘" value="t2" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
            <el-option label="空闲" value="IDLE" />
            <el-option label="占用" value="OCCUPIED" />
            <el-option label="回库中" value="RETURNING" />
          </el-select>
        </el-form-item>
        <el-form-item label="来源类型" prop="sourceType">
          <el-select v-model="queryParams.sourceType" placeholder="请选择来源类型" clearable>
            <el-option label="送检" value="INSPECTION" />
            <el-option label="出库" value="OUTBOUND" />
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
            v-hasPermi="['wms:outsideStation:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['wms:outsideStation:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:outsideStation:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="outsideStationList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="90" />
        <el-table-column label="库外站点" prop="stationCode" min-width="130" />
        <el-table-column label="托盘类型" prop="palletType" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.palletType === 't1'">小托盘</el-tag>
            <el-tag v-else-if="scope.row.palletType === 't2'" type="success">大托盘</el-tag>
            <span v-else>{{ scope.row.palletType || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" prop="status" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.status === 'IDLE'" type="success">空闲</el-tag>
            <el-tag v-else-if="scope.row.status === 'OCCUPIED'" type="warning">占用</el-tag>
            <el-tag v-else-if="scope.row.status === 'RETURNING'" type="info">回库中</el-tag>
            <span v-else>{{ scope.row.status || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="回库目标库位" prop="sourceBinCode" min-width="120" show-overflow-tooltip />
        <el-table-column label="托盘号" prop="palletNo" min-width="120" show-overflow-tooltip />
        <el-table-column label="来源任务号" prop="sourceTaskNo" min-width="160" show-overflow-tooltip />
        <el-table-column label="来源类型" prop="sourceType" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.sourceType === 'INSPECTION'">送检</el-tag>
            <el-tag v-else-if="scope.row.sourceType === 'OUTBOUND'" type="success">出库</el-tag>
            <span v-else>{{ scope.row.sourceType || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="回库任务号" prop="returnTaskNo" min-width="160" show-overflow-tooltip />
        <el-table-column label="失败原因" prop="errorMsg" min-width="160" show-overflow-tooltip />
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['wms:outsideStation:edit']">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:outsideStation:remove']">删除</el-button>
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

    <el-dialog :title="dialog.title" v-model="dialog.visible" width="640px" append-to-body :close-on-click-modal="false">
      <el-form ref="outsideStationFormRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="库外站点" prop="stationCode">
          <el-input v-model="form.stationCode" placeholder="请输入库外站点，如 Z6-装卸点" />
        </el-form-item>
        <el-form-item label="托盘类型" prop="palletType">
          <el-select v-model="form.palletType" placeholder="请选择托盘类型" style="width: 100%">
            <el-option label="小托盘" value="t1" />
            <el-option label="大托盘" value="t2" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio label="IDLE">空闲</el-radio>
            <el-radio label="OCCUPIED">占用</el-radio>
            <el-radio label="RETURNING">回库中</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="回库目标库位" prop="sourceBinCode">
          <el-input v-model="form.sourceBinCode" placeholder="请输入回库目标库位" />
        </el-form-item>
        <el-form-item label="托盘号" prop="palletNo">
          <el-input v-model="form.palletNo" placeholder="请输入托盘号" />
        </el-form-item>
        <el-form-item label="来源任务号" prop="sourceTaskNo">
          <el-input v-model="form.sourceTaskNo" placeholder="请输入来源任务号" />
        </el-form-item>
        <el-form-item label="来源类型" prop="sourceType">
          <el-select v-model="form.sourceType" placeholder="请选择来源类型" clearable style="width: 100%">
            <el-option label="送检" value="INSPECTION" />
            <el-option label="出库" value="OUTBOUND" />
          </el-select>
        </el-form-item>
        <el-form-item label="回库任务号" prop="returnTaskNo">
          <el-input v-model="form.returnTaskNo" placeholder="请输入空托回库任务号" />
        </el-form-item>
        <el-form-item label="失败原因" prop="errorMsg">
          <el-input v-model="form.errorMsg" type="textarea" placeholder="请输入失败原因" />
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

<script setup name="OutsideStation">
import { listOutsideStation, getOutsideStation, delOutsideStation, delOutsideStations, addOutsideStation, updateOutsideStation } from '@/api/wms/outsideStation';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';

const { proxy } = getCurrentInstance();

const outsideStationList = ref([]);
const buttonLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const outsideStationFormRef = ref();

const dialog = reactive({
  visible: false,
  title: ''
});

const initFormData = {
  id: undefined,
  stationCode: undefined,
  palletType: undefined,
  status: 'IDLE',
  sourceBinCode: undefined,
  palletNo: undefined,
  sourceTaskNo: undefined,
  sourceType: undefined,
  returnTaskNo: undefined,
  errorMsg: undefined,
};

const data = reactive({
  form: {...initFormData},
  queryParams: {
    pageNum: 1,
    pageSize: 50,
    stationCode: undefined,
    palletType: undefined,
    status: undefined,
    sourceType: undefined,
  },
  rules: {
    stationCode: [
      { required: true, message: '库外站点不能为空', trigger: 'blur' }
    ],
    palletType: [
      { required: true, message: '托盘类型不能为空', trigger: 'change' }
    ],
    status: [
      { required: true, message: '状态不能为空', trigger: 'change' }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

const getList = async () => {
  loading.value = true;
  const res = await listOutsideStation(queryParams.value).finally(() => {
    loading.value = false;
  });
  outsideStationList.value = res.rows;
  total.value = res.total;
};

const cancel = () => {
  reset();
  dialog.visible = false;
};

const reset = () => {
  form.value = {...initFormData};
  outsideStationFormRef.value?.resetFields();
};

const handleQuery = () => {
  queryParams.value.pageNum = 1;
  getList();
};

const resetQuery = () => {
  queryFormRef.value?.resetFields();
  handleQuery();
};

const handleSelectionChange = (selection) => {
  ids.value = selection.map(item => item.id);
  single.value = selection.length !== 1;
  multiple.value = !selection.length;
};

const handleAdd = () => {
  dialog.visible = true;
  dialog.title = '添加库外站点';
  reset();
};

const handleUpdate = async (row) => {
  dialog.visible = true;
  dialog.title = '修改库外站点';
  const _id = row.id || ids.value[0];
  const res = await getOutsideStation(_id);
  Object.assign(form.value, res.data);
};

const submitForm = () => {
  outsideStationFormRef.value?.validate(async (valid) => {
    if (valid) {
      buttonLoading.value = true;
      try {
        if (form.value.id) {
          await updateOutsideStation(form.value);
          proxy?.$modal.msgSuccess('修改成功');
        } else {
          await addOutsideStation(form.value);
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

const handleDelete = async (row) => {
  const _ids = row.id || ids.value;
  await proxy?.$modal.confirm('是否确认删除库外站点编号为"' + _ids + '"的数据项？');
  if (Array.isArray(_ids)) {
    await delOutsideStations(_ids);
  } else {
    await delOutsideStation(_ids);
  }
  proxy?.$modal.msgSuccess('删除成功');
  await getList();
};

onMounted(async () => {
  await getList();
});
</script>
