package com.lbl.controller;

import com.lbl.common.response.Status;
import com.lbl.common.response.StatusCode;
import com.lbl.entity.GoldEntity;
import com.lbl.entity.RegressionUnit;
import com.lbl.entity.ResultEntity;
import com.lbl.service.GoldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.Mapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@RestController("/")
public class GoldController {
    @Autowired
    private GoldService goldService;

    @RequestMapping("domesticAvg")
    public Status domesticAvg(@RequestParam(required = false) String requestTime){
        Date now=new Date();
        Timestamp time;
        try{
            time=requestTime==null||requestTime.equals("") ?
                    new Timestamp(now.getTime())
                    :Timestamp.valueOf(requestTime);
        }catch (IllegalArgumentException e){
            return new Status(false, StatusCode.ERROR_DATA,"时间错误");
        }

        ArrayList<GoldEntity> goldList=goldService.getGoldNearPrice(time);
        if(goldList==null||goldList.size()==0){
            return new Status(false, StatusCode.ERROR_DATA,"未找到对应的股票信息");
        }
        //求月平均
        ArrayList<GoldEntity> monthBigRangeData=goldService.getBigRangeDate(goldList,null);
        float monthAvg=goldService.getAvg(monthBigRangeData,goldService.getNearRegionList(goldList));

        //求周平均
        List<GoldEntity> weekList=goldList.stream().filter(a->(time.getTime()-a.getSj().getTime())/1000<7*24*60*60).collect(Collectors.toList());
        ArrayList<GoldEntity> weekBigRangeData=goldService.getBigRangeDate(weekList,monthBigRangeData);
        float weekAvg=goldService.getAvg(weekBigRangeData,goldService.getNearRegionList(weekList));

        //求日平均
        List<GoldEntity> dayList=weekList.stream().filter(a->(time.getTime()-a.getSj().getTime())/1000<24*60*60).collect(Collectors.toList());
        ArrayList<GoldEntity> dayBigRangeData=goldService.getBigRangeDate(dayList,weekBigRangeData);
        float dayAvg=goldService.getAvg(dayBigRangeData,goldService.getNearRegionList(dayList));

        List<GoldEntity> hourList=goldList.stream()
                .filter(a->time.getTime()-a.getSj().getTime()<60*60*1000)
                .collect(Collectors.toList());

        float rate=goldService.getRateByRegression(hourList);
        System.out.println("goldTime:"+(new Date().getTime()-now.getTime()));
        return new Status(true,StatusCode.SUCCESS,new ResultEntity(monthAvg,weekAvg,dayAvg,rate));
    }

    /**
     * 获取最新的国内黄金数据
     * @return
     */
    @RequestMapping("latestPrice")
    public Status getLatestPrice(){
        return new Status(true, StatusCode.SUCCESS,goldService.getLatestGold());
    }
}
