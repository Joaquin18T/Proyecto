<?php require_once '../header.php' ?>
<main class="mainPlanTareas">
    <h1>PLAN DE TAREAS</h1>
    <table  class="table table-striped" id="tb-plantareas">
        <thead>
            <tr>
                <th>ID</th>
                <th>Descripcion</th>
                <th>Tareas totales</th>
                <th>Activos vinculados</th>
                <th>Acciones</th>
            </tr>
        <tbody>
            
        </tbody>
    </table>
    <button class="btn btn-primary" id="btnInterfazNuevoPlanTarea">Nuevo</button>
</main>

<?php require_once '../footer.php' ?>


<script src="http://localhost/CMMS/js/plantareas/index.js"></script>
<script src="https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.js" type="text/javascript"></script>
</body>
</html>