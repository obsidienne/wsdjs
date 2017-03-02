//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
import glMenubar from './shared/gl_menubar';
import glSearch from './shared/gl_search';

export default class MainView {
  // This will be executed when the document loads...
  mount() {
    new glMenubar().mount();
    new glSearch().mount();
    this._intlDate()

    console.log('MainView mounted');
  }

  _intlDate() {
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);

    var elements = document.querySelectorAll("time");
    for (let i = 0; i < elements.length; i++) {
      let datetime = Date.parse(elements[i].getAttribute("datetime"))
      elements[i].textContent = dateTimeFormat.format(datetime);
    }
  }
}

/*
App.Votes = function() {
  hideOrShowDropRow();

  $("#new_rankuser").on("submit", function(e) {
    $('#rankuser-top10 tbody tr:not(.count-excluded)').each(function(index, elem) {
      $('<input type="hidden" name="rank[]" value="">').val($(this).data('id')).appendTo($("#new_rankuser"));
    });
  });

  $( "#rankuser-songs, #rankuser-top10" ).disableSelection();

  $('#rankuser-songs tbody').sortable({
    handle: '.handle',
    connectWith: "tbody",
    stop: function(ev, ui){
      if ($("#rankuser-top10 tbody").find("tr").length > 11) {
        $(this).sortable("cancel");
      }
    },
    receive: function(event, ui) {
      $(this).find("tbody").append(ui.item);
      hideOrShowDropRow();
    }
  });

  $( "#rankuser-top10 tbody" ).sortable({
    connectWith: "tbody",
    handle: '.handle',
    receive: function(event, ui) {
      $(this).find("tbody").append(ui.item);
      hideOrShowDropRow();
    }
  });

  function hideOrShowDropRow() {
    $("#rankuser-top10").each(function() {
        var dropRow = $(this).find(".drop-row"),
            hasRows = $(this).find("tbody tr").length;

        hasRows > 1 ? dropRow.hide() : dropRow.show();
    });
  }
};


$(document).on("page:change", function() {
  return App.Votes();
});

*/
