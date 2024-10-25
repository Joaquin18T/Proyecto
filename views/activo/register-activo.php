<?php
require_once '../header.php'

?>
<link rel="stylesheet" href="http://localhost/CMMS/css/register-activo.css">

<h2>REGISTRO DE ACTIVOS</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card h-100 mb-5">
      <div class="card-header card-header d-flex justify-content-between m-0">
        <a href="<?= $host ?>views/activo/" class="btn btn-outline-success btn-sm">Volver</a>
      </div>
      <div class="card-body">
        <form class="form-group mt-2" autocomplete="off" id="form-activo">
          <div class="row mb-1">
            <div class="col-md-5">
              <div class="row mb-3 mb-2">
                <div class="container text-center">
                  <div class="hr-text">
                    <h6>DATOS DEL ACTIVO</h6>
                  </div>
                </div>
              </div>
              <div class="row mb-3 mt-2">
                <div class="col-md-6">
                  <label for="subcategoria">SubCategorias</label>
                  <select name="subcategorias" id="subcategoria" class="form-control w-75" required autofocus>
                    <option value="">Selecciona</option>
                  </select>
                </div>
                <div class="col-6">
                  <label for="marca">Marca</label>
                  <select name="marcas" id="marca" class="form-control w-75" style="max-height: 50px; overflow-y: auto;" required>
                    <option value="">Selecciona</option>
                  </select>
                </div>
              </div>
              <div class="row mb-3 mt-4">
                <div class="col-6">
                  <label for="modelo">Modelo</label>
                  <input type="text" class="form-control w-75" placeholder="Modelo" id="modelo" minlength="3" required>
                </div>
                <div class="col-6">
                  <label for="descripcion">Descripcion</label>
                  <input type="text" class="form-control w-100" id="descripcion">
                </div>
              </div>
              <div class="row mt-4">
                <div class="col-6">
                  <label for="fecha">Fecha Adquisicion</label>
                  <input type="date" class="form-control w-75" id="fecha" required>
                </div>
                <div class="col-5">
                  <label for="cantidad">Cantidad</label>
                  <input type="number" class="form-control w-50" id="cantidad" min="0">
                </div>
              </div>
              <div class="row mb-6 mt-4">
                <div class="col-6">
                  <button class="btn btn-sm btn-success w-75" type="button" id="showSB">Agregar Cods. Identf.</button>
                </div>
                <div class="col-3">
                  <button class="btn btn-sm btn-info w-75" type="button" data-bs-toggle="offcanvas" 
                  data-bs-target="#sb-code" id="only-view" disabled>Ver lista</button>
                </div>
              </div>
            </div>
            <div class="col-md-2 h-100">
              <div class="v-line" style="border-left: 1px solid #ccc; height: 90%;"></div>
            </div>
            <div class="col-md-5">
              <div class="row mb-5">
                <div class="row mb-3 mb-2">
                  <div class="container text-center">
                    <div class="hr-text">
                      <h6>ESPECIFICACIONES</h6>
                    </div>
                  </div>
                </div>
                <div id="list-es">
                  <div class="row">
                    <div class="col-6">
                      <label>Especificacion 1</label>
                      <input type="text" class="form-control w-75 dataEs" required>
                    </div>
                    <div class="col-6 mb-0">
                      <label>Valor</label>
                      <input type="text" class="form-control w-75 dataEs" required>
                    </div>
                    <div class="col-4 mt-2">
                      <button class="btn btn-sm btn-primary btnAdd" type="button">AGREGAR</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
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