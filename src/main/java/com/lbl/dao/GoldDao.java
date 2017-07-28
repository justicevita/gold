package com.lbl.dao;

import com.lbl.entity.GoldEntity;
import com.lbl.entity.NearRegionEntity;
import com.lbl.entity.QueryGoldEntity;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Repository
public interface GoldDao {
    ArrayList<GoldEntity> selectGoldInTime(QueryGoldEntity queryGoldEntity);

    GoldEntity selectGoldByTime(Date queryTime);

    ArrayList<GoldEntity> selectGoldInTimeRegion(@Param("startTime") Timestamp startTime,
                                                 @Param("endTime") Timestamp endTime);

    ArrayList<GoldEntity> selectGoldInTimeRegionList(List<NearRegionEntity> nearRegionList);

    Float getAvgPriceInTimeRegion(@Param("regionList") List<NearRegionEntity> nearRegionList);

    GoldEntity getLatestGold();
}
