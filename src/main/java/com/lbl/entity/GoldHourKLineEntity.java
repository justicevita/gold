package com.lbl.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GoldHourKLineEntity {



    private int id;

    private Date gold_time;

    private float gold_open;

    private float gold_close;

    private float gold_high;

    private float gold_low;

    private int gold_type;

}
