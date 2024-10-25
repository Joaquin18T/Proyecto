<?php

require_once '../models/OrdenTrabajo.php';

$ordentrabajo = new OrdenTrabajo();

// CAMBIAR TODO DESDE AAca

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'obtenerTareaDeOdtGenerada':
      echo json_encode($ordentrabajo->obtenerTareaDeOdtGenerada(["idodt" => $_GET['idodt']]));
      break;

    case 'obtenerTareasOdt':
      echo json_encode($ordentrabajo->obtenerTareasOdt(["borrador" => $_GET['borrador']]));
      break;

    case 'obtenerDetalleOdt':
      echo json_encode($ordentrabajo->obtenerDetalleOdt(["idordentrabajo" => $_GET['idordentrabajo']]));
      break;
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $id = -1;
      $datosEnviar = [
        "idtarea"   => $_POST["idtarea"],
        "creado_por"     => $_POST["creado_por"]
      ];

      $id = $ordentrabajo->add($datosEnviar);
      echo json_encode(["id" => $id]);
      break;

    case 'registrarDetalleOdt':
      $id = -1;
      $datosEnviar = [
        "idodt"             => $_POST["idodt"],
        "clasificacion"     => $_POST["clasificacion"]
      ];

      $id = $ordentrabajo->registrarDetalleOdt($datosEnviar);
      echo json_encode(["id" => $id]);
      break;

    case 'actualizarBorradorOdt':
      $datosEnviar = [
        "idordentrabajo"   => $_POST["idordentrabajo"],
        "borrador"     => $_POST["borrador"]
      ];

      $actualizado = $ordentrabajo->actualizarBorradorOdt($datosEnviar);
      echo json_encode(["actualizado" => $actualizado]);
      break;

    case 'actualizarDetalleOdt':
      $datosEnviar = [
        "iddetalleodt"      => $_POST["iddetalleodt"],
        "fechafinal"        => $_POST["fechafinal"],
        "tiempoejecucion"   => $_POST["tiempoejecucion"],
        "clasificacion"     => $_POST["clasificacion"],
      ];

      $actualizado = $ordentrabajo->actualizarDetalleOdt($datosEnviar);
      echo json_encode(["actualizado" => $actualizado]);
      break;

    case 'eliminarOdt':
      $path = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : '/';

      $idEliminar = explode("/", $path);
      $idordentrabajo = ($path != '/') ? end($idEliminar) : null;
      $eliminado = $ordentrabajo->eliminarOdt(["idordentrabajo" => $idordentrabajo]);
      echo json_encode(["eliminado" => $eliminado]);
      break;
  }
}
