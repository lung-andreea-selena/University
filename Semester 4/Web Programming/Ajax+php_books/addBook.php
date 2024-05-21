<?php
require_once "utils/db.php";
$author = $_POST['author'];
$title = $_POST['title'];
$pages = $_POST['pages'];
$genre = $_POST['genre'];
$is_lent = $_POST['is_lent'];
$sql_query = "insert into book(author,title,pages,genre,is_lent) values ('$author','$title','$pages','$genre','$is_lent')";
global $connection;
$result = mysqli_query($connection, $sql_query);
if ($result) {
    echo "Book added successfully!";
    header("Location:showBooks.html");
} else {
    echo "Something went wrong and your book can not be added";
}
mysqli_close($connection);