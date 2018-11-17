
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
var table;
(function(window, document, $, undefined){

  $(function(){
    


    $('#datatable_skynethistory').dataTable({
        'paging':   true,  // Table pagination
        'ordering': true,  // Column ordering
        'info':     true,  // Bottom left status text
        'responsive': true, // https://datatables.net/extensions/responsive/examples/
        // "bPaginate": true,
        "iDisplayLength" : 10,
        "processing": true,
        "serverSide": true,
        sAjaxSource: '/pull_inventory/skynet',
        aoColumns: [
          { mData: 'inputfilename',
            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
              $(nTd).html("<a href='https://fba-skynets-csvs.s3.amazonaws.com/uploads/"+oData.inputfileurl+"' target=\"_blank\">"+oData.inputfilename+"</a>");
            }
          },
          { mData: 'name' },
          { mData: 'statusmessage' },
          { mData: 'outputfileurl' },
          { mData: 'created_at' },
        ],
        "columnDefs": [ {
            "targets": 3,//index of column starting from 0
            "data": "outputurl", //this name should exist in your JSON response
            "render": function ( data, type, full, meta ) {
                if(data != '' && data != null){
                    return "<a href=\""+data+"\">Download</a>";
                }else{
                    return '';
                }
              // return '<span class="label label-danger">'+data+'</span>';
            }
          },
         ],
        "order": [[ 3, "desc" ]],
        // sDom:      'C<"clear">lfrtip',
        // colVis: {
        //     order: 'alfa',
        //     'buttonText': 'Show/Hide Columns'
        // }
    });

  });
})(window, document, window.jQuery);

