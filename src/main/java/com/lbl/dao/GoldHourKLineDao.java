package com.lbl.dao;

import com.lbl.entity.GoldHourKLineEntity;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.Date;

@Repository
public interface GoldHourKLineDao {
    GoldHourKLineEntity selectLatestHourKLine(int type);

    void insertHourKLine(GoldHourKLineEntity goldHourKLineEntity);

    ArrayList<GoldHourKLineEntity> selectHourKLineInTimeRegion(@Param("startTime") Date startTime,
                                                               @Param("endTime") Date endTime,
                                                               @Param("gold_type") int gold_type);
}
