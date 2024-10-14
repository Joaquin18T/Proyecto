<?php

require_once 'ExecQuery.php';

class Tipoprioridad extends ExecQuery{

  public function getAll():array{
    try{
      $sp = parent::execQ("SELECT * FROM tipo_prioridades");
      $sp->execute();
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }



  // FUTUROS METODOS
}
