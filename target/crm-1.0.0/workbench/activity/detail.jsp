<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="../../jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript">

	$(function(){
	    remarkList();
        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}

		});
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		/*参数上绑定事件的动态元素不要加$()*/
        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        });
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        });
		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
        $("#edit-btn").click(function (){
            $("#edit-btn").blur();
            $(".edit-time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            $.ajax({
                url:"getUserList.do",
                type:"get",
                dataType:"json",
                success:function (data) {
                    //{"userList":[{},{},{}],"activity":{}}
                    let html = "";
                    $.each(data,function (i,n) {
                        html+="<option value='"+n.id+"'>"+n.name+"</option>";
                    })
                    $("#edit-marketActivityOwner").html(html);
                    $("#edit-marketActivityOwner").val("${activity.owner}");
                    $("#edit-marketActivityName").val("${activity.name}");
                    $("#edit-startTime").val("${activity.startDate}");
                    $("#edit-endTime").val("${activity.endDate}")
                    $("#edit-cost").val("${activity.cost}");
                    $("#edit-describe").val("${activity.description}");
                    $("#editActivityModal").modal("show");
                }
            })

        });
        $("#update-btn").click(function () {
            $.ajax({
                url:"update.do",
                data:{
                    "id":"${activity.id}",
                    "owner":$("#edit-marketActivityOwner").val(),
                    "name":$("#edit-marketActivityName").val().trim(),
                    "startDate":$("#edit-startTime").val(),
                    "endDate":$("#edit-endTime").val(),
                    "cost":$("#edit-cost").val().trim(),
                    "description":$("#edit-describe").val().trim()
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success){
                        $("#editActivityModal").modal("hide");
                        window.location.href="detail.do?id=${activity.id}";
                    }else {
                        alert("修改市场活动失败");
                    }
                }
            })
        });
        $("#delete-btn").click(function (){
            $("#delete-btn").blur();
            if (confirm("删除后无法恢复，您确认要删除该条记录吗？")){
                $.ajax({
                    url:"delete.do",
                    data:{"id":"${activity.id}"},
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.success){
                            window.location.href="index.jsp";
                        }else {
                            alert("删除失败");
                        }
                    }
                })
            }

        })
        $("#updateRemarkBtn").click(function () {
            let id = $("#hidden-id").val();
            let noteContent=$("#noteContent").val().trim();
            $.ajax({
                url:"editRemark.do",
                data:{
                    "id":id,
                    "noteContent":noteContent
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success){
                        let editTime = getSysTime();
                        $("#"+id).children("div").children("h5").text(noteContent);
                        $("#"+id).children("div").children("small").text(editTime+" 由"+"${user.name}");//2021-07-29 13:44:55
                        $("#editRemarkModal").modal("hide");
                    }else {
                        alert("修改失败");
                    }
                }
            })
        });
        $("#save-remark").click(function () {
            $("#save-remark").blur();
            saveRemark();
        });
        $(window).keydown(function (event) {
            if (event.keyCode===13 && $("#remark").is(":focus")){
                saveRemark();
            }
        })
	});
	function remarkList() {
        $.ajax({
            url:"getRemark.do",
            data:{
                "id":"${activity.id}"
            },
            type:"get",
            dataType:"json",//{"id":n.id}
            success:function (data) {
                let html='';
                $.each(data,function (i,n) {
                    html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">'
                    html+='	<img title="'+n.createBy+'" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">'
                    html+='		<div style="position: relative; top: -40px; left: 40px;" >'
                    html+='			<h5>'+n.noteContent+'</h5>'
                    html+='			<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+(n.editFlag==="0"?n.createTime:n.editTime)+' 由'+(n.editFlag==="0"?n.createBy:n.editBy)+'</small>'
                    html+='			<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                    html+='				<a class="myHref" href="javascript:void(0);" onclick="editRemark('+JSON.stringify(n).replaceAll('"',"'")+')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>'
                    html+='				&nbsp;&nbsp;&nbsp;&nbsp;'
                    html+='				<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>'
                    html+='			</div>'
                    html+='		</div>'
                    html+='</div>'
                })
                $("#remarkPage").after(html);
            }
        })
    }
    function editRemark(n) {
	    $("#hidden-id").val(n.id);
	    $("#noteContent").val(n.noteContent);
        $("#editRemarkModal").modal("show");
    }
    function removeRemark(id){
        if (confirm("删除之后不可恢复，您确认要删除吗？")) {
            $.ajax({
                url: "removeRemark.do",
                data: {"id": id},
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        $("#"+id).remove();
                    } else {
                        alert("删除失败");
                    }
                }
            })
        }
    }
    function saveRemark() {
        $.ajax({
            url:"saveRemark.do",
            data:{
                "noteContent":$("#remark").val().trim(),
                "activityId":"${activity.id}"
            },
            type:"post",
            dataType:"json",
            success:function (data) {
                if (data.success){
                    let html='';
                    let n=data.remark;
                    html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">'
                    html+='	<img title="'+n.createBy+'" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">'
                    html+='		<div style="position: relative; top: -40px; left: 40px;" >'
                    html+='			<h5>'+n.noteContent+'</h5>'
                    html+='			<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+n.createTime+' 由'+n.createBy+'</small>'
                    html+='			<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                    html+='				<a class="myHref" href="javascript:void(0);" onclick="editRemark('+JSON.stringify(n).replaceAll('"',"'")+')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>'
                    html+='				&nbsp;&nbsp;&nbsp;&nbsp;'
                    html+='				<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>'
                    html+='			</div>'
                    html+='		</div>'
                    html+='</div>'
                    $("#remarkDiv").before(html);
                    $("#remark").val("");
                }else {
                    alert("保存失败");
                }
            }
        })
    }
    function getSysTime() {
        //判断是否在前面加0
        function getNow(s) {
            return s < 10 ? '0' + s: s;
        }

        let myDate = new Date();

        let year=myDate.getFullYear();        //获取当前年
        let month=myDate.getMonth()+1;   //获取当前月
        let date=myDate.getDate();            //获取当前日


        let h=myDate.getHours();              //获取当前小时数(0-23)
        let m=myDate.getMinutes();          //获取当前分钟数(0-59)
        let s=myDate.getSeconds();

        return year + '-' + getNow(month) + "-" + getNow(date) + " " + getNow(h) + ':' + getNow(m) + ":" + getNow(s);
    }
</script>

</head>
<body>
    <input type="hidden" id="hidden-id"/>
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModal">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">

                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control edit-time" id="edit-startTime" value="2020-10-10">
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control edit-time" id="edit-endTime" value="2020-10-20">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="5,000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="update-btn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="edit-btn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="delete-btn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${actOwner.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
        <div class="page-header" id="remarkPage"><h4>备注</h4></div>

        <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
            <form role="form" style="position: relative;top: 10px; left: 10px;">
                <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
                <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                    <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                    <button type="button" class="btn btn-primary" id="save-remark">保存</button>
                </p>
            </form>
        </div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>