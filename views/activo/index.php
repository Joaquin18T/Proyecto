<?php require_once '../header.php' ?>
<h2>ACTIVOS</h2>
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header card-header d-flex justify-content-between m-0">
        <div class="mb-0 pt-1">Lista de Activos</div>
        <a href="<?= $host ?>views/activo/register-activo" class="btn btn-outline-success btn-sm text-end" type="button">Registrar</a>
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
                    <select name="subcategoria" id="subcategoria" class="form-control filter">
                      <option value="">Selecciona</option>
                    </select>
                    <label for="subcategoria" class="form-label">Subcategorias</label>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="form-floating">
                    <input type="text" class="form-control filter" id="cod_identificacion" autocomplete="off">
                    <label for="cod_identificacion">Cod. Identificacion</label>
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
                <div class="col-md-2">
                  <div class="form-floating">
                    <select name="marca" id="marca" class="form-control filter">
                      <option value="">Selecciona</option>
                    </select>
                    <label for="marca">Marca</label>
                  </div>
                </div>
              </div>
              <div class="row pt-3">
                <div class="row">
                  <div class="col-md-4">
                    <div class="card">
                      <div class="card-header pb-1 pt-1">Rango de Fechas</div>
                      <div class="card-body">
                        <div class="row">
                          <div class="col-md-5 ms-4">
                            <div class="form-floating">
                              <input type="date" class="form-control filter" id="fecha_adquisicion">
                              <label for="fecha_adquisicion">Fecha Inicio</label>
                            </div>
                          </div>
                          <div class="col-md-5 ms-2">
                            <div class="form-floating">
                              <input type="date" class="form-control filter" id="fecha_adquisicion_fin">
                              <label for="fecha_adquisicion_fin">Fecha Fin</label>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="card">
          <div class="card-body">
            <div class="row g-5">
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
                    <col style="width:1%">
                    <col style="width:1%">
                    <col style="width:1%">
                    <col style="width:2%">
                  </colgroup>
                  <thead class="text-center">
                    <tr>
                      <th>#</th>
                      <th>Categoria</th>
                      <th>Subcategoria</th>
                      <th>Marca</th>
                      <th>Modelo</th>
                      <th>Cod. Identif.</th>
                      <th>Fecha adq.</th>
                      <th>Descripcion</th>
                      <th>Estado</th>
                      <th>Especificaciones</th>
                      <th>Acciones</th>
                    </tr>
                  </thead>
                  <tbody id="tb-body-activo">
                  </tbody>
                </table>

              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
  <div class="modal fade" tabindex="-1" id="modal-update">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">¿Deseas actualizar el activo?</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <a class="btn btn-sm btn-success" href="<?= $host ?>views/activo/update-activo">Actualizar</a>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- SIDEBAR DE DETALLES DE LA BAJA DE UN ACTIVO-->
<div class="offcanvas offcanvas-end" tabindex="-1" id="activo-baja-detalle" aria-labelledby="offcanvasRightLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasRightLabel">DETALLES DE LA BAJA</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body g-3">
    <div class="row">
      <div class="col-md-6 pt-2">
        <p id="desc">Descrip. Activo</p>
      </div>
      <div class="col-md-3 pt-1">
        <button class="btn btn-sm btn-info w-75 text-first" type="button">+</button>
      </div>
    </div>
    <div class="row mt-3">
      <div class="col-md-12">
        <p id="fecha-baja">12/09/2018</p>
        <p id="aprobacion">Pedro Diaz (pedro3f)</p>
      </div>
    </div>
    <div class="row mt-3">
      <div class="col-md-12">
        <div>
          <strong>Motivo:</strong>
          <p class="text-break" id="motivo">Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto repellendus velit
            exercitationem vitae placeat necessitatibus voluptas aut quod deserunt magnam.
          </p>
        </div>
        <div class="pt-2">
          <strong>Comentario Adicional:</strong>
          <p class="text-break" id="comentario">Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto repellendus velit
            exercitationem vitae placeat necessitatibus voluptas aut quod deserunt magnam.
          </p>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-5">
        <a class="btn btn-sm btn-success" id="view-pdf-baja" target="_blank">ver PDF</a>
      </div>
    </div>
  </div>
</div>
<!-- ./SIDEBAR DE DETALLES DE LA BAJA DE UN ACTIVO-->

<?php require_once '../footer.php' ?>
<!-- JQUERY -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- LIBRERIA -->
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script src="<?=$host?>js/activos/index.js"></script>
</body>

</html>