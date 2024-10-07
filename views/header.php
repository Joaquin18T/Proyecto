<?php
session_start();
//require_once '../models/Permiso.php';

if (!isset($_SESSION['login']) || (isset($_SESSION['login']) && !$_SESSION['login']['permitido'])) {
  header('Location:http://localhost/CMMS');
}
$usuario = $_SESSION['login'];
// Permiso::setRol($usuario['rol']);
// $permisos = Permiso::getPermisos();

// $modulos = Module::getModules($permisos);
$host = "http://localhost/CMMS";
?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <link rel="stylesheet" href="<?= $host ?>/css/sidebar.css">

</head>

<body>
  <div class="container-fluid">
    <div class="row flex-nowrap">
      <div class="col-auto col-md-3 col-xl-2 px-sm-2 px-0 bg-dark">
        <div class="d-flex flex-column align-items-center align-items-sm-start px-3 pt-2 text-white min-vh-100">
          <a href="<?= $host ?>/views/" class="d-flex align-items-center pb-3 mb-md-0 me-md-auto text-white text-decoration-none">
            <span class="fs-5 d-none d-sm-inline">Menu</span>

          </a>
          <ul class="nav nav-pills flex-column mb-sm-auto mb-0 align-items-center align-items-sm-start" id="menu">
            <!-- USUARIOS -->
            <div class="sb-sidenav-menu-heading">Usuarios</div>
            <a class="nav-link" href="<?= $host ?>/views/usuarios/">
              <div class="sb-nav-link-icon">
              </div>
              Usuarios
            </a>
            <a class="nav-link" href="<?= $host ?>/views/usuarios/register.php">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-wallet"></i>
              </div>
              Registrar
            </a>
            <!-- FIN USUARIOS -->

            <!-- ACTIVOS -->
            <div class="sb-sidenav-menu-heading">Activos</div>
            <a class="nav-link" href="<?= $host ?>/views/activo/">
              <div class="sb-nav-link-icon">
              </div>
              Lista
            </a>
            <a class="nav-link" href="<?= $host ?>/views/activo/register-activo.php">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-wallet"></i>
              </div>
              Registrar
            </a>
            <!-- FIN ACTIVOS -->

            <!-- ASIGNACION -->
            <div class="sb-sidenav-menu-heading">Asignaciones</div>
            <a class="nav-link" href="<?= $host ?>/views/responsables/resp-activo.php">
              <div class="sb-nav-link-icon">
              </div>
              Asignar
            </a>
            <a class="nav-link" href="<?= $host ?>/views/responsables/select-responsable.php">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-wallet"></i>
              </div>
              Responsable Principal
            </a>
            <!-- FIN ASIGNACION -->
          </ul>
          <hr>
          <div class="dropdown pb-4">
            <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
              <img src="#" alt="hugenerd" width="30" height="30" class="rounded-circle">
              <span class="d-none d-sm-inline mx-1" id="nomuser"><?= $usuario['usuario'] ?></span>
            </a>
            <ul class="dropdown-menu dropdown-menu-dark text-small shadow">
              <li><a class="dropdown-item" href="#">New project...</a></li>
              <li><a class="dropdown-item" href="#">Settings</a></li>
              <li><a class="dropdown-item" href="#" id="rolUser"><?= $usuario['rol'] ?></a></li>
              <li>
                <hr class="dropdown-divider">
              </li>
              <li><a class="dropdown-item" href="#">Sign out</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div class="col py-3">


        <main>