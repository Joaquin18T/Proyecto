<?php

require_once '../models/Diagnostico.php';

$diagnostico = new Diagnostico();

function convertirAImagenBase64($archivo) {
    $tipo = pathinfo($archivo['name'], PATHINFO_EXTENSION); // Obtener el tipo de archivo
    $contenido = file_get_contents($archivo['tmp_name']); // Leer el contenido del archivo
    return 'data:image/' . $tipo . ';base64,' . base64_encode($contenido); // Codificar a Base64
}

if(isset($_GET['operation'])){
    switch ($_GET['operation']) {
        case 'obtenerEvidenciasDiagnostico':
            echo json_encode($diagnostico->obtenerEvidenciasDiagnostico(["iddiagnostico" => $_GET["iddiagnostico"]]));
            break;
    }
}

if (isset($_POST["operation"])) {
    switch ($_POST["operation"]) {
        case 'registrarDiagnostico':
            $datosEnviar = [
                "idordentrabajo"        => $_POST["idordentrabajo"],
                "idtipodiagnostico"     => $_POST["idtipodiagnostico"],
                "diagnostico"           => $_POST["diagnostico"]
            ];

            $id = $diagnostico->registrarDiagnostico($datosEnviar);
            echo json_encode(["id" => $id]);
            break;

        case 'registrarEvidenciaDiagnostico':
            //$iddiagnostico = $_POST["iddiagnostico"]
            $archivoEvidencia = $_FILES["evidencia"];
            $evidenciaBase64 = convertirAImagenBase64($archivoEvidencia);

            $datosEnviar = [
                "iddiagnostico" => $_POST["iddiagnostico"],
                "evidencia"     => $evidenciaBase64
            ];
            //echo $evidenciaBase64;
            error_log(print_r($datosEnviar, true));

            $resultado = $diagnostico->registrarEvidenciaDiagnostico($datosEnviar);
            echo json_encode(["guardado" => "success", "message" => "Evidencia registrada con exito.", "data" => $resultado]);
            break;
        
        
    }
}

