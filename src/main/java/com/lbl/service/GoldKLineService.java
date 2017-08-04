package com.lbl.service;

import com.lbl.dao.GoldDao;
import com.lbl.dao.GoldDayKLineDao;
import com.lbl.dao.GoldHourKLineDao;
import com.lbl.dao.LondonGoldDao;
import com.lbl.entity.GoldDayKLineEntity;
import com.lbl.entity.GoldHourKLineEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;

@Service
public class GoldKLineService {
    @Autowired
    private GoldDao goldDao;

    @Autowired
    private LondonGoldDao londonGoldDao;

    @Autowired
    private GoldDayKLineDao goldDayKLineDao;

    @Autowired
    private GoldHourKLineDao goldHourKLineDao;

    public GoldDayKLineEntity getLatestDayKLine(int type){
        return goldDayKLineDao.selectLatestDayKLine(type);
    }

    public GoldHourKLineEntity getLatestHourKLine(int type){
        return goldHourKLineDao.selectLatestHourKLine(type);
    }

    public void insertHourKLine(GoldHourKLineEntity goldHourKLineEntity){
        goldHourKLineDao.insertHourKLine(goldHourKLineEntity);
    }

    public ArrayList<GoldHourKLineEntity>  getHourKLineListInTimeRegion(Date starTime, Date endTime,int type){
        return goldHourKLineDao.selectHourKLineInTimeRegion(starTime,endTime,type);
    }
    public ArrayList<GoldDayKLineEntity>  getDayKLineListInTimeRegion(Date starTime, Date endTime,int type){
        return goldDayKLineDao.selectDayKLineInTimeRegion(starTime,endTime,type);
    }

    public void insertDayKLine(GoldDayKLineEntity goldDayKLineEntity){
        goldDayKLineDao.insertDayKLine(goldDayKLineEntity);
    }



}
