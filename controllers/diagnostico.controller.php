<?php

require_once '../models/Diagnostico.php';

$diagnostico = new Diagnostico();

$uploadDir = '../dist/images/evidencias/';

if (isset($_GET['operation'])) {
    switch ($_GET['operation']) {
        case 'obtenerEvidenciasDiagnostico':
            echo json_encode($diagnostico->obtenerEvidenciasDiagnostico(["iddiagnostico" => $_GET["iddiagnostico"]]));
            break;

        case 'obtenerDiagnostico':
            echo json_encode($diagnostico->obtenerDiagnostico(["idordentrabajo" => $_GET['idordentrabajo'], "idtipodiagnostico" => $_GET["idtipodiagnostico"]]));
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
            // Procesar la imagen enviada
            $archivoEvidencia = $_FILES["evidencia"];

            // Generar un nombre aleatorio de 8 caracteres
            $nombreAleatorio = substr(str_shuffle("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"), 0, 8);

            // Extraer la extensión del archivo original
            $extension = pathinfo($archivoEvidencia["name"], PATHINFO_EXTENSION);

            // Crear el nuevo nombre del archivo con la extensión original
            $nombreArchivo = $nombreAleatorio . '.' . $extension;

            // Definir la ruta completa donde se guardará la imagen
            $rutaArchivo = $uploadDir . $nombreArchivo;

            // Mover el archivo a la carpeta de destino
            if (move_uploaded_file($archivoEvidencia["tmp_name"], $rutaArchivo)) {
                $datosEnviar = [
                    "iddiagnostico" => $_POST["iddiagnostico"],
                    "evidencia"     => $nombreArchivo  // Guardar solo el nombre en la base de datos
                ];

                $resultado = $diagnostico->registrarEvidenciaDiagnostico($datosEnviar);
                echo json_encode(["guardado" => "success", "message" => "Evidencia registrada con éxito.", "data" => $resultado]);
            } else {
                echo json_encode(["guardado" => "error", "message" => "Error al guardar la evidencia."]);
            }
            break;
    }
}
