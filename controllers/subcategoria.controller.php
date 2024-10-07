<?php

require_once '../models/SubCategoria.php';

$sub = new SubCategoria();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getSubCategoria':
      echo json_encode($sub->getAll());
      break;
  }
}