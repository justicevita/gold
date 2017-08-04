package com.lbl.dao;

import com.lbl.entity.GoldDayKLineEntity;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.Date;

@Repository
public interface GoldDayKLineDao {

    GoldDayKLineEntity selectLatestDayKLine(int type);

    void insertDayKLine(GoldDayKLineEntity goldDayKLineEntity);

    ArrayList<GoldDayKLineEntity> selectDayKLineInTimeRegion(@Param("startTime") Date startTime,
                                                            @Param("endTime") Date endTime,
                                                            @Param("gold_type") int gold_type);
}
