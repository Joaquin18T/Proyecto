<?php

session_start();
require_once '../models/Usuarios.php';

$user = new Usuario();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'login':
      $login = [
        'permitido' => false,
        'idusuario' => -1,
        'usuario' => '',
        'rol' => '',
        'status' => ''
      ];

      $row = $user->login(['usuario' => $_GET['usuario']]);
      if (count($row) == 0) {
        $login['status'] = "No existe el usuario";
      } else {
        $claveEncriptada = $row[0]['contrasena'];
        $claveIngreso = $_GET['passusuario'];

        if (password_verify($claveIngreso, $claveEncriptada)) {
          $login['permitido'] = true;
          $login['usuario'] = $row[0]['usuario'];
          $login['rol'] = $row[0]['rol'];
          $login['idusuario'] = $row[0]['id_usuario'];
        } else {
          $login["status"] = "Contrasenia incorrecta";
        }
      }

      $_SESSION['login'] = $login;
      echo json_encode($login);
      break;
    case 'destroy':
      session_unset();
      session_destroy();
      header("Location:http://localhost/CMMS");
      break;

    case 'getData':
      echo json_encode($user->getDataUsuario());
      break;
    case 'searchUser':
      echo json_encode($user->searchUser(['usuario' => $_GET['usuario']]));
      break;
    case 'getUserById':
      echo json_encode($user->getUserById(['idusuario' => $_GET['idusuario']]));
      break;
    case 'listOfFilters':
      echo json_encode($user->listFilters([
        'idrol' => $_GET['idrol'] == "" ? null : $user->limpiarCadena($_GET['idrol']),
        'idtipodoc' => $_GET['idtipodoc'] == "" ? null : $user->limpiarCadena($_GET['idtipodoc']),
        'estado' => $_GET['estado'] == "" ? null : $user->limpiarCadena($_GET['estado']),
        'dato' => $_GET['dato'] == "" ? null : $user->limpiarCadena($_GET['dato'])
      ]));
      break;
    case 'filtrarUsuarios':
      echo json_encode($user->filtrarUsuarios([
        'numdoc' => $_GET['numdoc'] == "" ? null : $user->limpiarCadena($_GET['numdoc']),
        'dato' => $_GET['dato'] == "" ? null : $user->limpiarCadena($_GET['dato']),
      ]));
      break;
    case 'getUsuarioPersona':
      echo json_encode($user->getDataUserPersona(['idusuario' => $user->limpiarCadena($_GET['idusuario'])]));
      break;
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $respuesta = ['respuesta' => ''];
      $enviar = [
        'idpersona' => $_POST['idpersona'],
        'idrol' => $_POST['idrol'],
        'usuario' => $_POST['usuario'],
        'contrasena' => password_hash($_POST['contrasena'], PASSWORD_BCRYPT)
      ];
      $status = $user->add($enviar);
      if ($status) {
        $respuesta['respuesta'] = 1;
      } else {
        $respuesta['respuesta'] = -1;
      }
      echo json_encode($respuesta);
      break;
    case 'updateUser':
      $isUpdate = ['respuesta' => -1];
      $datosEnviar = [
        'idusuario' => $user->limpiarCadena($_POST['idusuario']),
        'idrol' => $user->limpiarCadena($_POST['idrol']),
        'usuario' => $user->limpiarCadena($_POST['usuario'])
      ];
      $respuesta = $user->updateUser($datosEnviar);
      if ($respuesta > 0) {
        $isUpdate['respuesta'] = $respuesta;
      }
      echo json_encode($isUpdate);
      break;
    case 'updateEstado':
      $isUpdate = ['respuesta' => -1];
      $datosEnviar = [
        'idusuario' => $user->limpiarCadena($_POST['idusuario']),
        'estado' => $user->limpiarCadena($_POST['estado'])
      ];
      $resp = $user->updateEstado($datosEnviar);
      if ($resp) {
        $isUpdate['respuesta'] = 1;
      }
      echo json_encode($isUpdate);
      break;
    case 'updateClaveAcceso':
      $isUpdate = ['respuesta' => -1];

      $datosEnviar = [
        'idusuario' => $user->limpiarCadena($_POST['idusuario']),
        'contrasena' => $user->limpiarCadena($_POST['contrasena'])
      ];
      $resp = $user->updateClaveAcceso($datosEnviar);
      if ($resp) {
        $isUpdate['respuesta'] = 1;
      }
      echo json_encode($isUpdate);
      break;
  }
}
