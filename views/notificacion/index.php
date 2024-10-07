<?php
require_once '../header.php';
?>
<div class="container mt-5">
  <style>
    .dropdown-toggle::after {
      display: none;
    }
    p{
      margin: 0px;
    }

    .dropdown-menu {
      min-width: 400px;
      max-height: 400px;
      overflow-y: auto;
      /* Ajusta el ancho mínimo */
    }

    .element-notificacion p{
      pointer-events: none;
    }
  </style>
  <div class="dropdown">
    <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
      <i class="fas fa-bell"></i> Notificaciones
    </button>
    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton" id="list-notificacion">
      <li class="ms-3 m-3"><b>NOTIFICACIONES</b></li>
    </ul>
  </div>
  <!-- INICIO MODAL -->
  <div class="modal fade" id="modal-detalle-notificacion" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="modalLabel">Detalle de la Notificacion</h5>
        </div>
        <div class="modal-body" id="modal-body-notif">

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>
  <!-- FIN MODAL -->
</div>
<?php require_once '../footer.php' ?>
<script src="../../js/notificacion/list.js"></script>
</body>

</html>