<?php
require_once '../models/BajaActivo.php';

$baja = new BajaActivo();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'sinServicio':
      $params = [
        'idestado' => $_GET['idestado'] == "" ? null : $_GET['idestado'],
        'fecha_adquisicion' => $_GET['fecha_adquisicion'] == "" ? null : $_GET['fecha_adquisicion']
      ];
      echo json_encode($baja->activosBaja($params));
      break;
    case 'dataBajaActivo':
      //metodo intval: convierte una cadena en entero
      echo json_encode($baja->dataBajaActivo(['idactivo'=>$baja->limpiarCadena($_GET['idactivo'])]));
      break;
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $respuesta = ['id' => ''];
      $datosEnviar = [
        'idactivo' => $_POST['idactivo'],
        'motivo' => $_POST['motivo'],
        'coment_adicionales' => $_POST['coment_adicionales']==''?null:$_POST['coment_adicionales'],
        'ruta_doc' => $_POST['ruta_doc'],
        'aprobacion' => $_POST['aprobacion']
      ];
      $valor = $baja->add($datosEnviar);
      if ($valor > 0) {
        $respuesta['id'] = $valor;
      } else {
        $respuesta['id'] = $valor;
      }
      echo json_encode($respuesta);
      break;

    case 'saveFile':
      $dir = "C:/xampp/htdocs/CMMS/uploads/";

      //Asegurarse de que el directorio exista
      if (!file_exists($dir)) {
        mkdir($dir, 0777, true); //crea el directorio si no existe
      }

      //Obtener Informacion del archivo
      $fileName = basename($_FILES['file']['name']);
      $fileTempName = $_FILES['file']['tmp_name'];
      $fileSize = $_FILES['file']['size']; //maximo 30MB  
      $fileError = $_FILES['file']['error'];

      $msg = ['respuesta'=>''];
      if($fileSize<6){
        $code = $_POST['code'];
  
        $ukFileName = $code . "-" . $fileName; //Nombre al archivo
        $path = $dir . $ukFileName;
  
        if (move_uploaded_file($fileTempName, $path)) {
          $msg['respuesta'] = $path;
        }
      }else{
        $msg['respuesta']="max";
      }
      echo json_encode($msg);
      break;
  }
}
