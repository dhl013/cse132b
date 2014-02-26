<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css" href="../css/student.css">
<script type="text/javascript" src="../javascript/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../javascript/underscore-min.js"></script>
<title>Insert title here</title>
</head>
<body>
	<div id="banner">
		<div id="banner-content">
			<a href="report_main.jsp" id="banner-link">Reports</a>			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>
			<thead>
				<tr>
					<td>Enter the student's PID: </td>
						<input type="hidden" value="search" name="action">
						<th><input value="" id="PID" size="10"></th>
						<th><button type="button" id="search" >Search</th>
					</form>
				</tr>			
			</thead>
			<tbody>
				<tr>
					<th>PID</th>
					<th>First</th>
					<th>Middle</th>
					<th>Last</th>
					<th>Course</th>
					<th>Class Title</th>
					<th>Quarter</th>
					<th>Grade</th>
					<th>Units</th>
				</tr>
			</tbody>
			<tfoot id="results">
			</tfoot>
		</table>
	</div>
			
</body>
<script type="text/javascript">
	$(document).ready(function(){
		$('#search').on('click',function(){
			//Maps for gpa calculations
			var gradeUnitMap = {
					'A'  : 4.00,
					'A-' : 3.00,
					'B+' : 3.33,
					'B'  : 3.00,
					'B-' : 2.70,
					'C+' : 2.30,
					'C'  : 2.00,
					'C-' : 1.70,
					'D+' : 1.30,
					'D'  : 1.00,
					'D-' : .70,
					'F'  : .00,
			};
			
			var gpaMap = {};
			
			var pid = $('#PID').val();
			
			var buildTableRow = function( r ){
				var html = '<tr>' +
						   '<td>' + r['PID'] + '</td>' +
						   '<td>' + r['first_name'] + '</td>' +
						   '<td>' + r['middle_name'] + '</td>' +
						   '<td>' + r['last_name'] + '</td>' +
						   '<td>' + r['course_number'] + '</td>' +
						   '<td>' + r['class_title'] + '</td>' +
						   '<td>' + r['q_id'] + '</td>' +
						   '<td>' + r['grade'] + '</td>' +
						   '<td>' + r['units'] + '</td>' +
						   '</tr>'
				$(html).appendTo('#results');

			};
			
			
			var buildGpaRow = function( q ) {
				var html = '<tr> <td id="gpaRow">TOTAL GPA for ' + q + ' : ' + gpaMap[q].points/gpaMap[q].hours + '</td></tr>';
				console.log(q, gpaMap[q]);
				$(html).appendTo('#results');
			};
			
			var buildCumulativeGpa = function( ){
				var pts = 0, hr = 0;
				_.each(gpaMap, function( q ){
					pts += q.points;
					hr += q.hours;
				});
				var html = '<tr><td id="gpaRow">TOTAL CUMULATIVE GPA :' + pts/hr +'</td></tr>';
				$(html).appendTo('#results');		
				
			}
			
			$.ajax('Grade_Report?PID=' + pid)
			 .success(function(data){
				 //Initalize
				 var prev_q = data['0']['q_id'];
				 gpaMap[prev_q] = {};
				 gpaMap[prev_q].points = 0;
				 gpaMap[prev_q].hours = 0;

				_.each(data, function(r){
					if( ! _.isUndefined( prev_q ) ){
						if(prev_q === r['q_id']){
							buildTableRow(r);
							gpaMap[prev_q].points += (r['units'] * gradeUnitMap[r['grade']]);
							gpaMap[prev_q].hours += r['units'];
						}
						else{
							buildGpaRow(prev_q);
							
							//reset
							prev_q = r['q_id'];
							gpaMap[prev_q] = {};
							gpaMap[prev_q].points = 0;
							gpaMap[prev_q].hours = 0;
							
							buildTableRow(r);
						}
					}
				});
				//Finish
				buildGpaRow(prev_q);
				buildCumulativeGpa();
				
			 });
		});
	});
</script>
</html>