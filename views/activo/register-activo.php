<?php
require_once '../header.php'

?>
<link rel="stylesheet" href="http://localhost/CMMS/css/register-activo.css">

<h2>REGISTRO DE ACTIVOS</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card h-100 mb-5">
      <div class="card-header card-header d-flex justify-content-between m-0">
        <a href="http://localhost/CMMS/views/activo/" class="btn btn-outline-success btn-sm">Volver</a>
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
                  <select name="subcategorias" id="subcategoria" class="form-control w-75" required>
                    <option value="">Selecciona</option>
                  </select>
                </div>
                <div class="col-6">
                  <label for="">Marca</label>
                  <select name="marcas" id="marca" class="form-control w-75" style="max-height: 50px; overflow-y: auto;" autofocus required>
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
                  <label for="codigo">Codigo Ident.</label>
                  <input type="text" class="form-control w-75" placeholder="Codido Ident." id="codigo" minlength="6" required maxlength="20">
                </div>
              </div>
              <div class="row mb-6 mt-4">
                <div class="col-6">
                  <label for="fecha">Fecha Adquisicion</label>
                  <input type="date" class="form-control w-75" id="fecha" required>
                </div>
                <div class="col-6">
                  <label for="descripcion">Descripcion</label>
                  <input type="text" class="form-control w-100" id="descripcion" required minlength="15">
                </div>
              </div>
              <div class="row mb-6 mt-4">
                <div class="col-6 mx-auto">
                  <button class="btn btn-sm btn-success w-75" type="submit" id="saveDatos">Save</button>
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
                      <label for="">Especificacion 1</label>
                      <input type="text" class="form-control w-75 dataEs" required>
                    </div>
                    <div class="col-6 mb-0">
                      <label for="">Valor</label>
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
<!-- <form class="form-group mt-5" autocomplete="off" id="form-activo">
    <div>
      <div class="row mb-3">
        <div class="col-4">
          <label for="subcategoria">SubCategorias</label>
          <select name="subcategorias" id="subcategoria" class="form-control w-50" required>
            <option value="">Selecciona</option>
          </select>
        </div>
        <div class="col-4">
          <label for="">Marca</label>
          <select name="marcas" id="marca" class="form-control w-50" style="max-height: 50px; overflow-y: auto;" autofocus required>
            <option value="">Selecciona</option>
          </select>
        </div>
        <div class="col-4">
          <label for="modelo">Modelo</label>
          <input type="text" class="form-control w-50" placeholder="Modelo" id="modelo" minlength="5" required>
        </div>
      </div>
      <div class="row mb-3">
        <div class="col-4">
          <label for="codigo">Codigo Ident.</label>
          <input type="text" class="form-control w-50" placeholder="Codido Ident." id="codigo" minlength="6" required maxlength="20">
        </div>
        <div class="col-4">
          <label for="fecha">Fecha Adquisicion</label>
          <input type="date" class="form-control w-50" id="fecha" required>
        </div>
        <div class="col-4">
          <label for="descripcion">Descripcion</label>
          <input type="text" class="form-control w-75" id="descripcion" required minlength="15">
        </div>
      </div>
      <div class="row mb-5">
        <div class="col-4">
          <button class="btn btn-sm btn-primary" type="submit" id="saveDatos">Save</button>
        </div>
      </div>
      <div id="list-es">
        <p>Especificaciones</p>
        <div class="row">
          <div class="col-4">
            <label for="">Especificacion 1</label>
            <input type="text" class="form-control w-50 dataEs" required>
          </div>
          <div class="col-3 mb-0">
            <label for="">Valor</label>
            <input type="text" class="form-control w-50 dataEs" required>
          </div>
          <div class="col-4">
            <label for=""></label>
            <button class="btn btn-primary btnAdd" type="button">AGREGAR</button>
          </div>
        </div>

      </div>
    </div>
  </form> -->
<?php require_once '../footer.php' ?>
<script src="../../js/activos/register-activo.js"></script>