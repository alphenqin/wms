import auth from '@/plugins/auth'
import router, { constantRoutes, dynamicRoutes } from '@/router'
import { getRouters } from '@/api/menu'
import Layout from '@/layout/index'
import ParentView from '@/components/ParentView'
import InnerLink from '@/layout/components/InnerLink'
import { isHttp } from '@/utils/validate'

// 匹配views里面所有的.vue文件
const modules = import.meta.glob('./../../views/**/*.vue')

const usePermissionStore = defineStore(
  'permission',
  {
    state: () => ({
      routes: [],
      addRoutes: [],
      defaultRoutes: [],
      topbarRouters: [],
      sidebarRouters: []
    }),
    actions: {
      setRoutes(routes) {
        this.addRoutes = routes
        this.routes = constantRoutes.concat(routes)
      },
      setDefaultRoutes(routes) {
        this.defaultRoutes = constantRoutes.concat(routes)
      },
      setTopbarRoutes(routes) {
        this.topbarRouters = routes
      },
      setSidebarRouters(routes) {
        this.sidebarRouters = routes
      },
      generateRoutes(roles) {
        return new Promise(resolve => {
          // 向后端请求路由数据
          getRouters().then(res => {
            // 确保 res.data 存在且是数组
            if (!res || !res.data || !Array.isArray(res.data)) {
              console.warn('路由数据格式错误，使用空数组')
              resolve([])
              return
            }
            const sdata = JSON.parse(JSON.stringify(res.data))
            const rdata = JSON.parse(JSON.stringify(res.data))
            const defaultData = JSON.parse(JSON.stringify(res.data))
            const sidebarRoutes = filterAsyncRouter(sdata)
            const rewriteRoutes = filterAsyncRouter(rdata, false, true)
            const defaultRoutes = filterAsyncRouter(defaultData)
            const asyncRoutes = filterDynamicRoutes(dynamicRoutes)
            asyncRoutes.forEach(route => { 
              if (route && route.path && !isHttp(route.path)) {
                router.addRoute(route) 
              }
            })
            this.setRoutes(rewriteRoutes)
            this.setSidebarRouters(constantRoutes.concat(sidebarRoutes))
            this.setDefaultRoutes(sidebarRoutes)
            this.setTopbarRoutes(defaultRoutes)
            resolve(rewriteRoutes)
          }).catch(err => {
            console.error('获取路由数据失败:', err)
            resolve([])
          })
        })
      }
    }
  })

// 遍历后台传来的路由字符串，转换为组件对象
function filterAsyncRouter(asyncRouterMap, lastRouter = false, type = false) {
  if (!asyncRouterMap || !Array.isArray(asyncRouterMap)) {
    return []
  }
  return asyncRouterMap.filter(route => {
    // 验证 route 对象是否存在
    if (!route) {
      return false
    }
    // 如果是外链路由，跳过处理
    if (route.path && (route.path.indexOf('http://') !== -1 || route.path.indexOf('https://') !== -1)) {
      return false
    }
    if (route.component) {
      // Layout ParentView 组件特殊处理
      if (route.component === 'Layout') {
        route.component = Layout
      } else if (route.component === 'ParentView') {
        route.component = ParentView
      } else if (route.component === 'InnerLink') {
        route.component = InnerLink
      } else {
        route.component = loadView(route.component)
      }
    }
    if (route.children != null && route.children && route.children.length) {
      route.children = filterAsyncRouter(route.children, route, type)
      // 对于嵌套路由，子路由路径应该是相对路径（不以 / 开头）
      // 这样 Vue Router 会自动将其与父路由路径拼接
      if (route.component === Layout && route.path) {
        route.children.forEach(child => {
          if (child.path && child.path.startsWith('/')) {
            // 如果子路由路径是绝对路径，且父路由存在，则转换为相对路径
            const parentPath = route.path.endsWith('/') ? route.path.slice(0, -1) : route.path
            if (child.path.startsWith(parentPath + '/')) {
              child.path = child.path.substring(parentPath.length + 1)
            } else if (child.path.startsWith('/')) {
              // 如果子路由路径是绝对路径但不以父路径开头，保持原样（可能是独立路由）
              // 但通常嵌套路由应该是相对路径
              const pathParts = child.path.split('/').filter(p => p)
              if (pathParts.length > 0) {
                child.path = pathParts[pathParts.length - 1]
              }
            }
          }
        })
      }
    } else {
      delete route['children']
      delete route['redirect']
    }
    // 确保 path 存在，如果不存在则跳过
    if (!route.path) {
      return false
    }
    // 确保路径以 / 开头（非外链，且不是嵌套路由的子路由）
    // 嵌套路由的子路由路径应该是相对路径（不以 / 开头）
    if (route.path && !route.path.startsWith('/') && !route.path.startsWith('http://') && !route.path.startsWith('https://')) {
      // 如果当前路由有父路由，且父路由是 Layout，则子路由应该是相对路径
      if (lastRouter && lastRouter.component === Layout) {
        // 保持相对路径，不添加 / 前缀
      } else {
        // 没有父路由或者是顶级路由，添加 / 前缀
        route.path = '/' + route.path
      }
    }
    return true
  })
}

function filterChildren(childrenMap, lastRouter = false) {
  if (!childrenMap || !Array.isArray(childrenMap)) {
    return []
  }
  var children = []
  childrenMap.forEach((el, index) => {
    // 验证 el 对象是否存在
    if (!el) {
      return
    }
    // 如果是外链路由，跳过
    if (el.path && (el.path.indexOf('http://') !== -1 || el.path.indexOf('https://') !== -1)) {
      return
    }
    if (el.children && el.children.length) {
      if (el.component === 'ParentView' && !lastRouter) {
        el.children.forEach(c => {
          if (!c || !c.path) {
            return
          }
          c.path = el.path + '/' + c.path
          if (c.children && c.children.length) {
            children = children.concat(filterChildren(c.children, c))
            return
          }
          children.push(c)
        })
        return
      }
    }
    if (lastRouter && lastRouter.path && el.path) {
      // 确保路径正确拼接，避免重复的斜杠
      const parentPath = lastRouter.path.endsWith('/') ? lastRouter.path.slice(0, -1) : lastRouter.path
      const childPath = el.path.startsWith('/') ? el.path.slice(1) : el.path
      el.path = parentPath + '/' + childPath
      // 确保路径以 / 开头
      if (!el.path.startsWith('/')) {
        el.path = '/' + el.path
      }
      if (el.children && el.children.length) {
        children = children.concat(filterChildren(el.children, el))
        return
      }
    }
    children = children.concat(el)
  })
  return children
}

// 动态路由遍历，验证是否具备权限
export function filterDynamicRoutes(routes) {
  const res = []
  routes.forEach(route => {
    if (route.permissions) {
      if (auth.hasPermiOr(route.permissions)) {
        res.push(route)
      }
    } else if (route.roles) {
      if (auth.hasRoleOr(route.roles)) {
        res.push(route)
      }
    }
  })
  return res
}

export const loadView = (view) => {
  let res;
  for (const path in modules) {
    const dir = path.split('views/')[1].split('.vue')[0];
    if (dir === view) {
      res = () => modules[path]();
      break;
    }
  }
  if (!res) {
    console.warn(`组件未找到: ${view}，请检查组件路径是否正确`);
  }
  return res;
}

export default usePermissionStore
