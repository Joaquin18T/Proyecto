<?php
session_start();
if (!isset($_SESSION['login']) || (isset($_SESSION['login']) && !$_SESSION['login']['permitido'])) {
  header('Location:http://localhost/CMMS/');
}
$idusuario = $_SESSION['login']['usuario'];
$rol = $_SESSION['login']['rol'];
$host = "http://localhost/CMMS/";
?>
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
  <!-- Asignaciones -->
  <link rel="stylesheet" href="http://localhost/CMMS/css/responsables/list-asignaciones.css">
  <!-- Usuarios -->

</head>

<body>
  <!-- BOTON HAMBURGUESA EN RESPONSIVE -->
  <nav class="navbar navbar-dark navbar-theme-primary px-4 col-12 d-lg-none">
    <div class="d-flex align-items-center ms-auto">
      <button
        class="navbar-toggler d-lg-none collapsed "
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#sidebarMenu"
        aria-controls="sidebarMenu"
        aria-expanded="false"
        aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
    </div>
  </nav>
  <!-- BOTON HAMBURGUESA EN RESPONSIVE-->

  <!-- SIDEBAR -->
  <nav
    id="sidebarMenu"
    class="sidebar d-lg-block bg-gray-800 text-white collapse"
    data-simplebar>
    <div class="sidebar-inner px-4 pt-3">
      <div
        class="user-card d-flex d-md-none align-items-center justify-content-between justify-content-md-center pb-4">
        <div class="collapse-close d-md-none">
          <a
            href="#sidebarMenu"
            data-bs-toggle="collapse"
            data-bs-target="#sidebarMenu"
            aria-controls="sidebarMenu"
            aria-expanded="true"
            aria-label="Toggle navigation">
            <svg
              class="icon icon-xs"
              fill="currentColor"
              viewBox="0 0 20 20"
              xmlns="http://www.w3.org/2000/svg">
              <path
                fill-rule="evenodd"
                d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                clip-rule="evenodd"></path>
            </svg>
          </a>
        </div>
      </div>
      <!-- OPCIONES SIDEBAR -->
      <ul class="nav flex-column pt-3 pt-md-0" id="options-sidebar">
        <li class="nav-item mb-3">
          <a href="#" class="nav-link d-flex align-items-center">
            <span class="sidebar-icon">
              <!-- LOGO -->
            </span>
            <span class="mt-1 ms-1 sidebar-text">SISGEMAPRE</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="<?= $host ?>views/usuarios" class="nav-link">
            <span class="sidebar-icon">
              <!-- LOGO -->
            </span>
            <span class="sidebar-text">USUARIOS</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="<?= $host ?>views/activo" class="nav-link d-flex justify-content-between">
            <span>
              <span class="sidebar-icon">
                <!-- ICONO -->
              </span>
              <span class="sidebar-text">Activos</span>
            </span>
          </a>
        </li>
        <li class="nav-item">
          <span
            class="nav-link collapsed d-flex justify-content-between align-items-center"
            data-bs-toggle="collapse"
            data-bs-target="#submenu-app">
            <span>
              <span class="sidebar-icon">
                <svg
                  class="icon icon-xs me-2"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                  xmlns="http://www.w3.org/2000/svg">
                  <path
                    fill-rule="evenodd"
                    d="M5 4a3 3 0 00-3 3v6a3 3 0 003 3h10a3 3 0 003-3V7a3 3 0 00-3-3H5zm-1 9v-1h5v2H5a1 1 0 01-1-1zm7 1h4a1 1 0 001-1v-1h-5v2zm0-4h5V8h-5v2zM9 8H4v2h5V8z"
                    clip-rule="evenodd"></path>
                </svg>
              </span>
              <span class="sidebar-text">Asignaciones</span>
            </span>
            <span class="link-arrow">
              <svg
                class="icon icon-sm"
                fill="currentColor"
                viewBox="0 0 20 20"
                xmlns="http://www.w3.org/2000/svg">
                <path
                  fill-rule="evenodd"
                  d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
                  clip-rule="evenodd"></path>
              </svg>
            </span>
          </span>
          <div
            class="multi-level collapse"
            role="list"
            id="submenu-app"
            aria-expanded="false">
            <ul class="flex-column nav">
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="<?= $host ?>views/responsables/resp-activo">
                  <span class="sidebar-text">Asignar Resp.</span>
                </a>
              </li>
            </ul>
          </div>
          <div
            class="multi-level collapse"
            role="list"
            id="submenu-app"
            aria-expanded="false">
            <ul class="flex-column nav">
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="<?= $host ?>views/responsables/select-responsable">
                  <span class="sidebar-text">Resp. Principal</span>
                </a>
              </li>
            </ul>
          </div>
        </li>
        <li class="nav-item">
          <span
            class="nav-link collapsed d-flex justify-content-between align-items-center"
            data-bs-toggle="collapse"
            data-bs-target="#submenu-app">
            <span>
              <span class="sidebar-icon">
                <svg
                  class="icon icon-xs me-2"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                  xmlns="http://www.w3.org/2000/svg">
                  <path
                    fill-rule="evenodd"
                    d="M5 4a3 3 0 00-3 3v6a3 3 0 003 3h10a3 3 0 003-3V7a3 3 0 00-3-3H5zm-1 9v-1h5v2H5a1 1 0 01-1-1zm7 1h4a1 1 0 001-1v-1h-5v2zm0-4h5V8h-5v2zM9 8H4v2h5V8z"
                    clip-rule="evenodd"></path>
                </svg>
              </span>
              <span class="sidebar-text">Tareas</span>
            </span>
            <span class="link-arrow">
              <svg
                class="icon icon-sm"
                fill="currentColor"
                viewBox="0 0 20 20"
                xmlns="http://www.w3.org/2000/svg">
                <path
                  fill-rule="evenodd"
                  d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
                  clip-rule="evenodd"></path>
              </svg>
            </span>
          </span>
          <div
            class="multi-level collapse"
            role="list"
            id="submenu-app"
            aria-expanded="false">
            <ul class="flex-column nav">
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="<?= $host ?>views/plantareas">
                  <span class="sidebar-text">Plan de tareas</span>
                </a>
              </li>
            </ul>
          </div>
        </li>
        <li class="nav-item">
          <span
            class="nav-link collapsed d-flex justify-content-between align-items-center"
            data-bs-toggle="collapse"
            data-bs-target="#submenu-pages">
            <span>
              <span class="sidebar-icon">
                <svg
                  class="icon icon-xs me-2"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                  xmlns="http://www.w3.org/2000/svg">
                  <path
                    fill-rule="evenodd"
                    d="M2 5a2 2 0 012-2h8a2 2 0 012 2v10a2 2 0 002 2H4a2 2 0 01-2-2V5zm3 1h6v4H5V6zm6 6H5v2h6v-2z"
                    clip-rule="evenodd"></path>
                  <path
                    d="M15 7h1a2 2 0 012 2v5.5a1.5 1.5 0 01-3 0V7z"></path>
                </svg>
              </span>
              <span class="sidebar-text">Page examples</span>
            </span>
            <span class="link-arrow">
              <svg
                class="icon icon-sm"
                fill="currentColor"
                viewBox="0 0 20 20"
                xmlns="http://www.w3.org/2000/svg">
                <path
                  fill-rule="evenodd"
                  d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
                  clip-rule="evenodd"></path>
              </svg>
            </span>
          </span>
          <div
            class="multi-level collapse"
            role="list"
            id="submenu-pages"
            aria-expanded="false">
            <ul class="flex-column nav">
              <li class="nav-item">
                <a class="nav-link" href="../../pages/examples/sign-in.html">
                  <span class="sidebar-text">Sign In</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="../../pages/examples/sign-up.html">
                  <span class="sidebar-text">Sign Up</span>
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="../../pages/examples/forgot-password.html">
                  <span class="sidebar-text">Forgot password</span>
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="../../pages/examples/reset-password.html">
                  <span class="sidebar-text">Reset password</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="../../pages/examples/lock.html">
                  <span class="sidebar-text">Lock</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="../../pages/examples/404.html">
                  <span class="sidebar-text">404 Not Found</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="../../pages/examples/500.html">
                  <span class="sidebar-text">500 Not Found</span>
                </a>
              </li>
            </ul>
          </div>
        </li>
      </ul>
      <!--/ OPCIONES SIDEBAR -->
    </div>
  </nav>
  <!-- FIN SIDEBAR -->

  <main class="content">
    <!-- NAVBAR-HEADER -->
    <nav
      class="navbar navbar-top navbar-expand navbar-dashboard navbar-dark ps-0 pe-2 pb-0">
      <div class="container-fluid px-0">
        <div
          class="d-flex justify-content-between w-100"
          id="navbarSupportedContent">
          <div class="d-flex align-items-center"></div>
          <!-- Navbar links (PERFIL USUARIO) -->
          <ul class="navbar-nav align-items-center">
            <!-- LOGO NOTIFICACION -->
            <li class="nav-item dropdown">
              <a
                class="nav-link text-dark notification-bell unread dropdown-toggle"
                href="#"
                role="button"
                data-bs-toggle="dropdown"
                aria-expanded="false">
                <svg
                  class="icon icon-sm text-gray-900"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                  xmlns="http://www.w3.org/2000/svg">
                  <path
                    d="M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6zM10 18a3 3 0 01-3-3h6a3 3 0 01-3 3z"></path>
                </svg>
              </a>
              <div class="dropdown-menu dropdown-menu-lg dropdown-menu-center mt-2 py-0">
                <div class="list-group list-group-flush">
                  <a href="#" class="text-center text-primary fw-bold border-bottom border-light py-3">
                    Notifications
                  </a>
                  <a href="#" class="list-group-item list-group-item-action border-bottom">
                    <div class="row align-items-center">
                      <div class="col-auto">
                        <!-- Avatar -->
                        <img alt="Image placeholder" src="#" class="avatar-md rounded" />
                      </div>
                      <div class="col ps-0 ms-2">
                        <div class="d-flex justify-content-between align-items-center">
                          <div>
                            <h4 class="h6 mb-0 text-small">Neil Sims</h4>
                          </div>
                          <div class="text-end">
                            <small class="text-danger">2 hrs ago</small>
                          </div>
                        </div>
                        <p class="font-small mt-1 mb-0">
                          You've been assigned a task for "Awesome new project".
                        </p>
                      </div>
                    </div>
                  </a>
                  <a href="#" class="dropdown-item text-center fw-bold rounded-bottom py-3">
                    <svg
                      class="icon icon-xxs text-gray-400 me-1"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                      xmlns="http://www.w3.org/2000/svg">
                      <path d="M10 12a2 2 0 100-4 2 2 0 000 4z"></path>
                      <path
                        fill-rule="evenodd"
                        d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z"
                        clip-rule="evenodd"></path>
                    </svg>
                    View all
                  </a>
                </div>
              </div>
            </li>
            <!-- FIN LOGO NOTIFICACION -->

            <!-- USER - LOGOUT -->
            <li class="nav-item dropdown ms-lg-3">
              <a
                class="nav-link dropdown-toggle pt-1 px-0"
                href="#"
                role="button"
                data-bs-toggle="dropdown"
                aria-expanded="false">
                <div class="media d-flex align-items-center">
                  <img class="avatar rounded-circle" alt="Image placeholder" src="#" />
                  <div class="media-body ms-2 text-dark align-items-center d-none d-lg-block">
                    <span class="mb-0 font-small fw-bold text-gray-900" id="nomuser"><?= $idusuario ?></span>
                  </div>
                </div>
              </a>
              <!-- Menú desplegable unificado -->
              <ul class="dropdown-menu dropdown-menu-end mt-2 py-1">
                <!-- Opción de rol de usuario -->
                <li>
                  <a class="dropdown-item d-flex align-items-center" id="rolUser">
                    <?= $rol ?>
                  </a>
                </li>
                <!-- Separador -->
                <li>
                  <hr class="dropdown-divider">
                </li>
                <!-- Opción de logout -->
                <li>
                  <a class="dropdown-item d-flex align-items-center" href="#">
                    <svg
                      class="dropdown-icon text-danger me-2"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                      xmlns="http://www.w3.org/2000/svg">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                    </svg>
                    Logout
                  </a>
                </li>
              </ul>
            </li>
            <!-- FIN USER - LOGOUT -->
          </ul>

        </div>
      </div>
    </nav>
    <!-- /NAVBAR-HEADER -->