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
      echo json_encode($ordentrabajo->obtenerTareasOdt());
      break;

    case 'obtenerDetalleOdt':
      echo json_encode($ordentrabajo->obtenerDetalleOdt(["idordentrabajo" => $_GET['idordentrabajo']]));
      break;


    case 'obtenerOdtporId':
      echo json_encode($ordentrabajo->obtenerOdtporId(["idodt" => $_GET['idodt']]));
      break;

    case 'obtenerHistorialOdt':
      echo json_encode($ordentrabajo->obtenerHistorialOdt());
      break;

    case 'obtenerIdsUsuariosOdt':
      echo json_encode($ordentrabajo->obtenerIdsUsuariosOdt());
      break;
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $id = -1;
      $datosEnviar = [
        "idtarea"   => $_POST["idtarea"],
        "creado_por"     => $_POST["creado_por"],
        "fecha_inicio"              => $_POST["fecha_inicio"],
        "hora_inicio"               => $_POST["hora_inicio"]
      ];

      $id = $ordentrabajo->add($datosEnviar);
      echo json_encode(["id" => $id]);
      break;

    case 'registrarDetalleOdt':
      $id = -1;
      $datosEnviar = [
        "idodt"             => $_POST["idodt"],
        "intervalos_ejecutados" => $_POST["intervalos_ejecutados"],
        "clasificacion"     => $_POST["clasificacion"]
      ];

      $id = $ordentrabajo->registrarDetalleOdt($datosEnviar);
      echo json_encode(["id" => $id]);
      break;

    case 'registrarHistorialOdt':
      $id = -1;
      $datosEnviar = [
        "idodt"             => $_POST["idodt"]
      ];

      $id = $ordentrabajo->registrarHistorialOdt($datosEnviar);
      echo json_encode(["id" => $id]);
      break;

    case 'registrarComentarioOdt':
      $datosEnviar = [
        "idodt"             => $_POST["idodt"],
        "comentario"        => $_POST["comentario"],
        "revisadopor"       => $_POST["revisadopor"]
      ];

      $registrado = $ordentrabajo->registrarComentarioOdt($datosEnviar);
      echo json_encode(["registrado" => $registrado]);
      break;

    case 'actualizarBorradorOdt':
      $datosEnviar = [
        "idordentrabajo"   => $_POST["idordentrabajo"],
        "borrador"     => $_POST["borrador"]
      ];

      $actualizado = $ordentrabajo->actualizarBorradorOdt($datosEnviar);
      echo json_encode(["actualizado" => $actualizado]);
      break;

    case 'actualizarEstadoOdt':
      $datosEnviar = [
        "idodt"   => $_POST["idodt"],
        "idestado"     => $_POST["idestado"]
      ];

      $actualizado = $ordentrabajo->actualizarEstadoOdt($datosEnviar);
      echo json_encode(["actualizado" => $actualizado]);
      break;

    case 'actualizarDetalleOdt':
      $datosEnviar = [
        "iddetalleodt"          => $_POST["iddetalleodt"],
        "fechafinal"            => $_POST["fechafinal"],
        "tiempoejecucion"       => $_POST["tiempoejecucion"],
        "intervalos_ejecutados" => $_POST["intervalos_ejecutados"],
        "clasificacion"         => $_POST["clasificacion"],
      ];

      $actualizado = $ordentrabajo->actualizarDetalleOdt($datosEnviar);
      echo json_encode(["actualizado" => $actualizado]);
      break;

    case 'actualizarFechaFinalOdt':
      $datosEnviar = [
        "idodt"          => $_POST["idodt"],
        "fechafinal"            => $_POST["fechafinal"],
        "horafinal"       => $_POST["horafinal"]
      ];

      $actualizado = $ordentrabajo->actualizarFechaFinalOdt($datosEnviar);
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
