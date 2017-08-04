package com.lbl.service;

import com.lbl.dao.GoldAvgDao;
import com.lbl.entity.GoldAvgEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;

@Service
public class GoldAvgService {

    @Autowired
    private GoldAvgDao goldAvgDao;

    public GoldAvgEntity getLatestGoldAvg(int type){
        return goldAvgDao.selectLatestGoldAvg(type);
    }


    public void insertGoldAvg(GoldAvgEntity goldAvgEntity){
        goldAvgDao.insertGoldAvg(goldAvgEntity);
    }

    public void insertGoldAvgList(ArrayList<GoldAvgEntity> goldAvgList){
        goldAvgDao.insertGoldAvgList(goldAvgList);
    }

    public ArrayList<GoldAvgEntity> getGoldAvgListInTimeRegion(Date starTime, Date endTime, int goldType,int avgType){
        return goldAvgDao.selectGoldAvgListInTimeRegion(starTime,endTime,goldType,avgType);
    }
}
