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


//= require datatable-editor/js/dataTables.editor.min


var editor; // use a global for the submit and return data rendering in the examples
var table;
var column_title;
function showfilter(column) {
    // $("#dlg_set_filter").modal();
    $('#dlg_set_filter').modal();
    column_title = column;
    
}
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
        sAjaxSource: '/api/skynethisotry',
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
          // {
          //     "targets": 0,//index of column starting from 0
          //     "data": "inputfileurl", //this name should exist in your JSON response
          //     "render": function ( data, type, full, meta ) {
          //         return "<a href=\""+data+"\">Download</a>";
                 
          //     }
          // }
         ],
        "order": [[ 3, "desc" ]],
        // sDom:      'C<"clear">lfrtip',
        // colVis: {
        //     order: 'alfa',
        //     'buttonText': 'Show/Hide Columns'
        // }
    });

  });


  loaddatatable($("#grid_vendor_id").val());
    

})(window, document, window.jQuery);



function outputdownload (cellvalue, options, rowObject) {
    if(cellvalue == null)
        return "In Progress";
    return "<a href='"+cellvalue+"'><em class='fa fa-download'>"+"Download"+"</em></a>";
}

document.getElementById("file_field").onchange = function(){
    document.getElementById("filefeed").submit();
}

$("#grid_vendor_id").change(function(){


  loaddatatable($(this).val());
    
});

function loaddatatable(vendor_id){

  
  if ( $.fn.dataTable.isDataTable( '#datatable4' ) ) {
      table = $('#datatable4').dataTable();
      table.fnDestroy();
  }

  table = $('#datatable4').DataTable({
        'paging':   true,  // Table pagination
        'ordering': true,  // Column ordering
        'info':     true,  // Bottom left status text
        'responsive': true, // https://datatables.net/extensions/responsive/examples/
        "processing": true,
        "serverSide": true,
        sAjaxSource: '/api/getitemlist?vendor='+vendor_id,
        aoColumns: [
          { mData: 'id' },
          { mData: 'vendortitle' },
          { mData: 'asin' },
          { mData: 'vendorsku' },
          { mData: 'upc' },
          { mData: 'cost' ,render: $.fn.dataTable.render.number( ',', '.', 2, '$' )},
          { mData: 'packcount' },
          { mData: 'packcost', render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
          { mData: 'buyboxprice', render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
          { mData: 'profit', render: $.fn.dataTable.render.number( ',', '.', 2,'$')},
          { mData: 'margin',render: $.fn.dataTable.render.number( ',', '.', 2, '','%' )},
          { mData: 'fbafee' ,render: $.fn.dataTable.render.number( ',', '.', 2, '$' )},
          { mData: 'commissionpct' },
          { mData: 'commissiionfee' ,render: $.fn.dataTable.render.number( ',', '.', 2, '$' )},
          { mData: 'salespermonth' },
          { mData: 'totaloffers' },
          { mData: 'fbaoffers' },
          { mData: 'fbmoffers' }
        ],
        // sDom:      'C<"clear">lfrtip',
        // colVis: {
        //     order: 'alfa',
        //     'buttonText': 'Show/Hide Columns'
        // }
        // buttons: [
        //     { extend: "create", editor: editor },
        //     { extend: "edit",   editor: editor },
        //     { extend: "remove", editor: editor }
        // ]
    });

  initComplete();

  table.columns().every( function () {
        var that = this;
 
        $( 'input', this.footer() ).on( 'keyup change', function () {
            if ( that.search() !== this.value ) {
                that
                    .search( this.value )
                    .draw();
            }
        } );
    } );

  
  
  

}

function initComplete () {
 
  $('#datatable4 tfoot th').each( function (i) {
      // var title = $(this).text();
      // $(this).html( '<input type="text" placeholder="Search '+title+'" />' );
      var title = $('#datatable4 thead th').eq( $(this).index() ).text();
      if(title == 'EST' || title == 'Profit' || title == 'Margin'){
        $(this).html( '<input type="hidden" placeholder="Search '+title+'" data-index="'+i+'" name="'+title+'" id="txt_'+title+'"/><a class="btn btn-primary" href="javascript:showfilter(\''+title+'\')">'+'<em class="fa fa-search"></em>'+'</a>' );
      }else{
        $(this).html( '<input type="text" placeholder="Search '+title+'" data-index="'+i+'" />' );  
      }
  } );
  // Activate an inline edit on click of a table cell
  editor = new $.fn.DataTable.Editor( {
      ajax: "/updatevendoritem",
      table: "#datatable4",
      idSrc:  'id',
      fields: [ {
              label: "Packcount",
              name: "packcount"
          }, {
              label: "COST",
              name: "cost"
          }, {
              label: "Name",
              name: "vendortitle"
          }, {
              label: "UPC",
              name: "upc"
          }, {
              label: "BBP",
              name: "buyboxprice"
          }, {
              label: "SalesPerMonth",
              name: "salespermonth"
          }, {
              label: "VendorSKU",
              name: "vendorsku"
          }
      ]
  } );
}

$(document).ready(function(){
    $(".skyent-id-types .tab1").addClass('active');
    $(".skyent-id-types .tabs").click(function(e) {
        var tabs = $(".skyent-id-types .tabs");
        for (i = 0; i < tabs.length; i++) {
            tabs[i].className = tabs[i].className.replace(" active", "");
        }
        e.currentTarget.className += " active";
        alert(e.currentTarget.innerText+" is selected");
    });


    $('#index_header').on('change', function (e) {
        var index_header_val = $("#index_header option:selected").val();
        if(index_header_val.toLowerCase().match(/asin/i) == 'asin'){
            $("#skynet_id_type_id").val('0');
        }else if(index_header_val.toLowerCase().match(/upc/i) == 'upc'){
            $("#skynet_id_type_id").val('1');
        }else if(index_header_val.toLowerCase().match(/isbn/i) == 'isbn'){
            $("#skynet_id_type_id").val('2');
        }else if(index_header_val.toLowerCase().match(/ean/i) == 'ean'){
            $("#skynet_id_type_id").val('3');
        }
    });

    $('#btn_confirm_filter').click(function () {
      $('#txt_'+column_title).attr('value', $('#slt_expression').val() + $('#txt_comparevalue').val());
      $('#txt_'+column_title).trigger("change");
    })

    $('#btn_reset_filter').click(function () {
      $('#txt_'+column_title).attr('value', '');
      $('#txt_'+column_title).trigger("change");
    })

    $('#datatable4').on( 'click', 'tbody td:not(:first-child)', function (e) {
      editor.inline( this );
      // editor.bubble( this );
    } );
});