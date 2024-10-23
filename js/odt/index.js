$(document).ready(async () => {
    //alert("idusuarioxdd: " + idusuario)
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
    let redirigir = false
    const host = "http://localhost/CMMS/controllers/";
    // **************************** SECCION DE OBTENER DATOS ****************************************************
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
        paramsTareasOdtListar.append("borrador", 0)
        const tareasOdt = await getDatos(`${host}ordentrabajo.controller.php`, paramsTareasOdtListar)
        console.log("TAREAS ODT: ", tareasOdt)
        return tareasOdt;
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
                id: 'b-finalizadas',
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
            const tareaOdtSeleccionada = tareasOdt.find(t => t.idtarea == cardId);

            // AGREGAR VALIDACIÓN PARA VERIFICAR SI LA TAREA EXISTE
            if (!tareaSeleccionada && !tareaOdtSeleccionada) {
                console.error("Tarea no encontrada.");
                return; // SALIR SI NINGUNA TAREA COINCIDE
            }

            // VALIDAR ESTADOS
            switch (targetBoardId) {
                case "b-proceso":
                    const idOdt = await registrarOdt(cardId);
                    console.log(idOdt);
                    window.localStorage.setItem("idtarea", cardId);
                    window.localStorage.setItem("idodt", idOdt.id);
                    // VALIDAR SI tareaOdtSeleccionada EXISTE Y SU ESTADO
                    if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "proceso") {
                        alert("Esta tarea ya está en proceso, no se puede redirigir");
                    } else if (tareaSeleccionada && tareaSeleccionada.nom_estado === "pendiente") {
                        // SI LA TAREA ESTÁ EN PENDIENTE, REDIRIGIR
                        const actualizado = await actualizarTareaEstado(cardId, 9)
                        console.log("actualizado?: ", actualizado)
                        console.log("redirigiendo ....")
                        window.location.href = `http://localhost/CMMS/views/odt/registrar-odt.php`;
                    }
                    break;
            }
        }

    });

    // ************************** SECCION DE RENDERIZADO DE DATOS E INTERFAZ ********************
    await renderTareasPendiente()

    async function renderTareasPendiente() {
        const tareas = await obtenerTareas() //PENDIENTES
        const tareasOdt = await obtenerTareasOdt() //EN PROCESO
        tareas.forEach(tarea => {
            const tareaHTML = `
                <h3 class="card-title">${tarea.descripcion}</h3>
                <p class=" mb-2 text-muted">Inicia: ${tarea.fecha_inicio} - Vence: ${tarea.fecha_vencimiento}</p>                 
                <p class="card-text">Plan de tarea: ${tarea.plantarea}</p>
                <p class="card-text">Activo: ${tarea.activo}</p>
                <p class="card-text"><small class="text-muted">Prioridad: ${tarea.prioridad}</small></p>
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
            const tareaOdtHTML = `             
                <div class="mb-3" >                    
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="card-title">${todt.tarea}</h3>
                        <div class="btn-group dropstart">
                            <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" data-id="dropdown">
                                ⋮
                            </button>
                            <ul class="dropdown-menu">
                                <li class="dropdown-item li-editar" data-id="${todt.idorden_trabajo}">Editar</li>
                                <li class="dropdown-item li-eliminar">Eliminar</li>                                
                            </ul>
                        </div>
                    </div>
                    <div class="tarea-odt" data-id="${todt.idorden_trabajo}">
                        <div class="d-flex align-items-center mb-3">
                            <img src="https://www.iconpacks.net/icons/1/free-user-group-icon-296-thumb.png" class="rounded-circle me-2" alt="Responsables" width="40" height="40"/>
                            <p class="mb-0">${todt.responsables}</p>
                        </div>
                        <p class="text-muted">Creada por ${todt.creador}</p>
                        <p><strong>Activo:</strong> ${todt.activo}</p>
                        <div class="progress mb-2">
                            <div class="progress-bar ${todt.clasificacion === 'finalizado' ? 'bg-success' : todt.clasificacion === 'iniciado' ? 'bg-warning' : 'bg-danger'}" 
                                role="progressbar" 
                                style="width: ${todt.clasificacion === 'finalizado' ? '100' : todt.clasificacion === 'iniciado' ? '50' : '0'}%" 
                                aria-valuenow="${todt.clasificacion === 'finalizado' ? '100' : todt.clasificacion === 'iniciado' ? '50' : '0'}" 
                                aria-valuemin="0" 
                                aria-valuemax="100">
                            </div>
                        </div>
                        <p class="text-center">${todt.clasificacion === 'finalizado' ? '100' : todt.clasificacion === 'iniciado' ? '50' : '0'}%</p>                       
                    </div>                                        
                </div>
            `
            switch (todt.nom_estado) {
                case 'proceso':
                    kanban.addElement('b-proceso', {
                        id: todt.idtarea,
                        title: tareaOdtHTML
                    });
                    break;
            }
        })

        $all('.tarea-odt').forEach(kanbanItem => {
            kanbanItem.addEventListener('click', async function (event) {
                const cardId = kanbanItem.getAttribute('data-id'); // Obtener el ID de la tarjeta
                console.log('Hiciste clic en la tarjeta con ID: ' + cardId);
                const targetElement = event.target; // El elemento donde ocurrió el clic
                console.log("targetElement: ", targetElement)

                const tareasOdt = await obtenerTareasOdt(); // Llama a la función para obtener tareas
                console.log("tareasOdt: ", tareasOdt)
                const tareaOdtSeleccionada = tareasOdt.find(t => t.idorden_trabajo == cardId);
                console.log("Tarea seleccionada: ", tareaOdtSeleccionada);

                if (tareaOdtSeleccionada && tareaOdtSeleccionada.nom_estado === "proceso") {
                    // Redirigir solo si la tarea está en proceso
                    window.localStorage.clear();
                    window.localStorage.setItem('idodt', tareaOdtSeleccionada.idorden_trabajo);
                    window.location.href = `http://localhost/CMMS/views/odt/orden.php`;
                } else {
                    // No redirigir si la tarea no está en proceso
                    alert("Solo las tareas en proceso pueden ser redirigidas.");
                }
            });
        });

        $all(".li-editar").forEach(li => {
            li.addEventListener("click", async ()=>{
                const liEditar = li.getAttribute('data-id')
                console.log("lioEditar: ", liEditar)
                window.localStorage.clear();
                window.localStorage.setItem('idodt', liEditar);
                window.location.href = `http://localhost/CMMS/views/odt/registrar-odt.php`
            })
        })

        return tareas
    }
    //**************************** FIN DE SECCION DE RENDERIZADO DE DATOS *********************** */

    // ***************************** SECCION DE REGISTROS ************************************
    async function registrarOdt(idtarea) {
        const formOdt = new FormData()
        formOdt.append("operation", "add")
        formOdt.append("idtarea", idtarea)
        formOdt.append("creado_por", idusuario)
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
        const Factualizado = await fetch(`${host}tarea.controller.php`, { method: 'POST', body: formActualizacion })
        const actualizado = await Factualizado.json()
        return actualizado
    }

    //************************ FIN DE SECCION DE ACTUALIZAR ******************************** */
})