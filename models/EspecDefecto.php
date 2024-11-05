<?php

require_once 'ExecQuery.php';

class EspecDefecto extends ExecQuery{
  public function getEspecificaciones($params=[]):array{
   $cmd = parent::execQ("CALL sp_default_especificacion(?)");
   $cmd->execute(
    array(
      $params['idsubcategoria']
    )
   ); 
   return $cmd->fetchAll(PDO::FETCH_ASSOC);
  }
}

// $esDefect = new EspecDefecto();

// $data= $esDefect->getEspecificaciones(['idsubcategoria'=>3]);

//print_r($data[0]['especificaciones']);
// $newJson = json_decode($data[0]['especificaciones']);
// echo json_encode($newJson);