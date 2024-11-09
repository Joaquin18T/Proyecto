<?php

require_once '../models/ResponsableAct.php';

$respAct = new ResponsableAct();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($respAct->getAll());
      break;
    case 'getById':
      echo json_encode($respAct->getRespById(['idactivo_resp' => $_GET['idactivo_resp']]));
      break;
    case 'existeResponsable':
      $send = ['respuesta' => ''];
      $data = $respAct->existResponsable(['idactivo' => $_GET['idactivo']]);
      if ($data[0]['cantidad'] > 0) {
        $send['respuesta'] = 1;
      } else {
        $send['respuesta'] = -1;
      }
      echo json_encode($send);
      break;
    case 'maxColaboradores':
      echo json_encode($respAct->cantColaboradores(['idactivo' => $_GET['idactivo']]));
      break;
    case 'repeatAsignacion':
      echo json_encode($respAct->repeatAsignacion([
        'idactivo' => $_GET['idactivo'],
        'idusuario' => $_GET['idusuario']
      ]));
      break;
    case 'usersByActivo':
      echo json_encode($respAct->usersByActivo(['idactivo' => $_GET['idactivo']]));
      break;
    case 'showImages':
      echo json_encode($respAct->test(['idactivo_resp' => $_GET['idactivo_resp']]));
      break;
    case 'searchActivoResp':
      $valoresBuscar = [
        'idsubcategoria' => $_GET['idsubcategoria'] == "" ? null : $respAct->limpiarCadena($_GET['idsubcategoria']),
        'idubicacion' => $_GET['idubicacion'] == "" ? null : $respAct->limpiarCadena($_GET['idubicacion']),
        'cod_identificacion' => $_GET['cod_identificacion'] == "" ? null : $respAct->limpiarCadena($_GET['cod_identificacion'])
      ];
      echo json_encode($respAct->searchActivoResponsable($valoresBuscar));
      break;

    case 'filtrarActivosResponsablesAsignados':
      $valoresBuscar = [
        'idsubcategoria' => $_GET['idsubcategoria'] == "" ? null : $respAct->limpiarCadena($_GET['idsubcategoria']),
        'idubicacion' => $_GET['idubicacion'] == "" ? null : $respAct->limpiarCadena($_GET['idubicacion']),
        'cod_identificacion' => $_GET['cod_identificacion'] == "" ? null : $respAct->limpiarCadena($_GET['cod_identificacion'])
      ];
      echo json_encode($respAct->filtrarActivosResponsablesAsignados($valoresBuscar));
      break;

    case 'listRespActivo':
      echo json_encode($respAct->listResp_activo());
      break;
    case 'getResponasblePrin':
      $cleanData = [
        'idactivo_resp' => $respAct->limpiarCadena($_GET['idactivo_resp']),
        'idactivo' => $respAct->limpiarCadena($_GET['idactivo'])
      ];
      echo json_encode($respAct->getResponsablePrin($cleanData));
      break;
    case 'verificarExisteColaboradores':
      echo json_encode($respAct->verificarColaboradores(['idactivo' => $_GET['idactivo']]));
      break;
    case 'getIdResp':
      echo json_encode($respAct->getIdResp([
        'idactivo' => $_GET['idactivo'],
        'idusuario' => $_GET['idusuario']
      ]));
    case 'getAnyIdResp':
      //$resp = $respAct->getAnyIdResp(['idactivo'=>$_GET['idactivo']]);
      echo json_encode($respAct->getAnyIdResp(['idactivo' => $_GET['idactivo']]));
      break;
    case 'getAnyIdUbicacion':
      echo json_encode($respAct->getAnyIdUbicacion(['idactivo_resp' => $_GET['idactivo_resp']]));
      break;
    case 'getUsersActivoV2':
      echo json_encode($respAct->getUsersByActivoV2(['idactivo'=>$_GET['idactivo']]));
      break;
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $mensaje = ['idresp' => ''];
      $enviarDatos = [
        'idactivo' => $_POST['idactivo'],
        'idusuario' => $_POST['idusuario'],
        //'fecha_designacion'=>$_POST['fecha_designacion']==""?null:$_POST['fecha_designacion'],
        'condicion_equipo' => $_POST['condicion_equipo'],
        'imagenes' => $_POST['imagenes'],
        'descripcion' => $_POST['descripcion'],
        'autorizacion' => $_POST['autorizacion'],
        'solicitud' => $_POST['solicitud']
      ];
      $resp = $respAct->add($enviarDatos);
      if ($resp[0]['idresp'] > 0) {
        $mensaje['idresp'] = $resp[0]['idresp'];
      } else {
        $mensaje['idresp'] = -1;
      }
      echo json_encode($mensaje);
      break;
    case 'chooseResponsable':
      $estado = ['respuesta' => ''];
      $resp = $respAct->chooseResponsable(['idactivo_resp' => $_POST['idactivo_resp']]);
      if ($resp) {
        $estado['respuesta'] = 1;
      } else {
        $estado['respuesta'] = -1;
      }
      echo json_encode($estado);
      break;
    case 'updateAsignacion':
      $estado = ['respuesta' => -1];
      $cleanData = [
        'idactivo_resp' => $respAct->limpiarCadena($_POST['idactivo_resp']),
        'idactivo' => $respAct->limpiarCadena($_POST['idactivo']),
        'idusuario' => $respAct->limpiarCadena($_POST['idusuario']),
        'autorizacion' => $respAct->limpiarCadena($_POST['autorizacion'])
      ];
      $resp = $respAct->updateAsignacion($cleanData);
      if ($resp) {
        $estado['respuesta'] = 1;
      }
      echo json_encode($estado);
      break;
    case 'updateResponsableP':
      $estado = ['respuesta' => -1];
      $cleanData = [
        'idactivo_resp' => $respAct->limpiarCadena($_POST['idactivo_resp']),
        'idactivo' => $respAct->limpiarCadena($_POST['idactivo']),
        'idusuario' => $respAct->limpiarCadena($_POST['idusuario']),
        'es_responsable' => $respAct->limpiarCadena($_POST['es_responsable']),
        'autorizacion' => $respAct->limpiarCadena($_POST['autorizacion'])
      ];

      $resp = $respAct->updateChangePrincipal($cleanData);
      if ($resp) {
        $estado['respuesta'] = 1;
      }
      echo json_encode($estado);
      break;
  }
}
