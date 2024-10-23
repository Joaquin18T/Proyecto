<?php require_once '../header.php' ?>
<main >
    <h1>PLAN DE TAREAS</h1>
    <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" type="button" role="tab" aria-controls="pills-home" aria-selected="true">Vigentes</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" type="button" role="tab" aria-controls="pills-profile" aria-selected="false">Eliminados</button>
        </li>
    </ul>
    <div class="tab-content" id="pills-tabContent">
        <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab">
            <table class="table table-striped table-hover" id="tb-plantareas">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Descripcion</th>
                        <th>Tareas totales</th>
                        <th>Activos vinculados</th>
                        <th>Acciones</th>
                        <th>Estado</th>
                    </tr>
                <tbody>

                </tbody>
            </table>
            <button class="btn btn-primary" id="btnInterfazNuevoPlanTarea">Nuevo</button>
        </div>
        <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">
            <table class="table table-striped table-hover" id="tb-plantareas-eliminadas">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Descripcion</th>
                        <th>Tareas totales</th>
                        <th>Activos vinculados</th>
                        <th>Acciones</th>
                        <th>Estado</th>
                    </tr>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>

</main>

<?php require_once '../footer.php' ?>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Luego, el archivo de DataTables -->

<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script src="http://localhost/CMMS/js/plantareas/index.js"></script>

</body>

</html>