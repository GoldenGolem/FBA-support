//--- jqGrid
//= require jqgrid/js/jquery.jqGrid.min.js
//= require jqgrid/js/i18n/grid.locale-en.js

//--- Datatables
//= require datatables/media/js/jquery.dataTables.min
//= require datatables-colvis/js/dataTables.colVis
//= require datatables/media/js/dataTables.bootstrap

//--- Datatables Buttons
//= require datatables-buttons/js/dataTables.buttons
//= datatables-buttons/css/buttons.bootstrap.css
//= require datatables-buttons/js/buttons.bootstrap
//= require datatables-buttons/js/buttons.colVis
//= require datatables-buttons/js/buttons.flash
//= require datatables-buttons/js/buttons.html5
//= require datatables-buttons/js/buttons.print
//= require datatables-responsive/js/dataTables.responsive
//= require datatables-responsive/js/responsive.bootstrap

$(document).ready(function(){
	var usertable = $('#userstable').DataTable({
		"aLengthMenu": [ 10, 25, 50, 100, 200 ],
	});
});