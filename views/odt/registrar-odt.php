<?php require_once '../header.php' ?>

<div class="container-fluid py-1">
    <div class="row gx-0 gy-1 gx-md-3 row-cols-1 row-cols-md-2 tab-content d-md-flex"><!--  style="height: 90vh;" -->
        <div class="contenedor-diagnostico-evidencia col align-items-stretch tab-pane show pe-0 fade d-md-flex active kanban-col mb-3">
            <div class="card border-0 pb-3 w-100">
                <div class="card-body p-4">
                    <h2 class="fs-5 fw-normal text-dark mb-2">Evidencias</h2>
                    <div class="px-md-2 pt-2 me-0 pe-1 me-md-1" style="/*max-height: calc(100vh - 150px);*//*overflow-y: auto;*/">
                        <div class="contenedor-evidencias">
                            <div class="mb-3">
                                <input type="file" name="evidencia[]" id="evidencias-img-input" class="custom-file-input form-control"
                                    accept="image/*">
                            </div>
                            <div id="preview-container" class="preview-container">
                                <p id="no-images-text" class="no-images-text">No hay imágenes seleccionadas aún</p>
                            </div>
                        </div>
                        <hr>
                        <div class="contenedor-diagnostico-entrada">
                            <h2 class="fs-5 fw-normal text-dark mb-2">Dianostico de Entrada</h2>
                            <textarea class="comment-textarea form-control" id="diagnostico-entrada" rows="5" placeholder="Escribe tu comentario aquí..."></textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="contenedor-responsables col align-items-stretch tab-pane show pe-0 fade d-md-flex active kanbancol mb-3">
            <div class="card border-0 pb-3 w-100">
                <div class="card-body p-4">
                    <h2 class="fs-5 fw-normal text-dark mb-2">Asignar Responsables</h2>
                    <div class="px-md-2 pt-2 me-0 pe-1 me-md-1" style="/*max-height: calc(100vh - 150px);*//*overflow-y: auto;*/">
                        <div class="card mb-3">
                            <div class="card-header">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-floating mb-3">
                                            <input type="text" class="form-control filter" id="txtNombresApellidos" placeholder="Nombres y Apellidos" autocomplete="off">
                                            <label for="txtNombresApellidos" class="form-label">Nombres y Apellidos</label>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-floating">
                                            <input type="text" class="form-control filter" id="txtDni" placeholder="Documento de identidad" autocomplete="off">
                                            <label for="txtDni" class="form-label">Documento de identidad</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <table id="tablaResponsables" class="stripe row-border order-column nowrap table-hover" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>Nombres</th>
                                            <th>Usuario</th>
                                            <th>Rol</th>
                                            <th>Numero documento</th>
                                        </tr>
                                    </thead>
                                    <tbody id="responsablesBodyTable"></tbody>
                                </table>
                            </div>
                            <div class="card-footer">
                                <button type="button" class="btn btn-primary" id="btnAgregarResponsable">Agregar</button>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-body">
                                <div class="contenedor-responsables-asignados">
                                    <ul>
                                        
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row justify-content-center">
        <button id="btnCrearOdt" class="mb-3 btn btn-primary">Crear Odt</button>
    </div>
    <!-- MODAL DE MOSTRAR RESPONSABLES -->
    <!-- <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasRightResponsables" aria-labelledby="offcanvasRightResponsablesLabel">
        <div class="offcanvas-header">
            <h5 class="offcanvas-title" id="offcanvasRightResponsablesLabel">Offcanvas right</h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        <div class="offcanvas-body">
            <h3>Asignar un responsable</h3>
            <p>Usuarios disponibles.</p>
            <table class="tUsuarios">
                <thead>
                    <th>#</th>
                    <th>Usuario</th>
                    <th>Estado</th>
                    <th>Rol</th>
                </thead>
                <tbody class="tbodyUsuarios">

                </tbody>
                <button id="btnConfirmarAsignacion" disabled>Confirmar</button>
            </table>
        </div>
    </div> -->

    <!-- MODAL DE MOSTRAR EVIDENCIAS -->
    <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasRightEvidencias"
        aria-labelledby="offcanvasRightEvidenciasLabel">
        <div class="offcanvas-header">
            <h5 class="offcanvas-title" id="offcanvasRightEvidenciasLabel">Offcanvas right</h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        <div class="offcanvas-body">
            <h2>Lista de todas las evidencias</h2>
            <div id="modal-evidencias-container">
                <!-- Aquí se agregarán las evidencias -->
                <p>Esto es un texto de prueba dentro de modal-content.</p> <!-- Este texto debe aparecer -->
            </div>
        </div>
    </div>

</div>

<?php require_once '../footer.php' ?>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Luego, el archivo de DataTables -->
<!-- jKanban JS -->

<script src="https://cdn.jsdelivr.net/npm/jkanban@1.2.0/dist/jkanban.min.js"></script>
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script src="http://localhost/CMMS/js/odt/registrar-odt.js"></script>

</body>

</html>