$(document).ready(function(){
       console.log($('#get_info').val());
       $('#search-form').submit(function (e) {
                          e.preventDefault();
                          console.log($('#get_info').val());
                          $.ajax({
                              type: "POST",
                              contentType: "application/json",
                              url: '/search_info',
                              data: JSON.stringify({
                                          gene_id:  $('#get_info').val()
                                      }),
                              success: function (data) {
                                      $('#table').html(data.html);
                                    }
                             });
      });
});
