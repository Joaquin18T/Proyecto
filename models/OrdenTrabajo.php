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

    public function obtenerHistorialOdt($params = []): array
    {
        try {
            $cmd = parent::execQ("CALL obtenerHistorialOdt()");
            $cmd->execute();
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO

    public function obtenerOdtporId($params = []): array
    {
        try {
            $cmd = parent::execQ("CALL obtenerOdtporId(?)");
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
            $cmd = parent::execQ("call registrar_odt(@idordentrabajo,?,?,?,?)");
            $cmd->execute(
                array(
                    $params['idtarea'],
                    $params['creado_por'],
                    $params['fecha_inicio'],
                    $params['hora_inicio']
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
            $cmd = parent::execQ("call registrarDetalleOdt(@iddetalleodt,?,?,?)");
            $cmd->execute(
                array(
                    $params['idodt'],
                    $params['intervalos_ejecutados'],
                    $params['clasificacion']
                )
            );
            $response = parent::execQuerySimple("SELECT @iddetalleodt as iddetalleodt")->fetch(PDO::FETCH_ASSOC);
            return (int) $response['iddetalleodt'];
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO

    public function registrarHistorialOdt($params = []): int
    {
        try {
            $cmd = parent::execQ("CALL registrarHistorialOdt(
                @idhistorial,
                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
            )");
            $cmd->execute([
                $params['idodt'],
                $params['clasificacion'],
                $params['creador'],
                $params['responsables'],
                $params['tiempo_ejecucion'],
                $params['activos'],
                $params['tarea'],
                $params['revisado_por'],
                $params['tipo_prioridad'],
                $params['fecha_inicio'],
                $params['hora_inicio'],
                $params['nom_estado'],
                $params['incompleto'],
                $params['fecha_final'],
                $params['hora_final']
            ]);
            $response = parent::execQuerySimple("SELECT @idhistorial as idhistorial")->fetch(PDO::FETCH_ASSOC);
            return (int) $response['idhistorial'];
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
            $cmd = parent::execQ("CALL actualizarDetalleOdt(?,?,?,?,?)");
            $status = $cmd->execute(array(
                $params['iddetalleodt'],
                $params['fechafinal'],
                $params['tiempoejecucion'],
                $params['intervalos_ejecutados'],
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

    public function actualizarFechaFinalOdt($params = []): bool
    {
        try {
            $status = false;
            $cmd = parent::execQ("CALL actualizarFechaFinalOdt(?,?,?)");
            $status = $cmd->execute(array(
                $params['idodt'],
                $params['fechafinal'],
                $params['horafinal']
            ));
            return $status;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO

}
