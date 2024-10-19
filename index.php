<?php
  session_start();
  if(isset($_SESSION['login']) && $_SESSION['login']['permitido']){
    header('Location:http://localhost/CMMS/views/index.php');
  }
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <link rel="stylesheet" href="http://localhost/CMMS/css/login.css">
  <title>Login</title>
</head>
<body>
  <div class="container">
    <form action="" id="form-login" class="form-group" autocomplete="off">
      <div class="mb-3 bg pt-5">
        <h2 class="text-center">Login</h2>
        <label for="usuario" class="form-label mt-5">Nombre de Usuario</label>
        <input type="text" class="form-control" id="usuario" required>
      </div>
      <div class="mb-3">
        <label for="passusuario" class="form-label mt-3">Clave Acceso</label>
        <input type="password" class="form-control" id="passusuario" required>
      </div>
      <button type="submit" id="access" class="btn btn-primary">Access</button>
    </form>
  </div>

  <script>
    document.addEventListener("DOMContentLoaded",()=>{
      document.querySelector("#form-login").addEventListener("submit",(e)=>{
        e.preventDefault();

        const params = new URLSearchParams();
        params.append("operation","login");
        params.append("usuario", document.querySelector("#usuario").value);
        params.append("passusuario", document.querySelector("#passusuario").value);

        fetch(`./controllers/usuarios.controller.php?${params}`)
        .then(resp=>resp.json())
        .then(acceso=>{
          console.log(acceso);
          if(!acceso.permitido){
            alert(acceso.status);
          }else{
            window.location.href='./views/odt';
          }
        })
        
      })
    })
  </script>
</body>
</html>