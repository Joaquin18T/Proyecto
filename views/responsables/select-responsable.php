<?php require_once '../header.php'; ?>

<div class="container-fluid px-4">
  <h2>ASIGNAR RESPONSABLE PRINCIPAL</h2>
  <style>
    .dropdown-menu li{
      padding: 10px;
      cursor: pointer;
    }
    #list{
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      max-height: 100px;
      overflow-y: auto;
    }

    #list li{
      padding-right: 7px;
      padding-left: 7px;
      padding-top: 3px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  </style>
  <div class="row">
    <div class="col-md-12">
      <div class="card">
        <div class="card-header">Asignar Responsable</div>
        <div class="card-body">
          <div class="row g-3 mb-3">
            <div class="col-md-3">
              <div class="form-floating">
                <input class="form-control form-contro-sm" type="text" id="activo" name="activo" placeholder="Escribe Nombre activo" autocomplete="off" autofocus required>
                <label for="activo">Buscar Activo (Descripcion)</label>
                <ul id="list" class="dropdown-menu w-100"></ul>
              </div>
            </div>
            <div class="col-md-8 ms-auto">
              <table class="table table-striped table-sm" id="tb-colaboradores">
                <colgroup>
                  <col style="width: 5%;">
                  <col style="width: 10%;">
                  <col style="width: 5%;">
                  <col style="width: 10%;">
                  <col style="width: 10%;">
                  <col style="width: 5%;">
                </colgroup>
                <thead>
                  <tr>
                    <th class="text-center">#</th>
                    <th class="text-center">Nombres</th>
                    <th class="text-center">Rol</th>
                    <th class="text-center">Asig. Actuales</th>
                    <th class="text-center">Disponibilidad</th>
                    <th class="text-center">Acciones</th>
                  </tr>
                </thead>
                <tbody></tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</main>
<?php require_once '../footer.php' ?>
<script src="../../js/responsables/select-responsable.js">
</script>