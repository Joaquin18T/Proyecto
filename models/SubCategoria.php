<?php

require_once 'ExecQuery.php';

class SubCategoria extends ExecQuery{
  public function getAll():array{
    try{
      $query = "SELECT * FROM v_subcategoria";
      $cmd = parent::execQ($query);
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

}

// $sub = new SubCategoria();

// echo json_encode($sub->getAll());