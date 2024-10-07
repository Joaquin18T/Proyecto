<?php require_once '../header.php' ?>
<link rel="stylesheet" type="text/css" href="http://localhost/CMMS/JSTable-master/dist/jstable.css">
<h2>USUARIOS</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">Lista de usuarios</div>
      <div class="card-body">
        <div class="row g-0 md-3">
          <div class="card">
            <div class="card-header">Filtros</div>
            <div class="card-body">
              <div class="row g-3 md-3">
                <div class="col-md-3">
                  <div class="form-floating">
                    <input type="text" class="form-control filters" id="dato" placeholder="Apellidos y Nombres" name="dato">
                    <label for="dato" class="form-label">Apellidos y Nombres</label>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="form-floating">
                    <select name="rol" id="rol" class="form-control filters">
                      <option value="">Selecciona</option>
                    </select>
                    <label for="rol" class="form-label">Roles</label>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="form-floating">
                    <select name="estado" id="estado" class="form-control filters">
                      <option value="">Selecciona</option>
                      <option value="1">Activo</option>
                      <option value="0">De baja</option>
                    </select>
                    <label for="estado" class="form-label">Estados</label>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="form-floating">
                    <select name="tipodoc" id="tipodoc" class="form-control filters">
                      <option value="">Selecciona</option>
                    </select>
                    <label for="tipodoc" class="form-label">Tipo Doc</label>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="card mt-3">
          <div class="card-body">
            <div class="row g-3">
              <div class="table-responsive">
                <table class="table table-striped" id="tb-usuarios">
                  <colgroup>
                    <col style="width: 0.5%;">
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                    <col style="width: 2%;">
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                    <col style="width: 0.5%;">
                  </colgroup>
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Nom. Usuario</th>
                      <th>Rol</th>
                      <th>Nombres y Ap.</th>
                      <th>Telefono</th>
                      <th>Genero</th>
                      <th>Nacionalidad</th>
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
  <div class="modal fade" id="modal-update-user" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="exampleModalLabel">Actualizar datos del usuario</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <h4>¿Estas seguro de actulizar?</h4>
        </div>
        <div class="modal-footer">
          <a class="btn btn-success aceppt-update">Save changes</a>
        </div>
      </div>
    </div>
  </div>
</div>

<?php require_once '../footer.php' ?>
<script type="text/javascript" src="http://localhost/CMMS/JSTable-master/dist/jstable.min.js"></script>
<script src="http://localhost/CMMS/js/users/index.js"></script>