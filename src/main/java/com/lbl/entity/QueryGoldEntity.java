package com.lbl.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QueryGoldEntity {
    private float price;

    private Date queryTime;

    private float lowPrice;

    private float highPrice;

    public QueryGoldEntity(float price,Date queryTime){
        this.price=price;
        this.queryTime=queryTime;
        this.lowPrice=price-0.1f;
        this.highPrice=price+0.1f;
    }


}
