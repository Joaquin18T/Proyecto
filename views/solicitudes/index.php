<?php require_once '../header.php' ?>

<div class="container">
  <h2>LISTA DE ACTIVOS</h2>
  <table class="table table-striped" id="tb-activos">
    <colgroup>
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
        <th>Cod. Identf.</th>
        <th>Modelo</th>
        <th>Fecha Adqus.</th>
        <th>Responsable</th>
        <th>Estado</th>
        <th>Solicitar</th>
      </tr>
    </thead>
    <tbody>
      <!--Dynamic -->
    </tbody>
  </table>
  <!-- INICIO MODAL -->
  <div class="modal fade" id="modal-solicitud" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="modalLabel">Motivo de la solicitud</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form action="" id="form-solicitud">
          <div class="modal-body">
            <textarea id="motivo" name="motivo" class="w-100 form-control"
              style="text-decoration: none; resize:none"
              autocomplete="off" cols="15" rows="5" minlength="15" required>
            </textarea>
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">Save changes</button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>  
        </form>
      </div>
    </div>
  </div>
  <!-- FIN MODAL -->
</div>

<?php require_once '../footer.php' ?>
<script src="http://localhost/CMMS/js/Solicitudes/listado-activos.js"></script>
<!-- </body>

</html> -->