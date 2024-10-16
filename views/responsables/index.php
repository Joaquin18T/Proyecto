<?php
require_once '../header.php';
?>
<link href="https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.css" rel="stylesheet" type="text/css">

<h2>ASIGNACIONES</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header d-flex justify-content-between m-0">
        <p class="text-start m-0 mt-0 pt-1">Asignaciones Registradas</p>
        <a href="http://localhost/CMMS/views/responsables/resp-activo" class="btn btn-outline-success btn-sm text-end">Asignar</a>
      </div>
      <div class="card-body">
        <div class="card">
          <div class="card-header">Filtros</div>
          <div class="card-body mb-2">
            <div class="row g-3">
              <div class="col-md-3">
                <div class="form-floating">
                  <input type="text" class="form-control filter" id="cod_identificacion" autocomplete="off">
                  <label for="cod_identificacion">Cod. Identificacion</label>
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-floating">
                  <select name="subcategoria" id="subcategoria" class="form-control filter">
                    <option value="">Selecciona</option>
                  </select>
                  <label for="subcategoria" class="form-label">Subcategorias</label>
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-floating">
                  <select name="ubicacion" id="ubicacion" class="form-control filter">
                    <option value="">Selecciona</option>
                  </select>
                  <label for="ubicacion" class="form-label">Ubicacion</label>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="card mt-2">
          <div class="card-body">
            <div class="row g-3">
              <div class="table-responsive">
                <table class="table" id="tb-activo-resp">
                  <colgroup>
                    <col style="width: 0.5%;">
                    <col style="width: 2%;">
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
                      <th>Acciones</th>
                    </tr>
                  </thead>
                  <tbody>
        
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

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
        <!-- FIN MODAL -->
      </div>
    </div>
  </div>

</div>
<!-- <button class="btn btn-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="offcanvasRight">Toggle right offcanvas</button> -->

<!-- SIDEBAR DE USUARIOS ASIGNADOS A UN ACTIVO -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="sidebar" aria-labelledby="offcanvasRightLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasRightLabel">Usuarios asignados a un activo</h5>
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
<!-- ./SIDEBAR DE USUARIOS ASIGNADOS A UN ACTIVO -->

<!-- SIDEBAR DE ACTUALIZAR LA UBICACION -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="sb-ubicacion-update" aria-labelledby="offcanvasRightLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasRightLabel">Offcanvas right</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body">
    <div class="form-floating">
      <select name="sb-ubicacion" id="sb-ubicacion" class="form-control w-75">
        <option value="">Selecciona</option>
      </select>
      <label for="sb-ubicacion" class="form-label">Ubicacion</label>
    </div>
    <div class="form-floating mt-2">
      <select name="sb-responsable" id="sb-responsable" class="form-control w-75">
        <option value="">Selecciona</option>
      </select>
      <label for="sb-responsable" class="form-label">Activo y responsable</label>
    </div>

  </div>
</div>
<!-- ./SIDEBAR DE ACTUALIZAR LA UBICACION -->

<?php require_once '../footer.php' ?>
<script src="https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.js" type="text/javascript"></script>
<script src="../../js/responsables/index.js"></script>
</body>

</html>