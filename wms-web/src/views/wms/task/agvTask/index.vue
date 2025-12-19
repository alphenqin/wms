<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="任务编号" prop="taskNo">
          <el-input v-model="queryParams.taskNo" placeholder="请输入任务编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="任务类型" prop="taskType">
          <el-select v-model="queryParams.taskType" placeholder="请选择任务类型" clearable>
            <el-option label="入库" value="1" />
            <el-option label="送检" value="2" />
            <el-option label="回库" value="3" />
            <el-option label="出库" value="4" />
          </el-select>
        </el-form-item>
        <el-form-item label="任务状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择任务状态" clearable>
            <el-option label="待执行" value="0" />
            <el-option label="执行中" value="1" />
            <el-option label="已完成" value="2" />
            <el-option label="失败" value="3" />
            <el-option label="已取消" value="4" />
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
            type="danger"
            plain
            icon="Close"
            :disabled="single"
            @click="handleCancel"
            v-hasPermi="['wms:agvTask:edit']"
          >取消任务</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="agvTaskList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="任务编号" prop="taskNo" width="150" />
        <el-table-column label="任务类型" prop="taskType">
          <template #default="scope">
            <el-tag v-if="scope.row.taskType === 1" type="success">入库</el-tag>
            <el-tag v-else-if="scope.row.taskType === 2" type="info">送检</el-tag>
            <el-tag v-else-if="scope.row.taskType === 3">回库</el-tag>
            <el-tag v-else-if="scope.row.taskType === 4" type="warning">出库</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="托盘编号" prop="palletCode" />
        <el-table-column label="起始库位" prop="fromBinCode" />
        <el-table-column label="目标库位" prop="toBinCode" />
        <el-table-column label="业务单号" prop="bizOrderNo" />
        <el-table-column label="任务状态" prop="status">
          <template #default="scope">
            <el-tag v-if="scope.row.status === 0" type="info">待执行</el-tag>
            <el-tag v-else-if="scope.row.status === 1" type="warning">执行中</el-tag>
            <el-tag v-else-if="scope.row.status === 2" type="success">已完成</el-tag>
            <el-tag v-else-if="scope.row.status === 3" type="danger">失败</el-tag>
            <el-tag v-else-if="scope.row.status === 4">已取消</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="完成时间" prop="finishTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="120">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)" v-hasPermi="['wms:agvTask:list']">查看</el-button>
            <el-button 
              v-if="scope.row.status === 0 || scope.row.status === 1"
              link 
              type="danger" 
              icon="Close" 
              @click="handleCancel(scope.row)" 
              v-hasPermi="['wms:agvTask:edit']"
            >取消</el-button>
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

    <!-- 查看任务详情对话框 -->
    <el-dialog title="AGV任务详情" v-model="detailDialog.visible" width="700px" append-to-body>
      <el-descriptions :column="2" border v-if="taskDetail">
        <el-descriptions-item label="任务编号">{{ taskDetail.taskNo }}</el-descriptions-item>
        <el-descriptions-item label="任务类型">
          <el-tag v-if="taskDetail.taskType === 1" type="success">入库</el-tag>
          <el-tag v-else-if="taskDetail.taskType === 2" type="info">送检</el-tag>
          <el-tag v-else-if="taskDetail.taskType === 3">回库</el-tag>
          <el-tag v-else-if="taskDetail.taskType === 4" type="warning">出库</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="托盘编号">{{ taskDetail.palletCode }}</el-descriptions-item>
        <el-descriptions-item label="任务状态">
          <el-tag v-if="taskDetail.status === 0" type="info">待执行</el-tag>
          <el-tag v-else-if="taskDetail.status === 1" type="warning">执行中</el-tag>
          <el-tag v-else-if="taskDetail.status === 2" type="success">已完成</el-tag>
          <el-tag v-else-if="taskDetail.status === 3" type="danger">失败</el-tag>
          <el-tag v-else-if="taskDetail.status === 4">已取消</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="起始库位">{{ taskDetail.fromBinCode }}</el-descriptions-item>
        <el-descriptions-item label="目标库位">{{ taskDetail.toBinCode }}</el-descriptions-item>
        <el-descriptions-item label="业务单号">{{ taskDetail.bizOrderNo }}</el-descriptions-item>
        <el-descriptions-item label="AGV任务ID">{{ taskDetail.agvTaskId }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ taskDetail.createTime }}</el-descriptions-item>
        <el-descriptions-item label="完成时间">{{ taskDetail.finishTime }}</el-descriptions-item>
        <el-descriptions-item label="错误信息" :span="2" v-if="taskDetail.errorMsg">
          <el-text type="danger">{{ taskDetail.errorMsg }}</el-text>
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup name="AgvTask">
import { listAgvTask, getAgvTask, cancelAgvTask } from '@/api/wms/agvTask';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';

const { proxy } = getCurrentInstance();

const agvTaskList = ref([]);
const taskDetail = ref(null);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const queryFormRef = ref();
const detailDialog = reactive({
  visible: false
});

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    taskNo: undefined,
    taskType: undefined,
    status: undefined,
  }
});

const { queryParams } = toRefs(data);

/** 查询AGV任务列表 */
const getList = async () => {
  loading.value = true;
  const res = await listAgvTask(queryParams.value).finally(() => {
    loading.value = false;
  });
  agvTaskList.value = res.rows;
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

/** 多选框选中数据 */
const handleSelectionChange = (selection) => {
  ids.value = selection.map(item => item.id);
  single.value = selection.length !== 1;
};

/** 查看任务详情 */
const handleView = async (row) => {
  const res = await getAgvTask(row.id);
  taskDetail.value = res.data;
  detailDialog.visible = true;
};

/** 取消任务 */
const handleCancel = async (row) => {
  const selected = row || agvTaskList.value.find(t => ids.value.includes(t.id));
  if (!selected?.id) {
    proxy?.$modal.msgError('请选择要取消的任务');
    return;
  }
  await proxy?.$modal.confirm('确认取消任务【' + selected.taskNo + '】吗？');
  await cancelAgvTask(selected.id);
  proxy?.$modal.msgSuccess("取消成功");
  await getList();
};

const total = ref(0);

onMounted(async () => {
  await getList();
});
</script>

