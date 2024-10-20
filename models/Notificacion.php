<?php

require_once 'ExecQuery.php';

class Notificacion extends ExecQuery{
  public function listNotifications($params=[]):array{
    try{
      $defaultParams=[
        'idusuario'=>null,
        'idnotificacion'=>null
      ];
      $realArray = array_merge($defaultParams, $params);
      $cmd = parent::execQ('CALL sp_list_notificacion(?,?)');
      $cmd->execute(
        array(
          $realArray['idusuario'],
          $realArray['idnotificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function detalleNotificaciones($params=[]):array{
    try{
      $cmd = parent::execQ('CALL sp_detalle_notificacion_resp(?,?)');
      $cmd->execute(
        array(
          $params['idusuario'],
          $params['idactivo_resp']
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

  public function dataRespNotificacion($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_responsable_notificacion(?)");
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
 
}

// $not = new Notificacion();

// echo json_encode($not->dataRespNotificacion(['idusuario'=>12]));

//echo json_encode($not->listNotifications(['idusuario'=>12]));

//echo json_encode($not->detalleNotificaciones(['idusuario'=>12, 'idactivo_resp'=>6]));

// echo json_encode($not->add([
//   'idusuario'=>4,
//   'idsolicitud'=>8,
//   'mensaje'=>'Tu solicitud para al activo ha sido rechazado'
// ]));

//echo json_encode($not->detalleByEstado(['idsolicitud'=>20]));