<?php require_once '../header.php' ?>

<main class="container-fluid">
    <div class="row">
        <div class="col-md-6">
            <h1>registrar plan</h1>
        </div>
        <div class="col-md-6 text-end">
            <a href="http://localhost/CMMS/views/plantareas/" class="btn btn-primary">Volver</a>
        </div>
    </div>
    <div class="contenedor-info-plan">
        <div class="row text-end">
            <div class="input-group mb-3 ">
                <input type="text" class="form-control" id="txtDescripcionPlanTarea" pattern="[a-zA-Z\s]+" title="Solo se permiten letras y espacios" placeholder="Descripcion" aria-label="Descripcion" required autocomplete="off">
                <div class="form-floating w-25">
                    <select class="form-select rounded-0" id="elegirCategoria">
                    </select>
                    <label for="elegirCategoria" class="form-label">Categoria</label>
                </div>
                <button class="btn btn-primary" type="button" id="btnGuardarPlanTarea">Guardar Plan</button>
            </div>
        </div>
    </div>

    <hr />

    <div class="row">
        <div class="col-md-6 mb-3">
            <form id="form-tarea" autocomplete="off">
                <div class="card">
                    <div class="card-header">
                        <h3>Registrar Tarea</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="txtDescripcionTarea" placeholder="Descripcion" disabled required autocomplete="off">
                                    <label for="txtDescripcionTarea" class="form-label">Descripcion</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <select class="form-select" id="tipoPrioridadTarea" disabled required>
                                    </select>
                                    <label for="tipoPrioridadTarea" class="form-label">Prioridad</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <select class="form-select" id="elegirSubCategoriaTarea" disabled required>
                                    </select>
                                    <label for="elegirSubCategoriaTarea" class="form-label">Sub Categoria</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="txtIntervaloTarea" placeholder="Intervalo" disabled required autocomplete="off">
                                    <label for="txtIntervaloTarea" class="form-label">Intervalo</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <select class="form-select" id="selectFrecuenciaTarea" disabled required>
                                    </select>
                                    <label for="selectFrecuenciaTarea" class="form-label">Frecuencia</label>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="card-footer">
                        <div class="row">
                            <div class="col-md-4">
                                <button type="submit" id="btnGuardarTarea" class="btn btn-primary" disabled>Guardar</button>
                            </div>
                            <div id="btnsTareaAcciones">

                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <div class="col-md-6 mb-3">
            <div class="card">
                <div class="card-header">
                    <h4 class="text-center">Tareas agregadas</h4>
                </div>
                <div class="card-body">
                    <ul class="listaTareasAgregadas list-group"></ul>
                </div>
            </div>
        </div>
    </div>

    <hr />
    <div class="row">
        <div class="col-md-6">

            <div class="card mb-4">
                <div class="card-header">
                    <h3>Asignar activos</h3>
                </div>
                <div class="card-header">
                    <div class="row">
                        <!--  filtros -->

                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <select class="form-select filter" name="" id="elegirTareaParaActivo" disabled></select>
                                <label for="elegirTareaParaActivo" class="form-label">Tarea</label>
                            </div>
                        </div>
                        <!-- <div class="col-md-4 mb-3">
                            <select class="form-select filter" name="" id="elegirSubCategoria" disabled></select>
                        </div> -->
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <select class="form-select filter" name="" id="elegirUbicacion" disabled></select>
                                <label for="elegirUbicacion" class="form-label">Ubicacion</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="tablaActivos" class="stripe row-border order-column nowrap table-hover" style="width:100%">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Activo</th>
                                    <th>Modelo</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody id="activosBodyTable"></tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer">
                    <button type="button" class="btn btn-primary" id="btnAgregarActivos" disabled>Agregar</button>
                </div>
            </div>

        </div>
        <div class="col-md-6 mb-3">
            <div class="card">
                <div class="card-header">
                    <h4 class="text-center">Activos agregadas</h4>
                </div>
                <div class="card-footer">
                    <ul class="listaActivosAsignados list-group"></ul>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col text-end mb-3">
                <button class="btn btn-primary" id="btnTerminarPlan" disabled>
                    Terminar
                </button>
            </div>
        </div>
    </div>
</main>

<?php require_once '../footer.php' ?>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Luego, el archivo de DataTables -->
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script src="http://localhost/CMMS/js/plantareas/registrar-plan.js"></script>
</body>

</html>