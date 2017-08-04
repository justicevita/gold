package com.lbl.dao;

import com.lbl.entity.GoldAvgEntity;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.Date;

@Repository
public interface GoldAvgDao {
    GoldAvgEntity selectLatestGoldAvg(int gold_type);

    void insertGoldAvg(GoldAvgEntity goldAvgEntity);

    void insertGoldAvgList(ArrayList<GoldAvgEntity> goldAvgList);

    ArrayList<GoldAvgEntity> selectGoldAvgListInTimeRegion(@Param("startTime") Date startTime,
                                                           @Param("endTime") Date endTime,
                                                           @Param("gold_type") int gold_type,
                                                           @Param("avg_type")int avg_type);
}
