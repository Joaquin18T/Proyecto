<?php
require_once '../header.php';
?>
<link href="https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.css" rel="stylesheet" type="text/css">

<h2>ASIGNACIONES</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">Asignaciones Registradas</div>
      <div class="card-body">
        <table class="table table-striped" id="tb-activo-resp">
          <colgroup>
            <col style="width: 2%;">
            <col style="width: 3%;">
            <col style="width: 5%;">
            <col style="width: 3%;">
            <col style="width: 3%;">
            <col style="width: 5%;">
          </colgroup>
          <thead>
            <tr class="text-center">
              <th>ID</th>
              <th>Cod. Identificación</th>
              <th>Descripción</th>
              <th>Ubicacion</th>
              <th>Responsable</th>
              <th>Ver Detalles</th>
            </tr>
          </thead>
          <tbody>

          </tbody>
        </table>

        <!-- INICIO MODAL -->
        <div class="modal fade" id="modal-activo-resp" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="modalLabel">Detalles del Activo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body" id="div-content">
                <p><strong>Modelo:</strong> <span id="det-modelo"></span></p>
                <p><strong>Fecha Adquisición:</strong> <span id="det-fecha-adquisicion"></span></p>
                <p><strong>Condición:</strong> <span id="det-condicion"></span></p>
                <p><strong>Ubicación Actual:</strong> <span id="det-ubicacion"></span></p>
                <p><strong>Estado:</strong> <span id="det-estado"></span></p>
                <p><strong>Fecha Asignacion:</strong> <span id="det-fecha-asignacion"></span></p>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- FIN MODAL -->
</div>
<!-- <button class="btn btn-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="offcanvasRight">Toggle right offcanvas</button> -->

<div class="offcanvas offcanvas-end" tabindex="-1" id="sidebar" aria-labelledby="offcanvasRightLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasRightLabel">Offcanvas right</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body" id="content-data">
    <div class="card">
      <div class="card-body">
        <div class="form-floating">
          <select name="list-sidebar-activos" id="list-sidebar-activos" class="form-control w-75">
            <option value="">Selecciona</option>
          </select>
          <label for="list-sidebar-activos" class="form-label">Activos Asg.</label>
        </div>
      </div>
    </div>
    <ul class="list-group mt-2" id="list-users">

    </ul>
  </div>
</div>
<?php require_once '../footer.php' ?>
<script src="https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.js" type="text/javascript"></script>
<script src="../../js/responsables/index.js"></script>
</body>

</html>