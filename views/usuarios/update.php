<?php require_once '../header.php' ?>

<h2>USUARIOS</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">Actualizar datos del usuario</div>
      <div class="card-body">
        <h5>Datos de la Persona</h5>
        <form action="" autocomplete="off" class="mt-3" id="form-update-user">
          <div class="row g-2 mb-3">
            <div class="col-md-3 me-4">
              <div class="input-group h-100">
                <input type="text"
                  id="numDoc"
                  placeholder="Num Doc."
                  pattern="[0-9]*"
                  class="form-control"
                  minlength="8"
                  maxlength="20"
                  required
                  autofocus
                  title="Por favor ingresa solo números.">
                <span class="input-group-text bg-success" style="cursor: pointer; color:#fff" id="search">Search</span>
              </div>
            </div>
            <div class="col-md-2 me-4">
              <div class="form-floating">
                <select name="tipodoc" id="tipodoc" class="form-control" required>
                  <option value="">Selecciona</option>
                </select>
                <label for="tipodoc" class="form-label">Tipo Doc.</label>
              </div>
            </div>
            <div class="col-md-3 me-4">
              <div class="form-floating">
                <input type="text" class="form-control w-100" id="apellidos" placeholder="Apellidos" minlength="3" required>
                <label for="apellidos" class="form-label">Apellidos</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="text" class="form-control w-100" id="nombres" placeholder="Nombres" required>
                <label for="nombres" class="form-label">Nombres</label>
              </div>
            </div>
          </div>
          <div class="row g-2 mb-3 mt-4">
            <div class="col-md-3 me-3">
              <div class="form-floating">
                <input
                  type="text"
                  class="form-control"
                  id="telefono"
                  placeholder="Telefono"
                  pattern="[0-9]+"
                  maxlength="9"
                  minlength="9"
                  required>
                <label for="telefono" class="form-label">Telefono</label>
              </div>
            </div>
            <div class="col-md-2 ms-2 me-3">
              <div class="form-floating">
                <select name="genero" id="genero" class="form-control w-100" required>
                  <option value="">Selecciona Genero</option>
                  <option value="M">Masculino</option>
                  <option value="F">Femenino</option>
                </select>
                <label for="genero" class="form-label">Genero</label>
              </div>
            </div>
            <div class="col-md-3 ms-2">
              <div class="form-floating">
                <input type="text" class="form-control" id="nacionalidad" placeholder="Nacionalidad" autocomplete="off" required>
                <label for="nacionalidad" class="form-label">Nacionalidad</label>
              </div>
            </div>
          </div>
          <div class="row g-2 mb-3 mt-4">
            <h5>Datos del Usuario</h5>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="text" id="usuario" class="form-control w-75" placeholder="Nom. Usuario">
                <label for="usuario">Nombre Usuario</label>
              </div>
            </div>
            <div class="col-md-2 ms-4">
              <div class="form-floating">
                <select name="rol" id="rol" class="form-control">
                  <option value="">Select rol</option>
                </select>
                <label for="rol">Rol</label>
              </div>
            </div>
          </div>
          <div class="row g-2 mb-2 mt-2">
            <div class="col-md-3">
              <button type="submit" class="form-control btn btn-primary w-50" id="btnEnviar" disabled>
                Registrar
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<?php require_once '../footer.php' ?>
<script src="http://localhost/CMMS/js/users/update-usuario.js"></script>