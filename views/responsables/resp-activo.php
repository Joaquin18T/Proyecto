<?php

require_once '../header.php'; ?>
<script src="../../node_modules/tinymce/tinymce.min.js" referrerpolicy="origin"></script>
<link rel="stylesheet" href="http://localhost/CMMS/css/responsables/asignar-resp.css">

<h2>RESPONSABLES</h2>
<div class="row">
  <style>
    .dropdown-menu {
      position: absolute;
      background-color: white;
      border: 1px solid #ccc;
      list-style: none;
      max-height: 150px;
      overflow-y: auto;
      width: 50%;
      padding: 0;
      margin: 0;
      z-index: 1000;
      visibility: hidden;
    }

    .dropdown-menu li {
      padding: 10px;
      cursor: pointer;
    }

    .input-container {
      height: 100px;
    }

    .img-select {
      cursor: pointer;
    }
  </style>
  <div class="col-md-12">
    <div class="card mb-5">
      <div class="card-header d-flex justify-content-between m-0">
        <p class="text-start m-0 pt-1">Asignar Responsable</p>
        <a href="http://localhost/CMMS/views/responsables/" class="btn btn-outline-success btn-sm text-end">Volver</a>
      </div>
      <div class="card-body">
        <form action="" id="form-responsables" autocomplete="off">
          <div class="row g-1 mb-1">
            <div class="col-md-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="activo" name="activo" placeholder="Escribe Nombre activo" autocomplete="off" autofocus required>
                <label for="activo" class="form-label">Buscar Activo</label>
                <ul id="list" class="dropdown-menu w-100"></ul>
              </div>
            </div>
            <div class="col-md-2">
              <div class="form-floating">
                <select class="form-control" id="ubicacion" required>
                  <option value="">Selecciona</option>
                </select>
                <label for="ubicacion">Ubicacion</label>
              </div>
            </div>
            <div class="col-md-7">
              <div class="form-floating">
                <input id="descripcion" class="form-control" name="descripcion" placeholder="Descripcion de la Asignacion" required>
                <label for="descripcion">DESCRIPCION</label>
              </div>
            </div>
          </div>
          <div class="row g-1 mb-1 mt-4">
            <div class="col-md-2">
              <button class="btn btn-outline-secondary w-100" id="modalResp" type="button">Asignar Responsable</button>
            </div>
            <div class="col-md-4">
              <input class="form-control" type="file" id="imageInput" accept="image/*" multiple required>
              <!-- La propiedada *accept* permite restringir el tipo de archivo a seleccionar -->
              <!-- La propiedad *multiple* permite seleccionar varios archivos al mismo tiempo -->
            </div>
            <div class="col-md-4">
              <div class="form-floating">
                <!-- Contenedor de previsualización de imágenes -->
                <div class="row " id="imagePreview" class="contain-images">
                  <!-- Aquí se agregarán las imágenes previsualizadas -->
                </div>
              </div>
            </div>
          </div>
          <div class="row g-1 mb-3 mt-4">
            <div class="col-md-12">
              <textarea name="condicion" id="condicion" class="w-100 form-control" style="text-decoration: none; resize:none" autocomplete="off" cols="15" rows="5" required>
              </textarea>
            </div>
          </div>
          <div class="row g-1 mb-3">
            <div class="col-md-3">
              <button type="submit" class="btn btn-primary">Registrar</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- MODAL -->
  <div class="modal fade" id="modalResponsables" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">Título del Modal</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <table id="tb-users" class="table">
            <colgroup>
              <col style="width: 5%;">
              <col style="width: 10%;">
              <col style="width: 10%;">
              <col style="width: 5%;">
            </colgroup>
            <thead>
              <tr>
                <th>#</th>
                <th>Rol</th>
                <th>Responsable</th>
                <th>Asignar</th>
              </tr>
            </thead>
            <tbody>

            </tbody>
          </table>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" id="btn-modalRes-cerrar">Cerrar</button>
          <button type="button" class="btn btn-primary" id="btmM-save">Guardar Cambios</button>
        </div>
      </div>
    </div>
  </div>
  <!-- FIN MODAL -->

  <!-- MODAL PARA MOSTRAR IMAGENES -->
  <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="imageModalLabel">AVISO</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body text-center ">
          <p>¿ESTAS SEGURO DE ELIMINAR LA IMAGEN?</p>
        </div>
        <div class="modal-footer">
          <button type="button" id="btn-eliminar" class="btn btn-sm btn-danger">Eliminar</button>
        </div>
      </div>
    </div>
  </div>
  <!-- FIN MODAL IMAGENES -->

</div>


</main>
<?php require_once '../footer.php' ?>
<script src="../../js/responsables/resp-activo.js"></script>