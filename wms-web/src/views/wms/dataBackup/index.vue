<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" ref="queryFormRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="备份编号" prop="backupNo">
          <el-input v-model="queryParams.backupNo" placeholder="请输入备份编号" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="备份类型" prop="backupType">
          <el-select v-model="queryParams.backupType" placeholder="请选择备份类型" clearable>
            <el-option label="全量备份" :value="1" />
            <el-option label="增量备份" :value="2" />
            <el-option label="指定表备份" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="备份状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择备份状态" clearable>
            <el-option label="进行中" :value="0" />
            <el-option label="成功" :value="1" />
            <el-option label="失败" :value="2" />
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
            v-hasPermi="['wms:backup:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Download"
            @click="handleBackup"
            v-hasPermi="['wms:backup:backup']"
          >执行备份</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="Refresh"
            :disabled="single"
            @click="handleRestore"
            v-hasPermi="['wms:backup:restore']"
          >恢复备份</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['wms:backup:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="backupList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="ID" prop="id" width="80" />
        <el-table-column label="备份编号" prop="backupNo" />
        <el-table-column label="备份名称" prop="backupName" />
        <el-table-column label="备份类型" prop="backupType" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.backupType === 1">全量备份</el-tag>
            <el-tag v-else-if="scope.row.backupType === 2" type="success">增量备份</el-tag>
            <el-tag v-else-if="scope.row.backupType === 3" type="info">指定表备份</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="文件大小(MB)" prop="fileSize" />
        <el-table-column label="备份时间" prop="backupTime" width="180" />
        <el-table-column label="备份状态" prop="status" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.status === 0" type="warning">进行中</el-tag>
            <el-tag v-else-if="scope.row.status === 1" type="success">成功</el-tag>
            <el-tag v-else-if="scope.row.status === 2" type="danger">失败</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="是否自动" prop="isAuto" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.isAuto === 1" type="success">是</el-tag>
            <el-tag v-else>否</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
          <template #default="scope">
            <el-button 
              v-if="scope.row.status === 1"
              link 
              type="warning" 
              icon="Refresh" 
              @click="handleRestore(scope.row)" 
              v-hasPermi="['wms:backup:restore']"
            >恢复</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['wms:backup:remove']">删除</el-button>
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

    <!-- 执行备份对话框 -->
    <el-dialog title="执行数据备份" v-model="backupDialog.visible" width="500px" append-to-body :close-on-click-modal="false">
      <el-form ref="backupFormRef" :model="backupForm" :rules="backupRules" label-width="120px">
        <el-form-item label="备份类型" prop="backupType">
          <el-select v-model="backupForm.backupType" placeholder="请选择备份类型" style="width: 100%">
            <el-option label="全量备份" :value="1" />
            <el-option label="增量备份" :value="2" />
            <el-option label="指定表备份" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="备份名称" prop="backupName">
          <el-input v-model="backupForm.backupName" placeholder="请输入备份名称" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button :loading="backupLoading" type="primary" @click="submitBackup">确 定</el-button>
          <el-button @click="backupDialog.visible = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="DataBackup">
import { listDataBackup, getDataBackup, delDataBackup, executeBackup, restoreBackup } from '@/api/wms/dataBackup';
import { getCurrentInstance, reactive, ref, toRefs, onMounted } from 'vue';

const { proxy } = getCurrentInstance();

const backupList = ref([]);
const backupLoading = ref(false);
const loading = ref(false);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const queryFormRef = ref();
const backupFormRef = ref();

const backupDialog = reactive({
  visible: false
});

const backupForm = reactive({
  backupType: 1,
  backupName: undefined,
});

const backupRules = {
  backupType: [
    { required: true, message: "备份类型不能为空", trigger: "change" }
  ]
};

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    backupNo: undefined,
    backupType: undefined,
    status: undefined,
  }
});

const { queryParams } = toRefs(data);

/** 查询备份列表 */
const getList = async () => {
  loading.value = true;
  const res = await listDataBackup(queryParams.value).finally(() => {
    loading.value = false;
  });
  backupList.value = res.rows;
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
  multiple.value = !selection.length;
};

/** 新增按钮操作 */
const handleAdd = () => {
  backupDialog.visible = true;
  backupForm.backupType = 1;
  backupForm.backupName = undefined;
};

/** 执行备份 */
const handleBackup = () => {
  handleAdd();
};

/** 提交备份 */
const submitBackup = () => {
  backupFormRef.value?.validate(async (valid) => {
    if (valid) {
      backupLoading.value = true;
      try {
        await executeBackup(backupForm.backupType, backupForm.backupName);
        proxy?.$modal.msgSuccess('备份任务已启动');
        backupDialog.visible = false;
        await getList();
      } finally {
        backupLoading.value = false;
      }
    }
  });
};

/** 恢复备份 */
const handleRestore = async (row) => {
  const backupId = row?.id || ids.value[0];
  if (!backupId) {
    proxy?.$modal.msgError('请选择要恢复的备份');
    return;
  }
  await proxy?.$modal.confirm('确认恢复备份吗？此操作将覆盖当前数据，请谨慎操作！');
  try {
    await restoreBackup(backupId);
    proxy?.$modal.msgSuccess('恢复成功');
  } catch (error) {
    proxy?.$modal.msgError('恢复失败：' + (error.msg || '未知错误'));
  }
};

/** 删除按钮操作 */
const handleDelete = async (row) => {
  const _ids = row.id || ids.value;
  await proxy?.$modal.confirm('是否确认删除备份编号为"' + _ids + '"的数据项？');
  await delDataBackup(_ids);
  proxy?.$modal.msgSuccess("删除成功");
  await getList();
};

onMounted(async () => {
  await getList();
});
</script>

