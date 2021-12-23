<%@page contentType="text/html;charset=UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$.ajax({
			url:"showDetail.do",
			data:{"id":getQueryVariable("id")},
			type:"get",
			dataType:"json",
			success:function (data) {//{"clue":{},"remarkList":[{},{},{}],"activityList":[{},{}]}
				doDetail(data.clue);
				doRemark(data.remarkList);
				doActivity(data.activityList);
			}
		})
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
		
		$("#remarkList").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		});
		$("#remarkList").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		});


		$("#edit-btn").click(function () {
			$("#edit-btn").blur();
			$(".edit-time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});
			$.ajax({
				url:"getClue.do",
				data:{"id":getQueryVariable("id")},
				type:"get",
				dataType:"json",
				success:function (data) {
					//{"userList":[{},{},{}],"activity":{}}
					let html = "";
					$.each(data.userList,function (i,n) {
						html+="<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#edit-clueOwner").html(html);
					$("#edit-clueOwner").val(data.clue.owner);
					$("#edit-company").val(data.clue.company);
					$("#edit-call").val(data.clue.appellation);
					$("#edit-surname").val(data.clue.fullname)
					$("#edit-job").val(data.clue.job);
					$("#edit-email").val(data.clue.email);
					$("#edit-phone").val(data.clue.phone);
					$("#edit-mphone").val(data.clue.mphone);
					$("#edit-website").val(data.clue.website);
					$("#edit-status").val(data.clue.state);
					$("#edit-source").val(data.clue.source);
					$("#edit-describe").val(data.clue.description);
					$("#edit-contactSummary").val(data.clue.contactSummary);
					$("#edit-nextContactTime").val(data.clue.nextContactTime);
					$("#edit-address").val(data.clue.address);
                    $("#editClueModal").modal("show");
				}
			})
		});
		$("#update-btn").click(function () {
			$.ajax({
				url:"updateClue.do",
				data:{
					"id":getQueryVariable("id"),
					"fullname":$("#edit-surname").val().trim(),
					"appellation":$("#edit-call").val(),
					"owner":$("#edit-clueOwner").val(),
					"company":$("#edit-company").val().trim(),
					"job":$("#edit-job").val().trim(),
					"email":$("#edit-email").val().trim(),
					"phone":$("#edit-phone").val().trim(),
					"website":$("#edit-website").val().trim(),
					"mphone":$("#edit-mphone").val().trim(),
					"state":$("#edit-status").val(),
					"source":$("#edit-source").val(),
					"description":$("#edit-describe").val().trim(),
					"contactSummary":$("#edit-contactSummary").val().trim(),
					"nextContactTime":$("#edit-nextContactTime").val(),
					"address":$("#edit-address").val().trim(),
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						$("#title").html($("#edit-surname").val().trim()+$("#edit-call").val()+" <small>"+$("#edit-company").val().trim()+"</small>");
						$("#name").html($("#edit-surname").val().trim()+$("#edit-call").val());
						$("#owner").html($("#edit-clueOwner option:selected").text());//同$("#edit-clueOwner").find('option:selected').text()
						$("#company").html($("#edit-company").val().trim());
						$("#job").html($("#edit-job").val().trim());
						$("#email").html($("#edit-email").val().trim());
						$("#phone").html($("#edit-phone").val().trim());
						$("#website").html($("#edit-website").val().trim());
						$("#mphone").html($("#edit-mphone").val().trim());
						$("#state").html($("#edit-status").val());
						$("#source").html($("#edit-source").val());
						$("#editBy").html("${user.name}");
						$("#editTime").html(getSysTime());
						$("#description").html($("#edit-describe").val().trim());
						$("#contactSummary").html($("#edit-contactSummary").val().trim());
						$("#nextContactTime").html($("#edit-nextContactTime").val());
						$("#address").html($("#edit-address").val().trim());
						$(".remark-title").text($("#name").text()+'-'+$("#company").text());
						$("#editClueModal").modal("hide");
					}else {
						alert("修改线索失败");
					}
				}
			})
		});
		$("#remove-btn").click(function () {
			$("#remove-btn").blur();
			if (confirm("删除后无法恢复，您确认要删除选中的记录吗？")){
				$.ajax({
					url:"remove.do",
					data: {"id":getQueryVariable("id")},
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
		});
		$("#save-remark").click(function () {
			$("#save-remark").blur();
			saveRemark();
		});
		$("#remark").keydown(function (event) {
			if (event.keyCode === 13) {
				saveRemark();
			}
		});
		$("#search-name").keydown(function (event) {
			if (event.keyCode === 13) {
				relation();
				return false;
			}
		});
		$("#updateRemarkBtn").click(function () {
			let id = $("#remarkId").val();
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
		$("#relation-activity").click(function () {
			$("#search-name").val("");
            relation();
			$("#bundModal").modal("show");
        });
		$("#qx").click(function () {
			$(".dx").prop("checked",this.checked);
		});
		$("#activitys").on("click",".dx",function (){
			$("#qx").prop("checked",$(".dx").length===$(".dx:checked").length);
		});
		$("#relate").click(function () {
			$("#relate").blur();
			let dx = $(".dx:checked");
			if (dx.length!==0){
				let ids = "cid="+getQueryVariable("id");
				$(dx).each(function (i) {
					ids+="&aid="+$(dx[i]).val();
				})
				$.ajax({
					url:"relate.do",
					data:ids,
					type:"post",
					dataType:"json",
					success:function (data) {
						if (data.success){
							$.ajax({
								url:"showAct.do",
								data:{"id":getQueryVariable("id")},
								type:"get",
								dataType:"json",
								success:function (activityList) {
									doActivity(activityList);
								}
							})
							$("#bundModal").modal("hide");
						}else {
							alert("关联市场活动失败");
						}
					}
				})
			}else {
				alert("请勾选需要关联的市场活动");
			}
		});
	});
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
	function getQueryVariable(variable)
	{
		let query = window.location.search.substring(1);
		let vars = query.split("&");
		for (let i=0;i<vars.length;i++) {
			let pair = vars[i].split("=");
			if(pair[0] === variable){return pair[1];}
		}
		return false;
	}
	function doDetail(clue) {
		$("#title").html(clue.fullname+clue.appellation+" <small>"+clue.company+"</small>");
		$("#name").html(clue.fullname+clue.appellation);
		$("#owner").html(clue.owner);
		$("#company").html(clue.company);
		$("#job").html(clue.job);
		$("#email").html(clue.email);
		$("#phone").html(clue.phone);
		$("#website").html(clue.website);
		$("#mphone").html(clue.mphone);
		$("#state").html(clue.state);
		$("#source").html(clue.source);
		$("#createBy").html(clue.createBy);
		$("#createTime").html(clue.createTime);
		$("#editBy").html(clue.editBy);
		$("#editTime").html(clue.editTime);
		$("#description").html(clue.description);
		$("#contactSummary").html(clue.contactSummary);
		$("#nextContactTime").html(clue.nextContactTime);
		$("#address").html(clue.address);
	}
	function doRemark(remarkList) {
		let html='';
		$.each(remarkList,function (i,n) {
			html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">'
			html+='	<img title="'+n.createBy+'" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">'
			html+='		<div style="position: relative; top: -40px; left: 40px;" >'
			html+='			<h5>'+n.noteContent+'</h5>'
			html+='			<font color="gray">线索</font> <font color="gray">-</font> <b class="remark-title">'+$("#name").text()+'-'+$("#company").text()+'</b> <small style="color: gray;">'+(n.editFlag==="0"?n.createTime:n.editTime)+' 由'+(n.editFlag==="0"?n.createBy:n.editBy)+'</small>'
			html+='			<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
			html+='				<a class="myHref" href="javascript:void(0);" onclick="editRemark('+JSON.stringify(n).replaceAll('"',"'")+')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #ff0000;"></span></a>'
			html+='				&nbsp;&nbsp;&nbsp;&nbsp;'
			html+='				<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #ff0000;"></span></a>'
			html+='			</div>'
			html+='		</div>'
			html+='</div>'
		})
		$("#remarkList").html(html);
	}
	function doActivity(activityList) {
		let html='';
		$.each(activityList,function (i,n) {
			html+='<tr id="'+n.id+'">';
			html+='	<td>'+n.name+'</td>';
			html+='	<td>'+n.startDate+'</td>';
			html+='	<td>'+n.endDate+'</td>';
			html+='	<td>'+n.owner+'</td>';
			html+='	<td><a href="javascript:void(0);" onclick="removeRelation(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
			html+='</tr>';
		});
		$("#activityList").html(html);
	}
	function relation() {
		$.ajax({
			url:"getActList.do",
			data:{
				"id":getQueryVariable("id"),
				"name":$("#search-name").val().trim()
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				let html='';
				$.each(data,function (i,n) {
					html+='<tr>';
					html+='    <td><input class="dx" type="checkbox" value="'+n.id+'"/></td>';
					html+='    <td>'+n.name+'</td>';
					html+='    <td>'+n.startDate+'</td>';
					html+='    <td>'+n.endDate+'</td>';
					html+='    <td>'+n.owner+'</td>';
					html+='</tr>';
				});
				$("#activitys").html(html);
				$("#qx").prop("checked",false);
			}
		})
	}
	function saveRemark() {
		$.ajax({
			url:"saveRemark.do",
			data:{
				"noteContent":$("#remark").val().trim(),
				"clueId":getQueryVariable("id")
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
					html+='			<font color="gray">线索</font> <font color="gray">-</font> <b class="remark-title">'+$("#name").text()+'-'+$("#company").text()+'</b> <small style="color: gray;">'+(n.editFlag==="0"?n.createTime:n.editTime)+' 由'+(n.editFlag==="0"?n.createBy:n.editBy)+'</small>'
					html+='			<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
					html+='				<a class="myHref" href="javascript:void(0);" onclick="editRemark('+JSON.stringify(n).replaceAll('"',"'")+')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #ff0000;"></span></a>'
					html+='				&nbsp;&nbsp;&nbsp;&nbsp;'
					html+='				<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #ff0000;"></span></a>'
					html+='			</div>'
					html+='		</div>'
					html+='</div>'
					$("#remarkList").append(html);
					$("#remark").val("");
				}else {
					alert("保存失败");
				}
			}
		})
	}
	function editRemark(n) {
		$("#remarkId").val(n.id);
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
	function removeRelation(id) {
		if (confirm("您确认要解除与该市场活动的关联吗？")) {
			$.ajax({
				url: "removeRelation.do",
				data: {
					"activityId": id,
					"clueId":getQueryVariable("id")
				},
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
</script>

</head>
<body>
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
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="search-name" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="qx" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activitys">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="relate">关联</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
									<option></option>
									<c:forEach items="${appellation}" var="aplt">
										<option value="${aplt.value}">${aplt.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
									<option></option>
									<c:forEach items="${clueState}" var="cs">
										<option value="${cs.value}">${cs.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option></option>
									<c:forEach items="${source}" var="sc">
										<option value="${sc.value}">${sc.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control edit-time" id="edit-nextContactTime">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="1" id="edit-address"></textarea>
								</div>
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
			<h3 id="title"></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='convert.jsp?id='+getQueryVariable('id');"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" id="edit-btn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="remove-btn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="name"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="owner"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="company"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="job"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="email"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="phone"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="website"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="mphone"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="state"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="source"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createBy"></b><small id="createTime" style="font-size: 10px; color: gray;"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy"></b><small id="editTime" style="font-size: 10px; color: gray;"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">

				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="contactSummary">

				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="nextContactTime"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="address">

                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="remarkList">

		</div>
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
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityList">

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="relation-activity" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>