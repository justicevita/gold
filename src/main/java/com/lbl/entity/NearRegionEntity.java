package com.lbl.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NearRegionEntity {
    private Timestamp startTime;

    private Timestamp endTime;
}
