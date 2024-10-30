<?php

require_once 'ExecQuery.php';

class HistorialActivo extends ExecQuery{
  public function add($params=[]):bool{
    try{
      $status=false;
      $cmd = parent::execQ("INSERT INTO historial_activos(idactivo_resp, idubicacion, accion, responsable_accion) VALUES(?,?,?,?)");
      $status = $cmd->execute(
        array(
          $params['idactivo_resp'],
          $params['idubicacion'],
          $params['accion'],
          $params['responsable_accion']
        )
      );
      return $status;
    }catch(Exception $e){
      die($e->getMessage());
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

// $hist = new HistorialActivo();

// echo json_encode($hist->ubicacionByActivo(['idactivo'=>4, 'idactivo_resp'=>5]));

// echo json_encode($hist->add([
//   'idactivo_resp'=>1,
//   'idubicacion'=>3,
//   'autorizacion'=>1,
//   'solicitud'=>1
// ]));