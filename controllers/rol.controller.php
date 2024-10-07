<?php
require_once '../models/Rol.php';

$rol = new Rol();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getAll':
      echo json_encode($rol->getAll());
      break;
    case 'getId':
      echo json_encode($rol->getByName(['rol'=>$_GET['rol']]));
      break;
  }
}