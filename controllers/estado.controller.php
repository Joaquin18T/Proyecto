<?php

require_once '../models/Estado.php';

$estado = new Estado();

header("Content-type: application/json; charset=utf-8");

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getAll':
      echo json_encode($estado->getAll());
      break;
  }
}