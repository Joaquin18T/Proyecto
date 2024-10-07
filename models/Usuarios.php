<?php

require_once 'ExecQuery.php';

class Usuario extends ExecQuery{

  public function login($params=[]):array{
    try{
      $sp = parent::execQ("CALL sp_user_login(?)");
      $sp->execute(array($params['usuario']));
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }

  }

  public function getDataUsuario():array{
    try{
      $cmd=parent::execQ("CALL sp_list_users()");
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function add($params=[]):bool{
    try{
      $status = false;
      $cmd = parent::execQ("CALL sp_register_user(?,?,?,?)");
      $status = $cmd->execute(
        array(
          $params['idpersona'],
          $params['idrol'],
          $params['usuario'],
          $params['contrasena']
        )
      );
      return $status;
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function searchUser($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_search_user(?)");
      $cmd->execute(
        array($params['usuario'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function getUserById($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_getUser_by_id(?)");
      $cmd->execute(
        array($params['idusuario'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function listFilters($params=[]):array{
    try{
      $defaultParams=[
        'idrol'=>null,
        'idtipodoc'=>null,
        'estado'=>null,
        'dato'=>null
      ];

      $realParams = array_merge($defaultParams, $params);
      $cmd = parent::execQ("CALL sp_list_persona_users(?,?,?,?)");
      $cmd->execute(
        array(
          $realParams['idrol'],
          $realParams['idtipodoc'],
          $realParams['estado'],
          $realParams['dato']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function updateUser($params=[]):int{
    try{
      $pdo = parent::getConexion();
      $cmd = $pdo->prepare("CALL sp_update_usuario(@idpersona, ?, ?, ?)");
      $cmd->execute(
        array(
          $params['idusuario'],
          $params['idrol'],
          $params['usuario']
        )
      );

      $respuesta = $pdo->query("SELECT @idpersona AS idpersona")->fetch(PDO::FETCH_ASSOC);
      return $respuesta['idpersona'];
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
      return -1;
    }
  }

  public function updateEstado($params=[]):bool{
    try{
      $state = false;
      $cmd = parent::execQ("CALL sp_update_estado_usuario(?,?)");
      $state=$cmd->execute(
        array(
          $params['idusuario'],
          $params['estado']
        )
      );
      return $state;
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
    }
  }

  public function updateClaveAcceso($params=[]):bool{
    try{
      $status=false;
      $cmd = parent::execQ("CALL sp_update_claveacceso(?,?)");
      $status = $cmd->execute(
        array(
          $params['idusuario'],
          $params['contrasena']          
        )
      );
      return $status;
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
    }
  }
}

//echo (password_hash('contrasena2', PASSWORD_BCRYPT));
// $user = new Usuario();

// echo json_encode($user->listFilters([]));

// $clave = password_hash("juan241", PASSWORD_BCRYPT);
// echo json_encode($user->updateClaveAcceso(['idusuario'=>8,'contrasena'=>$clave]));

//echo json_encode($user->updateEstado(['idusuario'=>8, 'estado'=>0]));

// $resp = $user->updateUser([
//   'idusuario'=>2,
//   'idrol'=>2,
//   'usuario'=>'A.smith'
// ]);
// echo json_encode($resp);
// echo json_encode($user->add([
//   'idpersona'=>4,
//   'idrol'=>2,
//   'usuario'=>'pablopro',
//   'contrasena'=>'pablopro12324'
// ]));

// echo json_encode($user->getDataUsuario(['nom_usuario'=>'pablo35a']));
//echo json_encode($user->login(['usuario'=>'a.smith']));
//echo password_hash("contrasena4", PASSWORD_BCRYPT);
//echo json_encode($user->searchUser((['usuario'=>'pablo3a'])));

//echo json_encode($user->getUserById(['idusuario'=>2]));