<?php require_once '../header.php' ?>
<link rel="stylesheet" href="http://localhost/CMMS/css/usuario-register.css">

<h2>USUARIOS</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header card-header d-flex justify-content-between m-0">
        <div class="text-start mb-0 pt-1">Crear un nuevo usuario</div>
        <a href="http://localhost/CMMS/views/usuarios/" class="btn btn-outline-success btn-sm text-end" type="button">Regresar</a>
      </div>
      <div class="card-body">
        <h5>Datos de la Persona</h5>
        <form action="" id="form-person-user">
          <div class="row g-2 mb-3">
            <div class="w-25  input-group me-0">
              <input type="text"
                autocomplete="off"
                id="numDoc"
                placeholder="Num Doc."
                pattern="[0-9]*"
                class="form-control"
                minlength="8"
                maxlength="20"
                required
                autofocus
                title="Por favor ingresa solo números.">
              <span class="input-group-text" style="cursor: pointer;" id="search">Search</span>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <select name="tipodoc" id="tipodoc" class="form-control" required>
                  <option value="">Selecciona</option>
                </select>
                <label for="tipodoc" class="form-label">Tipo Doc.</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="text" autocomplete="off" class="form-control" id="apellidos" minlength="3" required>
                <label for="apellidos" class="form-label">Apellidos</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="text" autocomplete="off" class="form-control" id="nombres" required>
                <label for="nombres" class="form-label">Nombres</label>
              </div>
            </div>
          </div>
          <div class="row g-2 mb-3 mt-2">
            <div class="col-md-3">
              <div class="form-floating">
                <input
                  type="text"
                  autocomplete="off"
                  class="form-control w-75"
                  id="telefono"
                  pattern="[0-9]+"
                  maxlength="9"
                  minlength="9"
                  >
                <label for="telefono" class="form-label">Telefono</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <select name="genero" id="genero" class="form-control" required>
                  <option value="">Selecciona Genero</option>
                  <option value="M">Masculino</option>
                  <option value="F">Femenino</option>
                </select>
                <label for="genero" class="form-label">Genero</label>
              </div>
            </div>
          </div>
          <div class="row g-2 mb-3 mt-3">
            <h5>Datos del Usuario</h5>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="text" id="usuario" class="form-control" autocomplete="off">
                <label for="usuario">Nombre Usuario</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="password" id="password" class="form-control" autocomplete="off">
                <label for="password">Contraseña</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <select name="rol" id="rol" class="form-control">
                  <option value="">Select rol</option>
                </select>
                <label for="rol">Rol</label>
              </div>
            </div>
          </div>
          <div class="row g-3 md-3">
            <div class="col-md-2 ms-auto">
              <button type="submit" class="form-control btn btn-primary w-75" id="btnEnviar" disabled>
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
<script src="http://localhost/CMMS/js/users/register-usuario.js"></script>
</body>

</html>