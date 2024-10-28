<?php

require_once 'ExecQuery.php';

class OrdenTrabajo extends ExecQuery
{

    public function obtenerTareaDeOdtGenerada($params = []): array
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

    public function obtenerDetalleOdt($params = []): array
    {
        try {
            $cmd = parent::execQ("CALL obtenerDetalleOdt(?)");
            $cmd->execute(array(
                $params['idordentrabajo']
            ));
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO


    public function add($params = []): int
    {
        try {
            $cmd = parent::execQ("call registrar_odt(@idordentrabajo,?,?)");
            $cmd->execute(
                array(
                    $params['idtarea'],
                    $params['creado_por']
                )
            );
            $response = parent::execQuerySimple("SELECT @idordentrabajo as idordentrabajo")->fetch(PDO::FETCH_ASSOC);
            return (int) $response['idordentrabajo'];
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO


    public function registrarDetalleOdt($params = []): int
    {
        try {
            $cmd = parent::execQ("call registrarDetalleOdt(@iddetalleodt,?,?)");
            $cmd->execute(
                array(
                    $params['idodt'],
                    $params['clasificacion']
                )
            );
            $response = parent::execQuerySimple("SELECT @iddetalleodt as iddetalleodt")->fetch(PDO::FETCH_ASSOC);
            return (int) $response['iddetalleodt'];
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO

    public function registrarComentarioOdt($params = []): bool
    {
        try {
            $status = false;
            $cmd = parent::execQ("call registrar_comentario_odt(?,?,?)");
            $status = $cmd->execute(
                array(
                    $params['idodt'],
                    $params['comentario'],
                    $params['revisadopor']
                )
            );
            return $status;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO

    public function verificarTareaInconclusa($params = []): array
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
            $cmd = parent::execQ("CALL obtenerTareasOdt");
            $cmd->execute();
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

    public function actualizarEstadoOdt($params = []): bool
    {
        try {
            $status = false;
            $cmd = parent::execQ("CALL actualizarEstadoOdt(?,?)");
            $status = $cmd->execute(array(
                $params['idodt'],
                $params['idestado']
            ));
            return $status;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO

    public function actualizarDetalleOdt($params = []): bool
    {
        try {
            $status = false;
            $cmd = parent::execQ("CALL actualizarDetalleOdt(?,?,?,?)");
            $status = $cmd->execute(array(
                $params['iddetalleodt'],
                $params['fechafinal'],
                $params['tiempoejecucion'],
                $params['clasificacion']
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
    } //  INTEGRADO


}
