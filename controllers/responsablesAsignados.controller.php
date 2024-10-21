<?php
require_once '../models/ResponsableAsignado.php';

$responsableasignado = new ResponsableAsignado();

if (isset($_GET['operation'])) {
    switch ($_GET['operation']) {
        case 'obtenerResponsables':
            echo json_encode($responsableasignado->obtenerResponsables(['idodt' => $_GET['idodt']]));
            break;
    }
}

if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case 'asignarResponsables':
            $estado = [
                'idresponsableasignado' => ''
            ];
            $enviar = [
                'idordentrabajo' => $_POST['idordentrabajo'],
                'idresponsable' => $_POST['idresponsable']
            ];
            $resp = $responsableasignado->asignarResponsables($enviar);
            if ($resp > 0) {
                $estado['idresponsableasignado'] = $resp;
            } else {
                $estado['idresponsableasignado'] = -1;
            }
            echo json_encode($estado);
            break;

        case 'eliminarResponsableOdt':
            $path = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : '/';

            $idEliminar = explode("/", $path);
            $idresponsableasignado = ($path != '/') ? end($idEliminar) : null;
            $estado = $responsableasignado->eliminarResponsableOdt(["idresponsableasignado" => $idresponsableasignado]);
            echo json_encode(["eliminado" => $estado]);
            break;
    }
}
