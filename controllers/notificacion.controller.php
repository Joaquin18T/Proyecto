<?php

require_once '../models/NotificacionActivo.php';

$notificacion = new Notificacion();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'listNotf':
      $cleanData = [
        'idusuario' => $_GET['idusuario'] == "" ? null : $_GET['idusuario']
      ];
      echo json_encode($notificacion->listNotifications($cleanData));
      break;
    case 'detalleAsignacion':
      $clearData = [
        'idnotificacion' => $notificacion->limpiarCadena($_GET['idnotificacion'])
      ];
      echo json_encode($notificacion->detalleAsignacionNotf($clearData));
      break;
    case 'dataRespNotf':
      $cleanData = $notificacion->limpiarCadena($_GET['idusuario']);
      echo json_encode($notificacion->dataRespNotificacion(['idusuario' => $cleanData]));
      break;

    case 'buscarNotificacionPorOdt':
      $cleanData = $notificacion->limpiarCadena($_GET['idodt']);
      echo json_encode($notificacion->buscarNotificacionPorOdt(['idodt' => $cleanData]));
      break;

    case 'listNotificationsMantenimiento':
      $cleanData = $notificacion->limpiarCadena($_GET['idusuario']);
      echo json_encode($notificacion->listNotificationsMantenimiento(['idusuario' => $cleanData]));
      break;
    case 'detalleBajaActivo':
      $clearData = [
        'idnotificacion' => $notificacion->limpiarCadena($_GET['idnotificacion'])
      ];
      echo json_encode($notificacion->NotifiDetalleBajaActivo($clearData));
      break;
    case 'detalleDesignacion':
      $clearData = [
        'idnotificacion' => $notificacion->limpiarCadena($_GET['idnotificacion'])
      ];
      echo json_encode($notificacion->detalleAsignacionNotf($clearData));
      break;
    case 'detalleUbicacion':
      $clearData = [
        'idnotificacion' => $notificacion->limpiarCadena($_GET['idnotificacion'])
      ];
      echo json_encode($notificacion->detalleUbicacionNoft($clearData));
      break;
    case 'detalleResponsableP':
      $clearData = [
        'idnotificacion' => $notificacion->limpiarCadena($_GET['idnotificacion'])
      ];
      echo json_encode($notificacion->detalleResponsablePNoft($clearData));
      break;
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $estado = ['respuesta' => 0];
      $datosEnviar = [
        'idactivo_resp' => $_POST['idactivo_resp'] == "" ? null : $_POST['idactivo_resp'],
        'tipo' => $_POST['tipo'],
        'mensaje' => $_POST['mensaje'],
        'idactivo' => $_POST['idactivo'] == "" ? null : $_POST['idactivo']
      ];
      $resp = $notificacion->add($datosEnviar);
      if ($resp) {
        $estado['respuesta'] = 1;
      } else {
        $estado['respuesta'] = -1;
      }
      echo json_encode($estado);
      break;

    case 'agregarNotificacionOdt':
      $datosEnviar = [
        'idodt'         => $_POST['idodt'],
        'tarea'         => $_POST['tarea'],
        'activos'       => $_POST['activos'],
        'idresp'        => $_POST['idresp'],
        'mensaje'       => $_POST['mensaje']
      ];
      $id = $notificacion->agregarNotificacionOdt($datosEnviar);
      echo json_encode(["id" => $id]);
      break;
  }
}




// $clearData = [
//   'idnotificacion' => $notificacion->limpiarCadena($_GET['idnotificacion'])
// ];
// echo json_encode($notificacion->NotifiDetalleBajaActivo($clearData));
// break;


// $clearData = [
//   'accion_responsable' => $notificacion->limpiarCadena($_GET['accion_responsable'])
// ];
// echo json_encode($notificacion->listNof_wh_IdactivoResp($clearData));
// break;


// $clearData = [
//   'idnotificacion' => $notificacion->limpiarCadena($_GET['idnotificacion'])
// ];
// echo json_encode($notificacion->detalleNof_wh_IdactivoResp($clearData));
// break;
