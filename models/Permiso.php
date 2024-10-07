<?php 

require_once 'Conexion.php';

class Permiso extends Conexion{

  private $pdo;

  public function __CONSTRUCT(){
    $this->pdo=parent::getConexion();
  }

  public function getPermisosPorRol($params=[]):array{
    try {
      $query = "SELECT * FROM permisos WHERE idrol=?";
      $cmd = $this->pdo->prepare($query);
      $cmd->execute(
        array(
          $params['idrol']
        )
      );
      $permisos = $cmd->fetchAll(PDO::FETCH_ASSOC);
      $result = [];

      foreach ($permisos as $permiso) {
 
        $decodedPermiso = json_decode($permiso['permiso'], true);

 
        $result[] = [
          'idpermiso' => $permiso['idpermiso'],
          'idrol' => $permiso['idrol'],
          'permiso' => $decodedPermiso
        ];
      }

      return $result[0];        
    } catch (Exception $e) {
      die($e->getCode());
    }
  }


}

//$permiso = new Permiso();

//echo json_encode($permiso->getPermisosPorRol(["idrol"=>2]), JSON_UNESCAPED_UNICODE);




