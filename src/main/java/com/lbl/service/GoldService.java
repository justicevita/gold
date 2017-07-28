package com.lbl.service;

import com.lbl.dao.GoldDao;
import com.lbl.dao.LondonGoldDao;
import com.lbl.entity.GoldEntity;
import com.lbl.entity.NearRegionEntity;
import com.lbl.entity.QueryGoldEntity;
import com.lbl.entity.RegressionUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class GoldService {
    @Autowired
    private LondonGoldDao londonGoldDao;

    @Autowired
    private GoldDao goldDao;

    /**
     * 获得一个月内符合要求的黄金数据
     * @param queryGoldEntity
     * @return
     */
    public ArrayList<GoldEntity> getGoldList(QueryGoldEntity queryGoldEntity){
        if(queryGoldEntity==null
                ||queryGoldEntity.getQueryTime()==null){
            return new ArrayList<>();
        }
        return londonGoldDao.selectGoldInTime(queryGoldEntity);
    }

    /**
     * 根据时间获得需要查询的黄金价格及时间
     * @param time
     * @return
     */
    public GoldEntity getGold(Date time){
        if(time==null){
            return null;
        }
        ArrayList<GoldEntity> goldList=londonGoldDao.selectGoldByTime(time);
        return goldList.size()==0?null:goldList.get(0);
    }

    /**
     * 根据时间获得符合要求的数据
     * @param time
     * @return
     */
    public ArrayList<GoldEntity> getGoldNearPrice(Date time){
        GoldEntity goldEntity=getGold(time);
        if(goldEntity==null){
            System.out.println("未找到对应金价");
            return new ArrayList<>();
        }
        return getGoldList(new QueryGoldEntity(goldEntity.getZxj(),goldEntity.getSj()));
    }

    /**
     * 获得一段时间内的平均值
     * @return
     */
    public float getAvg(List<GoldEntity> bigRangeData,ArrayList<NearRegionEntity> nearRegionList){
        if(bigRangeData==null
                ||bigRangeData.size()==0
                ||nearRegionList==null
                ||nearRegionList.size()==0){
            return 0;
        }

        ArrayList<GoldEntity> domesticGoldList=new ArrayList<>();//符合区间的数据
        for(int i=0;i<bigRangeData.size();i++){
            for(int j=0;j<nearRegionList.size();j++){
                //如果找到合适的区间
                if(bigRangeData.get(i).getSj().getTime()>=nearRegionList.get(j).getStartTime().getTime()
                        &&bigRangeData.get(i).getSj().getTime()<=nearRegionList.get(j).getEndTime().getTime()){
                    domesticGoldList.add(bigRangeData.get(i));
                    break;
                }
            }
        }

        return domesticGoldList.size()==0?0:domesticGoldList.stream().map(a->a.getZxj()).reduce(Float::sum).get()/domesticGoldList.size();
    }

    public ArrayList<NearRegionEntity> getNearRegionList(List<GoldEntity> goldList){
        ArrayList<NearRegionEntity> nearRegionList=new ArrayList<>();
        Timestamp startGoldTime=goldList.get(0).getSj();//当前区间的最开始
        //获取当前股票的区间
        for(int i=1;i<goldList.size();i++){
            //如果二者相差20秒以上,则认为他们不在同一个区间
            if(goldList.get(i).getSj().getTime()-goldList.get(i-1).getSj().getTime()>20*1000){
                nearRegionList.add(new NearRegionEntity(startGoldTime,goldList.get(i-1).getSj()));
                startGoldTime=goldList.get(i).getSj();
            }
            if(i==goldList.size()-1){
                nearRegionList.add(new NearRegionEntity(startGoldTime,goldList.get(i).getSj()));
            }
        }
        return nearRegionList;
    }

    /**
     * 获取包含所有数据的大的区间
     * @param goldList
     * @param existRangeData
     * @return
     */
    public  ArrayList<GoldEntity> getBigRangeDate(List<GoldEntity> goldList, ArrayList<GoldEntity> existRangeData){
        if(goldList==null||goldList.size()==0){
            return new ArrayList<>();
        }
        if(existRangeData==null||existRangeData.size()==0){
            return goldDao.selectGoldInTimeRegion(goldList.get(0).getSj(),goldList.get(goldList.size()-1).getSj());
        }
        return (ArrayList<GoldEntity>) existRangeData.stream().filter(a->a.getSj().getTime()>=goldList.get(0).getSj().getTime()).collect(Collectors.toList());
    }

    /**
     * 线性回归的最小二乘法求斜率
     * @param goldList
     * @return
     */
    public float getRateByRegression(List<GoldEntity> goldList){

        List<RegressionUnit> hourList=goldList.stream()
                .map(a->new RegressionUnit((3600-(goldList.get(goldList.size()-1).getSj().getTime()-a.getSj().getTime()))/1000,a.getZxj()))
                .collect(Collectors.toList());
        //TODO:这里累加的结果可能会达到浮点数上限
        long avgX=0;
        float avgY=0;
        double amountOfXMultiY=0;
        long amountOfXSquare=0;
        for(RegressionUnit regressionUnit:hourList){
            avgX+=regressionUnit.getX();
            avgY+=regressionUnit.getY();
            amountOfXMultiY+=regressionUnit.getX()*regressionUnit.getY();
            amountOfXSquare+=regressionUnit.getX()*regressionUnit.getY();
        }
        avgX/=hourList.size();
        avgY/=hourList.size();

        long denominator=amountOfXSquare-hourList.size()*avgX;//分母
        double numerator=amountOfXMultiY-hourList.size()*avgX*avgY;//分子
        return denominator==0?0:(float)(numerator/denominator);

    }

    /**
     * 获取最新的国内黄金价格
     * @return
     */
    public GoldEntity getLatestGold(){
        return goldDao.getLatestGold();
    }
}
