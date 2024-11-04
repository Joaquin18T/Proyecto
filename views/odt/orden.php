<?php require_once '../header.php' ?>

<div class="row container-fluid">
    <div class="row">
        <h1>Ejecución</h1>
        <a href="http://localhost/CMMS/views/odt/" class="btn btn-primary">Volver</a>
    </div>

    <div class="card mb-3" style="max-width: 100%;">
        <div class="row g-0">
            <div class="col-md-4 p-3 text-center contenedor-evidencias-entrada">
                <div class="mb-3">
                    <h5 class="card-title">Evidencias de entrada</h5>
                    <input type="file" name="evidencia[]" id="evidencias-img-input-entrada" class="custom-file-input form-control"
                        accept="image/*">
                </div>
                <div id="preview-container-entrada" class="preview-container">
                    <p id="no-images-text" class="no-images-text">No hay imágenes seleccionadas aún</p>
                </div>
            </div>
            <!-- <div class="contenedor-evidencias p-3 col-md-4 text-center">
                <div id="preview-container-entrada" class="preview-container">
                </div>
            </div> -->
            <div class="col-md-8">
                <div class="card-body ">
                    <h5 class="card-title">Diagnostico de entrada</h5>
                    <textarea class="comment-textarea form-control mb-3" id="diagnostico-entrada" rows="5" placeholder="Escribe tu diagnostico aquí..." disabled></textarea>
                    <button class="btn btn-primary" id="btn-guardar-diagnostico-entrada" disabled>Guardar</button>
                </div>

                <!-- <div class="card-body ">
                    <h5 class="card-title">Diagnostico entrada</h5>
                    <p class="card-text" id="txtDiagnosticoEntrada">This is a wider Lorem ipsum dolor sit amet consectetur adipisicing elit. Laudantium dicta et provident, quae est accusantium, fuga eaque placeat assumenda eos labore enim molestiae iste ab nostrum, quaerat quasi veritatis ex. card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                </div> -->
                <div class="card-footer">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="card border-0">
                                <div class="card-header fw-bolder border-0 text-center">
                                    Detalles
                                </div>
                                <div class="card-body contenedor-detallesOdtEntrada">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card border-0">
                                <div class="card-header border-0 text-center fw-bolder">
                                    Responsables
                                </div>
                                <div class="card-body">
                                    <ul class="list-group contenedor-responsablesOdt">
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card mb-3" style="max-width: 100%;">
        <div class="row g-0">
            <div class="col-md-4 p-3 text-center contenedor-evidencias">
                <div class="mb-3">
                    <h5 class="card-title">Evidencias de salida</h5>
                    <input type="file" name="evidencia[]" id="evidencias-img-input-salida" class="custom-file-input form-control"
                        accept="image/*">
                </div>
                <div id="preview-container-salida" class="preview-container">
                    <p id="no-images-text" class="no-images-text">No hay imágenes seleccionadas aún</p>
                </div>
            </div>
            <div class="col-md-8">
                <div class="card-body ">
                    <h5 class="card-title">Diagnostico de salida</h5>
                    <textarea class="comment-textarea form-control mb-3" id="diagnostico-salida" rows="5" placeholder="Escribe tu diagnostico aquí..." disabled></textarea>
                    <button class="btn btn-primary" id="btn-guardar-diagnostico-salida" disabled>Guardar</button>
                </div>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="card border-0">
                                <div class="card-header border-0 text-center">
                                    <h5 class="fw-bolder">Tiempo</h5>
                                </div>
                                <div class="card-body ">
                                    <div class="row">
                                        <p class="fw-bolder col">Fecha inicial: </p>
                                        <p class="fw-normal d-flex align-items-center col" id="txtFechaInicial"></p>
                                    </div>
                                    <div class="row">
                                        <p class="fw-bolder col">Fecha acabado: </p>
                                        <p class="fw-normal d-flex align-items-center col" id="txtFechaFinal"></p>
                                    </div>
                                    <div class="row">
                                        <p class="fw-bolder col">Tiempo de ejecucion: </p>
                                        <p class="fw-normal d-flex align-items-center col" id="txtTiempoEjecucion"></p>
                                    </div>
                                    <div class="row">
                                        <p class="fw-bolder col">Intervalos ejecutados: </p>
                                        <p class="fw-normal d-flex align-items-center col" id="txtIntervalosEjecutados"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card border-0 text-center">
                                <div class="card-header border-0 ">
                                    <h5 class="fw-bold">Acciones</h5>
                                </div>
                                <div class="card-body">
                                    <div class="card-body text-center">
                                        <button class="btn btn-primary" id="btn-iniciar">Iniciar</button>
                                    </div>
                                    <div class="card-body text-center">
                                        <button class="btn btn-secondary" id="btn-finalizar">Finalizar</button>
                                    </div>
                                    <div class="card-body text-center">
                                        <button class="btn btn-secondary" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRightEvidencias" id="btn-verDetalles">Ver Ejecuciones</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
<!-- MODAL DE MOSTRAR EVIDENCIAS -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasRightEvidencias"
    aria-labelledby="offcanvasRightEvidenciasLabel">
    <div class="offcanvas-header">
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <h2>Lista de todas las evidencias</h2>
        <div id="modal-container">

        </div>
    </div>
</div>

<?php require_once '../footer.php' ?>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Luego, el archivo de DataTables -->
<!-- jKanban JS -->
<script src="https://cdn.jsdelivr.net/npm/jkanban@1.2.0/dist/jkanban.min.js"></script>
<script>
    const idusuario = "<?php echo $_SESSION['login']['idusuario']; ?>"
</script>
<script src="http://localhost/CMMS/js/odt/orden.js"></script>

</body>

</html>