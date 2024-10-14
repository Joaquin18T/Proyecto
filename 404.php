<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <!-- Bootstrap -->
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
    rel="stylesheet"
    integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
    crossorigin="anonymous" />
  <!-- Volt CSS -->
  <link type="text/css" href="http://localhost/CMMS/css/dashboard/volt.css" rel="stylesheet" />
  <!-- Estilos personalizados -->
</head>
<section class="vh-100 d-flex align-items-center justify-content-center">
  <div class="container">
    <div class="row">
      <div
        class="col-12 text-center d-flex align-items-center justify-content-center">
        <div class="mt-2">
          <img
            class="img-fluid w-75 p-3"
            src="http://localhost/CMMS/dist/images/image-404.jpg"
            alt="404 not found" />
          <h1 class="mt-5">
            Pagina no <span class="fw-bolder text-primary">encontrada</span>
          </h1>
          <p class="lead my-4">
            Parece que seguiste un enlace incorrecto. 
          </p>
          <a
            href="http://localhost/CMMS/views/"
            class="btn btn-gray-800 d-inline-flex align-items-center justify-content-center mb-4">
            <svg
              class="icon icon-xs me-2"
              fill="currentColor"
              viewBox="0 0 20 20"
              xmlns="http://www.w3.org/2000/svg">
              <path
                fill-rule="evenodd"
                d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z"
                clip-rule="evenodd"></path>
            </svg>
            Volver al inicio
          </a>
        </div>
      </div>
    </div>
  </div>
</section>
<?php require_once './views/footer.php' ?>

</body>

</html>