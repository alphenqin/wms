package com.ruoyi.wms.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.DataBackupBo;
import com.ruoyi.wms.domain.entity.DataBackup;
import com.ruoyi.wms.domain.vo.DataBackupVo;
import com.ruoyi.wms.mapper.DataBackupMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * 数据备份Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class DataBackupService extends ServiceImpl<DataBackupMapper, DataBackup> {

    private final DataBackupMapper dataBackupMapper;

    public DataBackupVo queryById(Long id) {
        return dataBackupMapper.selectVoById(id);
    }

    public TableDataInfo<DataBackupVo> queryPageList(DataBackupBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<DataBackup> lqw = buildQueryWrapper(bo);
        Page<DataBackupVo> result = dataBackupMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<DataBackupVo> queryList(DataBackupBo bo) {
        LambdaQueryWrapper<DataBackup> lqw = buildQueryWrapper(bo);
        return dataBackupMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<DataBackup> buildQueryWrapper(DataBackupBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<DataBackup> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getBackupNo()), DataBackup::getBackupNo, bo.getBackupNo());
        lqw.like(StrUtil.isNotBlank(bo.getBackupName()), DataBackup::getBackupName, bo.getBackupName());
        lqw.eq(bo.getBackupType() != null, DataBackup::getBackupType, bo.getBackupType());
        lqw.eq(bo.getStatus() != null, DataBackup::getStatus, bo.getStatus());
        lqw.eq(bo.getIsAuto() != null, DataBackup::getIsAuto, bo.getIsAuto());
        lqw.orderByDesc(DataBackup::getBackupTime);
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(DataBackupBo bo) {
        DataBackup add = MapstructUtils.convert(bo, DataBackup.class);
        if (add.getBackupNo() == null) {
            add.setBackupNo(generateBackupNo());
        }
        if (add.getBackupTime() == null) {
            add.setBackupTime(new Date());
        }
        dataBackupMapper.insert(add);
    }

    private String generateBackupNo() {
        return "BACKUP" + System.currentTimeMillis();
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(DataBackupBo bo) {
        DataBackup update = MapstructUtils.convert(bo, DataBackup.class);
        dataBackupMapper.updateById(update);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        dataBackupMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        dataBackupMapper.deleteBatchIds(ids);
    }

    /**
     * 执行数据备份
     */
    @Transactional(rollbackFor = Exception.class)
    public String executeBackup(Integer backupType, String backupName) {
        DataBackupBo bo = new DataBackupBo();
        bo.setBackupName(backupName != null ? backupName : "自动备份");
        bo.setBackupType(backupType);
        bo.setStatus(0); // 进行中
        bo.setIsAuto(0);
        insertByBo(bo);

        DataBackupVo backup = queryById(bo.getId());
        
        try {
            // 执行备份逻辑
            String backupPath = performBackup(backupType, backup.getBackupNo());
            long fileSize = getFileSize(backupPath);

            // 更新备份记录
            bo.setId(backup.getId());
            bo.setFilePath(backupPath);
            bo.setFileSize(fileSize);
            bo.setStatus(1); // 成功
            updateByBo(bo);

            return backupPath;
        } catch (Exception e) {
            log.error("数据备份失败", e);
            // 更新备份记录为失败
            bo.setId(backup.getId());
            bo.setStatus(2); // 失败
            bo.setErrorMsg(e.getMessage());
            updateByBo(bo);
            throw new RuntimeException("数据备份失败: " + e.getMessage(), e);
        }
    }

    /**
     * 执行备份操作
     */
    private String performBackup(Integer backupType, String backupNo) throws IOException {
        // 备份目录
        String backupDir = System.getProperty("user.dir") + File.separator + "backup";
        Path backupPath = Paths.get(backupDir);
        if (!Files.exists(backupPath)) {
            Files.createDirectories(backupPath);
        }

        // 生成备份文件名
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String fileName = "wms_backup_" + backupNo + "_" + timestamp + ".zip";
        String filePath = backupDir + File.separator + fileName;

        // 执行备份（这里简化实现，实际应该备份数据库）
        // 可以使用mysqldump或其他数据库备份工具
        try (ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(filePath))) {
            // 这里可以添加需要备份的文件
            // 实际应该调用数据库备份命令
            ZipEntry entry = new ZipEntry("backup_info.txt");
            zos.putNextEntry(entry);
            zos.write(("Backup Time: " + new Date() + "\nBackup Type: " + backupType).getBytes());
            zos.closeEntry();
        }

        return filePath;
    }

    /**
     * 获取文件大小（MB）
     */
    private long getFileSize(String filePath) {
        File file = new File(filePath);
        if (file.exists()) {
            return file.length() / (1024 * 1024); // 转换为MB
        }
        return 0;
    }

    /**
     * 恢复数据备份
     */
    @Transactional(rollbackFor = Exception.class)
    public void restoreBackup(Long backupId) {
        DataBackupVo backup = queryById(backupId);
        if (backup == null) {
            throw new RuntimeException("备份记录不存在");
        }
        if (backup.getStatus() == null || backup.getStatus() != 1) {
            throw new RuntimeException("备份文件不可用");
        }

        try {
            // 执行恢复逻辑
            // 这里应该调用数据库恢复命令
            // 例如：mysql -u user -p database < backup_file.sql
            log.info("开始恢复数据备份: {}", backup.getFilePath());
            // 实际恢复逻辑需要根据数据库类型实现
        } catch (Exception e) {
            log.error("数据恢复失败", e);
            throw new RuntimeException("数据恢复失败: " + e.getMessage(), e);
        }
    }
}

