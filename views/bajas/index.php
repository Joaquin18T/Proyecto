<?php require_once '../header.php' ?>
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">
        Lista de Activos
      </div>
      <div class="card-body">
        <div class="row g-0 mb-3">
          <div class="card">
            <div class="card-header">
              Filtros
            </div>
            <div class="card-body">
              <div class="row g-3 mb-3">
                <div class="col-md-2">
                  <div class="form-floating">
                    <input type="date" class="form-control filter" id="fecha_adquisicion">
                    <label for="fecha_adquisicion">Fecha</label>
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
                    <col style="width:1%">
                    <col style="width:2%">
                  </colgroup>
                  <thead class="text-center">
                    <tr>
                      <th>#</th>
                      <th>Cod. Identf.</th>
                      <th>Descripcion</th>
                      <th>Fecha Adqui.</th>
                      <th>Resp. Princ.</th>
                      <th>Ult. Ubicacion</th>
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
</div>
<div class="offcanvas offcanvas-end" tabindex="-1" id="sidebar-baja" aria-labelledby="offcanvasRightLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasRightLabel">Offcanvas right</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body">
    <div class="form-floating">
      <input type="text" class="form-control" id="activo" disabled>
      <label for="activo" class="form-label">Activo Seleccionado</label>
    </div>

    <div class="form-floating mt-2 h-25">
      <textarea name="motivo" id="motivo" class="form-control h-100" style="text-decoration: none; resize:none"></textarea>
      <label for="motivo" class="form-label">Motivo</label>
    </div>
    <div class="form-floating mt-2 h-25">
      <textarea name="comentario" id="comentario" class="form-control h-100" style="text-decoration: none; resize:none"></textarea>
      <label for="comentario" class="form-label">Comentarios adicionales</label>
    </div>
    <div class="form-floating mt-2">
      <input type="file" class="form-control" id="documentacion" accept=".pdf">
      <label for="documentacion" class="form-label">Documentacion </label>
    </div>
    <div class="mt-2">
      <button type="button" class="btn btn-sm btn-outline-success">Dar de baja</button>
    </div>
  </div>
</div>
<?php require_once '../footer.php' ?>
<script src="http://localhost/CMMS/js/bajas/list-activos.js"></script>
<script src="https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.js" type="text/javascript"></script>
