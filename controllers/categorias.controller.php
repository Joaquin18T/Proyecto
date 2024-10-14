<?php

require_once '../models/Categoria.php';

$categoria = new Categoria();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($categoria->getAll());
      break;
    
  }
}
