<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="../../jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="../../jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="../../jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="../../jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){
		pageList(1,2);
		$(".search-time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		$("#create-btn").click(function (){
			$(".time").datetimepicker({
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
					let html = "";
					$.each(data,function (i,n) {
						html+="<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-marketActivityOwner").html(html);
					$("#create-marketActivityOwner").val("${user.id}");
					$("#createActivityModal").modal("show");
				}
			})

		})
		/*pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
				,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));*/
		$("#save-btn").click(function () {
			$.ajax({
				url:"save.do",
				data:{
					"owner":$("#create-marketActivityOwner").val(),
					"name":$("#create-marketActivityName").val().trim(),
					"startDate":$("#create-startTime").val(),
					"endDate":$("#create-endTime").val(),
					"cost":$("#create-cost").val().trim(),
					"description":$("#create-describe").val().trim()
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.success){
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#createActivityModal").modal("hide");
						//$(".form-control").val("");
						$("#save-form")[0].reset();
					}else {
						alert("创建市场活动失败");
					}
				}
			})
		})
		$("#close-btn").click(function () {
			$("#createActivityModal").modal("hide");
			$("#save-form")[0].reset();

			//$(".form-control").val("");

		})
		$("#search-btn").click(function () {
			$("#hidden-name").val($("#search-name").val().trim());
			$("#hidden-owner").val($("#search-owner").val().trim());
			$("#hidden-startDate").val($("#search-startDate").val().trim());
			$("#hidden-endDate").val($("#search-endDate").val().trim());
			pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
			$("#search-btn").blur();
		})
		$("#qx").click(function () {
			$(".dx").prop("checked",this.checked);
		})
		$("#search-page").on("click",".dx",function (){
			$("#qx").prop("checked",$(".dx").length===$(".dx:checked").length);
		})
		$("#delete-btn").click(function (){
			$("#delete-btn").blur();
			let dx = $(".dx:checked");
			if (dx.length!==0){
				if (!confirm("删除后无法恢复，您确认要删除选中的记录吗？")){
					return;
				}
				let ids = "";
				$(dx).each(function (i) {
					ids+="id="+$(dx[i]).val();
					if (i!==(dx.length-1)){
						ids+="&";
					}
				})
				$.ajax({
					url:"delete.do",
					data:ids,
					type:"post",
					dataType:"json",
					success:function (data) {
						if (data.success){
							pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						}else {
							alert("删除失败");
						}
					}
				})
			}else {
				alert("请勾选需要删除的内容");
			}
		})
		$("#edit-btn").click(function (){
			$("#edit-btn").blur();
			let dx=$(".dx:checked");
			if (dx.length===0){
				alert("请勾选要修改的记录");
				return;
			}else if (dx.length>1){
				alert("一次只能修改一条记录");
				return;
			}
			$(".edit-time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			$.ajax({
				url:"getActivity.do",
				data:{"id":dx.val()},
				type:"get",
				dataType:"json",
				success:function (data) {
					//{"userList":[{},{},{}],"activity":{}}
					let html = "";
					$.each(data.userList,function (i,n) {
						html+="<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#edit-marketActivityOwner").html(html);
					$("#edit-marketActivityOwner").val(data.activity.owner);
					$("#edit-marketActivityName").val(data.activity.name);
					$("#edit-startTime").val(data.activity.startDate);
					$("#edit-endTime").val(data.activity.endDate)
					$("#edit-cost").val(data.activity.cost);
					$("#edit-describe").val(data.activity.description);
					$("#editActivityModal").modal("show");
				}
			})

		})
		$("#update-btn").click(function () {
			$.ajax({
				url:"update.do",
				data:{
					"id":$(".dx:checked").val(),
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
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage'),$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editActivityModal").modal("hide");
					}else {
						alert("修改市场活动失败");
					}
				}
			})
		})
	});

	function pageList(pageNo,pageSize) {
		$("#search-name").val($("#hidden-name").val());
		$("#search-owner").val($("#hidden-owner").val());
		$("#search-startDate").val($("#hidden-startDate").val());
		$("#search-endDate").val($("#hidden-endDate").val());
		$.ajax({
			url:"pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$("#search-name").val(),
				"owner":$("#search-owner").val(),
				"startDate":$("#search-startDate").val(),
				"endDate":$("#search-endDate").val()
			},
			dataType:"json",
			type:"get",
			success:function (data) {
				$("#qx").prop("checked",false);
				let html = "";
				let dataList = data.dataList;
				$.each(dataList,function (i,n) {
					html+='<tr class="active"><td><input type="checkbox" class="dx" value="'+n.id+'"/></td><td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='+"'detail.do?id="+n.id+"'"+';">'+n.name+'</a></td><td>'+n.owner+'</td><td>'+n.startDate+'</td><td>'+n.endDate+'</td></tr>';
				})
				$("#search-page").html(html);
				let totalPage = parseInt((data.total-1)/pageSize)+1;

				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPage, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}
		})
	}
</script>
</head>
<body>
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="save-form" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime"/>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime"/>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="close-btn">关闭</button>
					<button type="button" class="btn btn-primary" id="save-btn">保存</button>
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
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
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
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control edit-time" id="edit-startTime">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control edit-time" id="edit-endTime">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
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
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="search-name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="search-owner" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control  search-time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control  search-time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button class="btn btn-default" type="button" id="search-btn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="create-btn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="edit-btn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="delete-btn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="search-page">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>