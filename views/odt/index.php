<?php require_once '../header.php' ?>
<div class="">
    <h1>Orden de trabajo</h1>
    <div class="row">
        <div class="col">
            <div id="kanban-container"></div>
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
<!-- Luego, el archivo de DataTables -->
<!-- jKanban JS -->
<script src="https://cdn.jsdelivr.net/npm/jkanban@1.2.0/dist/jkanban.min.js"></script>
<script>
    const idusuario = "<?php echo $_SESSION['login']['idusuario']; ?>"
</script>
<script src="http://localhost/CMMS/js/odt/index.js"></script>

</body>

</html>