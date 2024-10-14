<?php

require_once 'ExecQuery.php';

class Activosvinculados extends ExecQuery
{

 /*  public function obtenerActivosPorPlanTarea($params = []): array
  {
    try {
      $sp = parent::execQ("CALL obtenerActivosVinculadosPorPlanTarea(?)");
      $sp->execute(array($params['idplantarea']));
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
 */
  public function insertarActivoPorTarea($params = []): int
  {
    try {
      $sp = parent::execQ("CALL insertarActivoPorTarea(@idactivovinculado,?,?)");
      $sp->execute(
        array(
          $params['idactivo'],
          $params['idtarea']
        )
      );
      $response = parent::execQuerySimple("SELECT @idactivovinculado as idactivovinculado")->fetch(PDO::FETCH_ASSOC);
      return (int) $response['idactivovinculado'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO


  public function listarActivosPorTareaYPlan($params = []): array
  {
    try {
      $sp = parent::execQ("CALL listarActivosPorTareaYPlan(?)");
      $sp->execute(
        array(
          $params['idplantarea']
        )
      );
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO

  public function obtenerUnActivoVinculadoAtarea($params = []): array
  {
    try {
      $sp = parent::execQ("CALL obtenerUnActivoVinculadoAtarea(?)");
      $sp->execute(
        array(
          $params['idactivovinculado']
        )
      );
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // integrado

  // METODO DE ELIMIMNAR
  public function eliminarActivosVinculadosTarea($params = []): bool
  {
    try {
      $status = false;
      $sp = parent::execQ("CALL eliminarActivosVinculadosTarea(?)");
      $status = $sp->execute(array($params['idactivovinculado']));
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO
}
