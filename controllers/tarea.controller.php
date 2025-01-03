<?php

require_once '../models/Tarea.php';

$tarea = new Tarea();


if (isset($_GET['operation'])) {
    switch ($_GET['operation']) {
        case 'obtenerTareaPorId':
            echo json_encode($tarea->obtenerTareaPorId(['idtarea' => $_GET['idtarea']]));
            break;

        case 'obtenerTareasPorPlanTarea':
            echo json_encode($tarea->obtenerTareasPorPlanTarea(['idplantarea' => $_GET['idplantarea']]));
            break;

        case 'obtenerTareas':
            echo json_encode($tarea->obtenerTareas());
            break;

        case 'obtenerFrecuencias':
            echo json_encode($tarea->obtenerFrecuencias());
            break;

        case 'obtenerTareasSinActivos':
            echo json_encode($tarea->obtenerTareasSinActivos());
            break;


        case 'mostrarTareasEnTablaPorIdTarea':
            echo json_encode($tarea->mostrarTareasEnTablaPorIdTarea(['idtarea' => $_GET['idtarea']]));
            break;
    }
}


if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case 'add':
            $id = -1;
            $datosEnviar = [
                "idplantarea"               => $_POST["idplantarea"],
                "idtipo_prioridad"          => $_POST["idtipo_prioridad"],
                "descripcion"               => $_POST["descripcion"],
                "idsubcategoria"            => $_POST["idsubcategoria"],
                "intervalo"                 => $_POST["intervalo"],
                "idfrecuencia"                => $_POST["idfrecuencia"],
                "idestado"                  => $_POST["idestado"],
            ];

            $id = $tarea->add($datosEnviar);
            echo json_encode(["id" => $id]);
            break;

        case 'actualizarTareaEstado':
            $datosEnviar = [
                "idtarea"  => $_POST["idtarea"],
                "idestado" => $_POST["idestado"],
                "trabajado" => $_POST["trabajado"]
            ];
            $actualizado = $tarea->actualizarTareaEstado($datosEnviar);
            echo json_encode(["actualizado" => $actualizado]);
            break;

        case 'actualizarTareaEstadoTrabajado':
            $datosEnviar = [
                "idtarea"  => $_POST["idtarea"],
                "trabajado" => $_POST["trabajado"]
            ];
            $actualizado = $tarea->actualizarTareaEstadoTrabajado($datosEnviar);
            echo json_encode(["actualizado" => $actualizado]);
            break;

        case 'actualizarTareaEstadoPausado':
            $datosEnviar = [
                "idtarea"  => $_POST["idtarea"],
                "pausado" => $_POST["pausado"]
            ];
            $actualizado = $tarea->actualizarTareaEstadoPausado($datosEnviar);
            echo json_encode(["actualizado" => $actualizado]);
            break;

        case 'actualizarTarea':
            $datosEnviar = [
                "idtarea"           => $_POST["idtarea"],
                "idtipo_prioridad"  => $_POST["idtipo_prioridad"],
                "descripcion"       => $_POST["descripcion"],
                "intervalo"                 => $_POST["intervalo"],
                "idfrecuencia"                => $_POST["idfrecuencia"],
                "idestado"          => $_POST["idestado"],
            ];
            $actualizado = $tarea->actualizarTarea($datosEnviar);
            echo json_encode($actualizado[0]); // array , accedemos a posicion 0 por que ahi se encuentra
            break;

        case 'eliminarTarea':
            $path = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : '/';

            $idEliminar = explode("/", $path);
            $idtarea = ($path != '/') ? end($idEliminar) : null;
            $estado = $tarea->eliminarTarea(["idtarea" => $idtarea]);
            echo json_encode(["eliminado" => $estado]);
            break;

        case 'actualizarEstadoInhabilitadoTarea':
            $datosEnviar = [
                "idtarea"  => $_POST["idtarea"],
                "inhabilitado" => $_POST["inhabilitado"]
            ];
            $actualizado = $tarea->actualizarEstadoInhabilitadoTarea($datosEnviar);
            echo json_encode(["actualizado" => $actualizado]);
            break;
    }
}
