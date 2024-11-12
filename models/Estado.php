<?php

require_once 'ExecQuery.php';

class Estado extends ExecQuery{

  public function getAllByActivo():array{
    try{
      $cmd = parent::execQ("SELECT idestado, nom_estado FROM estados WHERE tipo_estado='activo'");
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
    }
  }

  public function estadoByRange($params=[]):array{
    try{
      $cmd = parent::execQ("SELECT idestado, nom_estado FROM estados WHERE idestado!=? AND
      (idestado>? AND idestado<?)");
      $cmd->execute(
        array(
          $params['idestado'],
          $params['menor'],
          $params['mayor']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      error_log("Error: ". $e->getMessage());
    }
  }
}

// $est = new Estado();
// echo json_encode($est->estadoByRange(['idestado'=>6, 'menor'=>1, 'mayor'=>6]));

// echo json_encode($est->getAll());