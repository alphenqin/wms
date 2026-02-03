import router from './router'
import { ElMessage } from 'element-plus'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'
import { getToken } from '@/utils/auth'
import { isHttp } from '@/utils/validate'
import { isRelogin } from '@/utils/request'
import useUserStore from '@/store/modules/user'
import useSettingsStore from '@/store/modules/settings'
import usePermissionStore from '@/store/modules/permission'
import {useWmsStore} from '@/store/modules/wms';

NProgress.configure({ showSpinner: false });

const whiteList = ['/login', '/register'];

function resolveRoutePath(parentPath, routePath) {
  if (!routePath) {
    return parentPath || '/'
  }
  if (routePath.startsWith('/')) {
    return routePath
  }
  const parent = parentPath && parentPath !== '/' ? parentPath : ''
  return `${parent}/${routePath}`.replace(/\/+/g, '/')
}

function findFirstRoutePath(routes, parentPath = '') {
  if (!Array.isArray(routes)) {
    return ''
  }
  for (const route of routes) {
    if (!route || !route.path || route.hidden || isHttp(route.path)) {
      continue
    }
    const fullPath = resolveRoutePath(parentPath, route.path)
    if (Array.isArray(route.children) && route.children.length > 0) {
      const childPath = findFirstRoutePath(route.children, fullPath)
      if (childPath) {
        return childPath
      }
    }
    if (!route.redirect && route.component && fullPath !== '/') {
      return fullPath
    }
  }
  return ''
}

router.beforeEach((to, from, next) => {
  NProgress.start()
  if (getToken()) {
    to.meta.title && useSettingsStore().setTitle(to.meta.title)
    /* has token*/
    if (to.path === '/login') {
      const firstPath = findFirstRoutePath(usePermissionStore().addRoutes)
      next({ path: firstPath || '/' })
      NProgress.done()
    } else {
      if (useUserStore().roles.length === 0) {
        isRelogin.show = true
        // 判断当前用户是否已拉取完user_info信息
        useUserStore().getInfo().then(() => {
          isRelogin.show = false
          usePermissionStore().generateRoutes().then(accessRoutes => {
            // 根据roles权限生成可访问的路由表
            // 确保 accessRoutes 是数组
            if (Array.isArray(accessRoutes)) {
              accessRoutes.forEach(route => {
                // 确保 route 存在且有 path 属性，且不是外链
                if (route && route.path && !isHttp(route.path)) {
                  router.addRoute(route) // 动态添加可访问路由表（Vue Router会自动处理children）
                }
              })
            } else {
              console.warn('accessRoutes 不是数组:', accessRoutes)
            }
            const firstPath = findFirstRoutePath(accessRoutes)
            if (to.path === '/' && firstPath) {
              next({ path: firstPath, replace: true })
            } else {
              next({ ...to, replace: true }) // hack方法 确保addRoutes已完成
            }
          }).catch(err => {
            console.error('生成路由失败:', err)
            next({ ...to, replace: true })
          })
        }).catch(err => {
          useUserStore().logOut().then(() => {
            ElMessage.error(err)
            next({ path: '/login' })
          })
        })
        initData()
      } else {
        if (to.path === '/') {
          const firstPath = findFirstRoutePath(usePermissionStore().addRoutes)
          if (firstPath) {
            next({ path: firstPath, replace: true })
            return
          }
        }
        next()
      }
    }
  } else {
    // 没有token
    if (whiteList.indexOf(to.path) !== -1) {
      // 在免登录白名单，直接进入
      next()
    } else {
      next(`/login?redirect=${to.fullPath}`) // 否则全部重定向到登录页
      NProgress.done()
    }
  }
})

async function initData() {
  await useWmsStore().getWarehouseList()
  await useWmsStore().getMerchantList()
  await useWmsStore().getItemCategoryList()
  await useWmsStore().getItemCategoryTreeList()
  await useWmsStore().getItemBrandList()
}

router.afterEach(() => {
  NProgress.done()
})
