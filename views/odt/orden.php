<?php require_once '../header.php' ?>

<div class="div row container-fluid">
    <h1>Orden de trabajo</h1>
    <div class="card mb-3" style="max-width: 100%;">
        <div class="row g-0">
            <div class="col-md-4 text-center">
                <img src="https://i.etsystatic.com/36262552/r/il/b32f2f/4239329917/il_570xN.4239329917_gcxb.jpg" class="img-fluid rounded-start" alt="...">
            </div>
            <div class="col-md-8">
                <div class="card-body ">
                    <h5 class="card-title">Diagnostico entrada</h5>
                    <p class="card-text">This is a wider Lorem ipsum dolor sit amet consectetur adipisicing elit. Laudantium dicta et provident, quae est accusantium, fuga eaque placeat assumenda eos labore enim molestiae iste ab nostrum, quaerat quasi veritatis ex. card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                </div>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="card border-0">
                                <div class="card-header fw-bolder border-0 text-center">
                                    Detalles
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <p class="fw-bolder col">Activo: </p>
                                        <p class="fw-normal d-flex align-items-center col">Manteca</p>
                                    </div>
                                    <div class="row">
                                        <p class="fw-bolder col">Fecha programada: </p>
                                        <p class="fw-normal d-flex align-items-center col">9/09/2024</p>
                                    </div>                                    
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card border-0">
                                <div class="card-header border-0 text-center fw-bolder">
                                    Resqponsables
                                </div>
                                <div class="card-body">
                                    <ul class="list-group">
                                        <li class="list-group-item">XD</li>
                                        <li class="list-group-item">XD</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <h1>Ejecución</h1>
    <div class="card mb-3" style="max-width: 100%;">
        <div class="row g-0">
            <div class="col-md-4 text-center">
                <img src="https://i.etsystatic.com/36262552/r/il/b32f2f/4239329917/il_570xN.4239329917_gcxb.jpg" class="img-fluid rounded-start" alt="...">
            </div>
            <div class="col-md-8">
                <div class="card-body ">
                    <h5 class="card-title">Diagnsotic salida</h5>
                    <p class="card-text">This is a wider Lorem ipsum dolor sit amet consectetur adipisicing elit. Laudantium dicta et provident, quae est accusantium, fuga eaque placeat assumenda eos labore enim molestiae iste ab nostrum, quaerat quasi veritatis ex. card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                </div>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="card border-0">
                                <div class="card-header border-0 text-center">
                                    <h5 class="fw-bolder">Tiempo</h5>
                                </div>
                                <div class="card-body ">
                                    <div class="row">
                                        <p class="fw-bolder col">Fecha inicial: </p>
                                        <p class="fw-normal d-flex align-items-center col">9/09/2024</p>
                                    </div>
                                    <div class="row">
                                        <p class="fw-bolder col">Fecha acabado: </p>
                                        <p class="fw-normal d-flex align-items-center col">9/09/2024</p>
                                    </div>
                                    <div class="row">
                                        <p class="fw-bolder col">Tiempo de ejecucion: </p>
                                        <p class="fw-normal d-flex align-items-center col">00:04:14</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card border-0 text-center">
                                <div class="card-header border-0 ">
                                    <h5 class="fw-bold">Acciones</h5>
                                </div>
                                <div class="card-body">
                                    <div class="card-body text-center">
                                        <button class="btn btn-primary">Iniciar</button>
                                    </div>
                                    <div class="card-body text-center">
                                        <button class="btn btn-secondary">Finalizar</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once '../footer.php' ?>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Luego, el archivo de DataTables -->
<!-- jKanban JS -->
<script src="https://cdn.jsdelivr.net/npm/jkanban@1.2.0/dist/jkanban.min.js"></script>
<script>
    const idusuario = "<?php echo $_SESSION['login']['idusuario']; ?>"
</script>
<script src="http://localhost/CMMS/js/odt/orden.js"></script>

</body>

</html>