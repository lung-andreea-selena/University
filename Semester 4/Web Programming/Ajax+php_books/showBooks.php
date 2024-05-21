<?php
require_once 'utils/db.php';
$sql_query = "SELECT * FROM book;";
global $connection;
$result = mysqli_query($connection, $sql_query);
if ($result) {
    $number_rows = mysqli_num_rows($result);
    $requested_books = array();
    $genre = $_GET["genre"];
    $author = $_GET["author"];
    for ($i = 0; $i < $number_rows; $i++) {
        $row = mysqli_fetch_array($result);
        if (str_contains($row["genre"], $genre) && str_contains($row["author"], $author)) {
            array_push($requested_books, array($row['bookId'], $row['author'], $row['title'], $row['pages'], $row['genre'], $row['is_lent']));
        }
    }
    mysqli_free_result($result); // Frees the memory associated with the query result
    echo json_encode($requested_books);//Converts the $requested_users array to a JSON string and outputs. it will be used as the response data.
}
mysqli_close($connection);