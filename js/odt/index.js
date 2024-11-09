$(document).ready(async () => {
    alert("idusuarioxdd: " + idusuario)
    window.localStorage.clear()
    function $q(object = null) {
        return document.querySelector(object);
    }

    function $all(object = null) {
        return document.querySelectorAll(object);
    }

    async function getDatos(link, params) {
        let data = await fetch(`${link}?${params}`);
        return data.json();
    }

    //variables
    let idrolusuario = -1;
    let redirigir = false;
    const tbodyTareas = $q("#tb-tarpendientes tbody")
    const host = "http://localhost/CMMS/controllers/";
    await verificarRolUsuario()
    await verificarTerminadoOdt()
    await obtenerHistorialOdt()
    await renderTablaInfoTareaPendiente()
    // **************************** SECCION DE OBTENER DATOS ****************************************************
    async function obtenerUsuario() {
        const paramsUsuario = new URLSearchParams()
        paramsUsuario.append("operation", "getUserById")
        paramsUsuario.append("idusuario", idusuario)
        const usuarioObtenido = await getDatos(`${host}usuarios.controller.php`, paramsUsuario)
        console.log("usuarioObtenido: ", usuarioObtenido)
        return usuarioObtenido
    }

    async function obtenerTareas() {
        const paramsTareasSearch = new URLSearchParams()
        paramsTareasSearch.append("operation", "obtenerTareas")
        const tareasRegistradasObtenidas = await getDatos(`${host}tarea.controller.php`, paramsTareasSearch)
        console.log("tareasRegistradasObtenidas: ", tareasRegistradasObtenidas)
        return tareasRegistradasObtenidas
    }

    async function obtenerTareasOdt() {
        const paramsTareasOdtListar = new URLSearchParams()
        paramsTareasOdtListar.append("operation", "obtenerTareasOdt")
        const tareasOdt = await getDatos(`${host}ordentrabajo.controller.php`, paramsTareasOdtListar)
        console.log("TAREAS ODT: ", tareasOdt)
        return tareasOdt;
    }

    async function obtenerHistorialOdt() {
        const paramsHistorialOdt = new URLSearchParams()
        paramsHistorialOdt.append("operation", "obtenerHistorialOdt")
        const historialOodt = await getDatos(`${host}ordentrabajo.controller.php`, paramsHistorialOdt)
        console.log("Historial odt: ", historialOodt)
        return historialOodt;
    }

    async function obtenerActivosPorTarea(idtarea) {
        const params = new URLSearchParams()
        params.append("operation", "obtenerActivosPorTarea")
        params.append("idtarea", idtarea)
        const activo = await getDatos(`${host}activo.controller.php`, params)
        console.log("activo: ", activo)
        return activo
    }

    async function obtenerTareasPorId(idtarea) {
        const paramsObtener = new URLSearchParams()
        paramsObtener.append("operation", "mostrarTareasEnTablaPorIdTarea")
        paramsObtener.append("idtarea", idtarea)
        const tareas = await getDatos(`${host}tarea.controller.php`, paramsObtener)
        return tareas
    }


    async function obtenerIdsUsuariosOdt() {
        const paramsObtener = new URLSearchParams()
        paramsObtener.append("operation", "obtenerIdsUsuariosOdt")
        const idsusuariosodt = await getDatos(`${host}ordentrabajo.controller.php`, paramsObtener)
        return idsusuariosodt
    }

    var kanban = new jKanban({
        element: '#kanban-container', // ID del contenedor
        boards: [
            {
                id: 'b-pendientes',
                title: 'Pendientes',
                class: 'pendientes',
                item: []
            },
            {
                id: 'b-proceso',
                title: 'En Proceso',
                class: 'proceso',
                item: []
            },
            {
                id: 'b-revision',
                title: 'En Revision',
                class: 'revision',
                item: []
            },
            {
                id: 'b-finalizado',
                title: 'Finalizadas',
                class: 'finalizadas',
                item: []
            }
        ],
        dragBoards: false,
        widthBoard: '400px',
        dropEl: async function (el, target, source, sibling) {
            var cardId = el.getAttribute('data-eid'); // ID de la tarjeta
            var targetBoardId = target.parentElement.getAttribute('data-id'); // ID del board donde cayó la tarjeta
            console.log('Tarjeta ' + cardId + ' fue movida al board ' + targetBoardId);

            // OBTENER TAREAS ODT Y TAREAS

            const tareasOdt = await obtenerTareasOdt();
            const tareas = await obtenerTareas();

            console.log("tareasOdt: ", tareasOdt);
            console.log("tareas: ", tareas);

            // BUSCAR LA TAREA SELECCIONADA EN AMBOS ARRAYS
            const tareaSeleccionada = tareas.find(t => t.idtarea == cardId);
            const tareaOdtSeleccionada = tareasOdt.find(t => t.idorden_trabajo == cardId); //ejemplo: card id: 1 == idtarea: 1
            const activoObtenidoPorTarea = await obtenerActivosPorTarea(tareaSeleccionada?.idtarea)

            // AGREGAR VALIDACIÓN PARA VERIFICAR SI LA TAREA EXISTE
            if (!tareaSeleccionada && !tareaOdtSeleccionada) {
                console.error("Tarea no encontrada.");
                return; // SALIR SI NINGUNA TAREA COINCIDE
            }

            // VALIDAR ESTADOS
            switch (targetBoardId) {
                case "b-proceso":
                    if (idrolusuario == 1) { //esto es administrador
                        let permitir = true
                        // VALIDAR SI tareaOdtSeleccionada EXISTE Y SU ESTADO
                        if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "proceso") {
                            alert("Esta tarea ya está en proceso, no se puede redirigir");
                            break;
                        } else if (tareaSeleccionada && tareaSeleccionada.nom_estado === "pendiente") {
                            const now = new Date();
                            const fechaInicioTarea = now.toISOString().split("T")[0]; // Fecha en formato YYYY-MM-DD
                            const horaInicioTarea = now.toTimeString().split(" ")[0].substring(0, 5); // Hora en formato HH:MM
                            //let fechaHoraInicio = new Date(`${fechaInicioTarea}T${horaInicioTarea}:00-05:00`);
                            console.log("tareaSeleccionada: ", tareaSeleccionada)
                            // SI LA TAREA ESTÁ EN PENDIENTE, REDIRIGIR
                            console.log("activoObtenidoPorTarea: ", activoObtenidoPorTarea)
                            for (let a = 0; a < activoObtenidoPorTarea.length; a++) {
                                if (activoObtenidoPorTarea[a].idestado == 2) {
                                    showToast(`Hay activos asignados a esta tarea que están en mantenimiento ahora mismo.`, 'ERROR', 6000);
                                    permitir = false;
                                    return
                                }
                            }
                            if (tareaSeleccionada.pausado == 1) {
                                showToast(`Esta tarea esta pausada, no puedes procesarla por el momento.`, 'ERROR', 6000);
                                permitir = false;
                                return
                            }

                            if (permitir) {
                                const activosPorTarea = await obtenerActivosPorTarea(cardId);
                                console.log("Iniciando orden...");
                                const tareasMostrarTabla = await obtenerTareasPorId(cardId) //ESTO ES PARA MOSTRAR LA TAREA EN LA TABLA DE VISTA PREVIA
                                console.log("tareasMostrarTabla_>", tareasMostrarTabla)
                                //const btnCancelarCreacionOdt = $q("") //botones para crear y cancelar la orden
                                tbodyTareas.innerHTML = ''
                                for (let i = 0; i < tareasMostrarTabla.length; i++) {
                                    tbodyTareas.innerHTML += `
                                        <tr>
                                            <th>${tareasMostrarTabla[i].descripcion}</th>
                                            <td>${tareasMostrarTabla[i].prioridad}</td>
                                            <td>${tareasMostrarTabla[i].frecuencia}</td>                                            
                                            <td>${tareasMostrarTabla[i].nombres} ${tareasMostrarTabla[i].apellidos}</td>                                            
                                            <td>${tareasMostrarTabla[i].activo}</td>
                                            <td>${tareasMostrarTabla[i].nom_estado}</td>
                                        </tr>
                                    `;
                                }
                                $(".btnCancelarCreacionOdt").click(function (e) {
                                    e.preventDefault();
                                    tbodyTareas.innerHTML = ''
                                });
                                $(".btnCrearOdt").click(async function (e) {
                                    e.preventDefault();
                                    const idOdt = await registrarOdt(cardId, fechaInicioTarea, horaInicioTarea);
                                    console.log(idOdt);
                                    for (let i = 0; i < tareasMostrarTabla.length; i++) {
                                        const responsableRegistrado = await registrarResponsablesAsignados(tareasMostrarTabla[i].idusuario, idOdt.id)
                                        console.log("responsableRegistrado : ", responsableRegistrado)
                                    }
                                    //window.localStorage.clear()
                                    //window.localStorage.setItem("idtarea", cardId);
                                    //window.localStorage.setItem("idodt", idOdt.id);
                                    const actualizado = await actualizarTareaEstado(cardId, 9)
                                    console.log("actualizado?: ", actualizado)
                                    if (actualizado.actualizado) {
                                        showToast("Orden de trabajo creado exitosamente.", 'SUCCESS', 3000)
                                        tbodyTareas.innerHTML = ''
                                        for (let o = 0; o < activosPorTarea.length; o++) {
                                            const activo = activosPorTarea[o];

                                            // Cambiar el estado del activo a "en mantenimiento" solo si no está ya en estado "2" en esta tarea
                                            if (activo.idestado !== 2) {
                                                await actualizarEstadoActivo(activo.idactivo, 2); // Cambiar estado a "en mantenimiento"
                                                console.log(`Estado actualizado del activo ${activo.idactivo} a 'en mantenimiento'`);
                                            }
                                        }
                                    }
                                });


                                //console.log("redirigiendo ....")
                                //window.location.href = `http://localhost/CMMS/views/odt/registrar-odt.php`;
                            }


                        } else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "revision") {
                            alert("Esta orden ya esta en revision, no se puede redirigir a proceso");
                            break;
                        } else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "finalizado") {
                            alert("Esta orden ya esta finalizada, no se puede redirigir a proceso");
                            break;
                        }

                        break;
                    } else {
                        showToast(`Solo administradores pueden crear ordenes de trabajo.`, 'ERROR', 6000);
                        break;
                    }

                case "b-revision":
                    if (idrolusuario == 2) { //esto seria usuario normal
                        if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "proceso") {
                            if (tareaOdtSeleccionada.incompleto === 1) {
                                alert("LA TAREA ODT ESTA INCOMPLETA NO PUEDES REVISARLA");
                                break;
                            }
                            else if (tareaOdtSeleccionada.clasificacion == null || tareaOdtSeleccionada.clasificacion == 9) {
                                alert("ESTA ODT NO PUEDE SER REVISADA POR QUE NO ESTA AL 100%")
                                break;
                            } else {
                                //window.localStorage.clear()
                                //window.localStorage.setItem("idodt", tareaOdtSeleccionada.idorden_trabajo);
                                const actualizado = await actualizarEstadoOdt(10, tareaOdtSeleccionada.idorden_trabajo)
                                console.log("actualizado ODT A REVISION?: ", actualizado)
                                //window.location.href = `http://localhost/CMMS/views/odt/revisar-odt.php`
                                showToast(`La orden de trabajo ha sido completada y enviada para revisión por un administrador.`, 'SUCCESS', 3000);
                                break;
                            }
                        } else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "pendientes") {
                            alert("Esta orden esta en pendientes, primero procesala");
                            break;
                        }
                        else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "revision") {
                            alert("Esta orden ya esta en reivison, no puedes redirigir");
                            break;
                        }
                        else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "finalizado") {
                            alert("Esta orden ya esta finalizada, no puedes redirigir");
                            break;
                        }
                    } else {
                        showToast(`Solo usuarios pueden mandar a revisar la orden de trabajo.`, 'ERROR', 6000);
                        break;
                    }


            }
        }

    });

    async function renderTablaInfoTareaPendiente() {
        if (idrolusuario == 1) {
            $('#tb-tarpendientes').DataTable({
                paging: true,
                searching: false,
                lengthMenu: [5, 10, 15, 20],
                pageLength: 5,
                language: {
                    lengthMenu: "Mostrar _MENU_ filas por página",
                    paginate: {
                        previous: "Anterior",
                        next: "Siguiente"
                    },
                    emptyTable: "No hay datos disponibles",
                    search: "Buscar:",
                    info: "Mostrando _START_ a _END_ de _TOTAL_ registros"
                }
            });
        } else {
            $q(".contenedor-tabla-creacion-odt").innerHTML = ''
        }
    }

    // ************************** SECCION DE RENDERIZADO DE DATOS E INTERFAZ ********************
    await renderTareasPendiente()

    async function renderTareasPendiente() {
        let idsodt = [];
        let idsusuarios = [];

        const idsusuariosOdt = await obtenerIdsUsuariosOdt(); //esto solo contiene los id's de los usuarios, por ejemplo, ahorita tiene 3 elementos, y sus valores son idusuario: 1
        console.log("idsusuariosOdt", idsusuariosOdt);
        const tareas = await obtenerTareas(); // PENDIENTES
        const tareasOdt = await obtenerTareasOdt(); // EN PROCESO
        console.log("EL GORROOPTERO: ", tareasOdt);
        const historialOdt = await obtenerHistorialOdt(); // FINALIZADAS

        // Agrupar las tareas por idtarea y concatenar los activos
        const tareasAgrupadas = tareas.reduce((acc, tarea) => {
            if (!acc[tarea.idtarea]) {
                // Si el idtarea no está en el acumulador, lo agregamos con un array de activos
                acc[tarea.idtarea] = {
                    ...tarea,
                    activos: [tarea.activo]
                };
            } else {
                // Si ya existe, concatenamos el activo actual al array de activos
                acc[tarea.idtarea].activos.push(tarea.activo);
            }
            return acc;
        }, {});

        // Crear las tarjetas a partir de las tareas agrupadas
        if (idrolusuario == 1) {
            Object.values(tareasAgrupadas).forEach(tarea => {
                const activosConcatenados = tarea.activos.join(', '); // Unir los activos en un solo string

                const tareaHTML = `
                <h3 class="card-title">${tarea.descripcion}</h3>                   
                <div class="row">
                    <div class="col-md-6">
                        <p><small><strong>Intervalo: </strong>${tarea.intervalo}</small></p>
                    </div>
                    <div class="col-md-6">
                        <p><small><strong>Frecuencia: </strong>${tarea.frecuencia}</small></p>
                    </div>
                </div>                
                <p class="card-text"><strong>Plan de tarea: </strong>${tarea.plantarea}</p>
                <p><strong>Activos: </strong>${activosConcatenados}</p>
                <hr>
                <p><strong>Prioridad: </strong>${tarea.prioridad}</p>                                             
            `;

                // Asignar las tareas a diferentes boards según su estado
                switch (tarea.nom_estado) {
                    case 'pendiente':
                        kanban.addElement('b-pendientes', {
                            id: tarea.idtarea, // Usamos el idtarea como id de la tarjeta
                            title: tareaHTML // Usamos el HTML que hemos creado
                        });
                        break;
                }
            });
        }

        for (let r = 0; r < idsusuariosOdt.length; r++) {
            idsodt.push(idsusuariosOdt[r].idorden_trabajo);
            idsusuarios.push(idsusuariosOdt[r].idusuario);
        }
        console.log("idsodt aaaaa: ", idsodt);

        if (idrolusuario == 2) {
            tareasOdt.forEach(todt => {
                // Verificar si el idorden_trabajo de la tarea está en las claves de idsUsuariosOdt
                if (idsodt.includes(todt.idorden_trabajo)) {
                    // Asegurarse de que responsables_ids sea una cadena válida
                    if (todt.responsables_ids && typeof todt.responsables_ids === 'string') {
                        // Convertir responsables_ids en un array de IDs de usuarios
                        const responsablesIdsArray = todt.responsables_ids
                            .split(',')                          // Separa por comas
                            .map(id => {
                                const parsedId = parseInt(id.trim(), 10);
                                console.log("ID parsed ->", parsedId); // Depuración de cada ID después de parsear
                                return parsedId;
                            })
                            .filter(id => !isNaN(id));           // Filtra valores no numéricos

                        // Muestra el array de IDs de responsables y el usuario logeado para depuración
                        console.log("responsablesIdsArray ->>>> ", responsablesIdsArray);
                        console.log("idusuario logeado ->> ", idusuario, " (tipo:", typeof idusuario, ")");

                        // Asegúrate de que idusuario también sea un número
                        const idUsuarioNumero = parseInt(idusuario, 10);
                        console.log("idUsuarioNumero (parseado) ->>", idUsuarioNumero, " (tipo:", typeof idUsuarioNumero, ")");

                        // Verifica si el usuario logeado está en el array de responsables
                        const isUserResponsible = responsablesIdsArray.includes(idUsuarioNumero);
                        console.log("¿Coincide el usuario? -> ", isUserResponsible); // Comparar si el idusuario está en el array
                        console.log("coinicde? -> ", isUserResponsible)
                        if (isUserResponsible) {
                            console.log("El usuario logueado es responsable de esta tarea", idusuario);
                            // Aquí puedes continuar con la lógica de la tarea si el usuario logueado es responsable
                        } else {
                            console.log("El usuario logueado no es responsable de esta tarea");
                        }

                        responsablesIdsArray.forEach(responsableId => {
                            console.log("responsableId ->>>> ", responsableId);
                            // Aquí puedes continuar con la lógica de la tarea si el usuario corresponde
                        });
                    } else {
                        console.log("responsables_ids no es válido: ", todt.responsables_ids);
                    }

                    const verificarEstadoClasificacion =
                        (todt.nom_estado === "proceso" && (todt.clasificacion === 9 || todt.clasificacion === 11 || todt.clasificacion == null));
                    const badgeClasificacion =
                        (todt.clasificacion === 11 && todt.nom_estado === "finalizado")
                            ? `<span class="badge bg-primary">Terminado</span>`
                            : (todt.nom_estado === "finalizado" && (todt.clasificacion === 9 || todt.clasificacion === null))
                                ? `<span class="badge bg-warning">No terminado/Vencido</span>`
                                : '';

                    const tareaOdtHTML = `
                    <div class="mb-3">                    
                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="card-title">${todt.tarea}</h3>
                            ${badgeClasificacion}
                            ${verificarEstadoClasificacion ? ` 
                                <div class="btn-group dropstart">
                                    <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" data-id="dropdown">
                                        ⋮
                                    </button>
                                    <ul class="dropdown-menu">                                       
                                        ${(todt.nom_estado === "proceso" && todt.clasificacion === 11) ? `<li class="dropdown-item li-revision" data-id="${todt.idorden_trabajo}">Enviar a revision</li>` : ''}                                                                
                                    </ul>
                                </div>
                            ` : ''}
                        </div>
                        <div class="tarea-odt" data-id="${todt.idorden_trabajo}">
                            <div class="d-flex align-items-center mb-3">
                                <img src="https://www.iconpacks.net/icons/1/free-user-group-icon-296-thumb.png" class="rounded-circle me-2" alt="Responsables" width="40" height="40"/>
                                <p class="mb-0">${todt.responsables}</p>
                            </div>
                            <p class="text-muted"><strong>Inició el:</strong> ${todt.fecha_inicio}</p>
                            ${todt.revisado_por ? `<p class="text-muted">Revisado por ${todt.revisado_por}</p>` : ''}
                            <p class="text-muted"><strong>Creada por:</strong> ${todt.creador}</p>
                            <p><strong>Activos:</strong> ${todt.activos}</p>
                            <div class="progress mb-2">
                                <div class="progress-bar ${todt.clasificacion === 11 ? 'bg-success' : todt.clasificacion === 9 ? 'bg-warning' : 'bg-danger'}" 
                                    role="progressbar" 
                                    style="width: ${todt.clasificacion === 11 ? '100' : todt.clasificacion === 9 ? '50' : '0'}%" 
                                    aria-valuenow="${todt.clasificacion === 11 ? '100' : todt.clasificacion === 9 ? '50' : '0'}" 
                                    aria-valuemin="0" 
                                    aria-valuemax="100">
                                </div>
                            </div>
                            <p class="text-center">${todt.clasificacion === 11 ? '100' : todt.clasificacion === 9 ? '50' : '0'}%</p>                       
                        </div>                                        
                    </div>
                `;

                    // Aquí es donde asignamos la tarea al kanban basado en su estado
                    switch (todt.nom_estado) {
                        case 'proceso':
                            kanban.addElement('b-proceso', {
                                id: todt.idorden_trabajo,
                                title: tareaOdtHTML
                            });
                            break;
                    }
                }
            });
        } else if (idrolusuario == 1) {
            tareasOdt.forEach(todt => {
                const verificarEstadoClasificacion =
                    (todt.nom_estado === "proceso" && (todt.clasificacion === 9 || todt.clasificacion === 11 || todt.clasificacion == null));
                const badgeClasificacion =
                    (todt.clasificacion === 11 && todt.nom_estado === "finalizado")
                        ? `<span class="badge bg-primary">Terminado</span>`
                        : (todt.nom_estado === "finalizado" && (todt.clasificacion === 9 || todt.clasificacion === null))
                            ? `<span class="badge bg-warning">No terminado/Vencido</span>`
                            : '';

                const tareaOdtHTML = `
                        <div class="mb-3">                    
                            <div class="d-flex justify-content-between align-items-center">
                                <h3 class="card-title">${todt.tarea}</h3>
                                
                            </div>
                            <div class="tarea-odt" data-id="${todt.idorden_trabajo}">
                                <div class="d-flex align-items-center mb-3">
                                    <img src="https://www.iconpacks.net/icons/1/free-user-group-icon-296-thumb.png" class="rounded-circle me-2" alt="Responsables" width="40" height="40"/>
                                    <p class="mb-0">${todt.responsables}</p>
                                </div>
                                <p class="text-muted"><strong>Inició el:</strong> ${todt.fecha_inicio}</p>
                                ${todt.revisado_por ? `<p class="text-muted">Revisado por ${todt.revisado_por}</p>` : ''}
                                <p class="text-muted"><strong>Creada por:</strong> ${todt.creador}</p>
                                <p><strong>Activos:</strong> ${todt.activos}</p>
                                <div class="progress mb-2">
                                    <div class="progress-bar ${todt.clasificacion === 11 ? 'bg-success' : todt.clasificacion === 9 ? 'bg-warning' : 'bg-danger'}" 
                                        role="progressbar" 
                                        style="width: ${todt.clasificacion === 11 ? '100' : todt.clasificacion === 9 ? '50' : '0'}%" 
                                        aria-valuenow="${todt.clasificacion === 11 ? '100' : todt.clasificacion === 9 ? '50' : '0'}" 
                                        aria-valuemin="0" 
                                        aria-valuemax="100">
                                    </div>
                                </div>
                                <p class="text-center">${todt.clasificacion === 11 ? '100' : todt.clasificacion === 9 ? '50' : '0'}%</p>                       
                            </div>                                        
                        </div>
                    `;

                // Aquí es donde asignamos la tarea al kanban basado en su estado
                switch (todt.nom_estado) {
                    case 'proceso':
                        kanban.addElement('b-proceso', {
                            id: todt.idorden_trabajo,
                            title: tareaOdtHTML
                        });
                        break;

                    case 'revision':
                        kanban.addElement('b-revision', {
                            id: todt.idorden_trabajo,
                            title: tareaOdtHTML
                        });
                        break;

                    // Aquí puedes añadir más casos si es necesario
                }
            });
        }

        historialOdt.forEach(historial => {
            const verificarEstadoClasificacion =
                (historial.nom_estado === "proceso" && (historial.clasificacion === 9 || historial.clasificacion === 11 || historial.clasificacion == null));
            const badgeClasificacion =
                (historial.clasificacion === 11 && historial.nom_estado === "finalizado")
                    ? `<span class="badge bg-primary">Terminado</span>`
                    : (historial.nom_estado === "finalizado" && (historial.clasificacion === 9 || historial.clasificacion === null))
                        ? `<span class="badge bg-warning">No terminado/Vencido</span>`
                        : '';
            const historialOdtFinalizadas = `
                <div class="mb-3" >                    
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="card-title">${historial.tarea}</h3>
                        ${badgeClasificacion}
                        ${verificarEstadoClasificacion ? `
                            <div class="btn-group dropstart">
                                <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" data-id="dropdown">
                                    ⋮
                                </button>
                                <ul class="dropdown-menu">
                                    ${(historial.nom_estado !== "finalizado" && historial.nom_estado !== "revision" && (historial.clasificacion === 9 || historial.clasificacion == null)) ? `<li class="dropdown-item li-editar" data-id="${historial.idorden_trabajo}" data-tarea-id="${historial.idtarea}">Editar</li>` : ''}
                                    ${(historial.nom_estado === "proceso" && historial.clasificacion === 11) ? `<li class="dropdown-item li-revision" data-id="${historial.idorden_trabajo}">Enviar a revision</li>` : ''}                                                                
                                </ul>
                            </div>
                        ` : ''}
                        
                    </div>
                    <div class="tarea-odt" data-id="${historial.idorden_trabajo}" >
                        <div class="d-flex align-items-center mb-3">
                            <img src="https://www.iconpacks.net/icons/1/free-user-group-icon-296-thumb.png" class="rounded-circle me-2" alt="Responsables" width="40" height="40"/>
                            <p class="mb-0">${historial.responsables}</p>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="text-muted"><small>Inció el: ${historial.fecha_inicio}</small></p>
                            </div>                                                           
                            <div class="col-md-6">
                                <p class="text-muted"><small>Finalizó el: ${historial.fecha_final}</small></p>
                            </div>
                        </div>
                        ${historial.revisado_por ? `<p class="text-muted"><strong>Revisado por</strong> ${historial.revisado_por}</p>` : ''}
                        <p class="text-muted"><strong>Creada por </strong> ${historial.creador}</p>
                        <p><strong>Activos:</strong> ${historial.activos}</p>
                        <div class="progress mb-2">
                            <div class="progress-bar ${historial.clasificacion === 11 ? 'bg-success' : historial.clasificacion === 9 ? 'bg-warning' : 'bg-danger'}" 
                                role="progressbar" 
                                style="width: ${historial.clasificacion === 11 ? '100' : historial.clasificacion === 9 ? '50' : '0'}%" 
                                aria-valuenow="${historial.clasificacion === 11 ? '100' : historial.clasificacion === 9 ? '50' : '0'}" 
                                aria-valuemin="0" 
                                aria-valuemax="100">
                            </div>
                        </div>
                        <p class="text-center">${historial.clasificacion === 11 ? '100' : historial.clasificacion === 9 ? '50' : '0'}%</p>                       
                    </div>                                        
                </div>
            `

            if (historial.nom_estado == "finalizado") {
                kanban.addElement('b-finalizado', {
                    id: historial.idorden_trabajo,
                    title: historialOdtFinalizadas
                })
            }
        })

        //ESTO FUNCIONA PARA PODER ENTRAR A REALIZAR LA ORDEN UNA VEZ CREADA - SOLO PUEDEN INGRESAR USUARIOS
        $all('.tarea-odt').forEach(kanbanItem => {
            kanbanItem.addEventListener('click', async function (event) {

                const cardId = kanbanItem.getAttribute('data-id'); // Obtener el ID de la tarjeta
                console.log('Hiciste clic en la tarjeta con ID: ' + cardId);
                const targetElement = event.target; // El elemento donde ocurrió el clic
                console.log("targetElement: ", targetElement);

                const tareasOdt = await obtenerTareasOdt(); // Llama a la función para obtener tareas
                console.log("tareasOdt: ", tareasOdt);
                const tareaOdtSeleccionada = tareasOdt.find(t => t.idorden_trabajo == cardId);
                console.log("Tarea odt seleccionada: ", tareaOdtSeleccionada);

                if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "proceso") {
                    if (idrolusuario == 2) { //ESTE ROL ES DE USUARio
                        if (tareaOdtSeleccionada.incompleto === 1) {
                            alert("LA TAREA ODT ESTA INCOMPLETA NO PUEDES TRABAJARLA");
                        } else if (tareaOdtSeleccionada.incompleto === 0) {
                            // Redirigir solo si la tarea está en proceso y completa
                            window.localStorage.clear();
                            window.localStorage.setItem('idodt', tareaOdtSeleccionada.idorden_trabajo);
                            window.localStorage.setItem('idtarea', tareaOdtSeleccionada.idtarea)
                            window.location.href = `http://localhost/CMMS/views/odt/orden.php`;
                        }
                    } else {
                        showToast(`Solo usuarios pueden realizar la orden de trabajo.`, 'ERROR', 6000);
                        return
                    }
                } else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "revision") {
                    if (idrolusuario == 1) {
                        window.localStorage.clear();
                        window.localStorage.setItem("idodt", tareaOdtSeleccionada.idorden_trabajo);
                        window.localStorage.setItem('idtarea', tareaOdtSeleccionada.idtarea)
                        const actualizado = await actualizarEstadoOdt(10, tareaOdtSeleccionada.idorden_trabajo);
                        console.log("actualizado ODT A REVISION?: ", actualizado);
                        window.location.href = `http://localhost/CMMS/views/odt/revisar-odt.php`;
                    }
                    else {
                        showToast(`Solo administradores pueden revisar la orden de trabajo.`, 'ERROR', 6000);
                        return
                    }
                } else {
                    // No redirigir si la tarea no está en proceso
                    alert("Solo las tareas en proceso pueden ser redirigidas.");
                }

            });
        });


        $all(".li-editar").forEach(li => {
            li.addEventListener("click", async () => {
                if (idrolusuario == 1) { //ESTE ROL ES DE ADMINSITRACDOR
                    const liEditar = li.getAttribute('data-id')
                    const tareaId = li.getAttribute('data-tarea-id');
                    console.log("lioEditar: ", liEditar)
                    window.localStorage.clear();
                    window.localStorage.setItem('idodt', liEditar);
                    window.localStorage.setItem('idtarea', tareaId);
                    window.location.href = `http://localhost/CMMS/views/odt/registrar-odt.php`
                } else {
                    showToast(`Solo administradores pueden editar la orden de trabajo.`, 'ERROR', 6000);
                    return
                }
            })
        })

        $all(".li-revision").forEach(li => {
            li.addEventListener("click", async () => {
                if (idrolusuario == 2) {
                    const liRevision = li.getAttribute('data-id');
                    console.log("liRevisionIDDATA: ", liRevision);

                    // Llama a la función para obtener tareas y encuentra la tarea seleccionada
                    const tareasOdt = await obtenerTareasOdt();
                    console.log("tareasOdt: ", tareasOdt);
                    const tareaOdtSeleccionada = tareasOdt.find(t => t.idorden_trabajo == liRevision);
                    console.log("Tarea ODT seleccionada para revisión: ", tareaOdtSeleccionada);

                    if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "proceso") {
                        if (tareaOdtSeleccionada.clasificacion == null || tareaOdtSeleccionada.clasificacion == 9) {
                            alert("ESTA ODT NO PUEDE SER REVISADA PORQUE NO ESTÁ AL 100%");
                        } else {
                            window.localStorage.clear();
                            window.localStorage.setItem('idodt', liRevision);
                            const actualizado = await actualizarEstadoOdt(10, liRevision); // liRevision = idodt
                            console.log("Actualizado ODT a revisión?: ", actualizado);
                            //window.location.href = `http://localhost/CMMS/views/odt/revisar-odt.php`;
                            showToast(`La orden de trabajo ha sido completada y enviada para revisión por un administrador.`, 'SUCCESS', 3000);
                            return
                        }
                    } else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "pendientes") {
                        alert("Esta orden está en pendientes, primero procésala.");
                    } else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "revision") {
                        alert("Esta orden ya está en revisión, no puedes redirigir.");
                    } else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "finalizado") {
                        alert("Esta orden ya está finalizada, no puedes redirigir.");
                    } else {
                        alert("Estado de la tarea no válido para la revisión.");
                    }
                } else {
                    showToast(`Solo usuarios pueden mandar a revisar la orden de trabajo.`, 'ERROR', 6000);
                    return
                }
            })
        })

        return tareas
    }
    //**************************** FIN DE SECCION DE RENDERIZADO DE DATOS *********************** */

    // ***************************** SECCION DE REGISTROS ************************************
    async function registrarOdt(idtarea, fechainicio, horainicio) {
        const formOdt = new FormData()
        formOdt.append("operation", "add")
        formOdt.append("idtarea", idtarea)
        formOdt.append("creado_por", idusuario)
        formOdt.append("fecha_inicio", fechainicio)
        formOdt.append("hora_inicio", horainicio)
        //formOdt.append("fecha_vencimiento", null)
        //formOdt.append("hora_vencimiento", null)
        const dataOdt = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formOdt })
        const idodt = await dataOdt.json()
        return idodt
    }

    async function registrarResponsablesAsignados(idresponsable, idodt) {
        console.log("ID ODT A ASIGNARLE: ", window.localStorage.getItem("idodt"))
        const formResponsableAsignado = new FormData()
        formResponsableAsignado.append("operation", "asignarResponsables")
        formResponsableAsignado.append("idordentrabajo", idodt)
        formResponsableAsignado.append("idresponsable", idresponsable)
        const fresponsableId = await fetch(`${host}responsablesAsignados.controller.php`, { method: 'POST', body: formResponsableAsignado })
        const responsableId = await fresponsableId.json()
        return responsableId
    }

    // ******************************* FIN DE SECCION DE REGISTROS ****************************

    // ********************* SECCION DE ACTUALIZAR ******************************************
    async function actualizarTareaEstado(idtarea, estado) {
        const formActualizacion = new FormData()
        formActualizacion.append("operation", "actualizarTareaEstado")
        formActualizacion.append("idtarea", idtarea)
        formActualizacion.append("idestado", estado)
        formActualizacion.append("trabajado", 1)
        const Factualizado = await fetch(`${host}tarea.controller.php`, { method: 'POST', body: formActualizacion })
        const actualizado = await Factualizado.json()
        return actualizado
    }

    async function actualizarEstadoOdt(idestado, idodt) {
        const formActualizacionEstadoOdt = new FormData()
        formActualizacionEstadoOdt.append("operation", "actualizarEstadoOdt")
        formActualizacionEstadoOdt.append("idodt", idodt)
        formActualizacionEstadoOdt.append("idestado", idestado)
        const Factualizado = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formActualizacionEstadoOdt })
        const actualizado = await Factualizado.json()
        return actualizado
    }

    async function actualizarEstadoActivo(idactivo, idestado) {
        const formActualizacion = new FormData()
        formActualizacion.append("operation", "updateEstado")
        formActualizacion.append("idactivo", idactivo)
        formActualizacion.append("idestado", idestado)
        const Factualizado = await fetch(`${host}activo.controller.php`, { method: 'POST', body: formActualizacion })
        const actualizado = await Factualizado.json()
        return actualizado
    }


    //************************ FIN DE SECCION DE ACTUALIZAR ******************************** */

    // ********************************* SECCION DE VERIFICACIONES ********************************************
    async function verificarTerminadoOdt() {
        const odt = await obtenerTareasOdt();
        console.log("VERIFICANDO ODT: ", odt);

        // Obtener la fecha y hora actual en horario de Lima
        //let ahora = new Date().toLocaleString("en-US", { timeZone: "America/Lima" });
        //let fechaHoraHoy = new Date(ahora);

        /* for (let i = 0; i < odt.length; i++) {
            // Si la fecha y hora de vencimiento existen
            if (odt[i].fecha_vencimiento && odt[i].hora_vencimiento) {
                // Crear un objeto Date combinando la fecha y la hora de vencimiento
                let fechaHoraVencimiento = new Date(`${odt[i].fecha_vencimiento}T${odt[i].hora_vencimiento}-05:00`);

                // Comparar la fecha y hora de vencimiento con la fecha y hora actuales
                if (fechaHoraVencimiento < fechaHoraHoy) {
                    console.log(`La ODT con id ${odt[i].idorden_trabajo} ha sido vencida.`);
                    const odtActualizado = await actualizarEstadoOdt(11, odt[i].idorden_trabajo)
                    console.log("odtactualizado?: ", odtActualizado)
                } else {
                    console.log(`La ODT con id ${odt[i].idorden_trabajo} aún está vigente.`);
                }
            } else {
                console.log(`La ODT con id ${odt[i].idorden_trabajo} no tiene fecha o hora de vencimiento completa.`);
            }
        } */
    }

    async function verificarRolUsuario() {
        const usuario = await obtenerUsuario()
        console.log("usuario: ", usuario)
        idrolusuario = usuario[0].idrol
    }
    // ******************************* FIN SECCION DE VERIFICACIONES ******************************************
})