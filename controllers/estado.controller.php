<?php

require_once '../models/Estado.php';

$estado = new Estado();

header("Content-type: application/json; charset=utf-8");

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getAllByActivo':
      echo json_encode($estado->getAllByActivo());
      break;
    case 'estadoByRange':
      $params=[
        'menor'=>$estado->limpiarCadena($_GET['menor']),
        'mayor'=>$estado->limpiarCadena($_GET['mayor']),
      ];
      echo json_encode($estado->estadoByRange($params));
      break;
  }
}