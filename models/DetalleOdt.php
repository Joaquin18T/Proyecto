<?php

require_once 'ExecQuery.php';

class DetalleOdt extends ExecQuery
{

/*     public function obtenerTareaDeOdtGenerada($params = []): array
    {
        try {
            $cmd = parent::execQ("CALL obtenerTareaDeOdtGenerada(?)");
            $cmd->execute(array(
                $params['idodt']
            ));
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO
 */
    public function registrarDetalleOdt($params = []): int
    {
        try {
            $cmd = parent::execQ("call registrarDetalleOdt(@iddetalleodt,?,?,?,?,?)");
            $cmd->execute(
                array(
                    $params['idordentrabajo'],
                    $params['fecha_inicio'],
                    $params['fecha_final'],
                    $params['tiempo_ejecucion'],
                    $params['clasificacion']
                )
            );
            $response = parent::execQuerySimple("SELECT @idordentrabajo as idordentrabajo")->fetch(PDO::FETCH_ASSOC);
            return (int) $response['idordentrabajo'];
        } catch (Exception $e) {
            die($e->getMessage()); // ME QUEDE ACA
        }
    } // INTEGRADO

    /* public function verificarTareaInconclusa($params = []): array
    {
        try {
            $cmd = parent::execQ("CALL verificarTareaInconclusa()");
            $cmd->execute();
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // ELIMINADO

    public function obtenerTareasOdt($params = []): array
    {
        try {
            $cmd = parent::execQ("CALL obtenerTareasOdt(?)");
            $cmd->execute(array(
                $params['borrador']
            ));
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO

    public function actualizarBorradorOdt($params = []): bool
    {
        try {
            $status = false;
            $cmd = parent::execQ("CALL actualizarBorradorOdt(?,?)");
            $status = $cmd->execute(array(
                $params['idordentrabajo'],
                $params['borrador']
            ));
            return $status;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO
    
    public function eliminarOdt($params = []): bool
    {
        try {
            $status = false;
            $cmd = parent::execQ("CALL eliminarOdt(?)");
            $status = $cmd->execute(array(
                $params['idordentrabajo']
            ));
            return $status;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } //  INTEGRADO */
}
