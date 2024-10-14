<?php require_once '../header.php' ?>

<main class="container-fluid">
    <h1>registrar plan</h1>
    <div class="contenedor-info-plan">
        <div class="row text-end">
            <div class="input-group mb-3 ">
                <input type="text" class="form-control" id="txtDescripcionPlanTarea" pattern="[a-zA-Z\s]+" title="Solo se permiten letras y espacios" placeholder="Descripcion" aria-label="Descripcion" required>
                <button class="btn btn-primary" type="button" id="btnGuardarPlanTarea">Guardar Plan</button>
            </div>
        </div>
    </div>

    <hr />

    <div class="row">
        <div class="col-md-6">
            <h3>Registrar Tarea</h3>
            <form id="form-tarea" autocomplete="off">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control filters" id="txtDescripcionTarea" placeholder="Descripcion" disabled required>
                            <label for="txtDescripcionTarea" class="form-label">Descripcion</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="date" class="form-control filters" id="fecha-inicio" placeholder="Fecha de inicio" disabled required>
                            <label for="fecha-inicio" class="form-label">Fecha de inicio</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="date" class="form-control filters" id="fecha-vencimiento" placeholder="Fecha de vencimiento" disabled required>
                            <label for="fecha-vencimiento" class="form-label">Fecha de vencimiento</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control filters" id="txtIntervaloTarea" placeholder="Intervalo" disabled required>
                            <label for="txtIntervaloTarea" class="form-label">Intervalo</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control filters" id="txtFrecuenciaTarea" placeholder="Frecuencia" disabled required>
                            <label for="txtFrecuenciaTarea" class="form-label">Frecuencia</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <select class="form-select" id="tipoPrioridadTarea" disabled required>
                            
                        </select>
                    </div>
                </div>

                <button type="submit" id="btnGuardarTarea" class="btn btn-primary" disabled>Guardar</button>
            </form>
        </div>
        <div class="col-md-6 bg-success">
            <h4 class="text-center">Tareas agregadas</h4>
            <ul class="listaTareasAgregadas"></ul>
        </div>
    </div>

    <hr />
    <div class="row">
        <div class="col-md-6">
            <h3>Asignar activos</h3>
            <table id="tablaActivos" class="stripe row-border order-column nowrap" style="width:100%">
                <thead>
                    <tr>
                        <th></th>
                        <th>Activo</th>
                        <th>Código</th>
                        <th>Categoria</th>
                        <th>Subcategoria</th>
                        <th>Marca</th>
                        <th>Modelo</th>
                    </tr>
                </thead>
                <tbody id="activosBodyTable"></tbody>
                <tfoot>
                    <div class="row">
                        <div class="col-md-6 d-flex justify-content-center">
                            <select name="" id="elegirTareaParaActivo" disabled></select>
                        </div>
                        <div class="col-md-6 d-flex justify-content-center">
                            <button type="button" class="btn btn-primary btn-agregar-activos" disabled>Agregar</button>
                        </div>
                    </div>
                </tfoot>
            </table>
        </div>
        <div class="col-md-6">
            <div class="row">
                <div class="col-md-6 d-flex justify-content-center">
                    <h4>Activos agregadas</h4>
                    <ul class="listaActivosAsignados"></ul>
                </div>
                <div class="col-md-6 d-flex justify-content-center">
                    <h4>Activos para agregar (VISTA PREVIA)</h4>
                    <ul class="listaActivosAsignadosPrevia"></ul>
                </div>
            </div>
        </div>
    </div>
    <button type="button" class="btn btn-primary" id="btnConfirmarCambios">Confirmar cambios</button>

</main>

<?php require_once '../footer.php' ?>

<script src="http://localhost/CMMS/js/plantareas/registrar-plan.js"></script>
<script src="https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.js" type="text/javascript"></script>
</body>

</html>