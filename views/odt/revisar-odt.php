<?php require_once '../header.php' ?>

<div class="row container-fluid">

    <div class="card mb-3">
        <div class="row g-0">

            <div class="contenedor-evidencias p-3 col-md-4 text-center">
                <div id="preview-container-entrada" class="preview-container">
                </div>
            </div>
            <div class="col-md-8">
                <div class="card-body ">
                    <h5 class="card-title">Diagnostico entrada</h5>
                    <p class="card-text" id="txtDiagnosticoEntrada"></p>
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

    <div class="card mb-3">
        <div class="row g-0">

            <div class="contenedor-evidencias p-3 col-md-4 text-center">
                <div id="preview-container-salida" class="preview-container">
                </div>
            </div>
            <div class="col-md-8">
                <div class="card-body ">
                    <h5 class="card-title">Diagnostico salida</h5>
                    <p class="card-text" id="txtDiagnosticoSalida"></p>
                </div>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="card border-0">
                                <div class="card-header fw-bolder border-0 text-center">
                                    Detalles
                                </div>
                                <div class="card-body contenedor-detallesOdtSalida">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card border-0">
                                <div class="card-header border-0 text-center fw-bolder">
                                    Comentario
                                </div>
                                <div class="card-body">
                                    <textarea class="comment-textarea form-control" id="comentario" rows="5" placeholder="Escribe tu comentario aquí..."></textarea>
                                </div>
                                <div class="card-footer text-end border-0">
                                    <button class="btn btn-primary" id="btn-finalizar">Finalizar</button>
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
<script src="http://localhost/CMMS/js/odt/revisar-odt.js"></script>

</body>

</html>