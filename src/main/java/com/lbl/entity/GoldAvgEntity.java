package com.lbl.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class GoldAvgEntity {
    private int id;

    private Date gold_time;

    private float ten_avg;

    private float twenty_avg;

    private float thirty_avg;

    private int avg_type;

    private int gold_type;
}
