<?php
require_once "utils/db.php";
global $connection;
if (isset($_POST['id']) && !empty(trim($_POST['id']))) {
    $id = trim($_POST['id']);
    $sql_query = "delete from book where bookId='$id';";
    $result = mysqli_query($connection, $sql_query);
    if ($result) {
        echo "Your book was deleted successfully!";
        header("Location: showBooks.html");
    } else {
        echo "Something went wrong and your book was not deleted";
    }
}
mysqli_close($connection);