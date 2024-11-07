<?php

require_once '../models/PlanDeTarea.php';

$plandetarea = new PlanDeTarea();

//header("Content-Type: application/json");
//$verbo = $_SERVER["REQUEST_METHOD"];

if (isset($_GET['operation'])) {
    switch ($_GET['operation']) {
        case 'getPlanesDeTareas':
            echo json_encode($plandetarea->getPlanesDeTareas(['eliminado' => $_GET['eliminado']]));
            break;

        case 'verificarPlanInconcluso':
            echo json_encode($plandetarea->verificarPlanInconcluso(['idplantarea' => $_GET['idplantarea']]));
            break;
        
        case 'obtenerPlanTareaPorId':
            echo json_encode($plandetarea->obtenerPlanTareaPorId(['idplantarea' => $_GET['idplantarea']]));
            break;
    }
}


if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case 'add':
            $id = -1;
            $datosEnviar = [
                "descripcion"               => $_POST["descripcion"],
                "idcategoria"               => $_POST["idcategoria"]
            ];
            $id = $plandetarea->add($datosEnviar);
            echo json_encode(["id" => $id]);
            break;

        case 'eliminarPlanDeTarea':
            $path = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : '/';

            $idEliminar = explode("/", $path);
            $idplantarea = ($path != '/') ? end($idEliminar) : null;
            $estado = $plandetarea->eliminarPlanDeTarea(["idplantarea" => $idplantarea, "eliminado" => $_POST['eliminado']]);
            echo json_encode(["eliminado" => $estado]);
            break;

        case 'actualizarPlanDeTareas':
            $datosEnviar = [
                "idplantarea"           => $_POST["idplantarea"],
                "descripcion"           => $_POST["descripcion"],
                "incompleto"              => $_POST["incompleto"]
            ];
            $actualizado = $plandetarea->actualizarPlanDeTareas($datosEnviar);
            echo json_encode(["actualizado" => $actualizado]); // array , accedemos a posicion 0 por que ahi se encuentra
            break;
    }
}
