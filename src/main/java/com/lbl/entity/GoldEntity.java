package com.lbl.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GoldEntity {
    private int id;

    private Timestamp sj;

    private float zxj;
}
