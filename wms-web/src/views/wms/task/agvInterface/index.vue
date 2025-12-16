<template>
  <div class="app-container">
    <el-card>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="任务下发" name="dispatch">
          <el-form ref="sendFormRef" :model="sendForm" :rules="sendRules" label-width="110px">
            <el-row :gutter="16">
              <el-col :span="12">
                <el-form-item label="任务类型" prop="taskType">
                  <el-select v-model="sendForm.taskType" placeholder="请选择任务类型">
                    <el-option v-for="item in taskTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="外部业务ID" prop="outId">
                  <el-input v-model="sendForm.outId" placeholder="可不填，系统自动生成" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="调度任务编号" prop="taskCode">
                  <el-input v-model="sendForm.taskCode" placeholder="可不填" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="任务级别" prop="level">
                  <el-select v-model="sendForm.level" placeholder="默认2普通">
                    <el-option label="1-优先" value="1" />
                    <el-option label="2-普通" value="2" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="AGV范围" prop="agvRange">
                  <el-input v-model="sendForm.agvRange" placeholder="充电/急停类任务必填，多个用逗号分隔" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="是否有序" prop="isOrder">
                  <el-select v-model="sendForm.isOrder">
                    <el-option label="否" value="false" />
                    <el-option label="是" value="true" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="清空外部业务ID" prop="clearOutId">
                  <el-input v-model="sendForm.clearOutId" placeholder="type=13 清空任务必填" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-alert
                  type="info"
                  show-icon
                  :closable="false"
                  title="取放货(type=01)需填写作业点；充电/急停/解除待命需填写AGV范围；清空任务需填写clearOutID。" />
              </el-col>
            </el-row>

            <el-divider content-position="left">作业点</el-divider>
            <el-space direction="vertical" fill style="width: 100%;">
              <el-card
                v-for="(point, index) in sendForm.points"
                :key="index"
                shadow="never"
                body-style="padding: 12px 12px 0 12px">
                <el-row :gutter="12">
                  <el-col :span="4">
                    <el-form-item :prop="'points.' + index + '.sn'" label="序号" label-width="50px" :rules="[{ required: true, message: '序号必填', trigger: 'blur' }]">
                      <el-input v-model="point.sn" placeholder="如 01" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="6">
                    <el-form-item :prop="'points.' + index + '.pointCode'" label="作业点" label-width="60px" :rules="[{ required: true, message: '作业点必填', trigger: 'blur' }]">
                      <el-input v-model="point.pointCode" placeholder="如 S001" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="6">
                    <el-form-item :prop="'points.' + index + '.pointType'" label="类型" label-width="50px" :rules="[{ required: true, message: '类型必填', trigger: 'change' }]">
                      <el-select v-model="point.pointType" placeholder="请选择">
                        <el-option v-for="pt in pointTypeOptions" :key="pt.value" :label="pt.label" :value="pt.value" />
                      </el-select>
                    </el-form-item>
                  </el-col>
                  <el-col :span="6">
                    <el-form-item :prop="'points.' + index + '.matCode'" label="物料" label-width="50px">
                      <el-input v-model="point.matCode" placeholder="可选" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="2" class="text-right">
                    <el-button v-if="sendForm.points.length > 1" type="danger" link icon="Delete" @click="removePoint(index)">移除</el-button>
                  </el-col>
                </el-row>
              </el-card>
              <el-button type="primary" plain icon="Plus" @click="addPoint">新增作业点</el-button>
            </el-space>

            <div class="mt10">
              <el-button type="primary" icon="Promotion" @click="handleSend" v-hasPermi="['wms:agvOpen:task:send']">下发任务</el-button>
              <el-button icon="Refresh" @click="resetSendForm">重置</el-button>
            </div>
          </el-form>
        </el-tab-pane>

        <el-tab-pane label="任务结果" name="result">
          <el-form :inline="true" :model="resultForm" label-width="100px">
            <el-form-item label="外部业务ID" prop="outId">
              <el-input v-model="resultForm.outId" placeholder="请输入outID" @keyup.enter="handleQueryResult" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="handleQueryResult" v-hasPermi="['wms:agvOpen:task:result']">查询结果</el-button>
            </el-form-item>
          </el-form>

          <el-empty v-if="!resultData" description="未查询到数据" />
          <el-descriptions v-else :column="2" border>
            <el-descriptions-item label="外部业务ID">{{ resultData.outId }}</el-descriptions-item>
            <el-descriptions-item label="AGV编号">{{ resultData.agvCode || '-' }}</el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="statusTag(resultData.status)">{{ renderStatus(resultData.status) }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="返回消息">{{ resultData.responseMessage }}</el-descriptions-item>
            <el-descriptions-item label="返回码">{{ resultData.responseCode }}</el-descriptions-item>
          </el-descriptions>

          <el-table v-if="resultData && resultPoints.length" class="mt10" :data="resultPoints" border>
            <el-table-column label="序号" prop="sn" width="80" />
            <el-table-column label="作业点" prop="pointCode" />
            <el-table-column label="类型" prop="pointType" />
            <el-table-column label="动作集" prop="pointAction" />
            <el-table-column label="步骤集" prop="pointStep" />
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="库位/AGV" name="bin">
          <el-row :gutter="16">
            <el-col :span="12">
              <el-card shadow="never" header="分配库位">
                <el-form :model="findBinForm" label-width="100px">
                  <el-form-item label="分配类型">
                    <el-select v-model="findBinForm.findType">
                      <el-option label="1-取货" value="1" />
                      <el-option label="2-放货" value="2" />
                    </el-select>
                  </el-form-item>
                  <el-form-item label="库位Like">
                    <el-input v-model="findBinForm.binCodeLikeStr" placeholder="A-，多个逗号分隔" />
                  </el-form-item>
                  <el-form-item label="排除库位">
                    <el-input v-model="findBinForm.exceptBinCode" placeholder="排除库位" />
                  </el-form-item>
                  <el-form-item label="物料代码">
                    <el-input v-model="findBinForm.matCode" placeholder="可选" />
                  </el-form-item>
                  <el-form-item label="取货规则">
                    <el-select v-model="findBinForm.pickupRule" placeholder="默认先进后出">
                      <el-option label="1-先进后出" value="1" />
                      <el-option label="2-先进先出" value="2" />
                    </el-select>
                  </el-form-item>
                  <el-form-item label="挪库目标">
                    <el-input v-model="findBinForm.moveBinCodeLikeStr" placeholder="挪库目标库位" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" icon="Position" @click="handleFindBin" v-hasPermi="['wms:agvOpen:bin:assign']">申请库位</el-button>
                  </el-form-item>
                  <el-alert v-if="findBinResult" type="success" show-icon :closable="false" :title="'分配结果：' + findBinResult" />
                </el-form>
              </el-card>
            </el-col>
            <el-col :span="12">
              <el-card shadow="never" header="库位查询 / 状态更新">
                <el-form :model="binInfoForm" label-width="100px" :inline="true">
                  <el-form-item label="库位编号">
                    <el-input v-model="binInfoForm.binCode" placeholder="不填查询全部" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" icon="Search" @click="handleBinInfo" v-hasPermi="['wms:agvOpen:bin:info']">查询库位</el-button>
                  </el-form-item>
                </el-form>

                <el-form :inline="true" :model="binStatusForm" label-width="120px" class="mt10">
                  <el-form-item label="更新库位编号">
                    <el-input v-model="binStatusForm.binCode" placeholder="必填" />
                  </el-form-item>
                  <el-form-item>
                    <el-button type="warning" icon="Refresh" @click="handleUpdateBinStatus" v-hasPermi="['wms:agvOpen:bin:update']">更新库位状态</el-button>
                  </el-form-item>
                </el-form>

                <el-table v-if="binInfoList.length" :data="binInfoList" class="mt10" border size="small">
                  <el-table-column label="库位" prop="binCode" />
                  <el-table-column label="状态" prop="binState">
                    <template #default="scope">
                      <el-tag :type="scope.row.binState === '01' ? 'success' : 'warning'">
                        {{ scope.row.binState === '01' ? '空闲' : '占用' }}
                      </el-tag>
                    </template>
                  </el-table-column>
                  <el-table-column label="物料" prop="matCode" />
                </el-table>
              </el-card>
            </el-col>
          </el-row>

          <el-card class="mt10" shadow="never" header="AGV状态">
            <el-button type="primary" icon="Refresh" @click="loadAgvInfo" v-hasPermi="['wms:agvOpen:agvInfo']">刷新</el-button>
            <el-table :data="agvInfoList" class="mt10" border>
              <el-table-column label="AGV编号" prop="agvCode" width="120" />
              <el-table-column label="状态" prop="agvState" />
              <el-table-column label="电量" prop="agvEle" />
              <el-table-column label="角度" prop="agvAngle" />
              <el-table-column label="坐标X" prop="x" />
              <el-table-column label="坐标Y" prop="y" />
              <el-table-column label="任务外部ID" prop="curOutID" />
              <el-table-column label="报警" prop="errMes" />
            </el-table>
          </el-card>
        </el-tab-pane>

        <el-tab-pane label="任务记录" name="record">
          <el-form :model="recordQuery" ref="recordQueryRef" :inline="true" label-width="90px" v-show="showRecordSearch">
            <el-form-item label="外部业务ID">
              <el-input v-model="recordQuery.outId" placeholder="模糊查询" clearable @keyup.enter="loadTaskList" />
            </el-form-item>
            <el-form-item label="任务类型">
              <el-select v-model="recordQuery.taskType" clearable>
                <el-option v-for="item in taskTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
            <el-form-item label="状态">
              <el-select v-model="recordQuery.status" clearable>
                <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="loadTaskList">搜索</el-button>
              <el-button icon="Refresh" @click="resetRecordQuery">重置</el-button>
            </el-form-item>
          </el-form>

          <el-table v-loading="recordLoading" :data="taskRecords" border>
            <el-table-column label="外部业务ID" prop="outId" width="160" />
            <el-table-column label="任务类型" prop="taskType" width="110">
              <template #default="scope">
                <el-tag>{{ renderTaskType(scope.row.taskType) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="AGV范围" prop="agvRange" />
            <el-table-column label="状态" prop="status" width="120">
              <template #default="scope">
                <el-tag :type="statusTag(scope.row.status)">{{ renderStatus(scope.row.status) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="AGV编号" prop="agvCode" width="120" />
            <el-table-column label="返回消息" prop="responseMessage" />
            <el-table-column label="创建时间" prop="createTime" width="180" />
            <el-table-column label="更新时间" prop="updateTime" width="180" />
          </el-table>
          <pagination
            v-show="recordTotal > 0"
            :total="recordTotal"
            v-model:page="recordQuery.pageNum"
            v-model:limit="recordQuery.pageSize"
            @pagination="loadTaskList"
          />
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup name="AgvInterface">
import { getCurrentInstance, reactive, ref, computed, onMounted } from 'vue';
import {
  sendAgvTask,
  listAgvOpenTask,
  queryAgvTaskResult,
  assignAgvBin,
  fetchBinInfo,
  updateBinStatus,
  fetchAgvInfo
} from '@/api/wms/agvOpen';

const { proxy } = getCurrentInstance();
const activeTab = ref('dispatch');

const taskTypeOptions = [
  { label: '01-取放货', value: '01' },
  { label: '05-充电', value: '05' },
  { label: '10-急停', value: '10' },
  { label: '12-解除急停', value: '12' },
  { label: '13-清空指定任务', value: '13' },
  { label: '18-解除待命', value: '18' }
];

const pointTypeOptions = [
  { label: '02-通用/取货', value: '02' },
  { label: '04-放货', value: '04' }
];

const statusOptions = [
  { label: '01-等待执行', value: '01' },
  { label: '02-执行中', value: '02' },
  { label: '08-执行完成', value: '08' },
  { label: '09-强制清空', value: '09' }
];

const sendFormRef = ref();
const sendForm = reactive({
  taskCode: '',
  taskType: '01',
  isOrder: 'false',
  agvRange: '',
  level: '2',
  clearOutId: '',
  outId: '',
  points: [
    { sn: '01', pointCode: '', pointType: '02', matCode: '' },
    { sn: '02', pointCode: '', pointType: '04', matCode: '' }
  ]
});

const sendRules = {
  taskType: [{ required: true, message: '请选择任务类型', trigger: 'change' }],
  points: [{
    validator: (_, value, callback) => {
      if (sendForm.taskType === '01' && (!value || !value.length)) {
        callback(new Error('取放货任务需至少一个作业点'));
      } else {
        callback();
      }
    },
    trigger: 'blur'
  }],
  agvRange: [{
    validator: (_, value, callback) => {
      if (['05', '10', '12', '18'].includes(sendForm.taskType) && !value) {
        callback(new Error('当前任务类型必须填写AGV范围'));
      } else {
        callback();
      }
    },
    trigger: 'blur'
  }],
  clearOutId: [{
    validator: (_, value, callback) => {
      if (sendForm.taskType === '13' && !value) {
        callback(new Error('清空任务需填写clearOutID'));
      } else {
        callback();
      }
    },
    trigger: 'blur'
  }]
};

const addPoint = () => {
  sendForm.points.push({
    sn: sendForm.points.length < 9 ? '0' + (sendForm.points.length + 1) : String(sendForm.points.length + 1),
    pointCode: '',
    pointType: '02',
    matCode: ''
  });
};
const removePoint = (index) => sendForm.points.splice(index, 1);

const resetSendForm = () => {
  sendForm.taskCode = '';
  sendForm.taskType = '01';
  sendForm.isOrder = 'false';
  sendForm.agvRange = '';
  sendForm.level = '2';
  sendForm.clearOutId = '';
  sendForm.outId = '';
  sendForm.points = [
    { sn: '01', pointCode: '', pointType: '02', matCode: '' },
    { sn: '02', pointCode: '', pointType: '04', matCode: '' }
  ];
  sendFormRef.value?.clearValidate();
};

const handleSend = async () => {
  await sendFormRef.value.validate();
  const payload = JSON.parse(JSON.stringify(sendForm));
  await sendAgvTask(payload);
  proxy?.$modal.msgSuccess('任务下发成功');
  loadTaskList();
};

// 任务结果
const resultForm = reactive({ outId: '' });
const resultData = ref(null);
const resultPoints = ref([]);

const handleQueryResult = async () => {
  if (!resultForm.outId) {
    proxy?.$modal.msgError('请输入外部业务ID');
    return;
  }
  const res = await queryAgvTaskResult({ outId: resultForm.outId });
  resultData.value = res;
  try {
    const resultJson = res?.lastResult ? JSON.parse(res.lastResult) : {};
    resultPoints.value = resultJson.points || [];
  } catch (e) {
    resultPoints.value = [];
  }
  loadTaskList();
};

// 库位与AGV
const findBinForm = reactive({
  findType: '1',
  binCodeLikeStr: '',
  exceptBinCode: '',
  matCode: '',
  pickupRule: '',
  moveBinCodeLikeStr: ''
});
const findBinResult = ref('');
const handleFindBin = async () => {
  const res = await assignAgvBin({ ...findBinForm });
  findBinResult.value = res.binCode || res.data?.binCode || '';
};

const binInfoForm = reactive({ binCode: '' });
const binInfoList = ref([]);
const handleBinInfo = async () => {
  const res = await fetchBinInfo({ ...binInfoForm });
  const data = res.data || [];
  binInfoList.value = Array.isArray(data) ? data : [data];
};

const binStatusForm = reactive({ binCode: '' });
const handleUpdateBinStatus = async () => {
  if (!binStatusForm.binCode) {
    proxy?.$modal.msgError('请填写库位编号');
    return;
  }
  await updateBinStatus({ binCode: binStatusForm.binCode });
  proxy?.$modal.msgSuccess('更新成功');
  handleBinInfo();
};

const agvInfoList = ref([]);
const loadAgvInfo = async () => {
  const res = await fetchAgvInfo();
  agvInfoList.value = res.data || res || [];
};

// 任务记录
const taskRecords = ref([]);
const recordLoading = ref(false);
const recordTotal = ref(0);
const showRecordSearch = ref(true);
const recordQueryRef = ref();
const recordQuery = reactive({
  pageNum: 1,
  pageSize: 10,
  outId: '',
  taskType: '',
  status: ''
});

const loadTaskList = async () => {
  recordLoading.value = true;
  const res = await listAgvOpenTask(recordQuery).finally(() => recordLoading.value = false);
  taskRecords.value = res.rows || [];
  recordTotal.value = res.total || 0;
};

const resetRecordQuery = () => {
  recordQueryRef.value?.resetFields();
  recordQuery.pageNum = 1;
  loadTaskList();
};

// 渲染
const renderTaskType = (val) => {
  const item = taskTypeOptions.find(i => i.value === val);
  return item ? item.label : val;
};
const renderStatus = (val) => {
  const item = statusOptions.find(i => i.value === val);
  return item ? item.label : val || '-';
};
const statusTag = (val) => {
  switch (val) {
    case '01': return 'info';
    case '02': return 'warning';
    case '08': return 'success';
    case '09': return 'danger';
    default: return '';
  }
};

onMounted(() => {
  loadTaskList();
  loadAgvInfo();
});
</script>

<style scoped>
.mt10 { margin-top: 10px; }
.text-right { text-align: right; }
</style>

