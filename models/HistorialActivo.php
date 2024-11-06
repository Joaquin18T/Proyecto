<?php

require_once 'ExecQuery.php';

class HistorialActivo extends ExecQuery{

  public function add($params=[]):int{
    try{
      $pdo = parent::getConexion();
      $cmd = $pdo->prepare("CALL sp_add_historial_activo(@idhistorial,?,?,?,?,?)");
      $cmd->execute(
        array(
          $params['idactivo_resp'],
          $params['idubicacion'],
          $params['accion'],
          $params['responsable_accion'],
          $params['idactivo']
        )
      );
      $respuesta = $pdo->query("SELECT @idhistorial AS idhistorial")->fetch(PDO::FETCH_ASSOC);
      return $respuesta['idhistorial'];
    }catch(Exception $e){
      die($e->getMessage());
      return -1;
    }

  }

  public function ubicacionByActivo($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_ubicacion_activo(?,?)");
      $cmd->execute(
        array(
          $params['idactivo'],
          $params['idactivo_resp']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function getUbicacionByOnlyActivo($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_ubicacion_only_activo(?)");
      $cmd->execute(
        array(
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}

//$hist = new HistorialActivo();

// echo json_encode($hist->getUbicacionByOnlyActivo(['idactivo'=>4]));

// echo json_encode($hist->ubicacionByActivo(['idactivo'=>4, 'idactivo_resp'=>5]));

// $data = $hist->add([
//   'idactivo_resp'=>1,
//   'idubicacion'=>3,
//   'accion'=>'test',
//   'responsable_accion'=>6,
//   'idactivo'=>3
// ]);

// echo $data;