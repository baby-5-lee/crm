<%@page contentType="text/html;charset=UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="../../jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	let clueId = getQueryVariable("id");
	$(function(){
		$.ajax({
			url:"getClue.do",
			data:{"id":clueId},
			type:"get",
			dataType:"json",
			success:function (data) {
				let clue=data.clue;
				$.each(data.userList,function (i,n) {
					if (n.id===clue.owner){
						$("#clue-owner").text(n.name);
					}
				})
				$("#title-name").text(clue.fullname+clue.appellation+"-"+clue.company);
				$("#create-customer").text("新建客户："+clue.company);
				$("#create-contact").text("新建联系人："+clue.fullname+clue.appellation);
				$("#tradeName").val(clue.company+"-");

			}
		})
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$(".time").datetimepicker({
					minView: "month",
					language:  'zh-CN',
					format: 'yyyy-mm-dd',
					autoclose: true,
					todayBtn: true,
					pickerPosition: "bottom-left"
				});
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});
		$("#search-page").click(function () {
			showActs();
			$("#searchActivityModal").modal("show");
		});
		$("#search-name").keydown(function (event) {
			if (event.keyCode===13){
				showActs();
				return false;
			}
		});
		$("#submit-btn").click(function () {
			$("#activity").val($("#"+$(".dx:checked").val()).text());
			$("#activityId").val($(".dx:checked").val())
			$("#searchActivityModal").modal("hide");
		});
		$("#convert").click(function () {
			if($("#isCreateTransaction").prop("checked")){
				$("#clueId").val(clueId);
				$("#tranForm").submit();
			}else{
				window.location.href="convert.do?clueId="+clueId;
			}
		});
	});
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
	function showActs() {
		$.getJSON("getBoundAct.do", {"id": clueId,"name":$("#search-name").val().trim()},function (data) {
			let html = '';
			$.each(data,function (i,n) {
				html += '<tr>';
				html += '	<td><input class="dx" value="'+n.id+'" type="radio" name="activity"/></td>';
				html += '	<td id="'+n.id+'">'+n.name+'</td>';
				html += '	<td>'+n.startDate+'</td>';
				html += '	<td>'+n.endDate+'</td>';
				html += '	<td>'+n.owner+'</td>';
				html += '</tr>';
			});
			$("#sources").html(html);
		})
	}
</script>


</head>
<body>
<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
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
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="sources">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submit-btn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small id="title-name"></small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">

	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">

	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="tranForm" action="convert.do" method="post">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" name="money" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control time" name="expectedDate" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage" name="stage"  class="form-control">
		    	<option></option>
				<c:forEach items="${stage}" var="sta">
					<option value="${sta.value}">${sta.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="search-page" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
			<input type="hidden" name="activityId" id="activityId">
			<input type="hidden" name="clueId" id="clueId">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b id="clue-owner"></b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="convert" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" onclick="window.history.back();" value="取消">
	</div>
</body>
</html>