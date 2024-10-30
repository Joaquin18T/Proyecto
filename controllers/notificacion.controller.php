<?php

require_once '../models/NotificacionActivo.php';

$notificacion = new Notificacion();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'listNotf':
      $cleanData = [
        'idusuario'=>$_GET['idusuario']==""?null:$_GET['idusuario']
      ];
      echo json_encode($notificacion->listNotifications($cleanData));
      break;
    case 'detalleNotf':
      $clearData = [
        'idnotificacion'=>$notificacion->limpiarCadena($_GET['idnotificacion'])
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
        'idactivo_resp'=>$_POST['idactivo_resp']==""?null:$_POST['idactivo_resp'],
        'tipo'=>$_POST['tipo'],
        'mensaje'=>$_POST['mensaje'],
        'idactivo'=>$_POST['idactivo']==""?null:$_POST['idactivo']
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