<?php
require_once "utils/db.php";
global $connection;
$id = "";
$author = "";
$title = "";
$pages = "";
$genre = "";
$is_lent = "";
if (isset($_GET['id']) && !empty(trim($_GET['id']))) {
    $id = trim($_GET['id']);
    $sql_query = "select * from book where bookId = $id;";
    $result = mysqli_query($connection, $sql_query);
    if ($result) {
        $number_of_rows = mysqli_num_rows($result);
        if ($number_of_rows == 1) {
            $row = mysqli_fetch_array($result);
            $author = $row['author'];
            $title = $row['title'];
            $pages = $row['pages'];
            $genre = $row['genre'];
            $is_lent = $row['is_lent'];
        } else {
            die("Incorrect book id");
        }
    } else {
        die("Something went wrong and the book cannot be updated!");
    }
    mysqli_close($connection);
} else
    die("Something went wrong and the book cannot be updated!");
?>

<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Update Book</title>
    <style>
        <?php include "addBook.css" ?>
    </style>
</head>

<body>
    <div class="container">
        <h1>Update Book</h1>
        <p><b>Please fill this form and submit to update the user in the database.</b></p>

        <form action="updateBookBackend.php" method="post">
            <input type="hidden" name="id" value="<?php echo trim($_GET['id']); ?>">
            <input type="text" name="author" placeholder="Author:" value="<?php echo $author ?>"> <br>
            <input type="text" name="title" placeholder="Title:" value="<?php echo $title ?>"> <br>
            <input type="number" name="pages" placeholder="Pages:" value="<?php echo $pages ?>"> <br>
            <input type="text" name="genre" placeholder="Genre:" value="<?php echo $genre ?>"> <br>
            <input type="text" name="is_lent" placeholder="Is lent (true or false):" value="<?php echo $is_lent ?>">
            <br>
            <div class="button_container">
                <button type="submit">Update Book</button>
                <button type="reset" onclick="window.location.href='showBooks.html'">Cancel</button>
            </div>
        </form>
    </div>
</body>

</html>