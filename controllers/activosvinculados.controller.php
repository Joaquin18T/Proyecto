<?php


require_once  '../models/Activosvinculados.php';

$activosvinculados = new Activosvinculados();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'listarActivosPorTareaYPlan':
      echo json_encode($activosvinculados->listarActivosPorTareaYPlan(["idplantarea" => $_GET["idplantarea"]]));
      break;

    case 'obtenerUnActivoVinculadoAtarea':
      echo json_encode($activosvinculados->obtenerUnActivoVinculadoAtarea(["idactivovinculado" => $_GET["idactivovinculado"]]));
      break;

      /* case 'obtenerActivosPorPlanTarea':
      echo json_encode($activosvinculados->obtenerActivosPorPlanTarea(["idplantarea" => $_GET["idplantarea"]]));
      break; */
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'insertarActivoPorTarea':
      $datosEnviar = [
        "idactivo"   => $_POST["idactivo"],
        "idtarea"     => $_POST["idtarea"]
      ];

      $id = $activosvinculados->insertarActivoPorTarea($datosEnviar);
      echo json_encode(["id" => $id]);
      break;

    case 'eliminarActivosVinculadosTarea':
      $path = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : '/';

      $idEliminar = explode("/", $path);
      $idactivovinculado = ($path != '/') ? end($idEliminar) : null;
      $eliminado = $activosvinculados->eliminarActivosVinculadosTarea(["idactivovinculado" => $idactivovinculado]);
      echo json_encode(["eliminado" => $eliminado]);
      break;

    case 'actualizarEstadoDesvinculadoAVT':
      $datosEnviar = [
        "idactivovinculado"           => $_POST["idactivovinculado"],
        "desvinculado"                => $_POST["desvinculado"]
      ];
      $actualizado = $activosvinculados->actualizarEstadoDesvinculadoAVT($datosEnviar);
      echo json_encode(["actualizado"=>$actualizado]); // array , accedemos a posicion 0 por que ahi se encuentra
      break;
  }
}
