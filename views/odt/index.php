<?php require_once '../header.php' ?>
<style>
    /* Estilo para el contenedor general */
    .contenedor-general {
        width: 100%;
        /* El contenedor ocupa el 100% del ancho */
        padding: 0 15px;
        /* Espaciado lateral */
        box-sizing: border-box;
        /* Incluye padding en el cálculo del ancho total */
    }

    /* Estilo para el subcontenedor */
    .subcontenedor {
        width: 100%;
        /* El subcontenedor también ocupa todo el ancho */
        display: flex;
        /* Usamos flexbox para la distribución */
        justify-content: center;
        /* Centrar el contenido */
    }

    /* Estilo para el contenedor de los kanban */
    #kanban-container {
        display: flex;
        /* Hacemos que el contenedor sea flex */
        justify-content: flex-start;
        align-items: flex-start;
        /* Aseguramos que los tableros no se estiren verticalmente */
        width: 100%;
        /* El contenedor ocupa todo el ancho disponible */
    }

    /* Contenedor de los tableros (kanban) */
    .kanban-container {
        display: flex;
        /* Usamos flex en el contenedor de los tableros */
        flex: 1;
        /* El contenedor ocupará todo el ancho disponible */
        flex-wrap: nowrap;
        /* Evitamos que los elementos se envuelvan en múltiples filas */
        justify-content: flex-start;
        /* Alineamos los elementos al inicio */
        overflow-x: hidden;
    }

    /* Estilo para cada kanban-board */
    .kanban-board {
        margin-bottom: 15px;
        /* Margin para separar cada tablero */
        flex: 1;
        /* Cada kanban-board ocupará espacio proporcional */
        min-width: 0;
        /* Evitar el desbordamiento */
        flex-shrink: 0;
        /* Evita que los tableros se reduzcan si hay contenido adicional */
        background-color: transparent;
        /* Fondo transparente */
    }

    /* Estilo para la cabecera de cada kanban-board */
    .kanban-board-header {
        border-radius: 8px;
        background-color: #1F2937;
        color: white;
        /* Color de fondo solo para la cabecera */
    }

    /* Estilo para el área donde se puede hacer drag (opcional) */
    .kanban-drag {
        opacity: 1;
        max-height: 700px;
        /* Ajusta esta altura según necesites */
        overflow-y: auto;
        /* Agrega el scroll vertical */
    }

    /* Media Query para pantallas pequeñas */
    @media (max-width: 768px) {
        .kanban-container {
            flex-direction: column;
            /* En pantallas pequeñas, las columnas se apilan */
        }

        .kanban-board {
            min-width: 90%;
            /* Cada columna ocupa el 100% en pantallas pequeñas */
            margin-bottom: 15px;
            /* Espacio entre columnas */
        }
    }
</style>

<div class=" contenedor-general">
    <div id="kanban-container"></div>

</div>
<br>
<br>

<div class="row px-2 contenedor-tabla-creacion-odt">
    <div class="card mb-4 ">
        <div class="card-header">
            <h3>Detalles de Tarea</h3>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover" id="tb-tarpendientes" style="overflow-x: auto;">
                    <thead>
                        <tr>
                            <th>Descripcion</th>
                            <th>Prioridad</th>
                            <th>Frecuencia</th>
                            <th>Responsable</th>
                            <th>Activo</th>
                            <th>Estado</th>
                        </tr>
                    <tbody>

                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer text-end">
            <button class="btn btn-primary btnCancelarCreacionOdt">Cancelar</button>
            <button class="btn btn-primary btnCrearOdt">Crear Orden de trabajo</button>
        </div>
    </div>
</div>
<!--     <div class="tablero">
        <div class="col-tablero" data-idcolumna="pendientes">
            <div class="nom-col">
                <h3>Pendientes</h3>
            </div>
            <div class="contenido-col-pendientes">

            </div>
        </div>
        <div class="col-tablero" data-idcolumna="proceso">
            <div class="nom-col">
                <h3>Proceso</h3>
            </div>
            <div class="contenido-col-proceso">

            </div>
        </div>
        <div class="col-tablero" data-idcolumna="revision">
            <div class="nom-col">
                <h3>Revision</h3>
            </div>
            <div class="contenido-col-revision">

            </div>
        </div>
        <div class="col-tablero" data-idcolumna="finalizado">
            <div class="nom-col">
                <h3>Finalizadas</h3>
            </div>
            <div class="contenido-col-finalizado">

            </div>
        </div>
    </div> -->



<!-- ************************************* INICIO MODAL DE REVISION  ***************************************************** -->
<!-- <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasRightRevision"
        aria-labelledby="offcanvasRightRevisionLabel">
        <div class="offcanvas-header">
            <h5 class="offcanvas-title" id="offcanvasRightRevisionLabel">Revisar Orden</h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        <div class="offcanvas-body" id="bodyRevision">

        </div>
    </div> -->
<!-- *************************************** FIN MODAL DE REVISION ******************************************************* -->
<!-- ************************************* INICIO MODAL DE FINALIZACION ************************************************** -->

</div>



<?php require_once '../footer.php' ?>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>

<!-- Luego, el archivo de DataTables -->
<!-- jKanban JS -->
<script src="https://cdn.jsdelivr.net/npm/jkanban@1.2.0/dist/jkanban.min.js"></script>
<script>
    const idusuario = "<?php echo $_SESSION['login']['idusuario']; ?>"
</script>
<script src="http://localhost/CMMS/js/odt/index.js"></script>

</body>

</html>