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
                    <input type="text" id="cod_identificacion" class="form-control filter">
                    <label for="cod_identificacion">Cod. Identif.</label>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="form-floating">
                    <input type="date" id="fecha_adquisicion" class="form-control filter">
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
            <div class="row g-5 pe-2">
              <div class="table-responsive">
                <table class="table" id="table-activos">
                  <colgroup>
                    <col style="width:0.2%">
                    <col style="width:1%">
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
                      <th>Estado</th>
                      <th>Acciones</th>
                    </tr>
                  </thead>
                  <tbody id="table-activos-tbody">
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
    <h5 class="offcanvas-title" id="offcanvasRightLabel">REGISTRAR BAJA DEL ACTIVO</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body">
    <form action="" id="register-baja">
      <div class="form-floating">
        <input type="text" class="form-control" id="activo" disabled>
        <label for="activo" class="form-label">Activo Seleccionado</label>
      </div>

      <div class="form-floating mt-2 h-25">
        <textarea name="motivo" id="motivo" class="form-control h-100" style="text-decoration: none; resize:none" required></textarea>
        <label for="motivo" class="form-label">Motivo</label>
      </div>
      <div class="form-floating mt-2 h-25">
        <textarea name="comentario" id="comentario" class="form-control h-100" style="text-decoration: none; resize:none"></textarea>
        <label for="comentario" class="form-label">Comentarios adicionales</label>
      </div>
      <div class="form-floating mt-2">
        <input type="file" class="form-control h-75" id="documentacion" accept=".pdf" required>
        <label for="documentacion" class="form-label">Documentacion </label>
        <p class="text-end"><strong style="font-size: small;">(Max. 6 MB)</strong></p>
      </div>
      <div class="mt-2">
        <button type="submit" class="btn btn-sm btn-outline-success" id="dar-baja">Dar de baja</button>
      </div>
    </form>
  </div>
</div>
<?php require_once '../footer.php' ?>
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script src="<?= $host ?>js/bajas/list-activos.js"></script>
</body>

</html>