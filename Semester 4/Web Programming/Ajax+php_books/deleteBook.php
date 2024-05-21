<!DOCTYPE html>

<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Delete Book</title>
    <link rel="stylesheet" type="text/css" href="deleteBook.css">
</head>

<body>
    <h1>Delete Book</h1>

    <div class="container">
        <p><b>Are you sure you want to delete this book?</b></p>

        <form action="deleteBookBackend.php" method="post">
            <input type="hidden" name="id" value="<?php echo trim($_GET['id']); ?>">
            <button type="submit" class="yes">YES</button>
        </form>
        <button class="no" onclick="window.location.href='showBooks.html'">
            NO
        </button>
    </div>
</body>

</html>