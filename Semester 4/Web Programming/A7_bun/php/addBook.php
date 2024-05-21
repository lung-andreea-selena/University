<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header('Content-Type: application/json');

$response = array("status" => "error", "message" => "Invalid request");

try {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $postdata = file_get_contents("php://input");
        $data = json_decode($postdata, true);

        if (json_last_error() === JSON_ERROR_NONE) {
            $author = $data['author'];
            $title = $data['title'];
            $pages = $data['pages'];
            $genre = $data['genre'];
            $is_lent = $data['is_lent'];

            // Check if all required fields are present
            if (!empty($author) && !empty($title) && !empty($pages) && !empty($genre) && isset($is_lent)) {
                require_once "utils/db.php";

                // Prepare and execute the SQL query
                $sql_query = "INSERT INTO book(author, title, pages, genre, is_lent) VALUES (?, ?, ?, ?, ?)";
                global $connection;
                if ($stmt = $connection->prepare($sql_query)) {
                    $stmt->bind_param("ssiss", $author, $title, $pages, $genre, $is_lent);

                    if ($stmt->execute()) {
                        $response["status"] = "success";
                        $response["message"] = "Book inserted successfully";
                    } else {
                        $response["message"] = "Database error: " . $stmt->error;
                    }

                    $stmt->close();
                } else {
                    $response["message"] = "Database error: " . $connection->error;
                }

                mysqli_close($connection);
            } else {
                $response["message"] = "Missing required fields";
            }
        } else {
            $response["message"] = "Invalid JSON data";
        }
    }
} catch (Exception $e) {
    $response["message"] = "Error: " . $e->getMessage();
}

echo json_encode($response);