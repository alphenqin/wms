<template>
  <div class="app-container">
    <el-card>
      <el-tabs v-model="activeTab" @tab-change="handleTabChange">
        <el-tab-pane label="入库报表" name="inbound">
          <el-form :model="inboundParams" ref="inboundFormRef" :inline="true" label-width="80px" class="mb20">
            <el-form-item label="开始日期">
              <el-date-picker
                v-model="inboundParams.startDate"
                type="date"
                placeholder="选择开始日期"
                value-format="YYYY-MM-DD"
              />
            </el-form-item>
            <el-form-item label="结束日期">
              <el-date-picker
                v-model="inboundParams.endDate"
                type="date"
                placeholder="选择结束日期"
                value-format="YYYY-MM-DD"
              />
            </el-form-item>
            <el-form-item label="仓库">
              <el-select v-model="inboundParams.warehouseId" placeholder="请选择仓库" clearable>
                <el-option
                  v-for="item in warehouseList"
                  :key="item.id"
                  :label="item.warehouseName"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="queryInboundReport">查询</el-button>
              <el-button icon="Refresh" @click="resetInboundQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table v-loading="inboundLoading" :data="inboundReportList" border>
            <el-table-column label="日期" prop="date" width="120" />
            <el-table-column label="型号" prop="model" />
            <el-table-column label="厂家" prop="manufacturer" />
            <el-table-column label="数量" prop="quantity" />
            <el-table-column label="金额" prop="amount" />
          </el-table>
          <pagination
            v-show="inboundTotal > 0"
            :total="inboundTotal"
            v-model:page="inboundParams.pageNum"
            v-model:limit="inboundParams.pageSize"
            @pagination="queryInboundReport"
          />
        </el-tab-pane>

        <el-tab-pane label="出库报表" name="outbound">
          <el-form :model="outboundParams" ref="outboundFormRef" :inline="true" label-width="80px" class="mb20">
            <el-form-item label="开始日期">
              <el-date-picker
                v-model="outboundParams.startDate"
                type="date"
                placeholder="选择开始日期"
                value-format="YYYY-MM-DD"
              />
            </el-form-item>
            <el-form-item label="结束日期">
              <el-date-picker
                v-model="outboundParams.endDate"
                type="date"
                placeholder="选择结束日期"
                value-format="YYYY-MM-DD"
              />
            </el-form-item>
            <el-form-item label="仓库">
              <el-select v-model="outboundParams.warehouseId" placeholder="请选择仓库" clearable>
                <el-option
                  v-for="item in warehouseList"
                  :key="item.id"
                  :label="item.warehouseName"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="queryOutboundReport">查询</el-button>
              <el-button icon="Refresh" @click="resetOutboundQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table v-loading="outboundLoading" :data="outboundReportList" border>
            <el-table-column label="日期" prop="date" width="120" />
            <el-table-column label="型号" prop="model" />
            <el-table-column label="厂家" prop="manufacturer" />
            <el-table-column label="数量" prop="quantity" />
            <el-table-column label="金额" prop="amount" />
          </el-table>
          <pagination
            v-show="outboundTotal > 0"
            :total="outboundTotal"
            v-model:page="outboundParams.pageNum"
            v-model:limit="outboundParams.pageSize"
            @pagination="queryOutboundReport"
          />
        </el-tab-pane>

        <el-tab-pane label="盘存报表" name="check">
          <el-form :model="checkParams" ref="checkFormRef" :inline="true" label-width="80px" class="mb20">
            <el-form-item label="开始日期">
              <el-date-picker
                v-model="checkParams.startDate"
                type="date"
                placeholder="选择开始日期"
                value-format="YYYY-MM-DD"
              />
            </el-form-item>
            <el-form-item label="结束日期">
              <el-date-picker
                v-model="checkParams.endDate"
                type="date"
                placeholder="选择结束日期"
                value-format="YYYY-MM-DD"
              />
            </el-form-item>
            <el-form-item label="仓库">
              <el-select v-model="checkParams.warehouseId" placeholder="请选择仓库" clearable>
                <el-option
                  v-for="item in warehouseList"
                  :key="item.id"
                  :label="item.warehouseName"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="queryCheckReport">查询</el-button>
              <el-button icon="Refresh" @click="resetCheckQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table v-loading="checkLoading" :data="checkReportList" border>
            <el-table-column label="日期" prop="date" width="120" />
            <el-table-column label="盘点单号" prop="orderNo" />
            <el-table-column label="盘点数量" prop="checkQuantity" />
            <el-table-column label="差异数量" prop="diffQuantity" />
          </el-table>
          <pagination
            v-show="checkTotal > 0"
            :total="checkTotal"
            v-model:page="checkParams.pageNum"
            v-model:limit="checkParams.pageSize"
            @pagination="queryCheckReport"
          />
        </el-tab-pane>

        <el-tab-pane label="库存统计" name="inventory">
          <el-form :model="inventoryParams" ref="inventoryFormRef" :inline="true" label-width="80px" class="mb20">
            <el-form-item label="仓库">
              <el-select v-model="inventoryParams.warehouseId" placeholder="请选择仓库" clearable>
                <el-option
                  v-for="item in warehouseList"
                  :key="item.id"
                  :label="item.warehouseName"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="queryInventoryStatistics">查询</el-button>
              <el-button icon="Refresh" @click="resetInventoryQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table v-loading="inventoryLoading" :data="inventoryStatisticsList" border>
            <el-table-column label="物料名称" prop="itemName" />
            <el-table-column label="型号" prop="model" />
            <el-table-column label="库存数量" prop="quantity" />
            <el-table-column label="库存金额" prop="amount" />
          </el-table>
          <pagination
            v-show="inventoryTotal > 0"
            :total="inventoryTotal"
            v-model:page="inventoryParams.pageNum"
            v-model:limit="inventoryParams.pageSize"
            @pagination="queryInventoryStatistics"
          />
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup name="Report">
import { queryInboundReport as queryInboundReportApi, queryOutboundReport as queryOutboundReportApi, queryCheckReport as queryCheckReportApi, queryInventoryStatistics as queryInventoryStatisticsApi } from '@/api/wms/report';
import { listWarehouseNoPage } from '@/api/wms/warehouse';
import { ref, reactive, onMounted } from 'vue';

const activeTab = ref('inbound');
const warehouseList = ref([]);

const inboundLoading = ref(false);
const outboundLoading = ref(false);
const checkLoading = ref(false);
const inventoryLoading = ref(false);

const inboundReportList = ref([]);
const outboundReportList = ref([]);
const checkReportList = ref([]);
const inventoryStatisticsList = ref([]);

const inboundTotal = ref(0);
const outboundTotal = ref(0);
const checkTotal = ref(0);
const inventoryTotal = ref(0);

const inboundParams = reactive({
  pageNum: 1,
  pageSize: 10,
  startDate: undefined,
  endDate: undefined,
  warehouseId: undefined,
});

const outboundParams = reactive({
  pageNum: 1,
  pageSize: 10,
  startDate: undefined,
  endDate: undefined,
  warehouseId: undefined,
});

const checkParams = reactive({
  pageNum: 1,
  pageSize: 10,
  startDate: undefined,
  endDate: undefined,
  warehouseId: undefined,
});

const inventoryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  warehouseId: undefined,
});

/** 查询仓库列表 */
const getWarehouseList = async () => {
  const res = await listWarehouseNoPage({});
  warehouseList.value = res.data;
};

/** 查询入库报表 */
const queryInboundReport = async () => {
  inboundLoading.value = true;
  try {
    const res = await queryInboundReportApi(inboundParams);
    inboundReportList.value = res.rows || [];
    inboundTotal.value = res.total || 0;
  } finally {
    inboundLoading.value = false;
  }
};

/** 查询出库报表 */
const queryOutboundReport = async () => {
  outboundLoading.value = true;
  try {
    const res = await queryOutboundReportApi(outboundParams);
    outboundReportList.value = res.rows || [];
    outboundTotal.value = res.total || 0;
  } finally {
    outboundLoading.value = false;
  }
};

/** 查询盘存报表 */
const queryCheckReport = async () => {
  checkLoading.value = true;
  try {
    const res = await queryCheckReportApi(checkParams);
    checkReportList.value = res.rows || [];
    checkTotal.value = res.total || 0;
  } finally {
    checkLoading.value = false;
  }
};

/** 查询库存统计 */
const queryInventoryStatistics = async () => {
  inventoryLoading.value = true;
  try {
    const res = await queryInventoryStatisticsApi(inventoryParams);
    inventoryStatisticsList.value = res.rows || [];
    inventoryTotal.value = res.total || 0;
  } finally {
    inventoryLoading.value = false;
  }
};

const resetInboundQuery = () => {
  Object.assign(inboundParams, {
    pageNum: 1,
    pageSize: 10,
    startDate: undefined,
    endDate: undefined,
    warehouseId: undefined,
  });
  queryInboundReport();
};

const resetOutboundQuery = () => {
  Object.assign(outboundParams, {
    pageNum: 1,
    pageSize: 10,
    startDate: undefined,
    endDate: undefined,
    warehouseId: undefined,
  });
  queryOutboundReport();
};

const resetCheckQuery = () => {
  Object.assign(checkParams, {
    pageNum: 1,
    pageSize: 10,
    startDate: undefined,
    endDate: undefined,
    warehouseId: undefined,
  });
  queryCheckReport();
};

const resetInventoryQuery = () => {
  Object.assign(inventoryParams, {
    pageNum: 1,
    pageSize: 10,
    warehouseId: undefined,
  });
  queryInventoryStatistics();
};

const handleTabChange = (tabName) => {
  if (tabName === 'inbound' && inboundReportList.value.length === 0) {
    queryInboundReport();
  } else if (tabName === 'outbound' && outboundReportList.value.length === 0) {
    queryOutboundReport();
  } else if (tabName === 'check' && checkReportList.value.length === 0) {
    queryCheckReport();
  } else if (tabName === 'inventory' && inventoryStatisticsList.value.length === 0) {
    queryInventoryStatistics();
  }
};

onMounted(async () => {
  await getWarehouseList();
  await queryInboundReport();
});
</script>

<style scoped>
.mb20 {
  margin-bottom: 20px;
}
</style>

