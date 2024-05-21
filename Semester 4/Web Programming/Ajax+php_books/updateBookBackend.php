<?php
require_once "utils/db.php";
$bookId = $_POST['id'];
$author = $_POST['author'];
$title = $_POST['title'];
$pages = $_POST['pages'];
$genre = $_POST['genre'];
$is_lent = $_POST['is_lent'];
$sql_query = "update book set author='$author', title='$title',pages='$pages',genre='$genre',is_lent='$is_lent' where bookId=$bookId";
global $connection;
$result = mysqli_query($connection, $sql_query);
if ($result) {
    echo "Your book was updated successfully!";
    header("Location: showBooks.html");
} else {
    echo "Something went wrong, could not update";
}
mysqli_close($connection);