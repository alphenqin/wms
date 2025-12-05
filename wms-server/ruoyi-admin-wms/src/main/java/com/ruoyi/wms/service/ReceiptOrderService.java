package com.ruoyi.wms.service;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.lang.Assert;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.common.core.constant.HttpStatus;
import com.ruoyi.common.core.constant.ServiceConstants;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.common.core.exception.base.BaseException;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.core.utils.StringUtils;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.ReceiptOrderBo;
import com.ruoyi.wms.domain.bo.ReceiptOrderDetailBo;
import com.ruoyi.wms.domain.entity.ReceiptOrder;
import com.ruoyi.wms.domain.entity.ReceiptOrderDetail;
import com.ruoyi.wms.domain.vo.ReceiptOrderDetailVo;
import com.ruoyi.wms.domain.vo.ReceiptOrderVo;
import com.ruoyi.wms.mapper.ReceiptOrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 入库单Service业务层处理
 *
 * @author zcc
 * @date 2024-07-19
 */
@RequiredArgsConstructor
@Service
public class ReceiptOrderService {

    private final ReceiptOrderMapper receiptOrderMapper;
    private final ReceiptOrderDetailService receiptOrderDetailService;
    private final InventoryService inventoryService;
    private final InventoryHistoryService inventoryHistoryService;
    private final AgvIntegrationService agvIntegrationService;
    private final AgvTaskService agvTaskService;
    private final PalletService palletService;
    private final ValveService valveService;
    private final BinService binService;

    /**
     * 查询入库单
     */
    public ReceiptOrderVo queryById(Long id){
        ReceiptOrderVo receiptOrderVo = receiptOrderMapper.selectVoById(id);
        Assert.notNull(receiptOrderVo, "入库单不存在");
        receiptOrderVo.setDetails(receiptOrderDetailService.queryByReceiptOrderId(id));
        return receiptOrderVo;
    }

    public Long queryIdByOrderNo(String orderNo){
        ReceiptOrderVo receiptOrderVo = receiptOrderMapper.selectVoOne(new QueryWrapper<ReceiptOrder>().eq("order_no",orderNo));
        return receiptOrderVo != null ? receiptOrderVo.getId() : null;
    }

    /**
     * 查询入库单列表
     */
    public TableDataInfo<ReceiptOrderVo> queryPageList(ReceiptOrderBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<ReceiptOrder> lqw = buildQueryWrapper(bo);
        Page<ReceiptOrderVo> result = receiptOrderMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    /**
     * 查询入库单列表
     */
    public List<ReceiptOrderVo> queryList(ReceiptOrderBo bo) {
        LambdaQueryWrapper<ReceiptOrder> lqw = buildQueryWrapper(bo);
        return receiptOrderMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<ReceiptOrder> buildQueryWrapper(ReceiptOrderBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<ReceiptOrder> lqw = Wrappers.lambdaQuery();
        lqw.eq(StringUtils.isNotBlank(bo.getOrderNo()), ReceiptOrder::getOrderNo, bo.getOrderNo());
        lqw.eq(bo.getOptType() != null, ReceiptOrder::getOptType, bo.getOptType());
        lqw.eq(bo.getMerchantId() != null, ReceiptOrder::getMerchantId, bo.getMerchantId());
        lqw.eq(StringUtils.isNotBlank(bo.getOrderNo()), ReceiptOrder::getOrderNo, bo.getOrderNo());
        lqw.eq(bo.getTotalAmount() != null, ReceiptOrder::getTotalAmount, bo.getTotalAmount());
        lqw.eq(bo.getOrderStatus() != null, ReceiptOrder::getOrderStatus, bo.getOrderStatus());
        lqw.orderByDesc(BaseEntity::getCreateTime);
        return lqw;
    }

    /**
     * 暂存入库单
     */
    @Transactional
    public Long insertByBo(ReceiptOrderBo bo) {
        // 校验入库单号唯一性
        validateReceiptOrderNo(bo.getOrderNo());
        // 创建入库单
        ReceiptOrder add = MapstructUtils.convert(bo, ReceiptOrder.class);
        receiptOrderMapper.insert(add);
        bo.setId(add.getId());
        List<ReceiptOrderDetailBo> detailBoList = bo.getDetails();
        List<ReceiptOrderDetail> addDetailList = MapstructUtils.convert(detailBoList, ReceiptOrderDetail.class);
        addDetailList.forEach(it -> {
            it.setOrderId(add.getId());
        });
        // 创建入库单明细
        receiptOrderDetailService.saveDetails(addDetailList);
        return add.getId();
    }

    /**
     * 入库：
     * 1.校验
     * 2.保存入库单和入库单明细
     * 3.保存库存明细
     * 4.增加库存
     * 5.保存库存记录
     */
    @Transactional
    public void receive(ReceiptOrderBo bo) {
        // 1. 校验
        validateBeforeReceive(bo);

        // 2. 保存入库单和入库单明细
        if (Objects.isNull(bo.getId())) {
            insertByBo(bo);
        } else {
            updateByBo(bo);
        }

        // 3.增加库存
        inventoryService.add(bo.getDetails());

        // 4.保存库存记录
        inventoryHistoryService.saveInventoryHistory(bo,ServiceConstants.InventoryHistoryOrderType.RECEIPT,true);
    }

    private void validateBeforeReceive(ReceiptOrderBo bo) {
        if (CollUtil.isEmpty(bo.getDetails())) {
            throw new BaseException("商品明细不能为空");
        }
    }

    /**
     * 修改入库单
     */
    @Transactional
    public void updateByBo(ReceiptOrderBo bo) {
        // 更新入库单
        ReceiptOrder update = MapstructUtils.convert(bo, ReceiptOrder.class);
        receiptOrderMapper.updateById(update);
        // 保存入库单明细
        List<ReceiptOrderDetail> detailList = MapstructUtils.convert(bo.getDetails(), ReceiptOrderDetail.class);
        //需要考虑detail删除
        List<ReceiptOrderDetailVo> dbList = receiptOrderDetailService.queryByReceiptOrderId(bo.getId());
        Set<Long> ids = detailList.stream().filter(it -> it.getId() != null).map(it -> it.getId()).collect(Collectors.toSet());
        List<ReceiptOrderDetailVo> delList = dbList.stream().filter(it -> !ids.contains(it.getId())).collect(Collectors.toList());
        if (CollectionUtil.isNotEmpty(delList)) {
            receiptOrderDetailService.deleteByIds(delList.stream().map(it->it.getId()).collect(Collectors.toList()));
        }
        detailList.forEach(it -> it.setOrderId(bo.getId()));
        receiptOrderDetailService.saveDetails(detailList);
    }

    /**
     * 入库单作废
     * @param id
     */
    public void editToInvalid(Long id) {
        LambdaUpdateWrapper<ReceiptOrder> wrapper = Wrappers.lambdaUpdate();
        wrapper.eq(ReceiptOrder::getId, id);
        wrapper.set(ReceiptOrder::getOrderStatus, ServiceConstants.ReceiptOrderStatus.INVALID);
        receiptOrderMapper.update(null, wrapper);
    }

    /**
     * 删除入库单
     */
    public void deleteById(Long id) {
        validateIdBeforeDelete(id);
        receiptOrderMapper.deleteById(id);
    }

    private void validateIdBeforeDelete(Long id) {
        ReceiptOrderVo receiptOrderVo = queryById(id);
        Assert.notNull(receiptOrderVo, "入库单不存在");
        if (ServiceConstants.ReceiptOrderStatus.FINISH.equals(receiptOrderVo.getOrderStatus())) {
            throw new ServiceException("删除失败", HttpStatus.CONFLICT,"入库单【" + receiptOrderVo.getOrderNo() + "】已入库，无法删除！");
        }
    }

    /**
     * 批量删除入库单
     */
    public void deleteByIds(Collection<Long> ids) {
        receiptOrderMapper.deleteBatchIds(ids);
    }

    public void validateReceiptOrderNo(String receiptOrderNo) {
        LambdaQueryWrapper<ReceiptOrder> receiptOrderLqw = Wrappers.lambdaQuery();
        receiptOrderLqw.eq(ReceiptOrder::getOrderNo, receiptOrderNo);
        ReceiptOrder receiptOrder = receiptOrderMapper.selectOne(receiptOrderLqw);
        Assert.isNull(receiptOrder, "入库单号重复，请手动修改");
    }

    /**
     * 入库业务（带AGV联动）：
     * 1. 托盘扫码
     * 2. 阀门绑定到托盘
     * 3. 库位分配
     * 4. 生成AGV入库任务
     * 5. 执行入库
     */
    @Transactional(rollbackFor = Exception.class)
    public String receiveWithAgv(Long receiptOrderId, String palletCode, List<String> valveNos, 
                                  String fromBinCode, String toBinCode) {
        // 1. 验证入库单
        ReceiptOrderVo receiptOrder = queryById(receiptOrderId);
        if (receiptOrder == null) {
            throw new BaseException("入库单不存在");
        }

        // 2. 验证托盘
        var palletVo = palletService.queryByPalletCode(palletCode);
        if (palletVo == null) {
            throw new BaseException("托盘不存在");
        }
        if (palletVo.getIsEmpty() == null || palletVo.getIsEmpty() == 0) {
            throw new BaseException("托盘不是空托，无法绑定物料");
        }

        // 3. 绑定阀门到托盘
        for (String valveNo : valveNos) {
            var valveVo = valveService.queryByValveNo(valveNo);
            if (valveVo == null) {
                throw new BaseException("阀门不存在: " + valveNo);
            }
            valveService.bindPallet(valveVo.getId(), palletVo.getId(), palletCode);
            // 更新阀门货位
            if (toBinCode != null) {
                var binVo = binService.queryByBinCode(toBinCode);
                if (binVo != null) {
                    valveService.updateValveBin(valveVo.getId(), binVo.getId(), toBinCode);
                }
            }
        }

        // 4. 更新托盘状态
        palletService.bindMaterial(palletVo.getId());
        if (toBinCode != null) {
            var binVo = binService.queryByBinCode(toBinCode);
            if (binVo != null) {
                palletService.updatePalletBin(palletVo.getId(), binVo.getId(), toBinCode);
            }
        }

        // 5. 生成AGV入库任务
        String agvTaskId = null;
        if (fromBinCode != null && toBinCode != null) {
            try {
                agvTaskId = agvIntegrationService.dispatchInboundTask(
                    palletCode, fromBinCode, toBinCode, receiptOrder.getOrderNo(), receiptOrderId);
            } catch (Exception e) {
                // AGV任务下发失败，记录日志但不影响入库流程
                // 可以后续手动补发任务
            }
        }

        return agvTaskId;
    }

    /**
     * AGV完成入库任务回调
     */
    @Transactional(rollbackFor = Exception.class)
    public void onAgvTaskCompleted(String taskNo, boolean success) {
        // 查询AGV任务
        var agvTaskVo = agvTaskService.queryByTaskNo(taskNo);
        if (agvTaskVo == null) {
            return;
        }

        if (success && agvTaskVo.getBizOrderId() != null) {
            // 更新入库单状态为已完成
            ReceiptOrderVo receiptOrder = queryById(agvTaskVo.getBizOrderId());
            if (receiptOrder != null && receiptOrder.getOrderStatus() == 0) {
                // 执行入库
                ReceiptOrderBo bo = MapstructUtils.convert(receiptOrder, ReceiptOrderBo.class);
                // 将VO列表转换为BO列表
                List<ReceiptOrderDetailVo> detailVos = receiptOrderDetailService.queryByReceiptOrderId(receiptOrder.getId());
                List<ReceiptOrderDetailBo> detailBos = detailVos.stream()
                    .map(vo -> MapstructUtils.convert(vo, ReceiptOrderDetailBo.class))
                    .collect(Collectors.toList());
                bo.setDetails(detailBos);
                receive(bo);
            }
        }
    }
}
