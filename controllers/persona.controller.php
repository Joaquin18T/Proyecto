<?php
require_once '../models/Persona.php';

$persona = new Persona();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($persona->getPersona());
      break;
    case 'getByNumCode':
      echo json_encode($persona->getByNumDoc(['num_doc' => $_GET['num_doc']]));
      break;
    case 'searchTelf':
      echo json_encode($persona->searchTelf(['telefono' => $_GET['telefono']]));
      break;
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $mensaje = ['respuesta' => ''];
      $enviarDatos = [
        'idtipodoc' => $_POST['idtipodoc'],
        'num_doc' => $_POST['num_doc'],
        'apellidos' => $_POST['apellidos'],
        'nombres' => $_POST['nombres'],
        'genero' => $_POST['genero'],
        'telefono' => $_POST['telefono']==""?null:$_POST['telefono']
      ];

      $dato = $persona->add($enviarDatos);
      if (count($dato) > 0) {
        $mensaje['respuesta'] = $dato;
      } else {
        $mensaje['respuesta'] = "Hubo un error";
      }
      echo json_encode($mensaje);
      break;
    case 'updatePersona':
      $data = ['respuesta' => -1];

      $datosEnviar = [
        'idpersona' => $persona->limpiarCadena($_POST['idpersona']),
        'idtipodoc' => $persona->limpiarCadena($_POST['idtipodoc']),
        'num_doc' => $persona->limpiarCadena($_POST['num_doc']),
        'apellidos' => $persona->limpiarCadena($_POST['apellidos']),
        'nombres' => $persona->limpiarCadena($_POST['nombres']),
        'genero' => $persona->limpiarCadena($_POST['genero']),
        'telefono' => $_POST['telefono']==""?null:$_POST['telefono']
      ];

      $resp = $persona->updatePersona($datosEnviar);
      if($resp){
        $data['respuesta']=1;
      }
      echo json_encode($data);
      break;
  }
}
