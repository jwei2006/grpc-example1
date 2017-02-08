<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">

    <title>任务调度系统</title>

    <!-- Bootstrap core CSS -->
    <link href="<%=request.getContextPath() %>/static/bower_components/bootstrap/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="<%=request.getContextPath() %>/static/assets/css/dashboard.css"
          rel="stylesheet">
    <link href="<%=request.getContextPath() %>/static/bower_components/select2-3.5.3/select2.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/static/bower_components/select2-3.5.3/select2-bootstrap.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]>
    <script src="<%=request.getContextPath() %>/static/assets/js/ie8-responsive-file-warning.js"></script>
    <![endif]-->
    <script src="<%=request.getContextPath() %>/static/assets/js/ie-emulation-modes-warning.js"></script>

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="<%=request.getContextPath() %>/static/assets/js/ie10-viewport-bug-workaround.js"></script>

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>
<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse"
                    data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">任务调度系统</a>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="#">欢迎你，${user.name}</a></li>
                <li><a href="https://sso.sankuai.com/logout">退出</a></li>
                <li><a href="http://wiki.sankuai.com/display/TRAVEL/MSchedule" target="_blank">帮助</a></li>
            </ul>
        </div>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
            <ul class="nav nav-sidebar">
                <li class="active"><a href="#">任务</a></li>
            </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <h3 class="page-header">
                任务列表
                <button type="button" class="btn btn-success btn-xs J_addNewJob">添加新任务</button>
            </h3>
            <form action="/manage/job/jobList" method="get" role="form" class="form-horizontal ng-scope ng-valid ng-dirty" id="searchForm">
                <div class="form-group">
                    <label class="col-sm-2 control-label">任务分组</label>

                    <div class="col-sm-4">
                        <input class="form-control ng-pristine ng-valid" type="text" autocomplete="off" name="jobGroup"
                               value="${jobList.data.jobInfoParam.jobGroup}">
                    </div>

                    <label class="col-sm-2 control-label">任务码</label>
                    <div class="col-sm-4">
                        <input class="form-control ng-pristine ng-valid" type="text" autocomplete="off" name="jobCode"
                               value="${jobList.data.jobInfoParam.jobCode}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">任务所有者</label>

                    <div class="col-sm-4">
                        <input class="form-control ng-pristine ng-valid" type="text" autocomplete="off" name="jobOwner"
                               value="${jobList.data.jobInfoParam.jobOwner}">
                    </div>

                    <label class="col-sm-2 control-label">启动状态</label>

                    <div class="col-sm-2">
                        <select class="form-control" data-field="${jobList.data.jobInfoParam.scheduleStatus}" name="scheduleStatus">
                            <c:choose>
                                <c:when test="${jobList.data.jobInfoParam.scheduleStatus == -1}">
                                    <option value="-1" selected>全部</option>
                                    <option value="1">启动</option>
                                    <option value="0">停止</option>
                                </c:when>
                                <c:when test="${jobList.data.jobInfoParam.scheduleStatus == 1}">
                                    <option value="-1">全部</option>
                                    <option value="1" selected>启动</option>
                                    <option value="0">停止</option>
                                </c:when>
                                <c:when test="${jobList.data.jobInfoParam.scheduleStatus == 0}">
                                    <option value="-1">全部</option>
                                    <option value="1">启动</option>
                                    <option value="0" selected>停止</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="-1" selected>全部</option>
                                    <option value="1">启动</option>
                                    <option value="0">停止</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </div>

                </div>
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <button type="button" class="btn btn-primary J_searchJob">查询
                        </button>
                        <button type="button" name="reset" class="btn btn-default">重置
                        </button>
                    </div>
                </div>
                <input type="hidden" name="pageNum" value="1">
                <input type="hidden" name="pageSize" value="20">
            </form>
            <div class="table-responsive">
                <table class="table table-striped tasks-list-table">
                    <thead>
                    <tr>
                        <th>任务分组</th>
                        <th>任务码</th>
                        <th>任务名称</th>
                        <th>匹配表达式</th>
                        <th>任务所有者</th>
                        <th>最后修改时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${jobList.ret == true}">
                        <c:forEach items="${jobList.data.jobDetails}" var="job">
                            <c:choose>
                                <c:when test="${job.scheduleStatus == 1}">
                                    <tr class="green" data-json='${job.jobJson}' data-id="${job.id}">
                                </c:when>
                                <c:otherwise>
                                    <tr class="red" data-json='${job.jobJson}' data-id="${job.id}">
                                </c:otherwise>

                            </c:choose>
                            <td>${job.jobGroup}</td>
                            <td>${job.jobCode}</td>
                            <td>${job.jobName}</td>
                            <td>${job.expression}</td>
                            <td>${job.jobOwner}</td>
                            <td>${job.modifyTime}</td>
                            <td>
                                <button type="button"
                                        class="btn btn-default btn-xs btn-primary J_taskItemToggle">
                                    <c:choose>
                                        <c:when test="${job.scheduleStatus == 1}">
                                            <span data-action="stop">停止</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span data-action="start">启动</span>
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                                <button type="button"
                                        class="btn btn-default btn-xs J_taskItemDetail"
                                        data-toggle="modal"
                                        data-target="#myModal">详情
                                </button>
                                <button type="button"
                                        class="btn btn-default btn-xs J_taskItemOnce">
                                    手动执行一次
                                </button>
                                <button type="button"
                                        class="btn btn-default btn-xs J_taskItemTrace">
                                    跟踪
                                </button>
                                <c:choose>
                                    <c:when test="${job.scheduleStatus != 1}">
                                        <button type="button"
                                                class="btn btn-default btn-xs J_removeItemDetail">删除
                                        </button>
                                    </c:when>
                                </c:choose>
                            </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <ul class="pagination pagination-sm">
                <c:choose>
                    <c:when test="${jobList.data.pageNum - 1 == 0}">
                        <li class="disabled"><a href="#">&laquo;</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="<%=request.getContextPath() %>/manage/job/jobList?jobCode=${jobList.data.jobInfoParam.jobCode}&jobGroup
                        =${jobList.data.jobInfoParam.jobGroup}&jobOwner
                        =${jobList.data.jobInfoParam.jobOwner}&scheduleStatus=${jobList.data.jobInfoParam.scheduleStatus}&pageNum
                        =${jobList.data.pageNum-1}&pageSize=20">&laquo;</a></li>
                    </c:otherwise>
                </c:choose>
                <c:if test="${jobList.ret == true}">
                    <c:forEach var="pageNum" begin="1"
                               end="${jobList.data.pageCount}"
                               step="1">
                        <c:choose>
                            <c:when test="${jobList.data.pageNum == pageNum}">
                                <li class="active">
                                    <a href="<%=request.getContextPath() %>/manage/job/jobList?jobCode=${jobList.data.jobInfoParam.jobCode}&jobGroup=${jobList.data.jobInfoParam.jobGroup}&jobOwner=${jobList.data.jobInfoParam.jobOwner}&scheduleStatus=${jobList.data.jobInfoParam.scheduleStatus}&pageNum=${pageNum}&pageSize=20">${pageNum}<span
                                            class="sr-only">(current)</span></a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${ (jobList.data.pageNum < 4 && pageNum < 8) || jobList.data.pageNum > jobList.data.pageCount - 3 && pageNum > jobList.data.pageCount - 7}">
                                        <li>
                                            <a href="<%=request.getContextPath() %>/manage/job/jobList?jobCode=${jobList.data.jobInfoParam.jobCode}&jobGroup=${jobList.data.jobInfoParam.jobGroup}&jobOwner=${jobList.data.jobInfoParam.jobOwner}&scheduleStatus=${jobList.data.jobInfoParam.scheduleStatus}&pageNum=${pageNum}&pageSize=20">${pageNum}</a>
                                        </li>
                                    </c:when>
                                    <c:when test="${jobList.data.pageNum +4 > pageNum && jobList.data.pageNum -4 < pageNum}">
                                        <li>
                                            <a href="<%=request.getContextPath() %>/manage/job/jobList?jobCode=${jobList.data.jobInfoParam.jobCode}&jobGroup=${jobList.data.jobInfoParam.jobGroup}&jobOwner=${jobList.data.jobInfoParam.jobOwner}&scheduleStatus=${jobList.data.jobInfoParam.scheduleStatus}&pageNum=${pageNum}&pageSize=20">${pageNum}</a>
                                        </li>
                                    </c:when>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:if>
                <c:choose>
                    <c:when test="${jobList.data.pageNum+1 > jobList.data.pageCount}">
                        <li class="disabled"><a href="#">&raquo;</a></li>
                    </c:when>
                    <c:otherwise>
                        <li>
                            <a href="<%=request.getContextPath() %>/manage/job/jobList?jobCode=${jobList.data.jobInfoParam.jobCode}&jobGroup=${jobList.data.jobInfoParam.jobGroup}&jobOwner=${jobList.data.jobInfoParam.jobOwner}&scheduleStatus=${jobList.data.jobInfoParam.scheduleStatus}&pageNum=${jobList.data.pageNum+1}&pageSize=20">&raquo;</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
            <div class="modal fade in" role="dialog" tabindex="-1" modal-window="" window-class="dialogs-default" size="sm" index="0"
                 animate="animate" style="z-index: 1060; display: none;" id="showInfo">
                <div class="modal-dialog modal-sm" style="">
                    <div modal-transclude="" class="modal-content">
                        <div class="modal-header dialog-header-error ng-scope">
                            <button name="close" class="close" type="button">×</button>
                            <h4 class="modal-title text-danger">
                                <span class="glyphicon glyphicon-warning-sign"></span>
                                <span ng-bind-html="header" class="ng-binding">错误</span>
                            </h4>
                        </div>
                        <div class="modal-body text-danger ng-binding ng-scope" name="msg"></div>
                        <div class="modal-footer ng-scope">
                            <button class="btn btn-default ng-binding" type="button" name="close">关闭</button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="confirmModal" class="modal fade in" role="dialog" tabindex="-1" animate="animate" style="z-index: 1050; display: none;">
                <div class="modal-dialog modal-sm" style="">
                    <div modal-transclude="" class="modal-content">
                        <div class="modal-header dialog-header-confirm ng-scope">
                            <button name="no" class="close" type="button">×</button>
                            <h4 class="modal-title ng-binding"><span class="glyphicon glyphicon-check"></span> 确认</h4>
                        </div>
                        <div class="modal-body ng-binding ng-scope" name="msg"></div>
                        <div class="modal-footer ng-scope">
                            <button name="yes" class="btn btn-primary" type="button">确定</button>
                            <button name="no" class="btn btn-default" type="button">取消</button>
                        </div>
                        <input type="hidden" value="" name="confirmType">
                        <input type="hidden" value="" name="dataJson">
                    </div>
                </div>
            </div>
            <div class="modal-backdrop fade in" name="confirmDropModal" style="z-index: 1040;display:none"></div>
            <div class="modal-backdrop fade in" name="showInfoDropModal" style="z-index: 1055;display:none"></div>
            <!-- Modal -->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
                 aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close"
                                    data-dismiss="modal"><span
                                    aria-hidden="true">&times;</span><span
                                    class="sr-only">Close</span></button>
                            <h4 class="modal-title" id="myModalLabel" style="font-weight: 700;">任务详情</h4>
                        </div>
                        <div class="modal-body J_modalBody">

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default"
                                    data-dismiss="modal">取消
                            </button>
                            <button type="button" class="btn btn-primary J_saveChanges">保存变更
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal -->
            <div class="modal fade" id="myModalAdd" tabindex="-1" role="dialog"
                 aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content J_modalBody">
                        <div class="modal-header">
                            <button type="button" class="close"
                                    data-dismiss="modal"><span
                                    aria-hidden="true">&times;</span><span
                                    class="sr-only">Close</span></button>
                            <h4 class="modal-title" id="myModalLabel" style="font-weight: 700;">任务信息</h4>
                        </div>
                        <form class="form-horizontal">
                            <div class="form-group" style="margin-top:15px">

                                <label class="col-sm-2 control-label label-require" style="font-weight:100">任务分组</label>
                                <div class="col-sm-3">
                                    <input type="text" autocomplete="off" class="form-control" name="jobGroup" placeholder="" value=""
                                           data-field="jobGroup"/>
                                </div>


                                <label class="col-sm-3 control-label label-require" style="font-weight:100">任务码</label>
                                <div class="col-sm-3">
                                    <input class="form-control" class="form-control" name="jobCode" placeholder="" value="" data-field="jobCode"
                                           autocomplete="off"/>
                                </div>





                            </div>
                            <div class="form-group" style="margin-top: 20px">

                                <label class="col-sm-2 control-label label-require" style="font-weight:100">务任名称</label>
                                <div class="col-sm-3">
                                    <input class="form-control" class="form-control" name="jobName" placeholder="" value="" data-field="jobName"
                                           autocomplete="off"/>
                                </div>


                                <label class="col-sm-3 control-label label-require" style="font-weight:100">任务所有者</label>
                                <div class="col-sm-3">
                                    <input type="text" autocomplete="off" class="form-control" name="jobOwner" placeholder="" value=""
                                           data-field="jobOwner"/>
                                </div>


                            </div>
                        </form>
                        <div class="modal-header">
                            <h4 class="modal-title" style="font-weight:700">执行信息</h4>
                        </div>
                        <form class="form-horizontal">
                            <div class="form-group" style="margin-top:15px">
                                <label class="col-sm-3 control-label" style="font-weight:100">任务回传数据</label>
                                <div class="col-sm-8">
                                    <input type="text" name="jobArgs" autocomplete="off" class="form-control" placeholder='任务下发时该数据回传' value=""
                                           data-field="jobArgs"/>
                                </div>
                            </div>
                            <div class="form-group" style="margin-top:15px">
                                <label class="col-sm-3 control-label label-require" style="font-weight:100">运行机器列表</label>

                                <div class="col-sm-8">
                                    <input type="text" name="jobRunNode" autocomplete="off" class="form-control" placeholder='多个机器之间以半角","隔开' value=""
                                           data-field="jobRunNode"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label label-require" style="font-weight:100">通信端口</label>

                                <div class="col-sm-4">
                                    <input type="text" autocomplete="off" name="port" class="form-control"
                                           placeholder="" value=""
                                           data-field="port"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label label-require" style="font-weight:100">表达式类型</label>
                                <div class="col-sm-3">
                                    <select class="form-control" data-field="expressionType" name="expressionType">
                                        <option value="cron">cron</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label label-require" style="font-weight:100">匹配表达式</label>

                                <div class="col-sm-8">
                                    <input type="text" autocomplete="off" name="expression" class="form-control" placeholder="" value=""
                                           data-field="expression"/>

                                    <p >提示: 秒 分 时 日 月 周 每天23点执行一次 0 0 23 * * ?</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label label-require" style="font-weight:100">任务执行策略</label>

                                <div class="col-sm-3">
                                    <select class="form-control" id="J_changeStrategy" data-field="strategyCode" name="strategyCode">
                                        <option value="0">第一个节点执行</option>
                                        <option value="1">随机节点执行</option>
                                        <option value="2">全节点执行</option>
                                    </select>
                                </div>
                            </div>
                            <%--

                            <div class="form-group" style="margin-left:-80px">
                                <label class="col-sm-5 control-label" style="font-weight:100">上次任务未完成不启动新任务</label>
                                <label class="radio-inline">
                                    <input type="radio" value="1" data-field="startNewJob" id="startNewJob1" checked="checked" name="startNewJob">是
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" value="0" data-field="startNewJob" id="startNewJob0" name="startNewJob">否
                                </label>
                            </div>
                            <div class="form-group" style="margin-left:-80px">
                                <label class="col-sm-5 control-label" style="font-weight:100">任务运行中是否报警</label>
                                <label class="radio-inline">
                                    <input type="radio" value="0" data-field="runningAlarm" checked="checked" name="runningAlarm">是
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" value="1" data-field="runningAlarm" name="runningAlarm">否
                                </label>
                            </div>
                            <div class="form-group" style="margin-left:-80px">
                                <label class="col-sm-5 control-label" style="font-weight:100">是否启动直连</label>
                                <label class="radio-inline">
                                    <input type="radio" value="1" data-field="scheduleChannel" name="scheduleChannel">是
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" value="0" data-field="scheduleChannel" checked="checked" name="scheduleChannel">否
                                </label>
                            </div>

                            --%>

                        </form>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default"
                                    data-dismiss="modal">取消
                            </button>
                            <button type="button" class="btn btn-primary J_addConfirm">确认新增
                            </button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<script type="text/juicer" id="J_myModalTpl">
    <form class="form-horizontal">
        <input class="form-control" disabled type="hidden" autocomplete="off" data-field="id" value="\${id}" placeholder=""/>
        <div class="form-group" style="margin-top:15px;margin-left:-80px">
            <label class="col-sm-3 control-label" style="font-weight:100">任务唯一码</label>
            <div class="col-sm-9">
                <input name="jobUniqCode" class="form-control" disabled type="text" autocomplete="off" data-field="jobUniqCode" value="\${jobUniqCode}" placeholder=""/>
            </div>
        </div>

        <div class="form-group" style="margin-top: 20px">
            <label class="col-sm-2 control-label label-require" style="font-weight:100">任务分组</label>
            <div class="col-sm-3">
                <input type="text" name="jobGroup" class="form-control" placeholder="" value="\${jobGroup}" data-field="jobGroup"/>
            </div>

            <label class="col-sm-3 control-label label-require" style="font-weight:100">任务码</label>
            <div class="col-sm-4">
                <input class="form-control" name="jobCode" type="text" autocomplete="off" data-field="jobCode" value="\${jobCode}" placeholder=""/>
            </div>
        </div>



        <div class="form-group">
        <label class="col-sm-2 control-label label-require" style="font-weight:100">任务名称</label>
            <div class="col-sm-3">
                <input class="form-control" name="jobName" class="form-control" placeholder="" value="\${jobName}" data-field="jobName"/>
            </div>

            <label class="col-sm-3 control-label label-require" style="font-weight:100">任务所有者11</label>
            <div class="col-sm-4">
                <input class="form-control" name="jobOwner" type="text" autocomplete="off" placeholder="" value="\${jobOwner}" data-field="jobOwner"/>
            </div>

        </div>
    </form>
    <div class="modal-header">
        <h4 class="modal-title" style="font-weight: 700;">执行信息</h4>
    </div>
    <form class="form-horizontal">
         <div class="form-group" style="margin-top:15px">
            <label class="col-sm-3 control-label" style="font-weight:100">任务回传数据</label>

            <div class="col-sm-8">
                <input type="text" name="jobArgs" autocomplete="off" class="form-control" placeholder='任务下发时该数据回传' value="\${jobArgs}"
                       data-field="jobArgs"/>
            </div>
        </div>
        <div class="form-group" style="margin-top:15px">
            <label class="col-sm-3 control-label label-require" style="font-weight:100">运行机器列表</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" name="jobRunNode" placeholder='多个机器之间以半角","隔开' value="\${jobRunNode}" data-field="jobRunNode"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label label-require" style="font-weight:100">通信端口</label>

            <div class="col-sm-4">
                <input type="text" autocomplete="off" name="port" class="form-control"
                       placeholder="" value="\${port}"
                       data-field="port"/>
            </div>
        </div>
        <div class="form-group" >
            <label class="col-sm-3 control-label label-require" style="font-weight:100">表达式类型</label>
            <div class="col-sm-3">
                <select class="form-control" data-field="expressionType" name="expressionType">
                    <option value="cron" {@if expressionType == 'cron'}selected{@/if}>cron</option>
                </select>
            </div>
        </div>
        <div class="form-group" >
            <label class="col-sm-3 control-label label-require" style="font-weight:100">匹配表达式</label>
            <div class="col-sm-8">
                <input type="text" name ="expression" class="form-control" placeholder="" value="\${expression}" data-field="expression"/>
                <p >提示: 秒 分 时 日 月 周 每天23点执行一次 0 0 23 * * ?</p>
            </div>
        </div>


        <div class="form-group">
            <label class="col-sm-3 control-label label-require" style="font-weight:100">任务运行策略</label>
            <div class="col-sm-3">
                <select class="form-control" id="J_changeStrategy" data-field="strategyCode" name="strategyCode">
                    <option value="0" {@if strategyCode == 0}selected{@/if} >第一个节点执行</option>
                    <option value="1" {@if strategyCode == 1}selected{@/if} >随机节点执行</option>
                    <option value="2" {@if strategyCode == 2}selected{@/if} >全节点执行</option>
                </select>
            </div>
        </div>

<%--



        <div class="form-group" style="margin-left:-80px">
            <label class="col-sm-5 control-label" style="font-weight:100">上次任务未完成不启动新任务</label>
            <label class="radio-inline">
                <input type="radio" value="1" {@if startNewJob == 1}checked{@/if} data-field="startNewJob" name="startNewJob">是
            </label>
            <label class="radio-inline">
                <input type="radio" value="0" data-field="startNewJob" {@if startNewJob == 0}checked{@/if} name="startNewJob">否
            </label>
        </div>


        <div class="form-group" style="margin-left:-80px">
            <label class="col-sm-5 control-label" style="font-weight:100">任务运行中是否报警</label>
            <label class="radio-inline">
                <input type="radio" value="0" {@if runningAlarm == 0}checked{@/if} data-field="runningAlarm" name="runningAlarm">是
            </label>
            <label class="radio-inline">
                <input type="radio" value="1" data-field="runningAlarm" {@if runningAlarm == 1}checked{@/if} name="runningAlarm">否
            </label>
        </div>



        --%>

    </form>

 <%--
    <div class="modal-header">
        <h4 class="modal-title" style="font-weight:700">报警配置</h4>
    </div>
    <form class="form-horizontal" style="margin-top:15px" id="alarmItem">
    <div class="form-group" >
        <label class="col-sm-3 control-label" style="font-weight:100">报警类型</label>
        <label class="radio-inline">
            <input type="radio" value="0" {@if alarmTimeInterval == 0}checked{@/if} name="alarmTimeInterval_1">只报一次
        </label>
        <label class="radio-inline">
            <input type="radio" value="1" {@if alarmTimeInterval !=0}checked{@/if} name="alarmTimeInterval_1">持续报警，每隔<input type="text" style="border: 1px solid #ccc;width: 4em;display: inline-block;height: 20px;margin-left:10px;" name="alarmTimeInterval" {@if alarmTimeInterval == 0}value="" disabled="desabled"{@else}value="\${alarmTimeInterval}" {@/if} data-field="alarmTimeInterval"/>分钟
        </label>
    </div>
    <div class="form-group">
        <div class="col-sm-3 control-label" >报警联系人</div>
    </div>
        {@if jobNotifyAlarmList}
            {@each jobNotifyAlarmList as jobAlarmItem, index}
                <div class="form-group alarmItemRow">
                    <input type="hidden" value="\${jobAlarmItem.id}" id="alarmId\${index}">
                    <div class="col-sm-3" style="margin-left:150px">
                      <input type="text" class="form-control" autocomplete="off" placeholder="选择报警联系人" value="\${jobAlarmItem.mis}" name="mis"/>
                       </div>
                     <div class="col-sm-4">
                      <label class="checkbox-alarm"><input name="daxiang" type="checkbox" {@if jobAlarmItem.daxiang == 1}checked{@/if}/>大象 </label>
                      <label class="checkbox-alarm"><input name="email" type="checkbox" {@if jobAlarmItem.email == 1}checked{@/if}/>邮件 </label>
                      <label class="checkbox-alarm"><input name="phone" type="checkbox" {@if jobAlarmItem.phone == 1}checked{@/if}/>短信 </label>
                    </div>
                    <div class="col-sm-2" style="margin-left:-20px">
                        <button type="button" class="btn btn-danger btn-xs J_removeAlarmItem iconBtn"><span class="glyphicon glyphicon-remove"></span></button>
                    </div>
                </div>
            {@/each}
        {@/if}
        <div class="form-group addfirst" style="margin-left:103px;{@if jobAlarmList}display:none;{@/if}">
             暂时还没有报警联系人，现在开始添加吧 <button type="button" class="btn btn-success btn-xs J_addAlarmItem iconBtn"><span class="glyphicon glyphicon-plus"></span></button>
        </div>
        <div class="form-group addmore" style="margin-left:103px;{@if !jobAlarmList}display:none;{@/if}">
            继续添加<button type="button" class="btn btn-success btn-xs J_addAlarmItem"><span class="glyphicon glyphicon-plus"></span></button>
        </div>


        <%--
        --%>
    </form>
    <input name="taskItemDetail" type="hidden" value='\${_|JSON.stringify}' />




</script>

<script type="text/juicer" id="J_taskItemTpl">
    {@if scheduleStatus == 1}
        <tr class="green" data-json='\${_|JSON.stringify}' data-id="\${id}">
    {@else}
        <tr class="red" data-json='\${_|JSON.stringify}' data-id="\${id}">
    {@/if}

    <td>\${jobGroup}</td>
    <td>\${jobCode}</td>
    <td>\${jobName}</td>
    <td>\${expression}</td>
    <td>\${jobOwner}</td>
    <td>\${modifyTime}</td>
    <td>
        <button type="button"
                class="btn btn-default btn-xs btn-primary J_taskItemToggle">

        {@if scheduleStatus == 1}
            <span data-action="stop">停止</span>
        {@else}
            <span data-action="start">启动</span>
        {@/if}

        </button>
        <button type="button"
                class="btn btn-default btn-xs J_taskItemDetail"
                data-toggle="modal"
                data-target="#myModal">详情
        </button>
        <button type="button"
                class="btn btn-default btn-xs J_taskItemOnce">
            手动执行一次
        </button>
        <button type="button"
                class="btn btn-default btn-xs J_taskItemTrace">
            跟踪
        </button>
        {@if scheduleStatus != 1}
            <button type="button"
                    class="btn btn-default btn-xs J_removeItemDetail">删除
            </button>
        {@/if}
    </td>
    </tr>




</script>
<script type="text/juicer" id="J_alarmItemTpl">
     <div class="form-group alarmItemRow">
         <div class="col-sm-3" style="margin-left:150px">
            <input type="text" class="form-control" autocomplete="off" placeholder="选择报警联系人" value="" name="mis"/>
         </div>
         <div class="col-sm-4">
          <label class="checkbox-alarm"><input name="daxiang" type="checkbox" value="1"  id="alarmType\${num}"/>大象 </label>
          <label class="checkbox-alarm"><input name="email" type="checkbox" value="2"  id="alarmType\${num}"/>邮件 </label>
          <label class="checkbox-alarm"><input name="phone" type="checkbox" value="3"  id="alarmType\${num}"/>短信 </label>
        </div>
        <div class="col-sm-2" style="margin-left:-20px">
            <%--<button type="button" class="btn btn-success btn-xs J_addAlarmItem iconBtn"><span class="glyphicon glyphicon-plus"></span></button>--%>
            <button type="button" class="btn btn-danger btn-xs J_removeAlarmItem iconBtn"><span class="glyphicon glyphicon-remove"></span></button>
        </div>
    </div>


</script>
<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="<%=request.getContextPath() %>/static/bower_components/jquery/dist/jquery.min.js"></script>
<script src="<%=request.getContextPath() %>/static/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<%--<script src="<%=request.getContextPath() %>/static/assets/js/docs.min.js"></script>--%>
<script src="<%=request.getContextPath() %>/static/assets/js/juicer-min.js"></script>
<script src="<%=request.getContextPath() %>/static/bower_components/select2-3.5.3/select2.js"></script>
<script src="<%=request.getContextPath() %>/static/bower_components/select2-3.5.3/select2_locale_zh-CN.js"></script>
<script src="<%=request.getContextPath() %>/static/assets/js/dashboard.js"></script>
</body>
</html>
