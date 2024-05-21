$(function () {
  //anonymous function and immediately invokes it
  function refresh() {
    //When the user inputs text into these elements, the refresh() function is called to update the table with filtered data
    let genre = $("#genre");
    let author = $("#author");
    $.getJSON(
      "showBooks.php",
      { genre: genre.val(), author: author.val() },
      function (json) {
        console.log(json);
        $("table tr:gt(0)").remove(); //remove all table rows except for the first row
        json.forEach(function (attribute) {
          $("table").append(`<tr>
          <td>${attribute[1]}</td>
          <td>${attribute[2]}</td>
          <td>${attribute[3]}</td>
          <td>${attribute[4]}</td>
          <td>${attribute[5]}</td>
          <td>
            <a href=updateBook.php?id=${attribute[0]}>Update</a>
            <br>
            <a href=deleteBook.php?id=${attribute[0]}>Delete</a>
            <br>
          </td>
             </tr>`);
        });
      }
    );
    $("#info").text(
      `the query has been done with the genre"${genre.val()}" and the author "${author.val()}"`
    );
  }
  $("#genre, #author").on("input", function () {
    refresh();
  });

  refresh();
});
