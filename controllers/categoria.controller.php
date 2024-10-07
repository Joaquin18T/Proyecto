<?php
require_once '../models/Categoria.php';

$categoria = new Categoria();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getCategoria':
      echo json_encode($categoria->getAll());
      break;
  }
}