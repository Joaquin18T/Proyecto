<?php

require_once 'ExecQuery.php';

class Notificacion extends ExecQuery{
  public function listNotifications($params=[]):array{
    try{
      $cmd = parent::execQ('CALL sp_list_notificacion(?)');
      $cmd->execute(
        array(
          $params['idusuario']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function detalleNotificaciones($params=[]):array{
    try{
      $cmd = parent::execQ('CALL sp_detalle_notificacion(?)');
      $cmd->execute(
        array(
          $params['idnotificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function add($params=[]):bool{
    try{
      $status=false;
      $cmd = parent::execQ('CALL sp_add_notificacion(?,?,?)');
      $status=$cmd->execute(
        array(
          $params['idusuario'],
          $params['tipo'],
          $params['mensaje']
        )
      );
      return $status;
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function detalleByEstado($params=[]):array{
    try{
      $cmd = parent::execQ('CALL sp_detalle_sol_estado(?)');
      $cmd->execute(
        array(
          $params['idsolicitud']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}

//$not = new Notificacion();

// echo json_encode($not->listNotifications(['idusuario'=>1]));

//echo json_encode($not->detalleNotificaciones(['idsolicitud'=>1]));

// echo json_encode($not->add([
//   'idusuario'=>4,
//   'idsolicitud'=>8,
//   'mensaje'=>'Tu solicitud para al activo ha sido rechazado'
// ]));

//echo json_encode($not->detalleByEstado(['idsolicitud'=>20]));