<?php

require_once 'ExecQuery.php';

class PlanDeTarea extends ExecQuery
{

    public function getPlanesDeTareas($params = []):array
    {
        try {
            $sp = parent::execQ("CALL obtenerPlantareasDetalles(?)");
            $sp->execute(array(
                $params['eliminado']
            ));
            return $sp->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO ✔

    public function add($params = []): int
    {
        try {
            $sp = parent::execQ("CALL insertarPlanDeTareas(@idplantarea,?,?)");
            $sp->execute(
                array(
                    $params['descripcion'],
                    $params['idcategoria']
                )
            );
            $response = parent::execQuerySimple("SELECT @idplantarea as idplantarea")->fetch(PDO::FETCH_ASSOC);
            return (int) $response['idplantarea'];
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO ✔

    public function verificarPlanInconcluso($params = [])
    {
        try {
            $sp = parent::execQ("CALL verificarPlanInconcluso(?)");
            $sp->execute(array($params['idplantarea']));
            return $sp->fetchAll(PDO::FETCH_ASSOC); // ME DEVOLVERA EL ULTIMO ID GENERADO
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO ✔

    public function obtenerPlanTareaPorId($params = [])
    {
        try {
            $sp = parent::execQ("CALL obtenerPlanTareaPorId(?)");
            $sp->execute(array($params['idplantarea']));
            return $sp->fetchAll(PDO::FETCH_ASSOC); // ME DEVOLVERA EL ULTIMO ID GENERADO
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO 

    public function eliminarPlanDeTarea($params = []): bool //ESTO SERA ELIMINACION LOGICA
    {
        try {
            $status = false;
            $sp = parent::execQ("CALL eliminarPlanDeTarea(?,?)");
            $status = $sp->execute(array(
                $params['idplantarea'],
                $params['eliminado']
            ));
            return $status;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO ✔

    public function actualizarPlanDeTareas($params = []): bool // USARE ESTE MISMO PARA CUANDO TERMINEN DE HACER EL PLAN
    {
        try {
            $status = false;
            $sp = parent::execQ("CALL actualizarPlanDeTareas(?,?,?)");
            $status = $sp->execute(array(
                $params['idplantarea'],
                $params['descripcion'],
                $params['incompleto']
            ));
            return $status;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    } // INTEGRADO ✔
}
