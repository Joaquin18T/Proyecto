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
        'idactivo_resp'=>$_POST['idactivo_resp']==""?null:$_POST['idactivo_resp'],
        'idubicacion'=>$_POST['idubicacion'],
        'accion'=>$_POST['accion']==""?null:$_POST['accion'],
        'responsable_accion'=>$_POST['responsable_accion']==""?null:$_POST['responsable_accion'],
        'idactivo'=>$_POST['idactivo']==""?null:$_POST['idactivo'],
      ];
      $valor = $historialAc->add($enviarDatos);
      if($valor>0){
        $response['mensaje']=$valor;
      }else{
        $response['mensaje']=-1;
      }
      echo json_encode($response);
      break;
  }
}