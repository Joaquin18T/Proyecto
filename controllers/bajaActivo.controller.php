<?php
require_once '../models/BajaActivo.php';

$baja = new BajaActivo();

if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'sinServicio':
      $params=[
        'idestado'=>$_GET['idestado']==""?null:$_GET['idestado'],
        'fecha_adquisicion'=>$_GET['fecha_adquisicion']==""?null:$_GET['fecha_adquisicion']
      ];
      echo json_encode($baja->activosBaja($params));
      break;
  }
}

if(isset($_POST['operation'])){
  switch($_POST['operation']){
    case 'add':
      $respuesta=['id'=>''];
      $datosEnviar = [
        'idactivo'=>$_POST['idactivo'],
        'motivo'=>$_POST['motivo'],
        'coment_adicionales'=>$_POST['coment_adicionales'],
        'ruta_doc'=>$_POST['ruta_doc'],
        'aprobacion'=>$_POST['aprobacion']
      ];
      $valor = $baja->add($datosEnviar);
      if($valor>0){
        $respuesta['id']=$valor;
      }else{
        $respuesta['id']=$valor;
      }
      echo json_encode($respuesta);
      break;
  }
}