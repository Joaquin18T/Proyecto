<?php require_once '../header.php' ?>

<div class="div row container-fluid">
    <h1>Orden de trabajo</h1>
    <div class="card mb-3" style="max-width: 100%;">
        <div class="row g-0">

            <div class="contenedor-evidencias col-md-4 text-center">
                <div id="preview-container col" class="preview-container">
                    <div class="row" id="contenedor-evidencia-previa">

                    </div>
                    <div class="row" id="contenedor-btn-abrirSideModal">

                    </div>
                </div>
            </div>
            <div class="col-md-8">
                <div class="card-body ">
                    <h5 class="card-title">Diagnostico entrada</h5>
                    <p class="card-text" id="txtDiagnosticoEntrada">This is a wider Lorem ipsum dolor sit amet consectetur adipisicing elit. Laudantium dicta et provident, quae est accusantium, fuga eaque placeat assumenda eos labore enim molestiae iste ab nostrum, quaerat quasi veritatis ex. card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                </div>
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
    <h1>Ejecución</h1>
    <div class="card mb-3" style="max-width: 100%;">
        <div class="row g-0">
            <div class="col-md-4 p-3 text-center contenedor-evidencias">
                <div class="mb-3">
                    <input type="file" name="evidencia[]" id="evidencias-img-input" class="custom-file-input form-control"
                        accept="image/*">
                </div>
                <div id="preview-container" class="preview-container">
                    <p id="no-images-text" class="no-images-text">No hay imágenes seleccionadas aún</p>
                    <img src="https://i.etsystatic.com/36262552/r/il/b32f2f/4239329917/il_570xN.4239329917_gcxb.jpg" class="img-fluid rounded-start" alt="...">
                </div>
            </div>
            <div class="col-md-8">
                <div class="card-body ">
                    <h5 class="card-title">Diagnsotico salida</h5>
                    <textarea class="comment-textarea form-control" id="diagnostico-salida" rows="5" placeholder="Escribe tu diagnostico aquí..."></textarea>
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
                                        <p class="fw-normal d-flex align-items-center col"></p>
                                    </div>
                                    <div class="row">
                                        <p class="fw-bolder col">Fecha acabado: </p>
                                        <p class="fw-normal d-flex align-items-center col"></p>
                                    </div>
                                    <div class="row">
                                        <p class="fw-bolder col">Tiempo de ejecucion: </p>
                                        <p class="fw-normal d-flex align-items-center col"></p>
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
                                    <div class="card-body text-center" id="btn-iniciar">
                                        <button class="btn btn-primary">Iniciar</button>
                                    </div>
                                    <div class="card-body text-center" id="btn-finalizar">
                                        <button class="btn btn-secondary">Finalizar</button>
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
        <div id="modal-evidencias-container">

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