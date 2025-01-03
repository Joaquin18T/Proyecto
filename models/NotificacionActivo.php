<?php

require_once 'ExecQuery.php';

class Notificacion extends ExecQuery
{
  public function listNotifications($params = []): array
  {
    try {

      $cmd = parent::execQ('CALL sp_list_notificacion(?)');
      $cmd->execute(
        array(
          $params['idusuario']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function listNotificationsMantenimiento($params = []): array
  {
    try {

      $cmd = parent::execQ('CALL sp_list_notificacion_mantenimiento(?)');
      $cmd->execute(
        array(
          $params['idusuario']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function detalleAsignacionNotf($params = []): array
  {
    try {
      $cmd = parent::execQ('CALL sp_detalle_asignacion_notificacion(?)');
      $cmd->execute(
        array(
          $params['idnotificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function add($params = []): bool
  {
    try {
      $status = false;
      $cmd = parent::execQ('CALL sp_add_notificacion_activo(?,?,?,?)');
      $status = $cmd->execute(
        array(
          $params['idactivo_resp'],
          $params['tipo'],
          $params['mensaje'],
          $params['idactivo']
        )
      );
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function agregarNotificacionOdt($params = []): int
  {
    try {
      $cmd = parent::execQ('CALL agregarNotificacionOdt(@idnotificacion_mantenimiento,?,?,?,?,?)');
      $cmd->execute(
        array(
          $params['idodt'],
          $params['tarea'],
          $params['activos'],
          $params['idresp'],
          $params['mensaje']
        )
      );
      $response = parent::execQuerySimple("SELECT @idnotificacion_mantenimiento as idnotificacion_mantenimiento")->fetch(PDO::FETCH_ASSOC);
      return (int) $response['idnotificacion_mantenimiento'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function detallesNoftMantenimiento($params = []): array
  {
    try {

      $cmd = parent::execQ('CALL sp_detalle_orden_trabajo(?)');
      $cmd->execute(
        array(
          $params['idnotificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }


  public function detalleByEstado($params = []): array
  {
    try {
      $cmd = parent::execQ('CALL sp_detalle_sol_estado(?)');
      $cmd->execute(
        array(
          $params['idsolicitud']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function dataRespNotificacion($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_responsable_notificacion(?)");
      $cmd->execute(
        array(
          $params['idusuario']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function NotifDesignacionDetalle($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_notificacion_designacion_detalle(?)");
      $cmd->execute(
        array(
          $params['idnotificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
      return [];
    }
  }


  public function NotifiDetalleBajaActivo($params=[]):array{
    try{
      $cmd=parent::execQ("CALL sp_notificacion_baja_detalle(?)");
      $cmd->execute(
        array(
          $params['idnotificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
      return [];
    }
  }


  public function detalleNof_wh_IdactivoResp($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_detalle_notificacion_baja_wh_idactivo_resp(?)");
      $cmd->execute(
        array(
          $params['idnotificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
      return [];
    }
  }
 
  public function detalleUbicacionNoft($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_detalle_ubicacion_notificacion(?)");
      $cmd->execute(
        array(
          $params['idnotificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
      return [];
    }
  }

  public function detalleResponsablePNoft($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_responsable_principal_detalle_notificacion(?)");
      $cmd->execute(
        array(
          $params['idnotificacion']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
      return [];
    }
  }
}

// $not = new Notificacion();

// echo json_encode($not->detalleNof_wh_IdactivoResp(['idnotificacion'=>58]));

//echo json_encode($not->detalleUbicacionNoft(['idnotificacion'=>4]));

//echo json_encode($not->detalleResponsablePNoft(['idnotificacion'=>4]));

// echo json_encode($not->dataRespNotificacion(['idusuario'=>12]));

//echo json_encode($not->listNotifications(['idusuario'=>2]));

//echo json_encode($not->detalleNotificaciones(['idusuario'=>12, 'idactivo_resp'=>6]));

// echo json_encode($not->add([
//   'idusuario'=>4,
//   'idsolicitud'=>8,
//   'mensaje'=>'Tu solicitud para al activo ha sido rechazado'
// ]));

//echo json_encode($not->detalleByEstado(['idsolicitud'=>20]));