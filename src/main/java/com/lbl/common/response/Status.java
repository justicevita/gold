package com.lbl.common.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Status {
    /**
     * 状态值
     */
    private boolean result;

    /**
     * 状态码
     */
    private int statusCode;

    /**
     * 需要让用户知道的数据
     */
    private Object data;

    @Override
    public String toString(){
        return "result:"+result+" statusCode:"+statusCode+" data:"+data;
    }
}
