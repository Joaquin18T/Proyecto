<?php
require_once 'ExecQuery.php';

class Activo extends ExecQuery{
  public function add($params=[]):int{
    try{
      $pdo = parent::getConexion();

      $cmd = $pdo->prepare("CALL sp_add_activo(@idactivo,?,?,?,?,?,?,?)");
      $cmd->execute(
        array(
          $params['idsubcategoria'],
          $params['idmarca'],
          $params['modelo'],
          $params['cod_identificacion'],
          $params['fecha_adquisicion'],
          $params['descripcion'],
          $params['especificaciones']
        )
      );
      $respuesta = $pdo->query("SELECT @idactivo AS idactivo")->fetch(PDO::FETCH_ASSOC);
      return $respuesta['idactivo'];
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
      return -1;
    }
  }

  public function searchbyDecripcion($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_search_activo(?)");
      $cmd->execute(
        array($params['descripcion'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function getAll():array{
    try{
      $cmd = parent::execQ('SELECT*FROM v_all_activos');
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function searchByActivo($params=[]):array{
    try{
      $cmd=parent::execQ("CALL sp_search_by_activo(?)");
      $cmd->execute(
        array(
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function repeatByCode($params=[]):array{
    try{
      $cmd = parent::execQ("CALL searchby_code(?)");
      $cmd->execute(
        array(
          $params['cod_identificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function filterBySubcategoria($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_filter_by_subcategorias(?)");
      $cmd->execute(
        array($params['idsubcategoria'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function listOfFilters($params=[]):array{
    try{
      //Inicializar los parametros con valores por defecto
      $defaultParams=[
        'idsubcategoria'=>null,
        'cod_identificacion'=>null,
        'fecha_adquisicion'=>null,
        'idestado'=>null,
        'idmarca'=>null
      ];

      $realParams = array_merge($defaultParams, $params);
      $cmd = parent::execQ("CALL sp_list_activos(?,?,?,?,?)");
      $cmd->execute(
        array(
          $realParams['idsubcategoria'],
          $realParams['cod_identificacion'],
          $realParams['fecha_adquisicion'],
          $realParams['idestado'],
          $realParams['idmarca']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function updateEstado($params=[]):bool{
    try{
      $status=false;
      $cmd = parent::execQ("CALL sp_update_estado_activo(?,?)");
      $status=$cmd->execute(
        array(
          $params['idactivo'],
          $params['idestado']
        )
      );
      return $status;
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
    }
  }

  public function updateActivo($params=[]):bool{
    try{
      $status=false;
      $cmd = parent::execQ("CALL sp_update_activo(?,?,?,?,?,?,?,?)");
      $status = $cmd->execute(
        array(
          $params['idactivo'],
          $params['idsubcategoria'],
          $params['idmarca'],
          $params['modelo'],
          $params['cod_identificacion'],
          $params['fecha_adquisicion'],
          $params['descripcion'],
          $params['especificaciones']
        )
      );
      return $status;
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
    }
  }

  public function searchActivoByUpdate($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_search_update_activo(?)");
      $cmd->execute(
        array(
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
    }
  }

  public function getById($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_get_activoById(?)");
      $cmd->execute(
        array(
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      error_log("Error: ".$e->getMessage());
    }
  }

  public function searchActivoResp($params):array{
    try{
      $cmd = parent::execQ("CALL sp_search_activo_resp(?)");
      $cmd->execute(
        array($params['descripcion'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}

// $asc = new Activo();

// echo json_encode($asc->getById(['idactivo'=>2]));

// echo json_encode($asc->searchActivoByUpdate(['idactivo'=>3]));

// echo json_encode($asc->searchByActivo(['idactivo'=>3]));

// echo json_encode($asc->updateActivo([
//   'idactivo'=>4,
//   'idsubcategoria'=>6,
//   'idmarca'=>6,
//   'modelo'=>'Palisade',
//   'cod_identificacion'=>'F34H43K5C',
//   'fecha_adquisicion'=>'2024-07-15',
//   'descripcion'=>'Camioneta Hyundai Palisade',
//   'especificaciones'=>'{"color":"Rojo", "Num Puertas":"4"}'
// ]));

// echo json_encode($asc->updateEstado([
//   'idactivo'=>4,
//   'idestado'=>4
// ]));

// echo json_encode($asc->listOfFilters(['fecha_adquisicion'=>'2024-10-03']));

// echo json_encode($asc->filterBySubcategoria(['idsubcategoria'=>7]));

// echo json_encode($asc->searchUser(['activo'=>4]));

//echo json_encode($asc->getAll());

//echo json_encode($asc->searchCode(['code'=>'D']));

// $params=[
//   'idsubcategoria'=>1,
//   'idmarca'=>1,
//   'modelo'=>"EDR v5",
//   'cod_identificacion'=>"RR45EA",
//   'fecha_adquisicion'=>"2024-10-04",
//   'descripcion'=>"EDR V5 product",
//   'especificaciones'=>'{"color":"Blanco"}'
// ];

// $id = $asc->add($params);
// echo json_encode($id);
