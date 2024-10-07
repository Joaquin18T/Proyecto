<?php

require_once '../models/Notificacion.php';

$notificacion = new Notificacion();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'listNotf':
      echo json_encode($notificacion->listNotifications(['idusuario'=>$_GET['idusuario']]));
      break;
    case 'detalleNotf':
      echo json_encode($notificacion->detalleNotificaciones(['idnotificacion'=>$_GET['idnotificacion']]));
      break;
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