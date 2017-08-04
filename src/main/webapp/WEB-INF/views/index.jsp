<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
    <base href="<%="basePath"%>">

    <title>My JSP 'index.jsp' starting page</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="content-type" content="text/html;charset=UTF-8">
    <TITLE>黄金价格查询</TITLE>
    <script src="http://libs.baidu.com/jquery/1.9.1/jquery.min.js"></script>

</HEAD>
<body>

<div style="text-align: center">
    <p id="resultp">请稍等</p>
</div>
<script>
    window.setInterval(requestAvg, 5000);
    function requestAvg() {
        var requestTime = $("#requestTime").val();
        var domain = "http://" + window.location.host;
        jQuery.support.cors = true;
        $.ajax({
            type: "get",
            //url:domain+"/gold/domesticAvg?requestTime="+requestTime,
            url: domain+"/gold/domesticAvg",
            ContentType: "application/x-www-form-urlencoded;charset=utf-8",
            data: {
                "requestTime": requestTime
            },
            dateType: "json",
            success: function (result) {
                if (result.result == true) {
                    $("#resultp").html("日平均:" + result.data.dayAvg + " 周平均:" + result.data.weekAvg + " 月平均:" + result.data.monthAvg + " 斜率" + result.data.rate+"  国内黄金价格:"+result.data.domesticPrice+"  世界黄金价格:"+result.data.worldPrice);
                } else {
                    $("#resultp").html("参数错误,请重新填写")
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("发生错误");
            }

        })
    }
</script>
<div style="text-align: center"
>
    <table tyle="text-align: center">
    <tr>
        <td>
            <div id="model1" style="height:400px ; width:800px ;"></div>
        </td>
        <td><div id="model2" style="height:400px ; width:800px ;"></div></td>
    </tr>
    <tr>
        <td><div id="model3" style="height:400px ; width:800px ;"></div></td>
        <td><div id="model4" style="height:400px ; width:800px ;"></div></td>
    </tr>
        <%--<tr>
            <td><div id="model5" style="height:400px ; width:600px ;"></div></td>
            <td><div id="model6" style="height:400px ; width:600px ;"></div></td>
        </tr>--%>
    </table>
    <script src="http://echarts.baidu.com/build/dist/echarts.js"></script>


    <script type="text/javascript">

        require.config({
            paths: {
                echarts: 'http://echarts.baidu.com/build/dist'
            }
        });

        // 使用
        require(
            [
                'echarts',
                'echarts/chart/bar', // 使用柱状图就加载bar模块，按需加载
                'echarts/chart/k',
                'echarts/chart/line'
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('model1'));

                var option = {
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var res = params[0].seriesName + ' ' + params[0].name;
                            res += '<br/>  开盘 : ' + params[0].value[0] + '  最高 : ' + params[0].value[3];
                            res += '<br/>  收盘 : ' + params[0].value[1] + '  最低 : ' + params[0].value[2];
                            res+='<br/>  10小时:'+params[1].value;
                            res+='<br/>  20小时:'+params[2].value;
                            res+='<br/>  30小时:'+params[3].value;
                            return res;
                        }
                    },
                    legend: {
                        data: ['世界黄金小时K线','世界黄金10小时均线','世界黄金20小时均线','世界黄金30小时均线']
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {show: true},
                            dataZoom: {show: true},
                            dataView: {show: true, readOnly: false},
                            restore: {show: true},
                            saveAsImage: {show: true}
                        }
                    },
                    dataZoom: {
                        show: true,
                        realtime: true,
                        start: 0,
                        end: 100
                    },
                    xAxis: [
                        {
                            type: 'category',
                            boundaryGap: true,
                            axisTick: {onGap: false},
                            splitLine: {show: false},
                            data: [
                                <c:forEach items="${hourKWorld}" var="variable" >
                                <c:out value="'${variable.gold_time.year+1900}/${variable.gold_time.month+1}/${variable.gold_time.date}:${variable.gold_time.hours+1}'," escapeXml="false"/>
                                </c:forEach>
                            ]
                        }
                    ],
                    yAxis: [
                        {
                            type: 'value',
                            scale: true,
                            boundaryGap: [0.01, 0.01]
                        }
                    ],
                    series: [
                        {
                            name: '世界黄金小时K线',
                            type: 'k',
                            barMaxWidth: 20,
                            itemStyle: {
                                normal: {
                                    color: 'red',           // 阳线填充颜色
                                    color0: 'lightgreen',   // 阴线填充颜色
                                    lineStyle: {
                                        width: 2,
                                        color: 'orange',    // 阳线边框颜色
                                        color0: 'green'     // 阴线边框颜色
                                    }
                                },
                                emphasis: {
                                    color: 'black',         // 阳线填充颜色
                                    color0: 'white'         // 阴线填充颜色
                                }
                            },
                            data: [ // 开盘，收盘，最低，最高

                                <c:forEach items="${hourKWorld}" var="variable" >


                                <c:choose>
                                <c:when test="${1!=1}">
                                <c:out value="{
                                value:[${variable.gold_open},${variable.gold_close},${variable.gold_low},${variable.gold_high}],
                                itemStyle: {
                                    normal: {
                                        color0: 'blue',
                                        lineStyle: {
                                            width: 2,
                                            color0: 'blue'
                                        }
                                    },
                                    emphasis: {
                                        color0: 'blue'
                                    }
                                }
                            }," escapeXml="false"/>
                                </c:when>
                                <c:otherwise>
                                <c:out value="[${variable.gold_open},${variable.gold_close},${variable.gold_low},${variable.gold_high}],"/>
                                </c:otherwise>
                                </c:choose>
                                </c:forEach>
                            ]
                        }, {
                            name: '世界黄金10小时均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgHourWorld}" var="variable" >
                                <c:out value="${variable.ten_avg},"/>
                                </c:forEach>
                            ]
                        },
                        {
                            name: '世界黄金20小时均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgHourWorld}" var="variable" >
                                <c:out value="${variable.twenty_avg},"/>
                                </c:forEach>
                            ]
                        },
                        {
                            name: '世界黄金30小时均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgHourWorld}" var="variable" >
                                <c:out value="${variable.thirty_avg},"/>
                                </c:forEach>
                            ]
                        }
                    ]
                };

                // 为echarts对象加载数据
                myChart.setOption(option);
            }
        );
    </script>



    <script type="text/javascript">

        require.config({
            paths: {
                echarts: 'http://echarts.baidu.com/build/dist'
            }
        });

        // 使用
        require(
            [
                'echarts',
                'echarts/chart/bar', // 使用柱状图就加载bar模块，按需加载
                'echarts/chart/k',
                'echarts/chart/line'
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('model3'));

                var option = {
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var res = params[0].seriesName + ' ' + params[0].name;
                            res += '<br/>  开盘 : ' + params[0].value[0] + '  最高 : ' + params[0].value[3];
                            res += '<br/>  收盘 : ' + params[0].value[1] + '  最低 : ' + params[0].value[2];
                            res+='<br/>  10小时:'+params[1].value;
                            res+='<br/>  20小时:'+params[2].value;
                            res+='<br/>  30小时:'+params[3].value;
                            return res;
                        }
                    },
                    legend: {
                        data: ['国内黄金小时K线','国内黄金10小时均线','国内黄金20小时均线','国内黄金30小时均线']
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {show: true},
                            dataZoom: {show: true},
                            dataView: {show: true, readOnly: false},
                            restore: {show: true},
                            saveAsImage: {show: true}
                        }
                    },
                    dataZoom: {
                        show: true,
                        realtime: true,
                        start: 0,
                        end: 100
                    },
                    xAxis: [
                        {
                            type: 'category',
                            boundaryGap: true,
                            axisTick: {onGap: false},
                            splitLine: {show: false},
                            data: [
                                <c:forEach items="${hourKDomestic}" var="variable" >
                                <c:out value="'${variable.gold_time.year+1900}/${variable.gold_time.month+1}/${variable.gold_time.date}:${variable.gold_time.hours+1}'," escapeXml="false"/>
                                </c:forEach>
                            ]
                        }
                    ],
                    yAxis: [
                        {
                            type: 'value',
                            scale: true,
                            boundaryGap: [0.01, 0.01]
                        }
                    ],
                    series: [
                        {
                            name: '国内黄金小时K线',
                            type: 'k',
                            barMaxWidth: 20,
                            itemStyle: {
                                normal: {
                                    color: 'red',           // 阳线填充颜色
                                    color0: 'lightgreen',   // 阴线填充颜色
                                    lineStyle: {
                                        width: 2,
                                        color: 'orange',    // 阳线边框颜色
                                        color0: 'green'     // 阴线边框颜色
                                    }
                                },
                                emphasis: {
                                    color: 'black',         // 阳线填充颜色
                                    color0: 'white'         // 阴线填充颜色
                                }
                            },
                            data: [ // 开盘，收盘，最低，最高

                                <c:forEach items="${hourKDomestic}" var="variable" >
                                <c:choose>
                                <c:when test="${1!=1}">
                                <c:out value="{
                                value:[${variable.gold_open},${variable.gold_close},${variable.gold_low},${variable.gold_high}],
                                itemStyle: {
                                    normal: {
                                        color0: 'blue',
                                        lineStyle: {
                                            width: 2,
                                            color0: 'blue'
                                        }
                                    },
                                    emphasis: {
                                        color0: 'blue'
                                    }
                                }
                            }," escapeXml="false"/>
                                </c:when>
                                <c:otherwise>
                                <c:out value="[${variable.gold_open},${variable.gold_close},${variable.gold_low},${variable.gold_high}],"/>
                                </c:otherwise>
                                </c:choose>
                                </c:forEach>
                            ]
                        },{
                            name: '国内黄金10小时均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgHourDomestic}" var="variable" >
                                <c:out value="${variable.ten_avg},"/>
                                </c:forEach>
                            ]
                        },
                        {
                            name: '国内黄金20小时均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgHourDomestic}" var="variable" >
                                <c:out value="${variable.twenty_avg},"/>
                                </c:forEach>
                            ]
                        },
                        {
                            name: '国内黄金30小时均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgHourDomestic}" var="variable" >
                                <c:out value="${variable.thirty_avg},"/>
                                </c:forEach>
                            ]
                        }
                    ]
                };

                // 为echarts对象加载数据
                myChart.setOption(option);
            }
        );
    </script>

    <script type="text/javascript">

        require.config({
            paths: {
                echarts: 'http://echarts.baidu.com/build/dist'
            }
        });

        // 使用
        require(
            [
                'echarts',
                'echarts/chart/bar', // 使用柱状图就加载bar模块，按需加载
                'echarts/chart/k',
                'echarts/chart/line'
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('model2'));

                var option = {
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var res = params[0].seriesName + ' ' + params[0].name;
                            res += '<br/>  开盘 : ' + params[0].value[0] + '  最高 : ' + params[0].value[3];
                            res += '<br/>  收盘 : ' + params[0].value[1] + '  最低 : ' + params[0].value[2];
                            res+='<br/>  10日:'+params[1].value;
                            res+='<br/>  20日:'+params[2].value;
                            res+='<br/>  30日:'+params[3].value;
                            return res;
                        }
                    },
                    legend: {
                        data: ['世界黄金日K线','世界黄金10日均线','世界黄金20日均线','世界黄金30日均线']
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {show: true},
                            dataZoom: {show: true},
                            dataView: {show: true, readOnly: false},
                            restore: {show: true},
                            saveAsImage: {show: true}
                        }
                    },
                    dataZoom: {
                        show: true,
                        realtime: true,
                        start: 0,
                        end: 100
                    },
                    xAxis: [
                        {
                            type: 'category',
                            boundaryGap: true,
                            axisTick: {onGap: false},
                            splitLine: {show: false},
                            data: [
                                <c:forEach items="${dayKWorld}" var="variable" >
                                <c:out value="'${variable.gold_time.year+1900}/${variable.gold_time.month+1}/${variable.gold_time.date}'," escapeXml="false"/>
                                </c:forEach>
                            ]
                        }
                    ],
                    yAxis: [
                        {
                            type: 'value',
                            scale: true,
                            boundaryGap: [0.01, 0.01]
                        }
                    ],
                    series: [
                        {
                            name: '世界黄金日K线',
                            type: 'k',
                            barMaxWidth: 20,
                            itemStyle: {
                                normal: {
                                    color: 'red',           // 阳线填充颜色
                                    color0: 'lightgreen',   // 阴线填充颜色
                                    lineStyle: {
                                        width: 2,
                                        color: 'orange',    // 阳线边框颜色
                                        color0: 'green'     // 阴线边框颜色
                                    }
                                },
                                emphasis: {
                                    color: 'black',         // 阳线填充颜色
                                    color0: 'white'         // 阴线填充颜色
                                }
                            },
                            data: [ // 开盘，收盘，最低，最高

                                <c:forEach items="${dayKWorld}" var="variable" >


                                <c:choose>
                                <c:when test="${1!=1}">
                                <c:out value="{
                                value:[${variable.gold_open},${variable.gold_close},${variable.gold_low},${variable.gold_high}],
                                itemStyle: {
                                    normal: {
                                        color0: 'blue',
                                        lineStyle: {
                                            width: 2,
                                            color0: 'blue'
                                        }
                                    },
                                    emphasis: {
                                        color0: 'blue'
                                    }
                                }
                            }," escapeXml="false"/>
                                </c:when>
                                <c:otherwise>
                                <c:out value="[${variable.gold_open},${variable.gold_close},${variable.gold_low},${variable.gold_high}],"/>
                                </c:otherwise>
                                </c:choose>
                                </c:forEach>
                            ]
                        },{
                            name: '世界黄金10日均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgDayWorld}" var="variable" >
                                <c:out value="${variable.ten_avg},"/>
                                </c:forEach>
                            ]
                        },
                        {
                            name: '世界黄金20日均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgDayWorld}" var="variable" >
                                <c:out value="${variable.twenty_avg},"/>
                                </c:forEach>
                            ]
                        },
                        {
                            name: '世界黄金30日均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgDayWorld}" var="variable" >
                                <c:out value="${variable.thirty_avg},"/>
                                </c:forEach>
                            ]
                        }
                    ]
                };

                // 为echarts对象加载数据
                myChart.setOption(option);
            }
        );
    </script>
    <script type="text/javascript">

        require.config({
            paths: {
                echarts: 'http://echarts.baidu.com/build/dist'
            }
        });

        // 使用
        require(
            [
                'echarts',
                'echarts/chart/bar', // 使用柱状图就加载bar模块，按需加载
                'echarts/chart/k',
                'echarts/chart/line'
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('model4'));

                var option = {
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var res = params[0].seriesName + ' ' + params[0].name;
                            res += '<br/>  开盘 : ' + params[0].value[0] + '  最高 : ' + params[0].value[3];
                            res += '<br/>  收盘 : ' + params[0].value[1] + '  最低 : ' + params[0].value[2];
                            res+='<br/>  10日:'+params[1].value;
                            res+='<br/>  20日:'+params[2].value;
                            res+='<br/>  30日:'+params[3].value;
                            return res;
                        }
                    },
                    legend: {
                        data: ['国内黄金日K线','国内黄金10日均线','国内黄金20日均线','国内黄金30日均线']
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {show: true},
                            dataZoom: {show: true},
                            dataView: {show: true, readOnly: false},
                            restore: {show: true},
                            saveAsImage: {show: true}
                        }
                    },
                    dataZoom: {
                        show: true,
                        realtime: true,
                        start: 0,
                        end: 100
                    },
                    xAxis: [
                        {
                            type: 'category',
                            boundaryGap: true,
                            axisTick: {onGap: false},
                            splitLine: {show: false},
                            data: [
                                <c:forEach items="${dayKDomestic}" var="variable" >
                                <c:out value="'${variable.gold_time.year+1900}/${variable.gold_time.month+1}/${variable.gold_time.date}'," escapeXml="false"/>
                                </c:forEach>
                            ]
                        }
                    ],
                    yAxis: [
                        {
                            type: 'value',
                            scale: true,
                            boundaryGap: [0.01, 0.01]
                        }
                    ],
                    series: [
                        {
                            name: '国内黄金日K线',
                            type: 'k',
                            barMaxWidth: 20,
                            itemStyle: {
                                normal: {
                                    color: 'red',           // 阳线填充颜色
                                    color0: 'lightgreen',   // 阴线填充颜色
                                    lineStyle: {
                                        width: 2,
                                        color: 'orange',    // 阳线边框颜色
                                        color0: 'green'     // 阴线边框颜色
                                    }
                                },
                                emphasis: {
                                    color: 'black',         // 阳线填充颜色
                                    color0: 'white'         // 阴线填充颜色
                                }
                            },
                            data: [ // 开盘，收盘，最低，最高

                                <c:forEach items="${dayKDomestic}" var="variable" >

                                <c:choose>
                                <c:when test="${1!=1}">
                                <c:out value="{
                                value:[${variable.gold_open},${variable.gold_close},${variable.gold_low},${variable.gold_high}],
                                itemStyle: {
                                    normal: {
                                        color0: 'blue',
                                        lineStyle: {
                                            width: 2,
                                            color0: 'blue'
                                        }
                                    },
                                    emphasis: {
                                        color0: 'blue'
                                    }
                                }
                            }," escapeXml="false"/>
                                </c:when>
                                <c:otherwise>
                                <c:out value="[${variable.gold_open},${variable.gold_close},${variable.gold_low},${variable.gold_high}],"/>
                                </c:otherwise>
                                </c:choose>
                                </c:forEach>
                            ]
                        },{
                            name: '国内黄金10日均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgDayDomestic}" var="variable" >
                                <c:out value="${variable.ten_avg},"/>
                                </c:forEach>
                            ]
                        },
                        {
                            name: '国内黄金20日均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgDayDomestic}" var="variable" >
                                <c:out value="${variable.twenty_avg},"/>
                                </c:forEach>
                            ]
                        },
                        {
                            name: '国内黄金30日均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgDayDomestic}" var="variable" >
                                <c:out value="${variable.thirty_avg},"/>
                                </c:forEach>
                            ]
                        }
                    ]
                };

                // 为echarts对象加载数据
                myChart.setOption(option);
            }
        );
    </script>

  <%--  <script type="text/javascript">

        require.config({
            paths: {
                echarts: 'http://echarts.baidu.com/build/dist'
            }
        });

        // 使用
        require(
            [
                'echarts',
                'echarts/chart/bar', // 使用柱状图就加载bar模块，按需加载
                'echarts/chart/k',
                'echarts/chart/line'
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('model5'));

                var option = {
                    tooltip: {
                        trigger: 'axis'
                        /*formatter: function (params) {
                            var res = params[0].seriesName + ' ' + params[0].name;
                            res += '<br/>  日均 : ' + params[0].value[0] + '  周均 : ' + params[0].value[1]+ '  年均 : ' + params[0].value[2];
                            return res;
                        }*/
                    },
                    legend: {
                        data: ['日均线','周均线','月均线']
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {show: true},
                            dataZoom: {show: true},
                            dataView: {show: true, readOnly: false},
                            restore: {show: true},
                            saveAsImage: {show: true}
                        }
                    },
                    dataZoom: {
                        show: true,
                        realtime: true,
                        start: 0,
                        end: 100
                    },
                    xAxis: [
                        {
                            type: 'category',
                            boundaryGap: true,

                            data: [
                                <c:forEach items="${avgWorld}" var="variable" >
                                <c:out value="'${variable.gold_time.year+1900}/${variable.gold_time.month+1}/${variable.gold_time.date} ${variable.gold_time.hours}:${variable.gold_time.minutes}:${variable.gold_time.seconds}'," escapeXml="false"/>
                                </c:forEach>
                            ]
                        }
                    ],
                    yAxis: [
                        {
                            type: 'value',
                            scale:true
                        }
                    ],
                    series: [
                        {
                            name: '日均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgWorld}" var="variable" >
                                <c:out value="${variable.day_avg},"/>
                                </c:forEach>
                            ]
                        },{
                            name: '周均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgWorld}" var="variable" >
                                <c:out value="${variable.week_avg},"/>
                                </c:forEach>
                            ]
                        },{
                            name: '月均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgWorld}" var="variable" >
                                <c:out value="${variable.month_avg},"/>
                                </c:forEach>
                            ]
                        }
                    ]
                };

                // 为echarts对象加载数据
                myChart.setOption(option);
            }
        );
    </script>

    <script type="text/javascript">

        require.config({
            paths: {
                echarts: 'http://echarts.baidu.com/build/dist'
            }
        });

        // 使用
        require(
            [
                'echarts',
                'echarts/chart/bar', // 使用柱状图就加载bar模块，按需加载
                'echarts/chart/k',
                'echarts/chart/line'
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('model6'));

                var option = {
                    tooltip: {
                        trigger: 'axis'
                        /*formatter: function (params) {
                            var res = params[0].seriesName + ' ' + params[0].name;
                            res += '<br/>  日均 : ' + params[0].value[0] + '  周均 : ' + params[0].value[1]+ '  年均 : ' + params[0].value[2];
                            return res;
                        }*/
                    },
                    legend: {
                        data: ['日均线','周均线','月均线']
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {show: true},
                            dataZoom: {show: true},
                            dataView: {show: true, readOnly: false},
                            restore: {show: true},
                            saveAsImage: {show: true}
                        }
                    },
                    dataZoom: {
                        show: true,
                        realtime: true,
                        start: 0,
                        end: 100
                    },
                    xAxis: [
                        {
                            type: 'category',
                            boundaryGap: true,

                            data: [
                                <c:forEach items="${avgDomestic}" var="variable" >
                                <c:out value="'${variable.gold_time.year+1900}/${variable.gold_time.month+1}/${variable.gold_time.date} ${variable.gold_time.hours}:${variable.gold_time.minutes}:${variable.gold_time.seconds}'," escapeXml="false"/>
                                </c:forEach>
                            ]
                        }
                    ],
                    yAxis: [
                        {
                            type: 'value',
                            scale:true
                        }
                    ],
                    series: [
                        {
                            name: '日均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgDomestic}" var="variable" >
                                <c:out value="${variable.day_avg},"/>
                                </c:forEach>
                            ]
                        },{
                            name: '周均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgDomestic}" var="variable" >
                                <c:out value="${variable.week_avg},"/>
                                </c:forEach>
                            ]
                        },{
                            name: '月均线',
                            type: 'line',
                            data: [
                                <c:forEach items="${avgDomestic}" var="variable" >
                                <c:out value="${variable.month_avg},"/>
                                </c:forEach>
                            ]
                        }
                    ]
                };

                // 为echarts对象加载数据
                myChart.setOption(option);
            }
        );
    </script>--%>
</div>



</body>

</html>
