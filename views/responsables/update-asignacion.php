<?php
require_once '../header.php';
?>
<style>
  .input-rdo {
    background-color: white;
    /* Fondo claro */
    color: black;
    /* Texto oscuro */
    cursor: default;
    /* Indicador de solo lectura */
  }
</style>
<h2>Asignaciones</h2>
<div class="row">
  <div class="col-md-12">
    <form action="" id="update-asignacion">
      <div class="card">
        <div class="card-header d-flex justify-content-between m-0">
          <div class="mb-0 pt-1">Designaciones para el activo</div>
          <button class="btn btn-sm btn-success m-0" type="submit" id="update-test">Actualizar</button>
        </div>
        <div class="card-body">
          <div class="col-md-12">
            <div class="card">
              <div class="card-header">Datos del Activo</div>
              <div class="card-body">
                <div class="row">
                  <div class="col-md-2">
                    <div class="form-floating">
                      <input type="text" class="input-rdo form-control" id="cod_identificacion" readonly>
                      <label for="cod_identificacion" class="form-label">C. Identificacion</label>
                    </div>
                  </div>
                  <div class="col-md-2">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="marca" readonly>
                      <label for="marca" class="form-label">Marca</label>
                    </div>
                  </div>
                  <div class="col-md-2">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="modelo" readonly>
                      <label for="modelo" class="form-label">Modelo</label>
                    </div>
                  </div>
                  <div class="col-md-2">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="descripcion" readonly>
                      <label for="descripcion" class="form-label">Descripcion</label>
                    </div>
                  </div>
                  <div class="col-md-2">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="estado" readonly>
                      <label for="estado" class="form-label">Estado</label>
                    </div>
                  </div>
                  <div class="col-md-2">
                    <div class="form-floating">
                      <select name="ubicacion" id="ubicacion" class="form-control">
                        <option value="">Selecciona</option>
                      </select>
                      <label for="ubicacion" class="form-label">Ubicacion</label>
                    </div>
                  </div>
                </div>
                <div class="row mt-3 me-0 ms-0">
                  <div class="card">
                    <div class="card-body">
                      <div class="table-responsive">
                        <table id="tb-asignacion" class="table-striped">
                          <colgroup>
                            <col style="width:0.5%">
                            <col style="width:1%">
                            <col style="width:1%">
                            <col style="width:1%">
                            <col style="width:1%">
                            <col style="width:1%">
                          </colgroup>
                          <tr>
                            <th>ID</th>
                            <th>Apellidos</th>
                            <th>Nombres</th>
                            <th>Usuario</th>
                            <th>R. Princ.</th>
                            <th>Designar</th>
                          </tr>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
</div>
<?php require_once '../footer.php' ?>
<!-- JQUERY -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- LIBRERIA -->
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script src="http://localhost/CMMS/js/responsables/update-asignacion.js"></script>
</body>

</html>