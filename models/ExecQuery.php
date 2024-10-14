<?php
require_once 'Conexion.php';

/**Clase para preparar la consulta (No hay necesidad de crear un Constructor en clases heredadas) */
class ExecQuery extends Conexion{
  private $pdo;

  public function __CONSTRUCT(){
    $this->pdo=parent::getConexion();
  }

  public function execQ($query):PDOStatement{
    return $this->pdo->prepare($query);
  }

  public function execQuerySimple($query):PDOStatement{
    return $this->pdo->query($query);
  }
  
}