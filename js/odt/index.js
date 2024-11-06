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
    let redirigir = false
    const host = "http://localhost/CMMS/controllers/";
    await verificarRolUsuario()
    await verificarTerminadoOdt()
    await obtenerHistorialOdt()
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
                                const idOdt = await registrarOdt(cardId, fechaInicioTarea, horaInicioTarea);
                                console.log(idOdt);
                                window.localStorage.clear()
                                window.localStorage.setItem("idtarea", cardId);
                                window.localStorage.setItem("idodt", idOdt.id);
                                const actualizado = await actualizarTareaEstado(cardId, 9)
                                console.log("actualizado?: ", actualizado)
                                console.log("redirigiendo ....")
                                window.location.href = `http://localhost/CMMS/views/odt/registrar-odt.php`;
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
                                showToast(`La orden de trabajo ha sido completada y enviada para revisión por un administrador.`, 'ERROR', 6000);
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

    // ************************** SECCION DE RENDERIZADO DE DATOS E INTERFAZ ********************
    await renderTareasPendiente()

    async function renderTareasPendiente() {
        const tareas = await obtenerTareas() //PENDIENTES
        const tareasOdt = await obtenerTareasOdt() //EN PROCESO
        const historialOdt = await obtenerHistorialOdt() //FINALIZADAS
        tareas.forEach(tarea => {
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
                <p><strong>Activos: </strong>${tarea.activos}</p>
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

                <div class="mb-3" >                    
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="card-title">${todt.tarea}</h3>
                        ${badgeClasificacion}
                        ${verificarEstadoClasificacion ? `
                            <div class="btn-group dropstart">
                                <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" data-id="dropdown">
                                    ⋮
                                </button>
                                <ul class="dropdown-menu">
                                    ${(todt.nom_estado !== "finalizado" && todt.nom_estado !== "revision" && (todt.clasificacion === 9 || todt.clasificacion == null)) ? `<li class="dropdown-item li-editar" data-id="${todt.idorden_trabajo}" data-tarea-id="${todt.idtarea}">Editar</li>` : ''}
                                    ${(todt.nom_estado === "proceso" && todt.clasificacion === 11) ? `<li class="dropdown-item li-revision" data-id="${todt.idorden_trabajo}">Enviar a revision</li>` : ''}                                                                
                                </ul>
                            </div>
                        ` : ''}
                        
                    </div>
                    <div class="tarea-odt" data-id="${todt.idorden_trabajo}" >
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
            `

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
                    })
                    break;

                // QUITADO FINALIZADO
            }
        })

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
                if (idrolusuario == 2) { //ESTE ROL ES DE USUARio
                    const cardId = kanbanItem.getAttribute('data-id'); // Obtener el ID de la tarjeta
                    console.log('Hiciste clic en la tarjeta con ID: ' + cardId);
                    const targetElement = event.target; // El elemento donde ocurrió el clic
                    console.log("targetElement: ", targetElement);

                    const tareasOdt = await obtenerTareasOdt(); // Llama a la función para obtener tareas
                    console.log("tareasOdt: ", tareasOdt);
                    const tareaOdtSeleccionada = tareasOdt.find(t => t.idorden_trabajo == cardId);
                    console.log("Tarea odt seleccionada: ", tareaOdtSeleccionada);

                    if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "proceso") {
                        if (tareaOdtSeleccionada.incompleto === 1) {
                            alert("LA TAREA ODT ESTA INCOMPLETA NO PUEDES TRABAJARLA");
                        } else if (tareaOdtSeleccionada.incompleto === 0) {
                            // Redirigir solo si la tarea está en proceso y completa
                            window.localStorage.clear();
                            window.localStorage.setItem('idodt', tareaOdtSeleccionada.idorden_trabajo);
                            window.localStorage.setItem('idtarea', tareaOdtSeleccionada.idtarea)
                            window.location.href = `http://localhost/CMMS/views/odt/orden.php`;
                        }
                    } else if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "revision") {
                        window.localStorage.clear();
                        window.localStorage.setItem("idodt", tareaOdtSeleccionada.idorden_trabajo);
                        window.localStorage.setItem('idtarea', tareaOdtSeleccionada.idtarea)
                        const actualizado = await actualizarEstadoOdt(10, tareaOdtSeleccionada.idorden_trabajo);
                        console.log("actualizado ODT A REVISION?: ", actualizado);
                        window.location.href = `http://localhost/CMMS/views/odt/revisar-odt.php`;
                    } else {
                        // No redirigir si la tarea no está en proceso
                        alert("Solo las tareas en proceso pueden ser redirigidas.");
                    }
                } else {
                    showToast(`Solo usuarios pueden realizar la orden de trabajo.`, 'ERROR', 6000);
                    return
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
                            window.location.href = `http://localhost/CMMS/views/odt/revisar-odt.php`;
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