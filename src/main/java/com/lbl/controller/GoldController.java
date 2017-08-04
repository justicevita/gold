package com.lbl.controller;

import com.lbl.common.response.Status;
import com.lbl.common.response.StatusCode;
import com.lbl.entity.*;
import com.lbl.service.GoldAvgService;
import com.lbl.service.GoldKLineService;
import com.lbl.service.GoldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Controller("/")
public class GoldController {
    @Autowired
    private GoldService goldService;

    @Autowired
    private GoldKLineService goldKLineService;

    @Autowired
    private GoldAvgService goldAvgService;

    @ResponseBody
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
        //System.out.println(goldList.get(0).getSj());
        //求月平均
        ArrayList<GoldEntity> monthBigRangeData=goldService.getBigRangeDate(goldList,null);
        float monthAvg=goldService.getAvg(monthBigRangeData,goldService.getNearRegionList(goldList));

        //求周平均
        List<GoldEntity> weekList=goldList.stream().filter(a->(time.getTime()-a.getSj().getTime())/1000<7L*24*60*60).collect(Collectors.toList());
        ArrayList<GoldEntity> weekBigRangeData=goldService.getBigRangeDate(weekList,monthBigRangeData);
        float weekAvg=goldService.getAvg(weekBigRangeData,goldService.getNearRegionList(weekList));

        //求日平均
        List<GoldEntity> dayList=weekList.stream().filter(a->(time.getTime()-a.getSj().getTime())/1000<24L*60*60).collect(Collectors.toList());
        ArrayList<GoldEntity> dayBigRangeData=goldService.getBigRangeDate(dayList,weekBigRangeData);
        float dayAvg=goldService.getAvg(dayBigRangeData,goldService.getNearRegionList(dayList));


        //System.out.println("m_l_count:"+goldList.size()+" m_b_count:"+monthBigRangeData.size()+"w_l_count:"+weekList.size()+" w_b_count:"+weekBigRangeData.size()+"d_l_count:"+dayList.size()+" d_b_count:"+dayBigRangeData.size());

        List<GoldEntity> hourList=goldList.stream()
                .filter(a->time.getTime()-a.getSj().getTime()<60*60*1000)
                .collect(Collectors.toList());

        float rate=goldService.getRateByRegression(hourList);

        float domesticPrice=goldService.getLatestGold().getZxj();
        float worldPrice=goldService.getLatestLondonGold().getZxj();
        System.out.println("goldTime:"+(new Date().getTime()-now.getTime()));
        return new Status(true,StatusCode.SUCCESS,new ResultEntity(monthAvg,weekAvg,dayAvg,rate,domesticPrice,worldPrice));
    }

    @ResponseBody
    @RequestMapping("needBuy")
    public Status needBuy(@RequestParam(required = false) String requestTime){
        Date now=new Date();


       return null;
    }
    /**
     * 获取最新的国内黄金数据
     * @return
     */
    @ResponseBody
    @RequestMapping("latestPrice")
    public Status getLatestPrice(){
        return new Status(true, StatusCode.SUCCESS,goldService.getLatestGold());
    }
    @RequestMapping("")
    public String getHomePage(Model model){
        Date now=new Date();
        ArrayList<GoldDayKLineEntity> goldDayKLineListInDomestic=goldKLineService.getDayKLineListInTimeRegion(new Date(now.getTime()-90L*24*60*60*1000),now,1);
        ArrayList<GoldDayKLineEntity> goldDayKLineListInWorld=goldKLineService.getDayKLineListInTimeRegion(new Date(now.getTime()-90L*24*60*60*1000),now,2);

        ArrayList<GoldHourKLineEntity> goldHourKLineInDomestic=goldKLineService.getHourKLineListInTimeRegion(new Date(now.getTime()-90L*60*60*1000),now,1);
        ArrayList<GoldHourKLineEntity> goldHourKLineInWorld=goldKLineService.getHourKLineListInTimeRegion(new Date(now.getTime()-90L*60*60*1000),now,2);


        ArrayList<GoldAvgEntity> goldHourAvgListInDomestic=goldAvgService.getGoldAvgListInTimeRegion(new Date(now.getTime()-90L*60*60*1000),now,1,1);
        ArrayList<GoldAvgEntity> goldHourAvgListInWorld=goldAvgService.getGoldAvgListInTimeRegion(new Date(now.getTime()-90L*60*60*1000),now,2,1);


        ArrayList<GoldAvgEntity> goldDayAvgListInDomestic=goldAvgService.getGoldAvgListInTimeRegion(new Date(now.getTime()-90L*24*60*60*1000),now,1,2);
        ArrayList<GoldAvgEntity> goldDayAvgListInWorld=goldAvgService.getGoldAvgListInTimeRegion(new Date(now.getTime()-90L*24*60*60*1000),now,2,2);
        model.addAttribute("dayKDomestic",goldDayKLineListInDomestic);
        model.addAttribute("dayKWorld",goldDayKLineListInWorld);
        model.addAttribute("hourKDomestic",goldHourKLineInDomestic);
        model.addAttribute("hourKWorld",goldHourKLineInWorld);
        model.addAttribute("avgHourDomestic",goldHourAvgListInDomestic);
        model.addAttribute("avgHourWorld",goldHourAvgListInWorld);
        model.addAttribute("avgDayDomestic",goldDayAvgListInDomestic);
        model.addAttribute("avgDayWorld",goldDayAvgListInWorld);

        return "index";
    }
}
