<?php

require_once '../models/SubCategoria.php';

$sub = new SubCategoria();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getSubCategoria':
      echo json_encode($sub->getAll());
      break;
    case 'getMarcasBySubcategoria':
      $cleandData = $sub->limpiarCadena($_GET['idsubcategoria']);
      echo json_encode($sub->getMarcasBySubcategoria(['idsubcategoria'=>$cleandData]));
      break;
  }
}