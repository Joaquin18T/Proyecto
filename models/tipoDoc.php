<?php

require_once 'ExecQuery.php';

class tipoDoc extends ExecQuery{
  public function getAll():array{
    try{
      $cmd = parent::execQ("SELECT*FROM tipo_doc ORDER BY idtipodoc");
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}


// $docs = new tipoDoc();

// echo json_encode($docs->getAll());