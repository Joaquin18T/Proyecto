<?php

require_once 'Conexion.php';

class Rol extends Conexion{
  private $pdo;
  public function __CONSTRUCT(){
    $this->pdo=parent::getConexion();
  }

  public function getAll():array{
    try{
      $query = "SELECT idrol, rol FROM roles";
      $cmd = $this->pdo->prepare($query);
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function getByName($params=[]):array{
    try{
      $query = "SELECT idrol FROM roles WHERE rol=?";
      $cmd = $this->pdo->prepare($query);
      $cmd->execute(
        array(
          $params['rol']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}
// $rol = new Rol();

// echo json_encode($rol->getByName(['rol'=>'Usuario']));