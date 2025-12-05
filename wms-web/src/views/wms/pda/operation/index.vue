<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="操作编号" prop="operationNo">
          <el-input v-model="queryParams.operationNo" placeholder="请输入操作编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="操作类型" prop="operationType">
          <el-select v-model="queryParams.operationType" placeholder="请选择操作类型" clearable>
            <el-option label="托盘扫码" :value="1" />
            <el-option label="阀门扫码" :value="2" />
            <el-option label="库位扫码" :value="3" />
            <el-option label="入库" :value="4" />
            <el-option label="出库" :value="5" />
            <el-option label="送检" :value="6" />
            <el-option label="回库" :value="7" />
            <el-option label="盘点" :value="8" />
            <el-option label="任务取消" :value="9" />
          </el-select>
        </el-form-item>
        <el-form-item label="操作人" prop="operator">
          <el-input v-model="queryParams.operator" placeholder="请输入操作人" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="PDA设备" prop="pdaDeviceNo">
          <el-input v-model="queryParams.pdaDeviceNo" placeholder="请输入PDA设备编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-row :gutter="10" class="mb8">
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="pdaOperationList">
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="操作编号" prop="operationNo" width="150" />
        <el-table-column label="操作类型" prop="operationType" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.operationType === 1">托盘扫码</el-tag>
            <el-tag v-else-if="scope.row.operationType === 2" type="success">阀门扫码</el-tag>
            <el-tag v-else-if="scope.row.operationType === 3" type="info">库位扫码</el-tag>
            <el-tag v-else-if="scope.row.operationType === 4" type="warning">入库</el-tag>
            <el-tag v-else-if="scope.row.operationType === 5" type="danger">出库</el-tag>
            <el-tag v-else-if="scope.row.operationType === 6">送检</el-tag>
            <el-tag v-else-if="scope.row.operationType === 7">回库</el-tag>
            <el-tag v-else-if="scope.row.operationType === 8">盘点</el-tag>
            <el-tag v-else-if="scope.row.operationType === 9">任务取消</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作人" prop="operator" />
        <el-table-column label="PDA设备" prop="pdaDeviceNo" />
        <el-table-column label="扫描条码" prop="scannedCode" />
        <el-table-column label="业务单号" prop="bizOrderNo" />
        <el-table-column label="操作结果" prop="result" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.result === 1" type="success">成功</el-tag>
            <el-tag v-else-if="scope.row.result === 0" type="danger">失败</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="结果描述" prop="resultMsg" show-overflow-tooltip />
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="100">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">查看</el-button>
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

    <!-- 查看详情对话框 -->
    <el-dialog title="PDA操作详情" v-model="detailDialog.visible" width="700px" append-to-body>
      <el-descriptions :column="2" border v-if="operationDetail">
        <el-descriptions-item label="操作编号">{{ operationDetail.operationNo }}</el-descriptions-item>
        <el-descriptions-item label="操作类型">
          <el-tag v-if="operationDetail.operationType === 1">托盘扫码</el-tag>
          <el-tag v-else-if="operationDetail.operationType === 2" type="success">阀门扫码</el-tag>
          <el-tag v-else-if="operationDetail.operationType === 3" type="info">库位扫码</el-tag>
          <el-tag v-else-if="operationDetail.operationType === 4" type="warning">入库</el-tag>
          <el-tag v-else-if="operationDetail.operationType === 5" type="danger">出库</el-tag>
          <el-tag v-else-if="operationDetail.operationType === 6">送检</el-tag>
          <el-tag v-else-if="operationDetail.operationType === 7">回库</el-tag>
          <el-tag v-else-if="operationDetail.operationType === 8">盘点</el-tag>
          <el-tag v-else-if="operationDetail.operationType === 9">任务取消</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作人">{{ operationDetail.operator }}</el-descriptions-item>
        <el-descriptions-item label="PDA设备">{{ operationDetail.pdaDeviceNo }}</el-descriptions-item>
        <el-descriptions-item label="扫描条码">{{ operationDetail.scannedCode }}</el-descriptions-item>
        <el-descriptions-item label="业务单号">{{ operationDetail.bizOrderNo }}</el-descriptions-item>
        <el-descriptions-item label="操作结果">
          <el-tag v-if="operationDetail.result === 1" type="success">成功</el-tag>
          <el-tag v-else-if="operationDetail.result === 0" type="danger">失败</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="结果描述" :span="2">{{ operationDetail.resultMsg }}</el-descriptions-item>
        <el-descriptions-item label="错误信息" :span="2" v-if="operationDetail.errorMsg">
          <el-text type="danger">{{ operationDetail.errorMsg }}</el-text>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ operationDetail.createTime }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup name="PdaOperation">
import { listPdaOperation, getPdaOperation } from '@/api/wms/pdaOperation';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';

const { proxy } = getCurrentInstance();

const pdaOperationList = ref([]);
const operationDetail = ref(null);
const loading = ref(false);
const showSearch = ref(true);
const total = ref(0);
const queryFormRef = ref();
const detailDialog = reactive({
  visible: false
});

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    operationNo: undefined,
    operationType: undefined,
    operator: undefined,
    pdaDeviceNo: undefined,
  }
});

const { queryParams } = toRefs(data);

/** 查询PDA操作列表 */
const getList = async () => {
  loading.value = true;
  const res = await listPdaOperation(queryParams.value).finally(() => {
    loading.value = false;
  });
  pdaOperationList.value = res.rows;
  total.value = res.total;
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

/** 查看详情 */
const handleView = async (row) => {
  const res = await getPdaOperation(row.id);
  operationDetail.value = res.data;
  detailDialog.visible = true;
};

onMounted(async () => {
  await getList();
});
</script>

