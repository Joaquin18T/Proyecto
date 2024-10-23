<?php

require_once 'ExecQuery.php';

class ResponsableAsignado extends ExecQuery
{
  public function asignarResponsables($params = []): int
  {
    try {
      $sp = parent::execQ("CALL asignarResponsables(@idresponsableasignado,?,?)");
      $sp->execute(array($params['idordentrabajo'], $params['idresponsable']));
      $response = parent::execQuerySimple("SELECT @idresponsableasignado as idresponsableasignado")->fetch(PDO::FETCH_ASSOC);
      return (int) $response['idresponsableasignado'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  
  public function obtenerResponsables($params = []): array
  {
    try {
      $sp = parent::execQ("CALL obtenerResponsables(?)");
      $sp->execute(array($params['idodt']));
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  
  public function eliminarResponsableOdt($params = []): bool
  {
    try {
      $status = -1;
      $sp = parent::execQ("CALL eliminarResponsableOdt(?)");
      $status = $sp->execute(array($params['idresponsableasignado']));
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
