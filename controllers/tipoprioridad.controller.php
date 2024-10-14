<?php

require_once '../models/Tipoprioridad.php';

$tipoprioridad = new Tipoprioridad();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($tipoprioridad->getAll());
      break;
    
  }
}
