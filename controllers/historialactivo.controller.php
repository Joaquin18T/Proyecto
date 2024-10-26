<?php

require_once '../models/HistorialActivo.php';

$historialAc = new HistorialActivo();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'ubiByActivo':
      echo json_encode($historialAc->ubicacionByActivo([
        'idactivo'=>$_GET['idactivo'],
        'idactivo_resp'=>$_GET['idactivo_resp']
      ]));
      break;
    case 'getUbiOnlyActivo':
      echo json_encode($historialAc->getUbicacionByOnlyActivo(['idactivo'=>$_GET['idactivo']]));
      break;
  }
}

if(isset($_POST['operation'])){
  switch($_POST['operation']){
    case 'add':
      $response = [
        'mensaje'=>''
      ];
      $enviarDatos=[
        'idactivo_resp'=>$_POST['idactivo_resp'],
        'idubicacion'=>$_POST['idubicacion']
      ];
      $valor = $historialAc->add($enviarDatos);
      if($valor){
        $response['mensaje']="Historial guardado";
      }else{
        $response['mensaje']="Hubo un error";
      }
      echo json_encode($response);
      break;
  }
}