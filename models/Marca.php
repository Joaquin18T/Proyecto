<?php

require_once 'ExecQuery.php';

class Marca extends ExecQuery{
  public function getAll():array{
    try{
      $cmd = parent::execQ("SELECT * FROM marcas ORDER BY idmarca ASC");
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}

// $marca = new Marca();
// echo json_encode($marca->getAll());