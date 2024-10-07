<?php require_once '../header.php' ?>

<div class="container">
  <h2>
    SOLICITUDES DE ASIGNACION
  </h2>
  <table class="table table-striped" id="tb-solicitudes">
    <colgroup>
      <col>
      <col>
      <col>
      <col>
      <col>
      <col>
      <col>
      <col>
    </colgroup>
    <thead>
      <tr>
        <th>#</th>
        <th>Solicitante</th>
        <th>Modelo</th>
        <th>Cod. Identf.</th>
        <th>Fecha Sol.</th>
        <th>Motivo.</th>
        <th>Acciones</th>
      </tr>
    </thead>
    <tbody>
      <!-- DYNAMIC -->
    </tbody>
  </table>

  <!-- MODAL -->
  <div class="modal fade" id="modal-action" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="titleModal">Title Dynamic</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form action="post" id="form-check-request">
          <div class="modal-body">
            <textarea name="admin-message" id="admin-message" 
            class="form-control w-100 txtComment" style="text-decoration: none; resize:none" 
            autocomplete="off" cols="15" rows="5" required minlength="15">

            </textarea>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary" id="btnSave">Save changes</button>
          </div>          
        </form>
      </div>
    </div>
  </div>
  <!-- FIN MODAL -->
  <!-- MODAL -->
  <div class="modal fade" id="modal-motivo" tabindex="-1" aria-labelledby="modalM" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="modalM">MOTIVO DEL USUARIO</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
        <textarea name="motivo-user" id="motivo-user" class="form-control w-100 txtComment" style="text-decoration: none; resize:none" autocomplete="off" cols="15" rows="5">

        </textarea>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Accept</button>
        </div>
      </div>
    </div>
  </div>
  <!-- FIN MODAL -->
</div>

<?php require_once '../footer.php' ?>
<script src="http://localhost/CMMS/js/Solicitudes/listado-requests.js"></script>
</body>
</html>