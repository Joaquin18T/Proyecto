<?php

require_once 'ExecQuery.php';

class Categoria extends ExecQuery{

  public function getAll():array{
    try{
      $query = "SELECT idcategoria, categoria FROM categorias ORDER BY idcategoria ASC";
      $cmd = parent::execQ($query);
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}

// $test = new Categoria();

// echo json_encode($test->getAll());