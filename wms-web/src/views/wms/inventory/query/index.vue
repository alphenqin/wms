<template>
  <div class="app-container">
    <el-card>
      <el-tabs v-model="activeTab" @tab-change="handleTabChange">
        <el-tab-pane label="按日期查询" name="date">
          <el-form :model="dateParams" ref="dateFormRef" :inline="true" label-width="100px" class="mb20">
            <el-form-item label="开始日期">
              <el-date-picker
                v-model="dateParams.startDate"
                type="date"
                placeholder="选择开始日期"
                value-format="YYYY-MM-DD"
              />
            </el-form-item>
            <el-form-item label="结束日期">
              <el-date-picker
                v-model="dateParams.endDate"
                type="date"
                placeholder="选择结束日期"
                value-format="YYYY-MM-DD"
              />
            </el-form-item>
            <el-form-item label="仓库">
              <el-select v-model="dateParams.warehouseId" placeholder="请选择仓库" clearable>
                <el-option
                  v-for="item in warehouseList"
                  :key="item.id"
                  :label="item.warehouseName"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="queryByDate">查询</el-button>
              <el-button icon="Refresh" @click="resetDateQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table v-loading="dateLoading" :data="dateResultList" border>
            <el-table-column label="物料名称" prop="itemName" />
            <el-table-column label="规格" prop="skuName" />
            <el-table-column label="数量" prop="quantity" />
            <el-table-column label="仓库" prop="warehouseName" />
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="按批次查询" name="batch">
          <el-form :model="batchParams" ref="batchFormRef" :inline="true" label-width="100px" class="mb20">
            <el-form-item label="批次号" prop="batchNo">
              <el-input v-model="batchParams.batchNo" placeholder="请输入批次号" />
            </el-form-item>
            <el-form-item label="仓库">
              <el-select v-model="batchParams.warehouseId" placeholder="请选择仓库" clearable>
                <el-option
                  v-for="item in warehouseList"
                  :key="item.id"
                  :label="item.warehouseName"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="queryByBatch">查询</el-button>
              <el-button icon="Refresh" @click="resetBatchQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table v-loading="batchLoading" :data="batchResultList" border>
            <el-table-column label="阀门编号" prop="valveNo" />
            <el-table-column label="型号" prop="model" />
            <el-table-column label="批次号" prop="batchNo" />
            <el-table-column label="状态" prop="status">
              <template #default="scope">
                <el-tag v-if="scope.row.status === 0">在库</el-tag>
                <el-tag v-else-if="scope.row.status === 1" type="warning">检测中</el-tag>
                <el-tag v-else-if="scope.row.status === 2" type="success">已检测</el-tag>
                <el-tag v-else-if="scope.row.status === 3">已出库</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="按库位查询" name="bin">
          <el-form :model="binParams" ref="binFormRef" :inline="true" label-width="100px" class="mb20">
            <el-form-item label="库位编号" prop="binCode">
              <el-input v-model="binParams.binCode" placeholder="请输入库位编号" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="queryByBin">查询</el-button>
              <el-button icon="Refresh" @click="resetBinQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table v-loading="binLoading" :data="binResultList" border>
            <el-table-column label="阀门编号" prop="valveNo" />
            <el-table-column label="型号" prop="model" />
            <el-table-column label="托盘编号" prop="palletCode" />
            <el-table-column label="库位编号" prop="currentBinCode" />
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="按托盘查询" name="pallet">
          <el-form :model="palletParams" ref="palletFormRef" :inline="true" label-width="100px" class="mb20">
            <el-form-item label="托盘编号" prop="palletCode">
              <el-input v-model="palletParams.palletCode" placeholder="请输入托盘编号" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="queryByPallet">查询</el-button>
              <el-button icon="Refresh" @click="resetPalletQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table v-loading="palletLoading" :data="palletResultList" border>
            <el-table-column label="阀门编号" prop="valveNo" />
            <el-table-column label="型号" prop="model" />
            <el-table-column label="托盘编号" prop="palletCode" />
            <el-table-column label="状态" prop="status">
              <template #default="scope">
                <el-tag v-if="scope.row.status === 0">在库</el-tag>
                <el-tag v-else-if="scope.row.status === 1" type="warning">检测中</el-tag>
                <el-tag v-else-if="scope.row.status === 2" type="success">已检测</el-tag>
                <el-tag v-else-if="scope.row.status === 3">已出库</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="状态统计" name="status">
          <el-card>
            <el-descriptions :column="3" border v-if="statusSummary">
              <el-descriptions-item label="在库阀门">{{ statusSummary.valveInStock }}</el-descriptions-item>
              <el-descriptions-item label="检测中">{{ statusSummary.valveInspecting }}</el-descriptions-item>
              <el-descriptions-item label="已检测">{{ statusSummary.valveInspected }}</el-descriptions-item>
              <el-descriptions-item label="已出库">{{ statusSummary.valveShipped }}</el-descriptions-item>
              <el-descriptions-item label="空托盘">{{ statusSummary.emptyPallets }}</el-descriptions-item>
              <el-descriptions-item label="载货托盘">{{ statusSummary.loadedPallets }}</el-descriptions-item>
              <el-descriptions-item label="空闲库位">{{ statusSummary.emptyBins }}</el-descriptions-item>
              <el-descriptions-item label="占用库位">{{ statusSummary.occupiedBins }}</el-descriptions-item>
              <el-descriptions-item label="禁用库位">{{ statusSummary.disabledBins }}</el-descriptions-item>
              <el-descriptions-item label="锁定库位">{{ statusSummary.lockedBins }}</el-descriptions-item>
            </el-descriptions>
            <div class="mt20">
              <el-button type="primary" @click="queryStatusSummary">刷新统计</el-button>
            </div>
          </el-card>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup name="InventoryQuery">
import { queryByDate, queryByBatch, queryByBin, queryByPallet, queryStatusSummary } from '@/api/wms/inventoryQuery';
import { listWarehouseNoPage } from '@/api/wms/warehouse';
import { ref, reactive, onMounted } from 'vue';

const activeTab = ref('date');
const warehouseList = ref([]);

const dateLoading = ref(false);
const batchLoading = ref(false);
const binLoading = ref(false);
const palletLoading = ref(false);

const dateResultList = ref([]);
const batchResultList = ref([]);
const binResultList = ref([]);
const palletResultList = ref([]);
const statusSummary = ref(null);

const dateParams = reactive({
  startDate: undefined,
  endDate: undefined,
  warehouseId: undefined,
});

const batchParams = reactive({
  batchNo: undefined,
  warehouseId: undefined,
});

const binParams = reactive({
  binCode: undefined,
});

const palletParams = reactive({
  palletCode: undefined,
});

/** 查询仓库列表 */
const getWarehouseList = async () => {
  const res = await listWarehouseNoPage({});
  warehouseList.value = res.data;
};

/** 按日期查询 */
const queryByDate = async () => {
  dateLoading.value = true;
  try {
    const res = await queryByDate(dateParams);
    dateResultList.value = res.data || [];
  } finally {
    dateLoading.value = false;
  }
};

/** 按批次查询 */
const queryByBatch = async () => {
  batchLoading.value = true;
  try {
    const res = await queryByBatch(batchParams);
    batchResultList.value = res.data || [];
  } finally {
    batchLoading.value = false;
  }
};

/** 按库位查询 */
const queryByBin = async () => {
  binLoading.value = true;
  try {
    const res = await queryByBin(binParams);
    binResultList.value = res.data || [];
  } finally {
    binLoading.value = false;
  }
};

/** 按托盘查询 */
const queryByPallet = async () => {
  palletLoading.value = true;
  try {
    const res = await queryByPallet(palletParams);
    palletResultList.value = res.data || [];
  } finally {
    palletLoading.value = false;
  }
};

/** 查询状态统计 */
const queryStatusSummary = async () => {
  try {
    const res = await queryStatusSummary({});
    statusSummary.value = res.data;
  } catch (error) {
    console.error('查询状态统计失败', error);
  }
};

const resetDateQuery = () => {
  Object.assign(dateParams, {
    startDate: undefined,
    endDate: undefined,
    warehouseId: undefined,
  });
};

const resetBatchQuery = () => {
  Object.assign(batchParams, {
    batchNo: undefined,
    warehouseId: undefined,
  });
};

const resetBinQuery = () => {
  Object.assign(binParams, {
    binCode: undefined,
  });
};

const resetPalletQuery = () => {
  Object.assign(palletParams, {
    palletCode: undefined,
  });
};

const handleTabChange = (tabName) => {
  if (tabName === 'status' && !statusSummary.value) {
    queryStatusSummary();
  }
};

onMounted(async () => {
  await getWarehouseList();
  await queryStatusSummary();
});
</script>

<style scoped>
.mb20 {
  margin-bottom: 20px;
}
.mt20 {
  margin-top: 20px;
}
</style>

