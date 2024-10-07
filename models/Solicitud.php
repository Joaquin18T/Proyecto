<?php
require_once 'ExecQuery.php';

class Solicitud extends ExecQuery{

  public function getSolByEstado($params=[]):array{
    try{
      $cmd = parent::execQ('CALL sp_list_pass(?)');
      $cmd->execute(
        array($params['estado'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function add($params=[]):array{
    try{
      $cmd = parent::execQ('CALL sp_add_solicitud(?,?,?)');
      $cmd->execute(
        array(
          $params['idusuario'],
          $params['idactivo'],
          $params['motivo_solicitud']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function checkSolicitud($params=[]):bool{
    try{
      $status = false;
      $cmd = parent::execQ('CALL sp_check_solicitud(?,?,?,?,?,?)');
      $status=$cmd->execute(
        array(
          $params['idsolicitud'],
          $params['idactivo'],
          $params['idusuario'],
          $params['estado_solicitud'],
          $params['idautorizador'],
          $params['coment_autorizador'],
        )
      );
      return $status;
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function searchSolicitud($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_search_solicitud(?)");
      $cmd->execute(
        array(
          $params['valor']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function isDuplicateRequest($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_request_duplicate(?,?)");
      $cmd->execute(
        array(
          $params['idusuario'],
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function showMotivo($params=[]):array{
    try{
      $cmd = parent::execQ("SELECT motivo_solicitud FROM solicitudes_activos WHERE idsolicitud=?");
      $cmd->execute(array(
        $params['idsolicitud']
      ));
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}
// NOTA: CUANDO ES UN SP PARA ACTUALIZAR, EL REGISTRO A ACTUALIZAR (ID) VA AL PRIMERO
//$sol = new Solicitud();

//echo json_encode($sol->showMotivo(['idsolicitud'=>7]));

// echo json_encode($sol->getAll());

//echo json_encode($sol->getSol(['estado'=>'aprobado']));

//echo json_encode($sol->searchSolicitud(['valor'=>'a.']));

//echo json_encode($sol->isDuplicateRequest(['idusuario'=>2, 'idactivo'=>1]));

// echo json_encode($sol->add([
//   'idusuario'=>3,
//   'idactivo'=>1,
//   'motivo_solicitud'=>'Para un proyecto aprobado'
// ]));

// echo json_encode($sol->checkSolicitud([
//   'idsolicitud'=>2,
//   'idactivo'=>1,
//   'idusuario'=>2,
//   'estado_solicitud'=>'aprobado',
//   'idautorizador'=>1,
//   'coment_autorizador'=>null,
// ]));