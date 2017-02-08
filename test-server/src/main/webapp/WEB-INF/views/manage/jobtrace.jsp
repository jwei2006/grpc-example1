<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
                <li><a href="http://wiki.sankuai.com/display/TRAVEL/MSchedule" target="_blank" >帮助</a></li>
            </ul>
        </div>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
<%--        <div class="col-sm-3 col-md-2 sidebar">
            <ul class="nav nav-sidebar">
                <li class="active"><a href="#">概览</a></li>
            </ul>
        </div>--%>
<%--        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">--%>
        <div class="col-sm-9 col-md-12  main">
            <h3 class="page-header">
                任务执行跟踪
            </h3>

            <div class="table-responsive">
                <table class="table table-striped tasks-list-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>traceId</th>
                        <th>任务码</th>
                        <th>任务名称</th>
                        <th>任务分组</th>
                        <th>开始时间</th>
                        <th>任务耗时</th>
                        <th>执行节点</th>
                        <th>执行状态</th>
                    </tr>
                    </thead>
                    <tbody>
                    <jsp:useBean id="date" class="java.util.Date" />
                    <c:if test="${jobTraceList.ret == true}">
                        <c:forEach items="${jobTraceList.data.jobTraceList}" var="job">
                            <tr data-json='' data-id="${job.id}">
                                <td>${job.id}</td>
                                <td>${job.traceId}</td>
                                <td>${job.jobCode}</td>
                                <td>${job.jobName}</td>
                                <td>${job.jobGroup}</td>
                                <td>
                                    <fmt:formatDate value="${job.createTime}" type="both" var="createTimeParsed" pattern="yyyy-MM-dd HH:mm:ss" />
                                    ${createTimeParsed}
                                </td>
                                <td>${job.jobDuration}</td>
                                <td>${job.runNode}</td>
                                <input type="hidden" value="${job.scheduleNode}">
                                <input type="hidden" value="${job.callbackNode}">
                                <td>
                                    <c:choose>
                                        <c:when test="${job.scheduleStatus == 0}">
                                            运行中
                                        </c:when>
                                        <c:when test="${job.scheduleStatus == 1}">
                                            成功
                                        </c:when>
                                        <c:when test="${job.scheduleStatus == 2}">
                                            失败
                                        </c:when>
                                        <c:when test="${job.scheduleStatus == 3}">
                                            调度失败
                                        </c:when>
                                        <c:when test="${job.scheduleStatus == 4}">
                                            非正常回调
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
                    <c:when test="${jobTraceList.data.pageNum - 1 == 0}">
                        <li class="disabled"><a href="#">&laquo;</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="<%=request.getContextPath() %>/manage/jobtrace?jobUniqCode=${param.jobUniqCode}&pageNum=${jobTraceList.data.pageNum-1}&pageSize=20">&laquo;</a></li>
                    </c:otherwise>
                </c:choose>
                <c:if test="${jobTraceList.ret == true}">
                    <c:forEach var="pageNum" begin="1"
                               end="${jobTraceList.data.pageCount}"
                               step="1">
                        <c:choose>
                            <c:when test="${jobTraceList.data.pageNum == pageNum}">
                                <li class="active">
                                    <a href="<%=request.getContextPath() %>/manage/jobtrace?jobUniqCode=${param.jobUniqCode}&pageNum=${pageNum}&pageSize=20">${pageNum}<span
                                            class="sr-only">(current)</span></a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${ (jobTraceList.data.pageNum < 4 && pageNum < 8) || (jobTraceList.data.pageNum > jobTraceList.data.pageCount - 3 && pageNum > jobTraceList.data.pageCount - 7)}">
                                        <li>
                                            <a href="<%=request.getContextPath() %>/manage/jobtrace?jobUniqCode=${param.jobUniqCode}&pageNum=${pageNum}&pageSize=20">${pageNum}</a>
                                        </li>
                                    </c:when>
                                    <c:when test="${jobTraceList.data.pageNum +4 > pageNum && jobTraceList.data.pageNum -4 < pageNum}">
                                        <li>
                                            <a href="<%=request.getContextPath() %>/manage/jobtrace?jobUniqCode=${param.jobUniqCode}&pageNum=${pageNum}&pageSize=20">${pageNum}</a>
                                        </li>
                                    </c:when>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:if>
                <c:choose>
                    <c:when test="${jobTraceList.data.pageNum+1 > jobTraceList.data.pageCount}">
                        <li class="disabled"><a href="#">&raquo;</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="<%=request.getContextPath() %>/manage/jobtrace?jobUniqCode=${param.jobUniqCode}&pageNum=${jobTraceList.data.pageNum+1}&pageSize=20">&raquo;</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>

        </div>
    </div>
</div>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="<%=request.getContextPath() %>/static/bower_components/jquery/dist/jquery.min.js"></script>
<script src="<%=request.getContextPath() %>/static/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<script src="<%=request.getContextPath() %>/static/assets/js/docs.min.js"></script>
<script src="<%=request.getContextPath() %>/static/assets/js/juicer-min.js"></script>
</body>
</html>
