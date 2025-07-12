<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Content-Type: application/json");

include 'db_config.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Collect inputs safely
    $name = $_POST['name'] ?? '';
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    $phone = $_POST['phone'] ?? '';
    $dob = $_POST['dob'] ?? '';
    $gender = $_POST['gender'] ?? '';
    $blood_group = $_POST['blood_group'] ?? '';

    // Validate required fields
    if (empty($name) || empty($email) || empty($password) || empty($phone)) {
        echo json_encode(["success" => false, "message" => "Required fields are missing"]);
        exit;
    }

    // Prepare and insert
    $sql = "INSERT INTO submitted_data (name, email, password, phone, dob, gender, blood_group) 
            VALUES (?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssssss", $name, $email, $password, $phone, $dob, $gender, $blood_group);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Form submitted successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Database error: " . $conn->error]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["success" => false, "message" => "Invalid request"]);
}
?>
