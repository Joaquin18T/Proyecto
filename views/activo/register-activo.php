<?php
require_once '../header.php'

?>
<link rel="stylesheet" href="http://localhost/CMMS/css/register-activo.css">

<h2>REGISTRO DE ACTIVOS</h2>
<div class="row">
  <div class="card p-0">
    <div class="card-header d-flex justify-content-between m-0">
      <div class="mb-0 pt-1">Registrar Activos</div>
      <button class="btn btn-sm btn-success" type="button" id="showSB">Agregar Cods. Identf.</button>
    </div>
    <div class="card-body" id="list-register-activos">

    </div>
  </div>
</div>
<!-- SIDEBAR PARA EL REGISTRO MULTIPLE (cod_identificacion) -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="sb-code" aria-labelledby="offcanvasRightLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasRightLabel">Offcanvas right</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body">
    <div class="list-code" id="container-code">

    </div>
    <button class="btn btn-sm btn-success w-50 mt-2" type="button" id="save">Guardar</button>
  </div>
</div>
<!-- ./SIDEBAR PARA EL REGISTRO MULTIPLE (cod_identificacion) -->
<?php require_once '../footer.php' ?>
<script src="../../js/activos/register-activo.js"></script>