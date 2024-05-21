<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header('Content-Type: application/json');

require_once "utils/db.php";

$response = array("status" => "error", "message" => "Invalid request");

try {
    global $connection;
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = file_get_contents("php://input");
        $data = json_decode($input, true);

        if (json_last_error() === JSON_ERROR_NONE) {
            $id = $data['id'];
        } else {
            $id = $_POST['id'] ?? null;
        }

        if (!empty($id)) {
            $sql_query = "DELETE FROM book WHERE bookId=?";
            if ($stmt = $connection->prepare($sql_query)) {
                $stmt->bind_param("i", $id);

                if ($stmt->execute()) {
                    $response["status"] = "success";
                    $response["message"] = "Book deleted successfully";
                } else {
                    $response["message"] = "Database error: " . $stmt->error;
                }

                $stmt->close();
            } else {
                $response["message"] = "Database error: " . $connection->error;
            }
        } else {
            $response["message"] = "Missing required fields";
        }
    }
} catch (Exception $e) {
    $response["message"] = "Error: " . $e->getMessage();
}

$connection->close();

echo json_encode($response);