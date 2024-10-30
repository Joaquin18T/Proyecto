<?php

require_once 'ExecQuery.php';

class BajaActivo extends ExecQuery{
  public function add($params=[]):int{
    try{
      $pdo = parent::getConexion();
      $cmd = $pdo->prepare("CALL sp_add_baja_activo(@idbaja,?,?,?,?,?)");
      $cmd->execute(
        array(
          $params['idactivo'],
          $params['motivo'],
          $params['coment_adicionales'],
          $params['ruta_doc'],
          $params['aprobacion']
        )
      );

      $respuesta = $pdo->query("SELECT @idbaja AS idbaja")->fetch(PDO::FETCH_ASSOC);
      return $respuesta['idbaja'];
    }catch(Exception $e){
      error_log("Error: " . $e->getMessage());
      return -1;
    }

  }

  public function activosBaja($params=[]):array{
    try{
      $defaultParams = [
        'fecha_adquisicion'=>null,
        'idestado'=>null,
        'cod_identificacion'=>null
      ];
      $realParams = array_merge($defaultParams, $params);
      $cmd=parent::execQ("CALL sp_activos_sin_servicio(?,?,?)");
      $cmd->execute(
        array(
          $realParams['fecha_adquisicion'],
          $realParams['idestado'],
          $realParams['cod_identificacion'],
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
    }
  }

  public function dataBajaActivo($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_data_baja_activo(?)");
      $cmd->execute(
        array(
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      error_log("Error: ", $e->getMessage());
    }
  }
}

//$baja = new BajaActivo();

// echo json_encode($baja->dataBajaActivo(['idactivo'=>1]));

//echo json_encode($baja->activosBaja(['cod_identificacion'=>'C']));

// $id = $baja->add([
//   'idactivo'=> 4,
//   'motivo'=>'Sobrecalentamiento del motor en carretera',
//   'coment_adicionales'=>null,
//   'ruta_doc'=>'http://localhost/CMMS/uploads/archiv1.pdf',
//   'aprobacion'=>1
// ]);
// echo $id;