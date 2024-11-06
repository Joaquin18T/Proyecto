<?php

require_once 'ExecQuery.php';

class Tarea extends ExecQuery
{

  public function obtenerFrecuencias($params = []): array
  {
    try {
      $sp = parent::execQ("CALL obtenerFrecuencias");
      $sp->execute();
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO ✔

  public function obtenerTareasPorPlanTarea($params = []): array
  {
    try {
      $sp = parent::execQ("CALL obtenerTareasPorPlanTarea(?)");
      $sp->execute(array($params['idplantarea']));
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO ✔

  public function add($params = []): int
  {
    try {
      $sp = parent::execQ("CALL insertarTarea(@idtarea,?,?,?,?,?,?,?)");
      $sp->execute(
        array(
          $params['idplantarea'],
          $params['idtipo_prioridad'],
          $params['descripcion'],
          $params['idsubcategoria'],
          $params['intervalo'],
          $params['idfrecuencia'],
          $params['idestado']
        ),

      );
      $response = parent::execQuerySimple("SELECT @idtarea as idtarea")->fetch(PDO::FETCH_ASSOC);
      return (int) $response['idtarea'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO ✔

  public function obtenerTareaPorId($params = []): array
  {
    try {
      $sp = parent::execQ("CALL obtenerTareaPorId(?)");
      $sp->execute(array($params['idtarea']));
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO ✔

  // METODOS DE ACTUALIZAR
  public function actualizarTarea($params = []): array
  {
    try {
      $sp = parent::execQ("CALL actualizarTarea(?,?,?,?,?,?)");
      $sp->execute(
        array(
          $params['idtarea'],
          $params['idtipo_prioridad'],
          $params['descripcion'],
          $params['intervalo'],
          $params['idfrecuencia'],
          $params['idestado']
        )
      );
      return $sp->fetchAll(PDO::FETCH_ASSOC); // ME DEVOLVERA EL ULTIMO ID GENERADO
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO ✔

  public function actualizarTareaEstadoTrabajado($params = []): bool
  {
    try {
      $status = false;
      $sp = parent::execQ("CALL actualizarTareaEstadoTrabajado(?,?)");
      $status = $sp->execute(
        array(
          $params['idtarea'],
          $params['trabajado']
        )
      );
      return $status; // ME DEVOLVERA EL ULTIMO ID GENERADO
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO ✔

  //METODO DE ELIMINAR
  public function eliminarTarea($params = []): bool
  {
    try {
      $status = false;
      $sp = parent::execQ("CALL eliminarTarea(?)");
      $status = $sp->execute(array($params['idtarea']));
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function obtenerTareas(): array
  {
    try {
      $sp = parent::execQ("CALL obtenerTareas");
      $sp->execute();
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO ✔

  public function actualizarTareaEstado($params = []): bool
  {
    try {
      $status = false;
      $sp = parent::execQ("CALL actualizarTareaEstado(?,?,?)");
      $status = $sp->execute(array(
        $params['idtarea'],
        $params['idestado'],
        $params['trabajado']
      ));
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO ✔

  public function actualizarTareaEstadoPausado($params = []): bool
  {
    try {
      $status = false;
      $sp = parent::execQ("CALL actualizarTareaEstadoPausado(?,?)");
      $status = $sp->execute(array(
        $params['idtarea'],
        $params['pausado']
      ));
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  } // INTEGRADO ✔
}
