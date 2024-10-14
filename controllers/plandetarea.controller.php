<?php

require_once '../models/PlanDeTarea.php';

$plandetarea = new PlanDeTarea();

//header("Content-Type: application/json");
//$verbo = $_SERVER["REQUEST_METHOD"];

if (isset($_GET['operation'])) {
    switch ($_GET['operation']) {
        case 'getPlanesDeTareas':
            echo json_encode($plandetarea->getPlanesDeTareas());
            break;

        case 'verificarPlanInconcluso':
            echo json_encode($plandetarea->verificarPlanInconcluso(['idplantarea' => $_GET['idplantarea']]));
            break;
    }
}

if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case 'add':
            $id = -1;
            $datosEnviar = [
                "descripcion"               => $_POST["descripcion"]
            ];
            $id = $plandetarea->add($datosEnviar);
            echo json_encode(["id" => $id]);
            break;

        case 'eliminarPlanDeTarea':
            $path = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : '/';

            $idEliminar = explode("/", $path);
            $idplantarea = ($path != '/') ? end($idEliminar) : null;
            $estado = $plandetarea->eliminarPlanDeTarea(["idplantarea" => $idplantarea]);
            echo json_encode(["eliminado" => $estado]);
            break;

        case 'actualizarPlanDeTareas':
            $datosEnviar = [
                "idplantarea"           => $_POST["idplantarea"],
                "descripcion"           => $_POST["descripcion"],
                "borrador"              => $_POST["borrador"]
            ];
            $actualizado = $plandetarea->actualizarPlanDeTareas($datosEnviar);
            echo json_encode(["actualizado" => $actualizado]); // array , accedemos a posicion 0 por que ahi se encuentra
            break;
    }
}
