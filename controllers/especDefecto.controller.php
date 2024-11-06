<?php

require_once '../models/EspecDefecto.php';

$especDefecto = new EspecDefecto();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getEspecificaciones':
      $especificaciones = $especDefecto->getEspecificaciones(['idsubcategoria'=>$_GET['idsubcategoria']]);
      $decodificar = json_decode($especificaciones[0]['especificaciones']);
      echo json_encode($decodificar);
      break;
  }
}