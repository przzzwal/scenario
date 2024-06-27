<!DOCTYPE html>
<html>

<head>
	<title>TSS</title>
	<link rel="stylesheet" type="text/css" href="Testcases.css">
	<style type="text/css">
		.column {
			float: left;
			width: 25%;
		}
		
		.row:after {
			content: "";
			display: table;
			clear: both;
		}
		
		.popup {
			display: none;
			position: fixed;
			z-index: 9;
			left: 50%;
			top: 50%;
			transform: translate(-50%, -50%);
			background-color: #f9f9f9;
			padding: 20px;
			border: 1px solid #ccc;
			box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
			transform: translate(-50%, -50%);
		}
		
		#myPopup2 {
			display: none;
			position: fixed;
			z-index: 9;
			left: 50%;
			top: 50%;
			transform: translate(-50%, -50%);
			background-color: #f9f9f9;
			padding: 20px;
			border: 1px solid #ccc;
			box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
			transform: translate(-50%, -50%);
		}
		
		#flex-div {
			display: flex;
		}
		
		#left-div {
			flex: 1;
		}
		
		#right-div {
			flex: 1;
		}
	</style>
	<script type="text/javascript">
	
		var current_col = 0;
		
		function Find_col_index(t) {
			current_col = t.cellIndex;
		}
		
		function callAjaxDataformat() {
			col = current_col;
			document.getElementById('Dropdown_list' + (col)).innerHTML = "";//to clear existing dropdown option
			if (document.getElementsByName("field_name")[col].value.includes("Validation")) {
				document.getElementById("myPopup2").style.display = "block";
			} 
			else if (document.getElementsByName("field_name")[col].value.includes("Extraction")) {
				document.getElementById("myPopup1").style.display = "block";
			}
			else {
				httpRequest = new XMLHttpRequest();
				if (!httpRequest) {
					console.log('Unable to create XMLHTTP instance');
					return false;
				}
				httpRequest.open('GET', 'Updatedataformat?criteria=' + document.getElementsByName("field_name")[col].value, true);
				httpRequest.responseType = 'json';
				httpRequest.send();
				httpRequest.onreadystatechange = function() {
					if (httpRequest.readyState === XMLHttpRequest.DONE) {
						var option_array = '';
						if (httpRequest.status === 200) {
							var array = httpRequest.response;
							if (array[0].Dropdown_value === "popup") {
								document.getElementById("myPopup").style.display = "block";
							} 
							else if (array[0].Dropdown_value === "formula" || array[0].Dropdown_value === "") {
								document.getElementById("myPopup1").style.display = "block";
							}
							else if (array[0].Dropdown_value != "") {
								for (var i = 0; i < array.length; i++) {
									var Dropdown_option = array[i].Dropdown_value;
									option_array = option_array + '<option value="' + Dropdown_option + '" />';
								}
								document.getElementById('Dropdown_list' + (col)).innerHTML = option_array;
							} 
							else {
								console.log("No popup required");
							}
						} else {
							console.log('XMLHTTP not ready');
						}
					}
				}
			}
		}
		
		function showTestData() {
			// LHS Formula
			var LHSDataTable = document.getElementById("lhstestDataTable");
			var lhs_hashMap = new Map();
			
			for (var i = 2; i < LHSDataTable.rows.length; i++) {
				var lhs_variable = document.getElementById("lhsvariable_" + i).innerText;
				var lhs_inputfield1 = document.getElementById("lhs_inputfield1_" + i).value;
				var lhs_operarfield = document.getElementById("lhs_operatorfield_" + i).value;
				var lhs_inputfield2 = document.getElementById("lhs_inputfield2_" + i).value;

				var variable_Name = "(" + lhs_variable + ")";
				var variable_Value = "";
				
				if (isNaN(lhs_inputfield1) && /^[A-Z]$/.test(lhs_inputfield1)) {
					variable_Value = "(" + lhs_inputfield1 + ")";
				} else if (isNaN(lhs_inputfield1) && !/^[A-Z]$/.test(lhs_inputfield1)) {
					variable_Value = "[" + lhs_inputfield1 + "]";
				} else {
					variable_Value = lhs_inputfield1;
				}
				
				variable_Value = variable_Value + lhs_operarfield;
				
				if (isNaN(lhs_inputfield2) && /^[A-Z]$/.test(lhs_inputfield2)) {
					variable_Value = variable_Value + "(" + lhs_inputfield2 + ")";
				} else if (isNaN(lhs_inputfield2) && !/^[A-Z]$/.test(lhs_inputfield2)) {
					variable_Value = variable_Value + "[" + lhs_inputfield2 + "]";
				} else {
					variable_Value = variable_Value + lhs_inputfield2;
				}
				
				lhs_hashMap.set(variable_Name, variable_Value);
			}
			
			var LHSLastVariable = "(" + document.getElementById("lhsvariable_" + (LHSDataTable.rows.length - 1)).innerText + ")";
			var rawLHSFormula = lhs_hashMap.get(LHSLastVariable);
			
			for (var i = 2; i < rawLHSFormula.length; i++) {
				var curr_char = rawLHSFormula[i-2] + rawLHSFormula[i-1] + rawLHSFormula[i];
				if (lhs_hashMap.has(curr_char)) {
					rawLHSFormula = rawLHSFormula.replace(curr_char, "(" + lhs_hashMap.get(curr_char) + ")");
			    }
			}
			
			// RHS Formula
			var RHSDataTable = document.getElementById("rhstestDataTable");
			var rhs_hashMap = new Map();
			
			for (var i = 2; i < RHSDataTable.rows.length; i++) {
				var rhs_variable = document.getElementById("rhsvariable_" + i).innerText;
				var rhs_inputfield1 = document.getElementById("rhs_inputfield1_" + i).value;
				var rhs_operarfield = document.getElementById("rhs_operatorfield_" + i).value;
				var rhs_inputfield2 = document.getElementById("rhs_inputfield2_" + i).value;

				var variable_Name = "(" + rhs_variable + ")";
				var variable_Value = "";
				
				if (isNaN(rhs_inputfield1) && /^[A-Z]$/.test(rhs_inputfield1)) {
					variable_Value = "(" + rhs_inputfield1 + ")";
				} else if (isNaN(rhs_inputfield1) && !/^[A-Z]$/.test(rhs_inputfield1)) {
					variable_Value = "[" + rhs_inputfield1 + "]";
				} else {
					variable_Value = rhs_inputfield1;
				}
				
				variable_Value = variable_Value + rhs_operarfield;
				
				if (isNaN(rhs_inputfield2) && /^[A-Z]$/.test(rhs_inputfield2)) {
					variable_Value = variable_Value + "(" + rhs_inputfield2 + ")";
				} else if (isNaN(rhs_inputfield2) && !/^[A-Z]$/.test(rhs_inputfield2)) {
					variable_Value = variable_Value + "[" + rhs_inputfield2 + "]";
				} else {
					variable_Value = variable_Value + rhs_inputfield2;
				}
				
				rhs_hashMap.set(variable_Name, variable_Value);
			}
			
			var RHSLastVariable = "(" + document.getElementById("rhsvariable_" + (RHSDataTable.rows.length - 1)).innerText + ")";
			var rawRHSFormula = rhs_hashMap.get(RHSLastVariable);
			for (var i = 2; i < rawRHSFormula.length; i++) {
				var curr_char = rawRHSFormula[i-2] + rawRHSFormula[i-1] + rawRHSFormula[i];
				if (rhs_hashMap.has(curr_char)) {
					rawRHSFormula = rawRHSFormula.replace(curr_char, "(" + rhs_hashMap.get(curr_char) + ")");
				}
			}
			
			// Final formula
			var finalFormula = rawLHSFormula + "=" + rawRHSFormula;
			document.getElementById("rawTestData").value = finalFormula
		}
		
		function rhsaddTestDataTableRow() {
			var TDTable = document.getElementById("rhstestDataTable");
			var TDTableRowCount = TDTable.rows.length;

			var newTDRow = TDTable.insertRow(TDTableRowCount);
			
			var newTDCell1 = newTDRow.insertCell(0);
			var variableId = "rhsvariable_" + TDTableRowCount;
			newTDCell1.id = variableId;
			newTDCell1.textContent = String.fromCharCode(TDTableRowCount + 63);
			
			var newTDCell2 = newTDRow.insertCell(1);
			var rhshield1Id = "rhs_field1_" + TDTableRowCount;
			newTDCell2.id = rhshield1Id;
			var inputEle1 = document.createElement("input");
			var inputEle1Id = "rhs_inputfield1_" + TDTableRowCount;
			inputEle1.id = inputEle1Id;
			inputEle1.type = "text";
			var rhs_datalist1_id = "rhs_inputfield1_list_" + TDTableRowCount;
			inputEle1.setAttribute("list", rhs_datalist1_id);
			var rhs_datalist1 = document.createElement("datalist");
			rhs_datalist1.id = rhs_datalist1_id;
			inputEle1.appendChild(rhs_datalist1);
			newTDCell2.ondblclick = function () {
				retrieveheader(rhs_datalist1_id);
			};
			newTDCell2.appendChild(inputEle1);
			
			var newTDCell3 = newTDRow.insertCell(2);
			var rhsoperatorId = "rhs_operator_" + TDTableRowCount;
			newTDCell3.id = rhsoperatorId;
			var inputEle2 = document.createElement("input");
			var inputEle2Id = "rhs_operatorfield_" + TDTableRowCount;
			inputEle2.id = inputEle2Id;
			inputEle2.type = "list";
			newTDCell3.appendChild(inputEle2);
			
			var newTDCell4 = newTDRow.insertCell(3);
			var rhsfield2Id = "rhs_field2_" + TDTableRowCount;
			newTDCell4.id = rhsfield2Id;
			var inputEle3 = document.createElement("input");
			var inputEle3Id = "rhs_inputfield2_" + TDTableRowCount;
			inputEle3.id = inputEle3Id;
			inputEle3.type = "text";
			var rhs_datalist2_id = "rhs_inputfield2_list_" + TDTableRowCount;
			inputEle3.setAttribute("list", rhs_datalist2_id);
			var rhs_datalist2 = document.createElement("datalist");
			rhs_datalist2.id = rhs_datalist2_id;
			inputEle3.appendChild(rhs_datalist2);
			newTDCell4.ondblclick = function () {
				retrieveheader(rhs_datalist2_id);
			};
			newTDCell4.appendChild(inputEle3);
		}
		
		function lhsaddTestDataTableRow() {
			var TDTable = document.getElementById("lhstestDataTable");
			var TDTableRowCount = TDTable.rows.length;

			var newTDRow = TDTable.insertRow(TDTableRowCount);
			
			var newTDCell1 = newTDRow.insertCell(0);
			var variableId = "lhsvariable_" + TDTableRowCount;
			newTDCell1.id = variableId;
			newTDCell1.textContent = String.fromCharCode(TDTableRowCount + 63);
			
			var newTDCell2 = newTDRow.insertCell(1);
			var lhshield1Id = "lhs_field1_" + TDTableRowCount;
			newTDCell2.id = lhshield1Id;
			var inputEle1 = document.createElement("input");
			var inputEle1Id = "lhs_inputfield1_" + TDTableRowCount;
			inputEle1.id = inputEle1Id;
			inputEle1.type = "text";
			var lhs_datalist1_id = "lhs_inputfield1_list_" + TDTableRowCount;
			inputEle1.setAttribute("list", lhs_datalist1_id);
			var lhs_datalist1 = document.createElement("datalist");
			lhs_datalist1.id = lhs_datalist1_id;
			inputEle1.appendChild(lhs_datalist1);
			newTDCell2.ondblclick = function () {
				retrieveheader(lhs_datalist1_id);
			};
			newTDCell2.appendChild(inputEle1);
			
			var newTDCell3 = newTDRow.insertCell(2);
			var lhsoperatorId = "lhs_operator_" + TDTableRowCount;
			newTDCell3.id = lhsoperatorId;
			var inputEle2 = document.createElement("input");
			var inputEle2Id = "lhs_operatorfield_" + TDTableRowCount;
			inputEle2.id = inputEle2Id;
			inputEle2.type = "list";
			newTDCell3.appendChild(inputEle2);
			
			var newTDCell4 = newTDRow.insertCell(3);
			var lhsfield2Id = "lhs_field2_" + TDTableRowCount;
			newTDCell4.id = lhsfield2Id;
			var inputEle3 = document.createElement("input");
			var inputEle3Id = "lhs_inputfield2_" + TDTableRowCount;
			inputEle3.id = inputEle3Id;
			inputEle3.type = "text";
			var lhs_datalist2_id = "lhs_inputfield2_list_" + TDTableRowCount;
			inputEle3.setAttribute("list", lhs_datalist2_id);
			var lhs_datalist2 = document.createElement("datalist");
			lhs_datalist2.id = lhs_datalist2_id;
			inputEle3.appendChild(lhs_datalist2);
			newTDCell4.ondblclick = function () {
				retrieveheader(lhs_datalist2_id);
			};
			newTDCell4.appendChild(inputEle3);
		}
		
		function retrieveheader(inputEleId) {
			var table = document.getElementById("myDataTable");
			var colCount = table.rows[0].cells.length;
			var option_array = "";

			for (var i = 5; i < colCount; i++) {
				var headerValue = table.rows[0].cells[i].innerHTML;
				option_array = option_array + '<option value="' + headerValue + '" />';
			}
			document.getElementById(inputEleId).innerHTML = option_array;
		}
		
		function dataValueOnChange() {
			var dataListElement = document.getElementById("search_data_list");
			var selectedOption = dataListElement.options[0];
			var inputElement = document.getElementById("test_data");
			inputElement.value = "{" + selectedOption.value + "}";
		}
		
		function searchMapping(inputEleId) {
			var search_Value = document.getElementById(inputEleId).value;
			httpRequest = new XMLHttpRequest();
			if (!httpRequest) {
				console.log('Unable to create XMLHTTP instance');
				return false;
			}
			httpRequest.open('GET', 'Createdropdown?criteria=' + search_Value, true);
			httpRequest.responseType = 'json';
			httpRequest.send();
			httpRequest.onreadystatechange = function() {
				if (httpRequest.readyState === XMLHttpRequest.DONE) {
					var option_array = '';
					if (httpRequest.status === 200) {
						var array = httpRequest.response;
						for (var i = 0; i < array.length; i++) {
							var curr_value = array[i].Field_name;
							if (curr_value.toUpperCase().includes(search_Value.toUpperCase())) {
								option_array = option_array
								+ '<option value="' + curr_value + '" />';
							}
						}
						document.getElementById(dataListId).innerHTML = option_array;
					} else {
						console.log('XMLHTTP not ready');
					}
				}
			}
		}
		
		function addNewRow() {
	        var newRow = document.createElement("tr");
	        newRow.innerHTML = `
				<td><input type="text" class="valueInput" placeholder="Fund Number"></td>
				<td><input type="text" class="valueInput" placeholder="Allocation"></td>
				<td><input type="text" class="valueInput" placeholder="Maturity Instruction"></td>
				<td><button class="removeRow">Remove</button></td>
	        `;
	        document.getElementById("valueTable").querySelector("tbody").appendChild(newRow);
	   	}
		
		function deleteRow_fund_popup() {    	
	        if (event.target.classList.contains("removeRow")) {
	            event.target.closest("tr").remove();
	        }
	    }
	    
	   	function closePopUp() {
	    	col = current_col;
	        var allInputs = document.querySelectorAll(".valueInput");
	        var enteredValues = Array.from(allInputs).map(input => input.value);
	        var formattedValues = enteredValues.slice(0, 3).join(";") + " @ " + enteredValues.slice(3).join(";");
	        document.getElementById("myPopup").style.display = "none";
	        document.getElementById('Dropdown_id' + col).removeAttribute('value');
	        document.getElementById('Dropdown_id' + col).setAttribute('value', formattedValues);
	        document.getElementById('Dropdown_id' + col).value = formattedValues;
	    }
	   	
	   	function closePopUp1() {
	    	col = current_col;
	    	var formattedValues = document.getElementById("test_data").value;
	        document.getElementById("myPopup1").style.display = "none";
	        document.getElementById('Dropdown_id' + col).setAttribute('value', formattedValues);
	        document.getElementById('Dropdown_id' + col).value = formattedValues;
	    }
	   	
	   	function closeTestDataPopUp() {
	   		col = current_col;
	    	var rawtestData = document.getElementById("rawTestData").value;
	        document.getElementById("myPopup2").style.display = "none";
	        document.getElementById('Dropdown_id' + col).setAttribute('value', rawtestData);
	        document.getElementById('Dropdown_id' + col).value = rawtestData;
	   	}
	   	
	   	function search_csa_fields() {
	   		var search_Value = document.getElementById("search_data").value;
			httpRequest = new XMLHttpRequest();
			if (!httpRequest) {
				console.log('Unable to create XMLHTTP instance');
				return false;
			}
			httpRequest.open('GET', 'Createdropdown?criteria=' + search_Value, true);
			httpRequest.responseType = 'json';
			httpRequest.send();
			httpRequest.onreadystatechange = function() {
				if (httpRequest.readyState === XMLHttpRequest.DONE) {
					if (httpRequest.status === 200) {
						var search_data_list = document.getElementById("search_data_list");
						search_data_list.innerHTML = "";
						var array = httpRequest.response;
						for (var i = 0; i < array.length; i++) {
							var curr_value = array[i].Field_name;
							if (curr_value.toUpperCase().includes(search_Value.toUpperCase())) {
								var opt = document.createElement("OPTION");
								opt.value = curr_value;
								search_data_list.appendChild(opt);
							}
						}
					} else {
						console.log('XMLHTTP not ready');
					}
				}
			}
	   	}
		
		function toggle() {
			divvid = "mysection";
			var element = document.getElementById(divvid);
			if (element.style.display.includes("none")) {
				element.style.display = "";
				document.getElementById("hsbtn").innerText = "Hide Section";
			} else {
				element.style.display = "none";
				document.getElementById("hsbtn").innerText = "Show Section";
			}
			;
		}
		
		function createMappingList() {
			httpRequest = new XMLHttpRequest();
			if (!httpRequest) {
				console.log('Unable to create XMLHTTP instance');
				return false;
			}
			httpRequest.open('GET', 'Createdropdown?criteria='
					+ document.getElementById("trxn").value, true);
			httpRequest.responseType = 'json';
			httpRequest.send();
			httpRequest.onreadystatechange = function() {
				if (httpRequest.readyState === XMLHttpRequest.DONE) {
					var option_array = '';
					if (httpRequest.status === 200) {
						var array = httpRequest.response;
						for (var i = 0; i < array.length; i++) {
							var field_name = array[i].Field_name;
							option_array = option_array
									+ '<option value="' + field_name + '" />';
						}
						option_array = option_array + '<option value="' + "DE_Extraction" + '" />' 
													+ '<option value="' + "DE_Validation" + '" />'
													+ '<option value="' + "PB_Extraction" + '" />'
													+ '<option value="' + "PB_Validation" + '" />';
						var trxn_field_list_array = document.getElementsByName("trx_field_list");
						for (var j = 0; j < trxn_field_list_array.length; j++) {
							var trxn_mapping_list = trxn_field_list_array[j];
							trxn_mapping_list.innerHTML = option_array;
						}
					} else {
						console.log('XMLHTTP not ready');
					}
				}
			}
		}

		function headerCreate() {
			document.getElementById("div2").innerHTML = "";
			var div2 = document.getElementById("div2");
			var h3 = document.createElement("H3");
			var txt = document.createTextNode("Data Table");
			h3.appendChild(txt);
			div2.appendChild(h3);
			var trxnlabel = document.createTextNode("Transaction Name:");
			div2.appendChild(trxnlabel);
			var trxninput = document.createElement("SELECT");
			trxninput.setAttribute("value", "");
			var default_opt = document.createElement("OPTION");
			default_opt.innerHTML = "";
			trxninput.options.add(default_opt);
			var opt1 = document.createElement("OPTION");
			opt1.innerHTML = "Allocations Change";
			trxninput.options.add(opt1);
			var opt2 = document.createElement("OPTION");	
			opt2.innerHTML = "Contract Details";
			trxninput.options.add(opt2);
			var opt3 = document.createElement("OPTION");
			opt3.innerHTML = "Death Claim Processing";
			trxninput.options.add(opt3);
			var opt4 = document.createElement("OPTION");
			opt4.innerHTML = "Dollar Cost Averaging Add";
			trxninput.options.add(opt4);
			var opt5 = document.createElement("OPTION");
			opt5.innerHTML = "Dollar Cost Averaging Change";
			trxninput.options.add(opt5);
			var opt6 = document.createElement("OPTION");
			opt6.innerHTML = "Full Surrender";
			trxninput.options.add(opt6);
			var opt7 = document.createElement("OPTION");
			opt7.innerHTML = "Fund Transfers";
			trxninput.options.add(opt7);
			var opt8 = document.createElement("OPTION");
			opt8.innerHTML = "Maturity Withdrawals Add";
			trxninput.options.add(opt8);
			var opt9 = document.createElement("OPTION");
			opt9.innerHTML = "Partial Surrender";
			opt9.value = "Partial Surrender";
			trxninput.options.add(opt9);
			var opt10 = document.createElement("OPTION");
			opt10.innerHTML = "Payout Change";
			trxninput.options.add(opt10);
			var opt11 = document.createElement("OPTION");
			opt11.innerHTML = "Role Add";
			trxninput.options.add(opt11);
			var opt12 = document.createElement("OPTION");
			opt12.innerHTML = "Systematic Withdrawals Add";
			trxninput.options.add(opt12);
			var opt13 = document.createElement("OPTION");
			opt13.innerHTML = "IE GK";
			trxninput.options.add(opt13);
			var opt14 = document.createElement("OPTION");
			opt14.innerHTML = "RIA Fee withdrawal Add";
			trxninput.options.add(opt14);
			trxninput.type = "text";
			trxninput.required = true;
			trxninput.setAttribute("id", "trxn");
			trxninput.setAttribute("name", "trxn_name");
			trxninput.setAttribute("list", "trxn_list");
			div2.appendChild(trxninput);
			var refresh_btn = document.createElement("input");
			refresh_btn.type = "button";
			refresh_btn.setAttribute("value", "Refresh Table");
			refresh_btn.setAttribute("id", "refresh_btn");
			refresh_btn.onclick = function() {
				createMappingList();
			};
			div2.appendChild(refresh_btn);
			var break_ele1 = document.createElement("BR");
			div2.insertBefore(break_ele1, document.getElementById("refresh_btn"));
			var break_ele2 = document.createElement("BR");
			div2.insertBefore(break_ele2, document.getElementById("refresh_btn"));
		}

		function createDataTable() {
			headerCreate();
			var myarray = [];
			var tempColumnName = "";
			var startFlag = 0;
			var x = document.getElementById("BDDteststeps").value;
			for (var i = 0; i < x.length; i++) {
				var myChar = x[i];
				if (myChar.match('<')) {
					startFlag = 1;
					tempColumnName = "";
				} else if (myChar.match('>')) {
					startFlag = 0;
					myarray.push(tempColumnName);
				} else {
					if (startFlag = 1) {
						tempColumnName = tempColumnName + myChar;
					}
				}
			}
			var myarrLen = myarray.length;
			var initialRowCount = 4;
			var table = document.createElement('table');
			table.id = "myDataTable";
			for (var i = 0; i < 4; i++) {
				var tr = document.createElement('tr');
				if (i === 0) {
					var th = document.createElement('th');
					var text = document.createTextNode("Fields>>");
					th.appendChild(text);
					th.id = "H1";
					tr.appendChild(th);
					var th = document.createElement('th');
					var text = document.createTextNode("Execute");
					th.appendChild(text);
					th.id = "H2";
					tr.appendChild(th);
					var th = document.createElement('th');
					var text = document.createTextNode("TC#");
					th.appendChild(text);
					th.id = "H3";
					tr.appendChild(th);
					var th = document.createElement('th');
					var text = document.createTextNode("Data#");
					th.appendChild(text);
					th.id = "H4";
					tr.appendChild(th);
					var th = document.createElement('th');
					var text = document.createTextNode("Cycle");
					th.appendChild(text);
					th.id = "H5";
					tr.appendChild(th);
					var th = document.createElement('th');
					var text = document.createTextNode("Product");
					th.appendChild(text);
					th.id = "H6";
					tr.appendChild(th);
					for (var j = 0; j < myarrLen; j++) {
						var th = document.createElement('th');
						var text = document.createTextNode(myarray[j]);
						th.appendChild(text);
						th.id = "c" + (j + 1);
						tr.appendChild(th);
					}
					table.appendChild(tr);
				}
				if (i === 1) {
					var colCount = table.rows[0].cells.length;
					var totalRowCount = table.rows.length;
					for (var m = 0; m < colCount; m++) {
						var Xcell = tr.insertCell(m);
						var cIndex = (totalRowCount) * colCount;
						var cID = "c" + (cIndex + m + 1);
						Xcell.id = cID;
						if (m === 0) {
							var input = document.createElement("input");
							input.id = "field_name";
							input.name = "field_name";
							input.type = "text";
							input.setAttribute("value", "Map>>");
							Xcell.appendChild(input);
						}
						if (m === 1) {
							var input = document.createElement("input");
							input.id = "field_name";
							input.name = "field_name";
							input.type = "text";
							input.setAttribute("value", "Execution");
							Xcell.appendChild(input);
						}
						if (m === 2) {
							var input = document.createElement("input");
							input.id = "field_name";
							input.name = "field_name";
							input.type = "text";
							input.setAttribute("value", "TC_ID");
							Xcell.appendChild(input);
						}
						if (m === 3) {
							var input = document.createElement("input");
							input.id = "field_name";
							input.name = "field_name";
							input.type = "text";
							input.setAttribute("value", "DATA_ID");
							Xcell.appendChild(input);
						}
						if (m === 4) {
							var input = document.createElement("input");
							input.id = "field_name";
							input.name = "field_name";
							input.type = "text";
							input.setAttribute("value", "Cycle No");
							Xcell.appendChild(input);
						}
						if (m === 5) {
							var input = document.createElement("input");
							input.id = "field_name";
							input.name = "field_name";
							input.type = "text";
							input.setAttribute("value", "Product");
							Xcell.appendChild(input);
						}
						if (m === 6) {
							var input = document.createElement("input");
							input.id = "field_name";
							input.name = "field_name";
							input.type = "text";
							input.setAttribute("value", "Contract_No");
							Xcell.appendChild(input);
						}
						if (m === 7) {
							var input = document.createElement("input");
							input.id = "field_name";
							input.name = "field_name";
							input.type = "text";
							input.setAttribute("value", "Effective_Date");
							Xcell.appendChild(input);
						}
						if (m > 7) {
							var input = document.createElement("input");
							input.id = "field_name";
							input.name = "field_name";
							input.type = "text";
							input.setAttribute("list", "trx_field_list");
							var datalist = document.createElement("datalist");
							datalist.setAttribute("id", "trx_field_list");
							datalist.setAttribute("name", "trx_field_list");
							input.appendChild(datalist);
							Xcell.appendChild(input);
							//new modification
							var clear_element = document.createElement("button");
							clear_element.setAttribute("type", "button");
							clear_element.setAttribute("class", "clear-btn");
							clear_element.setAttribute("onclick", "clearInput(this)");
							clear_element.textContent = 'X';					
							Xcell.append(clear_element);
							//new modification
						}
					}
					table.appendChild(tr);
				}
				if (i === 2) {
					var colCount = table.rows[0].cells.length;
					var totalRowCount = table.rows.length;
					for (var m = 0; m < colCount; m++) {
						var Xcell = tr.insertCell(m);
						var cIndex = (totalRowCount) * colCount;
						var cID = "c" + (cIndex + m + 1);
						Xcell.id = cID;
						if (m === 0) {
							Xcell.innerHTML = "CHK";
						} else {
							Xcell.innerHTML = "";
						}
					}
					table.appendChild(tr);
					table.rows[2].style.display = "none";
				}
				if (i === 3) {
					for (var m = 0; m < colCount; m++) {
						var colCount = table.rows[0].cells.length;
						var totalRowCount = table.rows.length;
						var cIndex = (totalRowCount) * colCount;
						var cID = "c" + (cIndex + m + 1);
						var Xcell = tr.insertCell(m);
						Xcell.id = cID;
						
						if (m === 0) {
							var checkbox = document.createElement("input");
							checkbox.type = "checkbox";
							checkbox.name = "chkbox[]";
							Xcell.appendChild(checkbox);
						} 
						else {
							if (m > 6) {
								Xcell.ondblclick = function() {
									Find_col_index(this);
									callAjaxDataformat();
								};
							}

							if (m === 4) {
								var input_ele = document.createElement("input");
								input_ele.addEventListener("input", function(event) {
									var selectedValue = event.target.value;
									this.setAttribute("value", selectedValue);
								});
								input_ele.setAttribute("id", "Dropdown_id" + m);
								input_ele.setAttribute("name", "Dropdown_id" + m);
								input_ele.type = "text";
								input_ele.setAttribute("list", "Dropdown_list" + m);
								var datalist = document.createElement("datalist");
								datalist.setAttribute("id", "Dropdown_list" + m);
								datalist.setAttribute("name", "Dropdown_list" + m);
								input_ele.appendChild(datalist);
								Xcell.appendChild(input_ele);
								var cycle_value = document.getElementById("cyclenum").value;
								var chkboxArray = document.getElementsByName("action");
								for (var chkbox of chkboxArray) {
									if (chkbox.checked) {
										cycle_value = cycle_value + "_" + chkbox.value;
									}
								}
								input_ele.setAttribute("value", cycle_value);
								document.getElementById("cyclenum").disabled = true;
							} 
							else if (m === 3) {
								var input_ele = document.createElement("input");
								input_ele.addEventListener("input", function(event) {
									var selectedValue = event.target.value;
									this.setAttribute("value", selectedValue);
								});
								input_ele.setAttribute("id", "Dropdown_id" + m);
								input_ele.setAttribute("name", "Dropdown_id" + m);
								input_ele.type = "text";
								input_ele.setAttribute("readonly", "readonly");
								Xcell.appendChild(input_ele);
								//new modification
								var clear_element = document.createElement("button");
								clear_element.setAttribute("type", "button");
								clear_element.setAttribute("class", "clear-btn");
								clear_element.setAttribute("onclick", "clearInput(this)");
								clear_element.textContent = 'X';					
								Xcell.append(clear_element);
								//new modification
							}
							else if (m === 1) {
								var trxninput = document.createElement("SELECT");
								trxninput.setAttribute("value", "");
								var opt1 = document.createElement("OPTION");
								opt1.innerHTML = "Yes";
								trxninput.options.add(opt1);
								var opt2 = document.createElement("OPTION");
								opt2.innerHTML = "No";
								trxninput.options.add(opt2);
								Xcell.appendChild(trxninput);
							}
							else {
								var input_ele = document.createElement("input");								
								input_ele.addEventListener("input", function(event) {
									var selectedValue = event.target.value;
									this.setAttribute("value", selectedValue);
								});
								input_ele.setAttribute("id", "Dropdown_id" +  m);
								input_ele.setAttribute("name", "Dropdown_id" + m);
								input_ele.type = "text";
								input_ele.setAttribute("list", "Dropdown_list" + m);
								var datalist = document.createElement("datalist");
								datalist.setAttribute("id", "Dropdown_list" + m);
								datalist.setAttribute("name", "Dropdown_list" + m);
								input_ele.appendChild(datalist);
								Xcell.appendChild(input_ele);
							}
							
						}
					}
					table.appendChild(tr);
				}
			}
			document.getElementById('div2').appendChild(table);
			var break_elem1 = document.createElement("BR");
			document.getElementById("div2").insertBefore(break_elem1, table);
			var break_elem2 = document.createElement("BR");
			document.getElementById("div2").insertBefore(break_elem2, table);
			
			var btn = document.createElement("input");
			btn.type = "button";
			btn.setAttribute("id", "CreateRow");
			btn.setAttribute("name", "CreateRow");
			btn.setAttribute("value", "Create Row");
			btn.onclick = function() {
				addDataTableRow();
			};
			document.getElementById('div2').appendChild(btn);
			
			var btn2 = document.createElement("input");
			btn2.type = "button";
			btn2.setAttribute("id", "DeleteRow");
			btn2.setAttribute("name", "DeleteRow");
			btn2.setAttribute("value", "Delete Row");
			btn2.onclick = function() {
				deleteRow();
			};
			document.getElementById('div2').appendChild(btn2);
			
			var btn3 = document.createElement("input");
			btn3.type = "button";
			btn3.setAttribute("id", "CreateDataID");
			btn3.setAttribute("name", "CreateDataID");
			btn3.setAttribute("value", "Create Data ID");
			btn3.onclick = function() {
				GenerateTCID();
			};
			document.getElementById('div2').appendChild(btn3);
			
			var btn4 = document.createElement("input");
			btn4.type = "button";
			btn4.setAttribute("id", "UploadTCTestData");
			btn4.setAttribute("name", "UploadTCTestData");
			btn4.setAttribute("value", "Add Test Case Test Data");
			btn4.onclick = function() {
				ADDTCTD();
			};
			document.getElementById('div2').appendChild(btn4);
			
			var btn5 = document.createElement("input");
			btn5.type = "button";
			btn5.setAttribute("id", "NextCycle");
			btn5.setAttribute("name", "NextCycle");
			btn5.setAttribute("value", "Create Steps for Next Cycle");
			btn5.onclick = function() {
				NextCycle();
			};
			document.getElementById('div2').appendChild(btn5);
			
			var btn6 = document.createElement("input");
			btn6.type = "submit";
			btn6.setAttribute("id", "Submit");
			btn6.setAttribute("name", "Submit");
			btn6.setAttribute("value", "Add to Run");
			document.getElementById('div2').appendChild(btn6);
		}

		function addDataTableRow() {
			var table = document.getElementById("myDataTable");
			var colCount = document.getElementById('myDataTable').rows[0].cells.length;
			var totalRowCount = table.rows.length;
			var row = table.insertRow(totalRowCount);
			for (var m = 0; m < colCount; m++) {
				var cIndex = totalRowCount * colCount;
				var cID = "c" + (cIndex + m + 1);
				var Xcell = row.insertCell(m);
				Xcell.id = cID;
				if (m === 0) {
					var checkbox = document.createElement("input");
					checkbox.type = "checkbox";
					checkbox.name = "chkbox[]";
					Xcell.appendChild(checkbox);
				}
				else {
					if (m > 6) {
						Xcell.ondblclick = function() {
							Find_col_index(this);
							callAjaxDataformat();
						};
					}
					if (m === 4) {
						var input_ele = document.createElement("input");
						input_ele.setAttribute("id", "Dropdown_id" + m);
						input_ele.setAttribute("name", "Dropdown_id" + m);
						input_ele.type = "text";
						input_ele.setAttribute("list", "Dropdown_list" + m);
						var datalist = document.createElement("datalist");
						datalist.setAttribute("id", "Dropdown_list" + m);
						datalist.setAttribute("name", "Dropdown_list" + m);
						input_ele.appendChild(datalist);
						Xcell.appendChild(input_ele);
						var cycle_value = document.getElementById("cyclenum").value;
						var chkboxArray = document.getElementsByName("action");
						for (var chkbox of chkboxArray) {
							if (chkbox.checked) {
								cycle_value = cycle_value + "_" + chkbox.value;
							}
						}
						input_ele.setAttribute("value", cycle_value);
					} 
					else if (m === 3) {
						var input_ele = document.createElement("input");
						input_ele.addEventListener("input", function(event) {
							var selectedValue = event.target.value;
							this.setAttribute("value", selectedValue);
						});
						input_ele.setAttribute("id", "Dropdown_id" + m);
						input_ele.setAttribute("name", "Dropdown_id" + m);
						input_ele.type = "text";
						input_ele.setAttribute("list", "Dropdown_list" + m);
						var datalist = document.createElement("datalist");
						datalist.setAttribute("id", "Dropdown_list" + m);
						datalist.setAttribute("name", "Dropdown_list" + m);
						input_ele.appendChild(datalist);
						Xcell.appendChild(input_ele);
						var reset_span = document.createElement("span");
						reset_span.setAttribute("id", "reset");
						reset_span.setAttribute("name", "reset");
						reset_span.setAttribute("class", "reset");
						reset_span.setAttribute("value", "reset");
						reset_span.textContent = "X";
						reset_span.onclick = function() {
							clear_input(this);
						}
						Xcell.appendChild(reset_span);
					}
					else {
						var input_ele = document.createElement("input");
						input_ele.setAttribute("id", "Dropdown_id" + m);
						input_ele.setAttribute("name", "Dropdown_id" + m);
						input_ele.type = "text";
						input_ele.setAttribute("list", "Dropdown_list" + m);
						var datalist = document.createElement("datalist");
						datalist.setAttribute("id", "Dropdown_list" + m);
						datalist.setAttribute("name", "Dropdown_list" + m);
						input_ele.appendChild(datalist);
						Xcell.appendChild(input_ele);
					}
				}
			}
		}
		
		function clear_input(element) {
			element.previousElementSibling.setAttribute("value", "");
		} 
		
		function GenerateTCID() {
			var dataIDInputElements = document.getElementsByName("Dropdown_id3");
			var count = 0;
			var result = "";
			for (var i = 0; i < dataIDInputElements.length; i++) {
				var dataIDInputElement = dataIDInputElements[i];
				if (dataIDInputElement.value === "") {
					count = count + 1;
				}
			}
			xhr = new XMLHttpRequest();
			if (!xhr) {
				console.log('Unable to create XMLHTTP instance');
				return false;
			}
			xhr.open("GET", "GenerateTCTDID?count=" + count, true);
			xhr.send();
			xhr.onreadystatechange = function () {
				if (xhr.readyState === 4 && xhr.status === 200) {
					result = xhr.responseText;
					alert(result);
					for (var i = 0; i < dataIDInputElements.length; i++) {
						var dataIDInputElement = dataIDInputElements[i];
						alert(dataIDInputElement);
						if (dataIDInputElement.value === "") {
							dataIDInputElement.setAttribute("value", result.split(";")[i]);
						}
					}
				}
			};
			
			
			//for (var i = 0; i < dataIDInputElements.length; i++) {
				//var dataIDInputElement = dataIDInputElements[i];
				//if (dataIDInputElement.value === "") {
					//xhr = new XMLHttpRequest();
					//if (!xhr) {
						//console.log('Unable to create XMLHTTP instance');
						//return false;
					//}
					//xhr.open("GET", "Save_scenario", true);
					//xhr.send();
					//xhr.onreadystatechange = function () {
						//if (xhr.readyState === 4 && xhr.status === 200) {
							//var result = xhr.responseText;
							//var ele = document.getElementsById("Dropdown_id_" + (i+3) + "_3");
							//dataIDInputElement.setAttribute("value", result);
						//}
					//};
				//}
			//}
		}
		
		function deleteRow() {
			var table = document.getElementById("myDataTable");
			var rowCount = table.rows.length;

			for (var i = rowCount - 1; i > 0; i--) {
				var row = table.rows[i];
				var checkBox = row.cells[0].querySelector('input[type="checkbox"]');
				if (checkBox.checked) {
					table.deleteRow(i);
				}
			}
		}

		function ADDTCTD() {
			var insertdata = "";
			var table = document.getElementById("myDataTable");
			for (var i = 3; i < table.rows.length; i++) {
				var row = table.rows[i];
				var testidrow = "";
				var dataId = "";
				for (var j = 1; j < row.cells.length; j++) {
					
					var field = "";
					if ((j+1) < 7) {
						field = document.getElementById("H"+(j+1)).innerHTML;
					} else {
						field = document.getElementById("c"+(j-5)).innerHTML;
					}
					
					var map = document.getElementsByName("field_name")[j].value;
					
					var dropDownArray = document.getElementsByName("Dropdown_id"+j);
					var testdata = dropDownArray[i-3].value;
					
					if (map == "") {
						var lowerCaseString = field.toLowerCase();
						if (lowerCaseString.includes('effective')) {
							map = 'Effective_Date';
						}
						if (lowerCaseString.includes('contract')) {
							map = 'Contract_No';
						}
					}
					
					if (map == "DATA_ID") {
						dataId = testdata;
					}

					if (insertdata == "") {
						insertdata = map + ";" + testdata;
					} else {
						insertdata = insertdata + "@" + map + ";" + testdata;
					}
				}

				insertdata = insertdata + "@" + "Application" + ";" + document.getElementById("application").value;
				insertdata = insertdata + "@" + "Region" + ";" + document.getElementById("region").value;
				insertdata = insertdata + "@" + "Scenario_Outline" + ";" + document.getElementById("scdescrip").value;
				insertdata = insertdata + "@" + "Project" + ";" + document.getElementById("project").value;
				insertdata = insertdata + "@" + "Release" + ";" + document.getElementById("release").value;
				
				insertdata = insertdata.replace(/\s/g, 'space');
				insertdata = insertdata.replace(/\//g, 'slash');
				insertdata = insertdata.replace(/@/g, 'attherate');
				insertdata = insertdata.replace(/;/g, 'semicolon');
				insertdata = insertdata.replace(/[(]/g, 'openbracket1');
				insertdata = insertdata.replace(/[)]/g, 'closebracket1');
				insertdata = insertdata.replace(/{/g, 'openbracket2');
				insertdata = insertdata.replace(/}/g, 'closebracket2');
				insertdata = insertdata.replace(/\[/g, 'openbracket3');
				insertdata = insertdata.replace(/\]/g, 'closebracket3');
				insertdata = insertdata.replace(/_/g, 'underscore');
				insertdata = insertdata.replace(/\-/g, 'minus');
				insertdata = insertdata.replace(/\*/g, 'multiply');
				insertdata = insertdata.replace(/\+/g, 'plus');

				var insertdata2 = "ScenarioID;" + document.getElementById("scid").value
					+ "@CycleNum;" + document.getElementById("cyclenum").value
					+ "@TestStepDescription;" + document.getElementById("BDDteststeps").value
					+ "@Project;" + document.getElementById("project").value
					+ "@Release;" + document.getElementById("release").value
					+ "@DataID;" + dataId;
					
				insertdata2 = insertdata2.replace(/\s/g, 'space');
				insertdata2 = insertdata2.replace(/\//g, 'slash');
				insertdata2 = insertdata2.replace(/@/g, 'attherate');
				insertdata2 = insertdata2.replace(/;/g, 'semicolon');
				insertdata2 = insertdata2.replace(/[(]/g, 'openbracket1');
				insertdata2 = insertdata2.replace(/[)]/g, 'closebracket1');
				insertdata2 = insertdata2.replace(/{/g, 'openbracket2');
				insertdata2 = insertdata2.replace(/}/g, 'closebracket2');
				insertdata2 = insertdata2.replace(/\[/g, 'openbracket3');
				insertdata2 = insertdata2.replace(/\]/g, 'closebracket3');
				insertdata2 = insertdata2.replace(/_/g, 'underscore');
				insertdata2 = insertdata2.replace(/\-/g, 'minus');
				insertdata2 = insertdata2.replace(/\*/g, 'multiply');
				insertdata2 = insertdata2.replace(/\+/g, 'plus');

				httpRequest = new XMLHttpRequest();
				if (!httpRequest) {
					console.log('Unable to create XMLHTTP instance');
					return false;
				}
				httpRequest.open('POST', 'csAXMLGTestCase?CSAXMLGDEData=' + insertdata + '&CSAXMLGTCData=' + insertdata2, true);
				httpRequest.send();
				httpRequest.onreadystatechange = function () {
					if (httpRequest.readyState === XMLHttpRequest.DONE) {
						if (httpRequest.status === 200) {
							alert(http.responseText);
							document.getElementById("errormsg").value = http.responseText;
						}
					}
					else {
						document.getElementById("errormsg").value = "Test Steps Added Successfully";
					}
				}
			}
			
			document.getElementById("cycletable").style.display = "";
			
			if (document.getElementById("cyclenum").value === "1") {
				document.getElementById("cycle1").innerHTML = document.getElementById("BDDteststeps").value;
			}
			else if (document.getElementById("cyclenum").value === "2") {
				document.getElementById("cycle2").innerHTML = document.getElementById("BDDteststeps").value;
			}
			else if (document.getElementById("cyclenum").value === "3") {
				document.getElementById("cycle3").innerHTML = document.getElementById("BDDteststeps").value;
			}
			else if (document.getElementById("cyclenum").value === "4") {
				document.getElementById("cycle4").innerHTML = document.getElementById("BDDteststeps").value;
			}

		}

		function NextCycle() {
			document.getElementById("BDDteststeps").innerHTML = "";
			document.getElementById("cyclenum").disabled = false;
			document.getElementById("div2").innerHTML = "";
		}
		function clearInput(button) {
		    var input = button.parentNode.querySelector('input[list="search_data_list"]') || button.parentNode.querySelector('input[list="trx_field_list"]') || button.parentNode.querySelector('input[id*="Dropdown_id"]');
		    input.value ='';
		}

	</script>

</head>

<body>

	<div style="overflow-x: hidden;">
		<div class="center">
			<h2>
				<span>Nexus Test Wizard</span>
			</h2>
		</div>
		<ul>
			<li><a href="index.jsp">Home</a></li>
			<li><a class="active" href="Save_scenario.jsp">Create Scenario</a></li>
			<li><a href="Search_scenario.jsp">Search Scenario</a></li>
		</ul>
	</div>

	<form action="NavigateToHomePage" method="post">

	<div onload="hideshow()" style="background-color:#f5f5f5;">
		
		<h3 style="text-align: left">
			<u>Test Scenario</u>
		</h3>
		
		<div class="container">
			<div class="field">
				<div class="box box1">
					<center>Project</center>
				</div>
				<textarea id="project" name="project" rows="5" cols="20">${PROJECT}</textarea>
			</div>
			<div class="field">
				<div class="box box1">
					<center>Release</center>
				</div>
				<textarea id="release" name="release" rows="5" cols="20">${RELEASE}</textarea>
			</div>
			<div class="field">
				<div class="box box1">
					<center>Intitative/Feature#</center>
				</div>
				<textarea id="initiativeid" name="initiativeid" rows="5" cols="20">${FEATUREID}</textarea>
			</div>
			<div class="field">
				<div class="box box1">
					<center>Intitative/Feature Title</center>
				</div>
				<textarea id="initiative" name="initiative" rows="5" cols="20">${FEATURETITLE}</textarea>
			</div>
			<div class="field">
				<div class="box box1">
					<center>Scenario#</center>
				</div>
				<textarea id="scid" name="scid" rows="5" cols="20">${SCENARIOID}</textarea>
			</div>
			<div class="field">
				<div class="box box1">
					<center>Description</center>
				</div>
				<textarea id="scdescrip" name="scdescrip" rows="5" cols="20">${DESCRIPTION}</textarea>
			</div>
			<div class="field">
				<div class="box box1">
					<center>Functional Tags</center>
				</div>
				<textarea id="ftag" name="ftag" rows="5" cols="20">${TAGS}</textarea>
			</div>
		</div>

		<hr style="  border-radius: 1px;padding: 0px;margin: 0px;">
		<br>

		<div class="section1">

			<div id="mysection">
				<h3 style="text-align:left"><u>Test Case</u></h3>

				<table id="cycletable" width="100%" class="equaldivide">
					<tr>
						<th>
							<center><u id="cy1">Cycle 1</u></center>
						</th>
						<th>
							<center><u id="cy2">Cycle 2</u></center>
						</th>
						<th>
							<center><u id="cy3">Cycle 3</u></center>
						</th>
						<th>
							<center><u id="cy4">Cycle 4</u></center>
						</th>
					</tr>
					<tr class="table-row">
						<td id="cycle1"></td>
						<td id="cycle2"></td>
						<td id="cycle3"></td>
						<td id="cycle4"></td>
					</tr>
				</table>
			</div>

			<br>
			<br>

			<hr style="border: 4px solid rgb(147, 173, 145); border-radius: 1px;padding: 0px;margin: 0px;">
			
			<br>

			<div style="float: right; padding-right: 25px; padding-top: 5px;">
				<textarea
					style="width: 200px; height: 50px; border: 1px; padding: 2px; background-color: rgb(238, 248, 192)"
					id="errormsg" disabled=true></textarea>
			</div>
			
			<h3 style="text-align:left">
				<u>Test Steps</u>
			</h3>
			
			<p>Write Cycle wise Test Steps in Gherkin's format</p>
			
			<br>
			
			<div class="row">
				<div class="column">
					<label for="application">Application:</label> 
					<input list="applications" name="applications" id="application">
					<datalist id="applications">
						<option value="wmA">
						<option value="csA">
					</datalist>
				</div>
				<div class="column">
					<label for="region">Region:</label> 
					<input list="regions" name="regions" id="region">
					<datalist id="regions">
						<option value="QA1">
						<option value="QA2">
						<option value="QA3">
						<option value="QA5">
						<option value="UAT">
					</datalist>
				</div>
				<div class="column">
					<label for="cyclenum">Cycle Number:</label>
					<input list="cycle" name="cycle" id="cyclenum">
					<datalist id="cycle">
						<option value="1">
						<option value="2">
						<option value="3">
						<option value="4">
						<option value="5">
					</datalist>
				</div>
				<div class="column">
					<left>
						<div class="row">
							<div class="column">
								<label for="action">Action:</label>
							</div>
							<div class="column">
								<input type="checkbox" id="action1" name="action" value="DE"> 
								<label for="action1"> DE</label>
								<br> 
								<input type="checkbox" id="action2" name="action" value="DE_PB"> 
								<label for="action2"> DE_PB</label><br>
							</div>
						</div>
					</left>
				</div>
			</div>
			
			<br>
			
			<left>
				<textarea id="BDDteststeps" name="Test Steps" rows="5" cols="65" placeholder="Describe Test Step in Gherkins format"></textarea>
				<br>
				<br>
				<span id="errorname"></span>
				<br>
				<input id="subbutn" type="button" onclick="createDataTable()" value="Create Data Table">
				<input id="showbutn" type="button" onclick="showDataTable()" value="Show Data Table">
			</left>
			
			<br> <br>
			
			<div id="div2"></div>

			<hr>
			<br>
		</div>
	</div>
	
	</form>
	
	<br>
	
	<div class="popup" id="myPopup">
		<h2 style="color: black;">Enter Fund Details in the below table:</h2>
		<table id="valueTable">
			<thead>
				<tr>
					<th>Fund Number</th>
					<th>Allocation Amount/Percent</th>
					<th>Maturity Instruction</th>
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<input type="text" class="valueInput" placeholder="Fund Number">
					</td>
					<td>
						<input type="text" class="valueInput" placeholder="Allocation Amount/Percent">
					</td>
					<td>
						<input type="text" class="valueInput" placeholder="Maturity Instruction">
					</td>
					<td>
						<button class="removeRow" onclick="deleteRow_fund_popup();">Remove</button>
					</td>
				</tr>
			</tbody>
		</table>
		<button id="addRow" onclick="addNewRow();">Add Row</button>
		<button id="closePopup" onclick="closePopUp();">Save & Close</button>
	</div>
	
	<div class="popup" id="myPopup1">
		<h2 style="color: black; width: 100%">Create Test Data</h2>
		<br>
		<label for = "test_data">Test Data:</label>
		<input type="text" id="test_data">
		<label>Search Text:</label>
		<input type="text" list="search_data_list" id="search_data" onkeyup="search_csa_fields();" onfocusout="dataValueOnChange();">
		<datalist id="search_data_list"></datalist>
		<button type=button class="clear-btn" onclick="clearInput(this)">X</button>
		<br>
		<br>
		<button id="closePopup" onclick="closePopUp1();">Save & Close</button>
	</div>
	
	<div class="popup" id="myPopup2" style="width: 1250px">
		<h2 style="color: black; width: 100%">Create Test Data</h2>
		<br>
		<div id="flex-div">
			<div id="left-div" style="width: 30%;">
				<table id="lhstestDataTable" style="padding: 10px;">
					<tr>
						<th colspan="4">
							<center><u>LHS Formula</u></center>
						</th>
					</tr>
					<tr>
						<th>Variable</th>
						<th>Custom Field1/Text1/Value1</th>
						<th>Operator</th>
						<th>Custom Field2/Text2/Value2</th>
					</tr>
				</table>
				<button id="lhsaddRow" onclick="lhsaddTestDataTableRow();">Add Row</button>
			</div>
			<div id="right-div" style="width: 30%;">
				<table id="rhstestDataTable" style="padding: 10px;">
					<tr>
						<th colspan="4">
							<center><u>RHS Formula</u></center>
						</th>
					</tr>
					<tr>
						<th>Variable</th>
						<th>Custom Field1/Text1/Value1</th>
						<th>Operator</th>
						<th>Custom Field2/Text2/Value2</th>
					</tr>
				</table>
				<button id="rhsaddRow" onclick="rhsaddTestDataTableRow();">Add Row</button>
			</div>
		</div>
		<br> <br> 
		Test Data:
		<textarea id="rawTestData" rows="1" cols="40"></textarea>
		<button id="showTestDataBtn" onclick="showTestData();">Show Test Data</button>
		<br> <br>
		<button id="closePopup" onclick="closeTestDataPopUp();">Save & Close</button>
	</div>
	
</body>

</html>