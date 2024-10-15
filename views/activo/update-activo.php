<?php require_once '../header.php' ?>


<h2>ACTIVOS</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card mb-5">
      <form action="" class="form-group mt-2" id="form-update">
        <div class="card-header d-flex justify-content-flex-end  align-items-center">
          <h6>Actulizacion de datos del activo</h6>
          <div class="ms-auto">
            <a href="<?= $host ?>views/activo/" class="btn btn-sm btn-outline-warning ms-auto me-1">Volver</a>
            <button type="submit" class="btn btn-sm btn-primary ms-auto" id="update-activo">Actualizar</button>
          </div>
        </div>
        <div class="card-body">
          <div class="row g-4 mb-3">
            <div class="col-md-3">
              <div class="form-floating">
                <select name="subcategoria" id="subcategoria" class="form-control filter">
                  <option value="">Selecciona</option>
                </select>
                <label for="subcategoria" class="form-label">Subcategorias</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <select name="marca" id="marca" class="form-control filter">
                  <option value="">Selecciona</option>
                </select>
                <label for="marca">Marca</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="modelo" required>
                <label for="modelo" class="form-label">Modelo</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="cod_identificacion" required>
                <label for="cod_identificacion" class="form-label">Cod. Identificacion</label>
              </div>
            </div>
          </div>
          <div class="row g-4 mb-3">
            <div class="col-md-3">
              <div class="form-floating">
                <input type="date" class="form-control" id="fecha_adquisicion" required>
                <label for="fecha_adquisicion" class="form-label">Fecha Adquisicion</label>
              </div>
            </div>
            <div class="col-md-9">
              <div class="form-floating">
                <input type="text" class="form-control" id="descripcion" required>
                <label for="descripcion" class="form-label">Descripcion</label>
              </div>
            </div>
          </div>
          <div class="row">
            <h6 class="mt-2">ESPECIFICACIONES DEL ACTIVO</h6>
          </div>
          <div class="row g-3 mb-3">
            <div class="col-md-6">
              <div id="list-es">
                <div class="row">
                  <div class="col-md-6">
                    <div class="form-floating">
                      <input type="text" class="form-control w-75 dataEs" disabled required>
                      <label for="">Especificacion 1</label>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-floating h-75">
                      <input type="text" class="form-control w-75 dataEs" disabled required>
                      <label for="">Valor</label>
                    </div>
                  </div>
                  <div class="col-md-2 mt-2">
                    <button class="btn btn-sm btn-primary btnAdd" type="button">AGREGAR</button>
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


<?php require_once '../footer.php' ?>
<script src="<?= $host ?>js/activos/update-activo.js"></script>
</body>

</html>