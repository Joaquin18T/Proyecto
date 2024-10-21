<?php

require_once 'ExecQuery.php';

class Diagnostico extends ExecQuery
{
  
  public function registrarDiagnostico($params = []): int
  {
    try {
      $sp = parent::execQ("CALL registrarDiagnostico(@iddiagnostico,?,?,?)");
      $sp->execute(
        array(
          $params['idordentrabajo'],
          $params['idtipodiagnostico'],
          $params['diagnostico'],
        )
      );
      $response = parent::execQuerySimple("SELECT @iddiagnostico as iddiagnostico")->fetch(PDO::FETCH_ASSOC);
      return (int) $response['iddiagnostico'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function registrarEvidenciaDiagnostico($params = []): bool
  {
    try {
      $status = false;
      $sp = parent::execQ("CALL registrarEvidenciaDiagnostico(?,?)");
      $status = $sp->execute(array(
        $params['iddiagnostico'],
        $params['evidencia']
      ));
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  
  public function obtenerEvidenciasDiagnostico($params = []): array
  {
    try {
      $sp = parent::execQ("CALL obtenerEvidenciasDiagnostico(?)");
      $sp->execute(array(
        $params['iddiagnostico']
      ));
      return $sp->fetchAll(PDO::FETCH_ASSOC);

    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  
  public function obtenerDiagnostico($params = []): array
  {
    try {
      $sp = parent::execQ("CALL obtenerDiagnostico(?,?)");
      $sp->execute(array(
        $params['idordentrabajo'],
        $params['idtipodiagnostico']
      ));
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
