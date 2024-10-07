<?php 
require_once 'header.php';

?>
<div class="">

  <a href="<?=$host?>/controllers/usuarios.controller.php?operation=destroy">aaaa</a>

  <div>

  </div>

  <p>
  <?php
      if($usuario['rol']=="Administrador"){
        echo "Texto visto por admin";
      }
    ?>
  </p>
  <p>
    <?php
      if($usuario['rol']=="Usuario" ||$usuario['rol']=="Administrador"){
        echo "Texto visto por usuario y admin";
      }
    ?>
  </p>

</div>
<?php require_once 'footer.php' ?>
</body>
</html>