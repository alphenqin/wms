<template>
  <div class="navbar">
    <hamburger id="hamburger-container" :is-active="appStore.sidebar.opened" class="hamburger-container" @toggleClick="toggleSideBar" />
    <breadcrumb id="breadcrumb-container" class="breadcrumb-container" v-if="!settingsStore.topNav" />
    <top-nav id="topmenu-container" class="topmenu-container" v-if="settingsStore.topNav" />

    <div class="right-menu">
      <div class="right-menu-item scan-toggle" v-hasPermi="['wms:config:edit']">
        <el-button size="small" :type="palletScanEnabled ? 'success' : 'info'" :loading="palletScanLoading" @click="togglePalletScan">
          扫码{{ palletScanEnabled ? '开' : '关' }}
        </el-button>
      </div>
      <div class="avatar-container">
        <el-dropdown @command="handleCommand" class="right-menu-item hover-effect" trigger="click">
          <div class="avatar-wrapper">
            <img :src="userStore.avatar" class="user-avatar" />
            <el-icon><caret-bottom /></el-icon>
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <router-link to="/user/profile">
                <el-dropdown-item>个人中心</el-dropdown-item>
              </router-link>
              <el-dropdown-item divided command="logout">
                <span>退出登录</span>
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ElMessage, ElMessageBox } from 'element-plus'
import { onMounted, ref } from 'vue'
import Breadcrumb from '@/components/Breadcrumb'
import TopNav from '@/components/TopNav'
import Hamburger from '@/components/Hamburger'
import Screenfull from '@/components/Screenfull'
import SizeSelect from '@/components/SizeSelect'
import HeaderSearch from '@/components/HeaderSearch'
import RuoYiGit from '@/components/RuoYi/Git'
import RuoYiDoc from '@/components/RuoYi/Doc'
import useAppStore from '@/store/modules/app'
import useUserStore from '@/store/modules/user'
import useSettingsStore from '@/store/modules/settings'
import { addWmsConfig, getWmsConfigByKey, updateWmsConfig } from '@/api/wms/wmsConfig'

const appStore = useAppStore()
const userStore = useUserStore()
const settingsStore = useSettingsStore()
const palletScanEnabled = ref(false)
const palletScanLoading = ref(false)
const palletScanConfig = ref(null)

const palletScanConfigKey = 'pda.pallet_scan.enabled'
const palletScanConfigDesc = 'PDA托盘扫码开关'

function parseConfigValue(value) {
  if (value === true) {
    return true
  }
  if (value === false || value === null || value === undefined) {
    return false
  }
  const normalized = String(value).trim().toLowerCase()
  return normalized === 'true' || normalized === '1' || normalized === 'yes' || normalized === 'y' || normalized === 'on'
}

async function loadPalletScanConfig() {
  try {
    const res = await getWmsConfigByKey(palletScanConfigKey)
    const config = res?.data || null
    palletScanConfig.value = config
    palletScanEnabled.value = parseConfigValue(config?.configValue)
  } catch (error) {
    palletScanConfig.value = null
  }
}

async function togglePalletScan() {
  if (palletScanLoading.value) {
    return
  }
  const nextValue = !palletScanEnabled.value
  palletScanLoading.value = true
  try {
    if (palletScanConfig.value && palletScanConfig.value.id) {
      await updateWmsConfig({
        ...palletScanConfig.value,
        configKey: palletScanConfigKey,
        configValue: String(nextValue),
        configType: palletScanConfig.value.configType ?? 4
      })
      palletScanConfig.value.configValue = String(nextValue)
      palletScanEnabled.value = nextValue
    } else {
      await addWmsConfig({
        configKey: palletScanConfigKey,
        configValue: String(nextValue),
        configType: 4,
        configGroup: 'pda',
        configDesc: palletScanConfigDesc,
        status: '0'
      })
      await loadPalletScanConfig()
      palletScanEnabled.value = nextValue
    }
    ElMessage.success(`托盘扫码已${nextValue ? '开启' : '关闭'}`)
  } catch (error) {
    ElMessage.error('托盘扫码开关更新失败')
    await loadPalletScanConfig()
  } finally {
    palletScanLoading.value = false
  }
}

function toggleSideBar() {
  appStore.toggleSideBar()
}

function handleCommand(command) {
  switch (command) {
    case "setLayout":
      setLayout();
      break;
    case "logout":
      logout();
      break;
    default:
      break;
  }
}

function logout() {
  ElMessageBox.confirm('确定注销并退出系统吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    userStore.logOut().then(() => {
      location.href = import.meta.env.VITE_APP_CONTEXT_PATH + 'index';
    })
  }).catch(() => { });
}

const emits = defineEmits(['setLayout'])
function setLayout() {
  emits('setLayout');
}

onMounted(() => {
  loadPalletScanConfig()
})
</script>

<style lang='scss' scoped>
.navbar {
  height: 50px;
  overflow: hidden;
  position: relative;
  background: #F8F9FD;

  .hamburger-container {
    line-height: 46px;
    height: 100%;
    float: left;
    cursor: pointer;
    transition: background 0.3s;
    -webkit-tap-highlight-color: transparent;

    &:hover {
      background: rgba(0, 0, 0, 0.025);
    }
  }

  .breadcrumb-container {
    float: left;
  }

  .topmenu-container {
    position: absolute;
    left: 50px;
  }

  .errLog-container {
    display: inline-block;
    vertical-align: top;
  }

  .right-menu {
    float: right;
    height: 100%;
    line-height: 50px;
    display: flex;

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: inline-block;
      padding: 0 8px;
      height: 100%;
      font-size: 18px;
      color: #5a5e66;
      vertical-align: text-bottom;

      &.hover-effect {
        cursor: pointer;
        transition: background 0.3s;

        &:hover {
          background: rgba(0, 0, 0, 0.025);
        }
      }
    }

    .avatar-container {
      margin-right: 40px;

      .avatar-wrapper {
        margin-top: 5px;
        position: relative;

        .user-avatar {
          cursor: pointer;
          width: 40px;
          height: 40px;
          border-radius: 10px;
        }

        i {
          cursor: pointer;
          position: absolute;
          right: -20px;
          top: 25px;
          font-size: 12px;
        }
      }
    }

    .scan-toggle {
      display: flex;
      align-items: center;
      margin-right: 8px;
    }
  }
}
</style>
