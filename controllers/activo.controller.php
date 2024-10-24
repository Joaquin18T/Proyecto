  <?php

require_once '../models/Activo.php';

$activo = new Activo();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'searchDescripcion':
      echo json_encode($activo->searchbyDecripcion(['descripcion' => $_GET['descripcion']]));
      break;
    case 'searchByActivo':
      echo json_encode($activo->searchByActivo(['idactivo' => $_GET['idactivo']]));
      break;
    case 'repeatCode':
      echo json_encode($activo->repeatByCode(['cod_identificacion' => $_GET['cod_identificacion']]));
      break;
    case 'filterBySubcategoria':
      echo json_encode($activo->filterBySubcategoria(['idsubcategoria' => $_GET['idsubcategoria']]));
      break;
    case 'getAllFilters':
      $datosEnviar = [
        'idsubcategoria' => $_GET['idsubcategoria']==""?null:$_GET['idsubcategoria'],
        'cod_identificacion' => $_GET['cod_identificacion']==""?null:$_GET['cod_identificacion'],
        'fecha_adquisicion' => $_GET['fecha_adquisicion']==""?null:$_GET['fecha_adquisicion'],
        'fecha_adquisicion_fin' => $_GET['fecha_adquisicion_fin']==""?null:$_GET['fecha_adquisicion_fin'],
        'idestado' => $_GET['idestado']==""?null:$_GET['idestado'],
        'idmarca' => $_GET['idmarca']==""?null:$_GET['idmarca']
      ];
      echo json_encode($activo->listOfFilters($datosEnviar));
      break;
    case 'searchByUpdate':
      echo json_encode($activo->searchActivoByUpdate(['idactivo'=>$activo->limpiarCadena($_GET['idactivo'])]));
      break;
    case 'getById':
      echo json_encode($activo->getById(['idactivo'=>$activo->limpiarCadena($_GET['idactivo'])]));
      break;
    case 'searchActivoResp':
      echo json_encode($activo->searchActivoResp(['descripcion' => $_GET['descripcion']]));
      break;
    case 'searchActivoResponsable':
      $datosEnviar = [
        'idsubcategoria'  => $_GET['idsubcategoria']=="" ? null : $_GET['idsubcategoria'],
        'idubicacion' => $_GET['idubicacion']=="" ? null : $_GET['idubicacion'],
        'cod_identificacion' => $_GET['cod_identificacion']=="" ? null : $_GET['cod_identificacion']
      ];
      echo json_encode($activo->searchActivoResponsable($datosEnviar));
      break;
    case 'obtenerActivosPorTarea':
      echo json_encode($activo->obtenerActivosPorTarea(['idtarea' => $_GET['idtarea']]));
      break;
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $estado = [
        'idactivo' => ''
      ];
      $getDatos = [
        'idsubcategoria' => $_POST['idsubcategoria'],
        'idmarca' => $_POST['idmarca'],
        'modelo' => $_POST['modelo'],
        'cod_identificacion' => $_POST['cod_identificacion'],
        'fecha_adquisicion' => $_POST['fecha_adquisicion'],
        'descripcion' => $_POST['descripcion'],
        'especificaciones' => $_POST['especificaciones']
      ];
      $resp = $activo->add($getDatos);
      if ($resp> 0) {
        $estado['idactivo'] = $resp;
      } else {
        $estado['idactivo'] = -1;
      }
      echo json_encode($estado);
      break;
    case 'updateEstado':
      $data = ['respuesta' => -1];

      $datosEnviar = [
        'idactivo' => $activo->limpiarCadena($_POST['idactivo']),
        'idestado' => $activo->limpiarCadena($_POST['idestado'])
      ];

      $resp = $activo->updateEstado($datosEnviar);
      if ($resp) {
        $data['respuesta'] = 1;
      }
      echo json_encode($data);
      break;
    case 'updateActivo':
      $data = ['respuesta' => -1];

      $datosEnviar = [
        'idactivo' => $activo->limpiarCadena($_POST['idactivo']),
        'idsubcategoria' => $activo->limpiarCadena($_POST['idsubcategoria']),
        'idmarca' => $activo->limpiarCadena($_POST['idmarca']),
        'modelo' => $activo->limpiarCadena($_POST['modelo']),
        'cod_identificacion' => $activo->limpiarCadena($_POST['cod_identificacion']),
        'fecha_adquisicion' => $activo->limpiarCadena($_POST['fecha_adquisicion']),
        'descripcion' => $activo->limpiarCadena($_POST['descripcion']),
        'especificaciones' => $activo->limpiarCadena($_POST['especificaciones'])
      ];

      $resp = $activo->updateActivo($datosEnviar);
      if($resp){
        $data['respuesta']=1;
      }
      echo json_encode($data);
      break;
  }
}
