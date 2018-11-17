

//--- jqGrid
//= require jqgrid/js/jquery.jqGrid.min.js
//= require jqgrid/js/i18n/grid.locale-en.js

//--- Datatables
//= require datatables/media/js/jquery.dataTables.min
//= require datatables-colvis/js/dataTables.colVis
//= require datatables/media/js/dataTables.bootstrap
//= require datatables/media/js/dataTables.editor.min
//= require datatables/media/js/dataTables.select.min

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


var editor; // use a global for the submit and return data rendering in the examples

(function(window, document, $, undefined){

  $(function(){

    loaddatatable(vendor_id);
 
    
  });

})(window, document, window.jQuery);

$("#vendor_id").change(function(){

  loaddatatable(vendor);
    
});


function loaddatatable(vendor_id){

  if ( $.fn.dataTable.isDataTable( '#datatable_itemlist' ) ) {
      table = $('#datatable_itemlist').DataTable();
      table.destory();
  }

  initComplete();
  

  var table = $('#datatable_itemlist').DataTable({
        dom: "Bfrtip",
        destroy: true,
        'paging':   true,  // Table pagination
        'ordering': true,  // Column ordering
        'info':     true,  // Bottom left status text
        // 'responsive': true, // https://datatables.net/extensions/responsive/examples/
        // "bPaginate": true,
        "iDisplayLength" : 10,
        "processing": true,
        "serverSide": true,
        "scrollX": true,
        fixedColumns:   true,
        sAjaxSource: '/api/getitemlist?vendor='+vendor_id,
        aoColumns: [
          // {
          //       mdata: null,
          //       defaultContent: '',
          //       className: 'select-checkbox',
          //       orderable: false
          //   },
          { mData: 'id' },
          { mData: 'name' },
          { mData: 'asin' },
          { mData: 'vendorsku' },
          { mData: 'upc' },
          { mData: 'cost' ,render: $.fn.dataTable.render.number( ',', '.', 2, '$' )},
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
          { mData: 'fbmoffers' },
        ],
        columnDefs: [
          { orderable: false, targets: [0] }
        ],
        "order": [[ 1, "asc" ]],
        "createdRow": function(row, data, dataIndex){
          //$('td:eq(1)', row).css('min-width', '200px');
        },
        sDom:      'C<"clear">lfrtip',
        colVis: {
            order: 'alfa',
            'buttonText': 'Show/Hide Columns'
        },
        select: {
            style:    'os',
            selector: 'td:first-child'
        },
        buttons: [
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    });

    // Apply the search
    // table.columns().every( function () {
    //     var that = this;
    //     $( 'input', this.header() ).on( 'keyup change', function () {
    //         console.log('asd');
    //         if ( that.search() !== this.value ) {
    //             that
    //                 .search( this.value )
    //                 .draw();
    //         }
    //     } );
    // } );
    $("#datatable_itemlist_wrapper thead input").on('keyup change', function() {
        table
            .column($(this).parent().index() + ':visible')
            .search(this.value)
            .draw();
    });

     $('#datatable_itemlist').on( 'click', 'tbody td:not(:first-child)', function (e) {
      editor.inline( this );
      // editor.bubble( this );
  } );


}

function initComplete () {
  // var r = $('#datatable_itemlist tfoot tr');
  // r.find('th').each(function(){
  //   $(this).css('padding', 10);
  // });
  // $('#datatable_itemlist thead').append(r);
  // $('#search_0').css('text-align', 'center');

  $('#datatable_itemlist #table_search_row th:not(:first-child)').each( function () {
      var title = $(this).text();
      if(title != 'Margin' && title != 'Profit' || 1){
        $(this).html( '<input type="text" placeholder="'+title+'" />' );  
      }else{
        $(this).html( '');  
      }
      
  } );
  
  editor = new $.fn.DataTable.Editor( {
      ajax: "api/updatevendoritem",
      table: "#datatable_itemlist",
      idSrc:  'id',
      fields: [ {
              label: "Packcount",
              name: "packcount"
          }, {
              label: "COST",
              name: "cost"
          }
      ]
  } );

  // Activate an inline edit on click of a table cell
 
}


// if ( $.fn.dataTable.isDataTable( '#datatable_itemlist' ) ) {
  //     table = $('#datatable_itemlist').DataTable();
  //     table.destory();
  // }

  /*
  var table = $('#datatable_itemlist').DataTable({
        // 'paging':   true,  // Table pagination
        'ordering': true,  // Column ordering
        'info':     true,  // Bottom left status text
        'responsive': true, // https://datatables.net/extensions/responsive/examples/
        "iDisplayLength" : 10,
        "processing": true,
        "serverSide": true,
        sAjaxSource: '/api/getitemlist?vendor='+vendor_id,
        aoColumns: [
          // {
          //       mdata: null,
          //       defaultContent: '',
          //       className: 'select-checkbox',
          //       orderable: false
          //   },
          { mData: 'id' },
          { mData: 'name' },
          { mData: 'asin' },
          { mData: 'vendorsku' },
          { mData: 'upc' },
          { mData: 'cost' ,render: $.fn.dataTable.render.number( ',', '.', 2, '$' )},
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
          { mData: 'fbmoffers' },
        ],
        // columnDefs: [
        //   { orderable: false, targets: [0] }
        // ],
        // "order": [[ 1, "asc" ]],
        // "createdRow": function(row, data, dataIndex){
        //   //$('td:eq(1)', row).css('min-width', '200px');
        // },
        // sDom:      'C<"clear">lfrtip',
        
        // select: {
        //     style:    'os',
        //     selector: 'td:first-child'
        // },
        // buttons: [
            // {extend: 'colvis', text:"Columns"},
            // { extend: "create", editor: editor },
            // { extend: "edit",   editor: editor },
            // { extend: "remove", editor: editor }
        // ]
    });

    // Apply the search
    // table.columns().every( function () {
    //     var that = this;
    //     $( 'input', this.footer() ).on( 'keyup change', function () {
    //         if ( that.search() !== this.value ) {
    //             that
    //                 .search( this.value )
    //                 .draw();
    //         }
    //     } );
    // } );

  
     $('#datatable_itemlist').on( 'click', 'tbody td:not(:first-child)', function (e) {
      // editor.inline( this );
      // editor.bubble( this );
    } );
    */

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
