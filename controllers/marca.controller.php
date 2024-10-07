<?php

require_once '../models/Marca.php';

$marca = new Marca();
header("Content-Type: application/json");
$verbo = $_SERVER["REQUEST_METHOD"]; 

switch($verbo){
  case 'GET':
    if($_GET['operation']){
      switch($_GET['operation']){
        case 'getAll':
          echo json_encode($marca->getAll());
          break;
      }
    }    
    break;
}

