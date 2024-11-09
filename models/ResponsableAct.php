<?php

require_once 'ExecQuery.php';


class ResponsableAct extends ExecQuery
{
  public function add($params = []): array
  {
    try {

      $cmd = parent::execQ("CALL sp_respact_add(?,?,?,?,?,?,?)");
      $cmd->execute(
        array(
          $params['idactivo'],
          $params['idusuario'],
          $params['condicion_equipo'],
          $params['imagenes'],
          $params['descripcion'],
          $params['autorizacion'],
          $params['solicitud']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getAll(): array
  {
    try {
      $cmd = parent::execQ("SELECT * FROM v_activo_resp");
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getRespById($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_search_resp(?)");
      $cmd->execute(
        array($params['idactivo_resp'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function existResponsable($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_existe_responsable(?)");
      $cmd->execute(
        array($params['idactivo'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }


  public function cantColaboradores($params = []): int
  {
    try {
      $pdo = parent::getConexion();
      $query = "CALL sp_max_colaboradores(@cantidad,?)";
      $cmd = $pdo->prepare($query);
      $cmd->execute(
        array($params['idactivo'])
      );
      $response = $pdo->query("SELECT @cantidad AS cantidad")->fetch(PDO::FETCH_ASSOC);
      return $response['cantidad'];
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
      return -2;
    }
  }

  public function repeatAsignacion($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_repeat_responsable(?,?)");
      $cmd->execute(
        array(
          $params['idactivo'],
          $params['idusuario']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function chooseResponsable($params = []): bool
  {
    try {
      $estado = false;
      $cmd = parent::execQ("CALL sp_update_responsable(?)");
      $estado = $cmd->execute(
        array(
          $params['idactivo_resp']
        )
      );
      return $estado;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function usersByActivo($params = [])
  {
    try {
      $cmd = parent::execQ("CALL sp_users_by_activo(?)");
      $cmd->execute(
        array(
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function test($params = []): array
  {
    try {
      $cmd = parent::execQ("SELECT imagenes FROM activos_responsables where idactivo_resp=?");
      $cmd->execute(
        array($params['idactivo_resp'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function searchActivoResponsable($params = []): array
  {
    try {
      $defaultParams = [
        'idsubcategoria' => null,
        'idubicacion' => null,
        'cod_identificacion' => null
      ];
      $realArray = array_merge($defaultParams, $params);
      $cmd = parent::execQ("CALL sp_search_activo_responsable(?,?,?)");
      $cmd->execute(
        array(
          $realArray['idsubcategoria'],
          $realArray['idubicacion'],
          $realArray['cod_identificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  }

  public function filtrarActivosResponsablesAsignados($params = []): array
  {
    try {
      $defaultParams = [
        'idsubcategoria' => null,
        'idubicacion' => null,
        'cod_identificacion' => null
      ];
      $realArray = array_merge($defaultParams, $params);
      $cmd = parent::execQ("CALL sp_filtrar_activos_responsables_asignados(?,?,?)");
      $cmd->execute(
        array(
          $realArray['idsubcategoria'],
          $realArray['idubicacion'],
          $realArray['cod_identificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  } // NO USAR

  public function listarActivosResponsables($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL listarActivosResponsables(?,?)");
      $cmd->execute(
        array(
          $params['idsubcategoria'],
          $params['idubicacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  }

  public function listResp_activo()
  {
    return parent::getData("sp_list_resp_activo");
  }

  public function getResponsablePrin($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_getresp_principal(?,?)");
      $cmd->execute(
        array(
          $params['idactivo_resp'],
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  }

  public function updateAsignacion($params = []): bool
  {
    try {
      $respuesta = false;
      $cmd = parent::execQ("CALL sp_update_activo_responsable(?,?,?,?)");
      $respuesta = $cmd->execute(
        array(
          $params['idactivo_resp'],
          $params['idactivo'],
          $params['idusuario'],
          $params['autorizacion']
        )
      );
      return $respuesta;
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  }

  public function updateChangePrincipal($params = []): bool
  {
    try {
      $respuesta = false;
      $cmd = parent::execQ("CALL sp_update_asignacion_principal(?,?,?,?,?)");
      $respuesta = $cmd->execute(
        array(
          $params['idactivo_resp'],
          $params['idactivo'],
          $params['idusuario'],
          $params['es_responsable'],
          $params['autorizacion']
        )
      );
      return $respuesta;
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  }

  public function verificarColaboradores($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_verificar_colaboradores(?)");
      $cmd->execute(
        array(
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  }

  public function getIdResp($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL get_idresp_activo(?,?)");
      $cmd->execute(
        array(
          $params['idactivo'],
          $params['idusuario']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  }

  public function getAnyIdResp($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_get_any_idresp(?)");
      $cmd->execute(
        array(
          $params['idactivo']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  }

  public function getAnyIdUbicacion($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_get_any_ubicacion_activo(?)");
      $cmd->execute(
        array(
          $params['idactivo_resp']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      error_log("Error: " . $e->getMessage());
    }
  }
}

// $resp = new ResponsableAct();
// echo json_encode($resp->getAnyIdResp(['idactivo'=>10]));
// $id=$resp->getAnyIdResp(['idactivo'=>8]);

// echo json_encode($resp->getAnyIdUbicacion(['idactivo_resp'=>$id[0]['idactivo_resp']]));
// echo json_encode($resp->getIdResp(['idactivo'=>3, 'idusuario'=>5]));

//echo json_encode($resp->verificarColaboradores(['idactivo'=>8]));

// echo json_encode($resp->updateAsignacion([
//   'idactivo_resp'=>2,
//   'idactivo'=>1,
//   'idusuario'=>8,
//   'autorizacion'=>1,
// ]));

// echo json_encode($resp->updateChangePrincipal([
//   'idactivo_resp'=>16,
//   'idactivo'=>1,
//   'idusuario'=>7,
//   'es_responsable'=>'0',
//   'autorizacion'=>1,
// ]));

//echo json_encode($resp->getResponsablePrin(['idactivo_resp'=>5, 'idactivo'=>4]));

// echo json_encode($resp->listResp_activo());

// echo json_encode($resp->searchActivoResponsable(['cod_identificacion'=>'5']));

// $valor = $resp->test(['idactivo_resp'=>6]);
// var_dump(count($valor));
//echo json_encode($resp->usersByActivo(['idactivo'=>8]));

//echo json_encode($resp->chooseResponsable(['idactivo_resp'=>24]));

//echo json_encode($resp->repeatAsignacion(['idactivo'=>2, 'idusuario'=>3]));

// $valor = $resp->cantColaboradores(['idactivo'=>3]);
// var_dump($valor);

// $data = $resp->existResponsable(['idactivo'=>4]);
// echo var_dump($data[0]['cantidad']);

//echo json_encode($resp->getRespById(['idactivo_resp'=>6]));


// echo json_encode($resp->add([
//   'idactivo'=>4,
//   'idusuario'=>2,
//   'descripcion'=>'Para el uso del responsable',
//   'imagenes'=>'{"image1":"http://nose.png"}',
//   'condicion_equipo'=>'En optimo estado',
//   'autorizacion'=>1,
//   'solicitud'=>1
// ]));
