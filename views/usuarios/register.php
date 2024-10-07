<?php require_once '../header.php' ?>
<link rel="stylesheet" href="http://localhost/CMMS/css/usuario-register.css">

<div class="container">
  <h2 class="">REGISTRO DE PERSONAL</h2>
  <div class="container text-center">
    <div class="hr-text">
      PERSONA
    </div>
  </div>
  <!-- REGISTRO PERSONAS -->
  <form action="" id="form-person-user">
    <div class="row mt-5">
      <div class="w-25  input-group col-3">
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
      <div class="col-3" style="margin-right: -60px;">
        <select name="tipodoc" id="tipodoc" class="form-control w-75" required>
          <option value="">Select Tipo Doc</option>
        </select>
      </div>
      <div class="col-3" style="margin-right: -60px;">
        <input type="text" autocomplete="off" class="form-control w-75" id="apellidos" placeholder="Apellidos" minlength="3" required>
      </div>
      <div class="col-3">
        <input type="text" autocomplete="off" class="form-control w-75" id="nombres" placeholder="Nombres" required>
      </div>
    </div>
    <div class="row mt-5 justify-content-center">
      <div class="col-3" style="margin-right: -60px;">
        <input 
        type="text" 
        autocomplete="off" 
        class="form-control w-75" 
        id="telefono" 
        placeholder="Telefono" 
        pattern="[0-9]+" 
        maxlength="9" 
        minlength="9"
        required>
      </div>
      <div class="col-3" style="margin-right: -60px;">
        <select name="genero" id="genero" class="form-control w-75" required>
          <option value="">Selecciona Genero</option>
          <option value="M">Masculino</option>
          <option value="F">Femenino</option>
        </select>
      </div>
      <div class="col-3" style="margin-right: -60px;">
        <input type="text" class="form-control w-75" id="nacionalidad" placeholder="Nacionalidad" autocomplete="off" required>
      </div>
    </div>
    <!--FIN REGISTRO PERSONAS -->
    <div class="container text-center mt-5">
      <div class="hr-text">
        DATOS USUARIO
      </div>
    </div>
    <!-- REGISTRO USUARIOS -->
    <div class="row mt-5 justify-content-center">
      <div class="col-3" style="margin-right: -60px;">
        <label for="usuario">Nombre Usuario</label>
        <input type="text" id="usuario" class="form-control w-75" autocomplete="off">
      </div>
      <div class="col-3" style="margin-right: -60px;">
        <label for="password">Contraseña</label>
        <input type="password" id="password" class="form-control w-75" autocomplete="off">
      </div>
      <div class="col-3">
        <label for="rol">Rol</label>
        <select name="rol" id="rol" class="form-control w-75">
          <option value="">Select rol</option>
        </select>
      </div>
    </div> 
    <div class="row mt-4">
      <div class="col-4">
        <button type="submit" class="form-control btn btn-primary w-25" id="btnEnviar" disabled>
          Registrar
        </button>
      </div>
    </div>   
  </form>

  <!-- FIN REGISTRO USUARIOS -->
</div>
<?php require_once '../footer.php' ?>
<script src="http://localhost/CMMS/js/users/register-usuario.js"></script>
</body>
</html>