<?php

require_once '../models/Solicitud.php';

$soli = new Solicitud();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getSolicitud':
      echo json_encode($soli->getSolByEstado(['estado'=>$_GET['estado']]));
      break;
    case 'searchSolicitud':
      echo json_encode($soli->searchSolicitud(['valor'=>$_GET['valor']]));
      break;
    case 'isDuplicate':
      echo json_encode($soli->isDuplicateRequest(
        [
          'idusuario'=>$_GET['idusuario'], 
          'idactivo'=>$_GET['idactivo']
        ]));
      break;
    case 'showMotivo':
      echo json_encode($soli->showMotivo(['idsolicitud'=>$_GET['idsolicitud']]));
      break;
  }
}

if(isset($_POST['operation'])){
  switch($_POST['operation']){
    case 'add':
      $msg = ['respuesta'=>''];
      $datos=[
        'idactivo'=>$_POST['idactivo'],
        'idusuario'=>$_POST['idusuario'],
        'motivo_solicitud'=>$_POST['motivo_solicitud']
      ];
      $estado = $soli->add($datos);
      if($estado[0]['idsolicitud']>0){
        $msg['respuesta']=$estado[0]['idsolicitud'];
      }else{
        $msg['respuesta']=-1;
      }
      echo json_encode($msg);
      break;
    case 'verifierSoli': 
      $msg = ['respuesta'=>''];
      $datos=[
        'idsolicitud'=>$_POST['idsolicitud'],
        'idactivo'=>$_POST['idactivo'],
        'idusuario'=>$_POST['idusuario'],
        'estado_solicitud'=>$_POST['estado_solicitud'],
        'idautorizador'=>$_POST['idautorizador'],
        'coment_autorizador'=>$_POST['coment_autorizador']
      ];
      $estado = $soli->checkSolicitud($datos);
      if($estado){
        $msg['respuesta']=1;
      }else{
        $msg['respuesta']=-1;
      }
      echo json_encode($msg);
      break;
  }
}

