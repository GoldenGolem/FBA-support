

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

var editor; // use a global for the submit and return data rendering in the examples
var table;

function showfilter(column_title) {
    // $("#dlg_set_filter").modal();
   
    $('[name=EST]').attr('value', '5');
    $('[name=EST]').text(column_title);
    // $('#txt_'+column_title).val('5')
    console.log($('#txt_'+column_title));
    console.log($('#txt_'+column_title).val());
    // var value = $("#txt_"+column_title).val();
          
        // table
        //     .search( this.value )
        //     .draw();
        // console.log(val);
  }

(function(window, document, $, undefined){

  

  initComplete();
  loaddatatable($("#grid_vendor_id").val());
  

})(window, document, window.jQuery);



$("#grid_vendor_id").change(function(){


  loaddatatable($(this).val());
    
});

function loaddatatable(vendor_id){

  if ( $.fn.dataTable.isDataTable( '#datatable4' ) ) {
      var old_table = $('#datatable4').dataTable();
      old_table.fnDestroy();
  }

  table = $('#datatable4').DataTable({
        'paging':   true,  // Table pagination
        'ordering': true,  // Column ordering
        'info':     true,  // Bottom left status text
        // 'responsive': true, // https://datatables.net/extensions/responsive/examples/
        "processing": true,
        "serverSide": true,
        'scrollX':        true,
        'scrollCollapse': true,
        // "autoWidth": false,
        // "autoWidth": false,
        sAjaxSource: '/api/getitemlist?vendor='+vendor_id,
        aoColumns: [
          { mData: 'id' },
          { mData: 'name' },
          { mData: 'asin' },
          { mData: 'vendorsku' },
          { mData: 'upc' },
          { mData: 'cost' },
          { mData: 'packcount' },
          { mData: 'packcost', render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
          { mData: 'buyboxprice' },
          { mData: 'profit'},
          { mData: 'margin'},
          { mData: 'fbafee' },
          { mData: 'commissionpct' },
          { mData: 'commissiionfee' },
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
    });

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

function deletevendoritems(){
  var vendor = $("#grid_vendor_id").val();
  var href =  '/vendoritems?delete_vendor='+vendor;
  window.location = href;
}
function initComplete () {
  // var r = $('#datatable_itemlist tfoot tr');
  // r.find('th').each(function(){
  //   $(this).css('padding', 10);
  // });
  // $('#datatable_itemlist thead').append(r);
  // $('#search_0').css('text-align', 'center');

  // $('#datatable_itemlist tfoot th').each( function () {
  //     var title = $(this).text();
  //     if(title != 'Margin' && title != 'Profit' || 1){
  //       $(this).html( '<input type="text" placeholder="'+title+'" />' );  
  //     }else{
  //       $(this).html( '');  
  //     }
      
  // } );

  // editor = new $.fn.DataTable.Editor( {
  //     ajax: "api/updatevendoritem",
  //     table: "#datatable_itemlist",
  //     idSrc:  'id',
  //     fields: [ {
  //             label: "Packcount",
  //             name: "packcount"
  //         }, {
  //             label: "COST",
  //             name: "cost"
  //         }
  //     ]
  // } );

  // Activate an inline edit on click of a table cell
 
  $('#datatable4 tfoot th').each( function (i) {
      // var title = $(this).text();
      // $(this).html( '<input type="text" placeholder="Search '+title+'" />' );
      var title = $('#datatable4 thead th').eq( $(this).index() ).text();
      if(title == 'EST'){
        $(this).html( '<input type="text" placeholder="Search '+title+'" data-index="'+i+'" name="'+title+'" id="txt_'+title+'"/><a class="btn btn-primary" href="javascript:showfilter(\''+title+'\')">'+'<em class="fa fa-search"></em>'+'</a>' );
      }else{
        $(this).html( '<input type="text" placeholder="Search '+title+'" data-index="'+i+'" />' );  
      }
  } );
}



