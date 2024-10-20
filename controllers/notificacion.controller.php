<?php

require_once '../models/Notificacion.php';

$notificacion = new Notificacion();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'listNotf':
      $cleanData = [
        'idusuario'=>$_GET['idusuario']==""?null:$_GET['idusuario'],
        'idnotificacion'=>$_GET['idnotificacion']==""?null:$_GET['idnotificacion']
      ];
      echo json_encode($notificacion->listNotifications($cleanData));
      break;
    case 'detalleNotf':
      $clearData = [
        'idusuario'=>$notificacion->limpiarCadena($_GET['idusuario']),
        'idactivo_resp'=>$notificacion->limpiarCadena($_GET['idactivo_resp'])
      ];
      echo json_encode($notificacion->detalleNotificaciones($clearData));
      break;
    case 'dataRespNotf':
      $cleanData = $notificacion->limpiarCadena($_GET['idusuario']);
      echo json_encode($notificacion->dataRespNotificacion(['idusuario'=>$cleanData]));
  }
}

if(isset($_POST['operation'])){
  switch($_POST['operation']){
    case 'add':
      $estado=['respuesta'=>0];
      $datosEnviar=[
        'idusuario'=>$_POST['idusuario'],
        'tipo'=>$_POST['tipo'],
        'mensaje'=>$_POST['mensaje']
      ];
      $resp = $notificacion->add($datosEnviar);
      if($resp){
        $estado['respuesta']=1;
      }else{
        $estado['respuesta']=-1;
      }
      echo json_encode($estado);
      break;
  }
}