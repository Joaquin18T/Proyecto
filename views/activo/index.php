<?php require_once '../header.php' ?>
<h2>ACTIVOS</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">Activos Registrados
      </div>
      <div class="card-body">
        <div class="row g-0 mb-3">
          <div class="card">
            <div class="card-header">Filtros</div>
            <div class="card-body">
              <div class="row g-3 mb-3">
                <div class="col-md-2">
                  <div class="form-floating">
                    <select name="subcategoria" id="subcategoria" class="form-control filter">
                      <option value="">Selecciona</option>
                    </select>
                    <label for="subcategoria" class="form-label">Subcategorias</label>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="form-floating">
                    <input type="text" class="form-control filter" id="cod_identificacion" placeholder="cod. identificacion" autocomplete="off">
                    <label for="cod_identificacion">Cod. Identificacion</label>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="form-floating">
                    <input type="date" class="form-control filter" id="fecha_adquisicion" placeholder="Fecha adquisicion">
                    <label for="fecha_adquisicion">Fecha adquisicion</label>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="form-floating">
                    <select name="estado" id="estado" class="form-control filter">
                      <option value="">Selecciona</option>
                    </select>
                    <label for="estado">Estado</label>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="form-floating">
                    <select name="marca" id="marca" class="form-control filter">
                      <option value="">Selecciona</option>
                    </select>
                    <label for="marca">Marca</label>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="card">
          <div class="card-body">
            <div class="row g-5">
              <div class="table-responsive">
                <table class="table" id="table-activos">
                  <colgroup>
                    <col style="width:0.2%">
                    <col style="width:1%">
                    <col style="width:1%">
                    <col style="width:1%">
                    <col style="width:1%">
                    <col style="width:2%">
                  </colgroup>
                  <thead class="text-center">
                    <tr>
                      <th>#</th>
                      <th>Categoria</th>
                      <th>Modelo</th>
                      <th>Descripcion</th>
                      <th>Especificaciones</th>
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

      </div>
    </div>
  </div>
  <div class="modal fade" tabindex="-1" id="modal-update">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">¿Deseas actualizar el activo?</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <a class="btn btn-sm btn-success" href="http://localhost/CMMS/views/activo/update-activo.php">Actualizar</a>
        </div>
      </div>
    </div>
  </div>
</div>
<?php require_once '../footer.php' ?>
<script src="../../js/activos/index.js"></script>
<script src="https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.js" type="text/javascript"></script>
</body>
</html>