<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header('Content-Type: application/json');

require_once "utils/db.php";

$response = array("status" => "error", "message" => "Invalid request");

try {
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(200);
        exit();
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = file_get_contents("php://input");
        $data = json_decode($input, true);

        error_log("Received data: " . print_r($data, true)); // Log received data

        if (json_last_error() === JSON_ERROR_NONE) {
            $bookId = $data['bookId'] ?? null;
            $author = $data['author'] ?? null;
            $title = $data['title'] ?? null;
            $pages = $data['pages'] ?? null;
            $genre = $data['genre'] ?? null;
            $is_lent = $data['is_lent'] ?? null;

            // Log extracted fields
            error_log("bookId: $bookId, author: $author, title: $title, pages: $pages, genre: $genre, is_lent: $is_lent");
        } else {
            error_log("JSON decode error: " . json_last_error_msg());
            $bookId = $_POST['bookId'] ?? null;
            $author = $_POST['author'] ?? null;
            $title = $_POST['title'] ?? null;
            $pages = $_POST['pages'] ?? null;
            $genre = $_POST['genre'] ?? null;
            $is_lent = $_POST['is_lent'] ?? null;
        }

        if (!empty($bookId) && !empty($author) && !empty($title) && !empty($pages) && !empty($genre) && isset($is_lent)) {
            global $connection;
            if ($connection) {
                $sql_query = "UPDATE book SET author=?, title=?, pages=?, genre=?, is_lent=? WHERE bookId=?";
                if ($stmt = $connection->prepare($sql_query)) {
                    $stmt->bind_param("ssissi", $author, $title, $pages, $genre, $is_lent, $bookId);

                    if ($stmt->execute()) {
                        $response["status"] = "success";
                        $response["message"] = "Book updated successfully";
                        http_response_code(200);
                    } else {
                        $response["message"] = "Database error: " . $stmt->error;
                        http_response_code(500);
                    }

                    $stmt->close();
                } else {
                    $response["message"] = "Database error: " . $connection->error;
                    http_response_code(500);
                }
            } else {
                $response["message"] = "Database connection error.";
                http_response_code(500);
            }
        } else {
            $response["message"] = "Missing or invalid required fields";
            http_response_code(400);
        }
    } else {
        $response["message"] = "Invalid request method";
        http_response_code(405);
    }
} catch (Exception $e) {
    $response["message"] = "Error: " . $e->getMessage();
    http_response_code(500);
}

$connection->close();

echo json_encode($response);
