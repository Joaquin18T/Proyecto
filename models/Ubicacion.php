<?php

require_once 'ExecQuery.php';

class Ubicacion extends ExecQuery{
  public function getAll():array{
    try{
      $cmd = parent::execQ("SELECT * FROM ubicaciones");
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}

// $ubi = new Ubicacion();

// echo json_encode($ubi->getAll());