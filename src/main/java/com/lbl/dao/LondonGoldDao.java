package com.lbl.dao;

import com.lbl.entity.GoldEntity;
import com.lbl.entity.QueryGoldEntity;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;

@Repository
public interface LondonGoldDao {
    ArrayList<GoldEntity> selectGoldInTime(QueryGoldEntity queryGoldEntity);

    ArrayList<GoldEntity> selectGoldByTime(Date queryTime);
}
