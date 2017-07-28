package com.lbl.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResultEntity {
    private float monthAvg;

    private float weekAvg;

    private float dayAvg;

    private float rate;
}
