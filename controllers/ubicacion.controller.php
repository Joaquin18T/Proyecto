<?php
require_once '../models/Ubicacion.php';
$ubi = new Ubicacion();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getAll':
      echo json_encode($ubi->getAll());
      break;
    case 'getUbiExcept':
      echo json_encode($ubi->getUbiExcep(['idubicacion'=>$_GET['idubicacion']]));
      break;
  }

}