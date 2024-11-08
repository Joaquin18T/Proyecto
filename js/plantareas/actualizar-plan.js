$(document).ready(async () => {
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

    const host = "http://localhost/CMMS/controllers/";
    let tbActivos = null
    let idplantarea_generado = window.localStorage.getItem('idplantarea');
    let idtarea_generado = -1;
    let idcategoria_generado = -1
    const btnGuardarPlanTarea = $q("#btnGuardarPlanTarea");
    const filters = $all(".filter")
    let habilitarBeforeUnload = true
    //FORMULARIo
    const formtarea = $q("#form-tarea")
    //TABLAS
    const activosList = $q("#activosBodyTable");
    //UL
    const listaActivosAsignados = $q(".listaActivosAsignados")
    const ulTareasAgregadas = $q(".listaTareasAgregadas");
    // LISTAS
    let activosElegidos = []
    //SELECT - Tarea
    const selectSubCategoriaTarea = $q("#elegirSubCategoriaTarea")
    //SELECTS
    const selectElegirTareaParaActivo = $q("#elegirTareaParaActivo");
    const selectSubCategoria = $q("#elegirSubCategoria")
    const selectUbicacion = $q("#elegirUbicacion")
    //BOTONES
    const btnAgregarActivos = $q("#btnAgregarActivos")
    const btnTerminarPlan = $q("#btnTerminarPlan")
    const btnGuardarTarea = $q("#btnGuardarTarea")
    const btnsTareaAcciones = $q("#btnsTareaAcciones") // esto en realidad es un div pero guardara botones

    //variables que son traidas al renderizr el plan
    let incompleto = -1


    await renderDescripcionPlan()
    await obtenerTareas()
    //await filtrarActivosList()
    await obtenerActivosVinculados()
    await renderPrioridades()
    await renderFrecuencias()
    habilitarCamposTarea(false);
    btnTerminarPlan.disabled = false

    //RENDERIZAR DATOS A INTERFAZ OBTENIDAS
    await renderTareas()
    await renderAvt()

    function habilitarCamposTarea(habilitado = true) {
        $q("#txtDescripcionTarea").disabled = habilitado
        /* $q("#fecha-inicio").disabled = habilitado
        $q("#fecha-vencimiento").disabled = habilitado
        $q("#txtIntervaloTarea").disabled = habilitado
        $q("#txtFrecuenciaTarea").disabled = habilitado */
        $q("#elegirSubCategoriaTarea").disabled = habilitado
        $q("#txtIntervaloTarea").disabled = habilitado
        $q("#selectFrecuenciaTarea").disabled = habilitado
        $q("#tipoPrioridadTarea").disabled = habilitado
        //$q("#txtDescripcionPlanTarea").disabled = !habilitado
        //$q("#btnGuardarPlanTarea").remove()
        $q("#btnGuardarTarea").disabled = habilitado
    }

    function habilitarCamposActivo(habilitado = true) {
        selectElegirTareaParaActivo.disabled = habilitado
        //selectSubCategoria.disabled = habilitado
        selectUbicacion.disabled = habilitado
        btnAgregarActivos.disabled = habilitado
    }


    async function renderDescripcionPlan() {
        const params = new URLSearchParams()
        params.append("operation", "obtenerPlanTareaPorId")
        params.append("idplantarea", idplantarea_generado)
        const planTarea = await getDatos(`${host}plandetarea.controller.php`, params)
        console.log("plan de tarea obtenido: ", planTarea)
        incompleto = planTarea[0].incompleto
        idcategoria_generado = planTarea[0].idcategoria
        $q("#txtDescripcionPlanTarea").value = planTarea[0].descripcion
    }


    async function renderTareasSelect() { // ESTO RENDERIZARA LAS TAREAS EN EL SELECT
        const params = new URLSearchParams()
        params.append("operation", "obtenerTareasPorPlanTarea")
        params.append("idplantarea", idplantarea_generado)
        const data = await getDatos(`${host}tarea.controller.php`, params)

        console.log("tareas obtenidas recien creadas: ", data)
        console.log("idplantarea_generado: ", idplantarea_generado)
        selectElegirTareaParaActivo.innerHTML =
            "<option value='-1'>Seleccione una tarea</option>"; // Opción predeterminada

        for (let i = 0; i < data.length; i++) {
            selectElegirTareaParaActivo.innerHTML += `
                <option value="${data[i].idtarea}">${data[i].descripcion}</option>
            `;
        }
    }

    function renderTablaActivos() {
        if (tbActivos) {
            tbActivos.clear().rows.add($(activosList).find('tr')).draw();
        } else {
            // Inicializa DataTable si no ha sido inicializado antes
            tbActivos = $('#tablaActivos').DataTable({
                paging: true,
                searching: false,
                lengthMenu: [10, 25, 50, 100],
                pageLength: 10,
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
        }
    }

    async function renderUbicacion() {
        const data = await getDatos(`${host}ubicacion.controller.php`, `operation=getAll`)
        selectUbicacion.innerHTML = `<option selected value="-1">Ubicacion</option>`
        for (let i = 0; i < data.length; i++) {
            selectUbicacion.innerHTML += `
                <option value="${data[i].idubicacion}">${data[i].ubicacion}</option>
              `;
        }
    }

    async function renderSubCategorias(idcategoria) {
        const subcategorias = await obtenerSubCategoriaPorCategoria(idcategoria)

        //const data = await getDatos(`${host}subcategoria.controller.php`, `operation=getSubCategoria`)

        //selectSubCategoria.innerHTML = `<option selected value="-1">Sub Categoria</option>`
        selectSubCategoriaTarea.innerHTML = `<option selected value="-1">Sub Categoria</option>`
        for (let i = 0; i < subcategorias.length; i++) {
            //selectSubCategoria.innerHTML += `
            //    <option value="${data[i].idsubcategoria}">${data[i].subcategoria}</option>
            //  `;
            selectSubCategoriaTarea.innerHTML += `
            <option value="${subcategorias[i].idsubcategoria}">${subcategorias[i].subcategoria}</option>
            `
        }
    }

    async function renderPrioridades() {
        const data = await getDatos(`${host}tipoprioridad.controller.php`, `operation=getAll`)
        //selects de prioridades
        const selectPrioridades = $q("#tipoPrioridadTarea");
        selectPrioridades.innerHTML += `<option selected>Tipo de prioridad</option>`
        for (let i = 0; i < data.length; i++) {
            selectPrioridades.innerHTML += `
                <option value="${data[i].idtipo_prioridad}">${data[i].tipo_prioridad}</option>
              `;
        }
    }

    async function renderFrecuencias() {
        const frecuencia = await obtenerFrecuencias()
        //selects de prioridades
        const selectFrecuenciaTarea = $q("#selectFrecuenciaTarea");
        selectFrecuenciaTarea.innerHTML += `<option selected>Frecuencia</option>`
        for (let i = 0; i < frecuencia.length; i++) {
            selectFrecuenciaTarea.innerHTML += `
                <option value="${frecuencia[i].idfrecuencia}">${frecuencia[i].frecuencia}</option>
              `;
        }
    }

    async function agregarTareas() {
        const descripcionTarea = $q("#txtDescripcionTarea");
        const intervaloTarea = $q("#txtIntervaloTarea");
        const frecuenciaTarea = $q("#selectFrecuenciaTarea")
        /* const intervaloTarea = $q("#txtIntervaloTarea");
        const frecuenciaTarea = $q("#txtFrecuenciaTarea");
        const fechaInicioTarea = $q("#fecha-inicio");
        const fechaVencimiento = $q("#fecha-vencimiento"); */
        const subCategoriaTarea = $q("#elegirSubCategoriaTarea")


        let formTarea = new FormData();
        formTarea.append("operation", "add")
        formTarea.append("idplantarea", idplantarea_generado);
        formTarea.append("idtipo_prioridad", tipoPrioridadTarea.value);
        formTarea.append("descripcion", descripcionTarea.value);
        formTarea.append("idsubcategoria", subCategoriaTarea.value)
        formTarea.append("intervalo", intervaloTarea.value);
        formTarea.append("idfrecuencia", frecuenciaTarea.value);
        /* formTarea.append("fecha_inicio", fechaInicioTarea.value);
        formTarea.append("fecha_vencimiento", fechaVencimiento.value);
        formTarea.append("cant_intervalo", intervaloTarea.value);
        formTarea.append("frecuencia", frecuenciaTarea.value); */
        formTarea.append("idestado", 8);
        //console.log("agregar tareas idplantarea: ", idplantarea_generado)
        const data = await fetch(`${host}tarea.controller.php`, { method: 'POST', body: formTarea })
        return data;
    }

     async function filtrarActivosList() {
        const tarea = await obtenerTareaPorId(selectElegirTareaParaActivo?.value.trim())
        //console.log("selectElegirTareaParaActivo?.value: ", selectElegirTareaParaActivo?.value)
        console.log("tarea obtenida con filter: ", tarea)
        const params = new URLSearchParams()
        params.append("operation", "filtrarActivosResponsablesAsignados")
        params.append("idsubcategoria", (tarea[0]?.idsubcategoria === "" || tarea[0]?.idsubcategoria == -1) ? "" : tarea[0]?.idsubcategoria) //
        params.append("idubicacion", (selectUbicacion.value.trim() === "" || selectUbicacion.value == -1) ? "" : selectUbicacion.value) //
        params.append("cod_identificacion", "")

        const data = await getDatos(`${host}respActivo.controller.php`, params)
        activosList.innerHTML = "";
        console.log("activos fitlrados", data);
        for (let i = 0; i < data.length; i++) {
            activosList.innerHTML += `
            <tr>
                <th scope="row">
                    <input type="checkbox" class="activo-checkbox" data-descact="${data[i].descripcion}" data-idactivo="${data[i].idactivo}" data-idactivoresp="${data[i].idactivo_resp}">
                </th>
                <td>${data[i].descripcion}</td>
                <td>${data[i].marca}</td>
                <td>${data[i].modelo}</td>
            </tr>
            `;
        }

        renderTablaActivos()

        const chkActivo = $all(".activo-checkbox")
        chkActivo.forEach(chk => {
            const idActivoRespCheckbox = parseInt(chk.getAttribute("data-idactivoresp"));
            const idActivoCheckbox = parseInt(chk.getAttribute("data-idactivo"));
            const descripcionActivoCheckbox = chk.getAttribute("data-descact");

            const activoEncontrado = activosElegidos.find(activo => activo.idactivo === idActivoCheckbox);
            if (activoEncontrado) {
                chk.checked = true;
            }

            chk.addEventListener("change", () => {
                console.log("activos seleccionados despues de cambiar el filtro: ", activosElegidos)


                if (chk.checked) {
                    const found = activosElegidos.find(activo => activo.idactivo === idActivoCheckbox);
                    if (!found) {
                        activosElegidos.push({
                            idact_resp: idActivoRespCheckbox,
                            idactivo: idActivoCheckbox,
                            descripcion: descripcionActivoCheckbox,
                            idtarea: parseInt(selectElegirTareaParaActivo.value)
                        });
                    }

                } else {
                    // Si está desmarcado
                    activosElegidos = activosElegidos.filter(activo => activo.idactivo !== idActivoCheckbox);
                }

                console.log(activosElegidos);
            })
        })

    } 

    // ****************** SECCION DE RENDERIZAR DATOS CUANDO SE QUIERA ACTUALIAR *****************************
    async function renderUItareas() {
        const tareas = await obtenerTareas()
        ulTareasAgregadas.innerHTML = ""
        for (let k = 0; k < tareas.length; k++) {
            ulTareasAgregadas.innerHTML += `
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-3">
                        <p class="tarea-agregada mb-0" data-tarea-id="${tareas[k]?.idtarea}">
                            ${tareas[k]?.descripcion} - Tarea: ${tareas[k]?.idtarea} - estado: ${tareas[k].nom_estado}
                        </p>
                        <div class="d-flex gap-2">
                            <span class="badge bg-primary rounded-pill btn-eliminar-tarea d-flex align-items-center justify-content-center" 
                                data-tarea-id="${tareas[k]?.idtarea}" style="cursor: pointer;">
                                <i class="fa-solid fa-trash"></i>
                            </span>
                            <span class="badge bg-primary rounded-pill btn-pausar-tarea d-flex align-items-center justify-content-center" 
                                data-tarea-id="${tareas[k]?.idtarea}" style="cursor: pointer;">
                                ${tareas[k].pausado == 1 ? `<i class="fa-solid fa-play"></i>` : `<i class="fa-solid fa-pause"></i>`}                            

                            </span>
                        </div>
                    </li>

              `;
        }
    }
    async function renderTareas() {
        let sintareas = false;
        const formtarea = $q("#form-tarea");
        await renderUItareas();

        formtarea.reset();
        habilitarCamposActivo(false);
        await renderTareasSelect();
        await renderSubCategorias(idcategoria_generado);
        await renderUbicacion();

        const tareasObtenidasAntesDeEliminar = await obtenerTareas();

        // Asignar eventos iniciales
        asignarEventosTareas();

        async function asignarEventosTareas() {
            const liTareaAgregada = $all(".tarea-agregada");
            const btnsEliminarTarea = $all(".btn-eliminar-tarea");
            const btnsPausarTarea = $all(".btn-pausar-tarea");

            btnsEliminarTarea.forEach(btn => {
                btn.addEventListener("click", async () => {
                    const idTarea = parseInt(btn.getAttribute("data-tarea-id"));
                    let procesoEncontrado = false;

                    for (let w = 0; w < tareasObtenidasAntesDeEliminar.length; w++) {
                        if (tareasObtenidasAntesDeEliminar[w].idtarea === idTarea) {
                            if (tareasObtenidasAntesDeEliminar[w].nom_estado === "proceso" || tareasObtenidasAntesDeEliminar[w].trabajado === 1) {
                                alert("ESTA TAREA NO SE PUEDE ELIMINAR.");
                                procesoEncontrado = true;
                                break;
                            }
                        }
                    }

                    if (!procesoEncontrado) {
                        const li = btn.closest("li");
                        li.remove();

                        const formEliminacionTarea = new FormData();
                        formEliminacionTarea.append("operation", "eliminarTarea");
                        const eliminado = await fetch(`${host}tarea.controller.php/${idTarea}`, { method: 'POST', body: formEliminacionTarea });
                        const elim = await eliminado.json()
                        console.log("eliminado?: ", elim.eliminado)

                        const tareasRegistradasObtenidas = await obtenerTareas()
                        const avtObtenidas = await obtenerActivosVinculados()
                        console.log("tareasRegistradasObtenidas: ", await tareasRegistradasObtenidas) // me quede aca
                        console.log("avt data hasta el momento: ", avtObtenidas)
                        //ELIMINAR CONTENIDO DE LAS CAJAS DE TEXTO
                        formtarea.reset()

                        if (elim.eliminado) {
                            if (tareasRegistradasObtenidas.length == 0 && avtObtenidas.length == 0) {
                                console.log("ya no hay tareas");
                                habilitarCamposActivo(true)
                            }
                        }

                        await renderUItareas();
                        await renderTareasSelect()
                        asignarEventosTareas(); // Reasignar eventos después de renderizar
                        
                        sintareas = true
                        return
                    }
                });
            });

            btnsPausarTarea.forEach(btn => {
                btn.addEventListener("click", async () => {
                    const idtarea = btn.getAttribute("data-tarea-id");
                    const tareaObtenida = await obtenerTareaPorId(idtarea);

                    if (tareaObtenida[0].idestado !== 9) { //PAUSAR LA TAREA CUANDO SEA DE TODO MENOS EN PROCESO
                        await actualizarTareaEstadoPausado(idtarea, tareaObtenida[0].pausado === 0 ? 1 : 0);
                        await renderUItareas();
                        asignarEventosTareas(); // Reasignar eventos después de renderizar
                    } else {
                        showToast("No puedes pausar esta tarea porque se encuentra en proceso.", "ERROR", 6000);
                    }
                });
            });

            liTareaAgregada.forEach(litarea => {
                litarea.addEventListener("click", async () => {
                    const idtarea = litarea.getAttribute("data-tarea-id");
                    const tareaObtenida = await obtenerTareaPorId(idtarea);

                    $q("#txtDescripcionTarea").value = tareaObtenida[0].descripcion;
                    $q("#txtIntervaloTarea").value = tareaObtenida[0].intervalo;
                    $q("#selectFrecuenciaTarea").value = tareaObtenida[0].idfrecuencia;
                    $q("#tipoPrioridadTarea").value = tareaObtenida[0].idtipo_prioridad;
                    $q("#elegirSubCategoriaTarea").value = tareaObtenida[0].idsubcategoria;

                    btnGuardarTarea.style.display = 'none';
                    $q("#elegirSubCategoriaTarea").disabled = true;
                    btnsTareaAcciones.innerHTML = `
                        <div class="col-md-4">
                            <button type="button" id="btnActualizarTarea" class="btn btn-success">Actualizar</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" id="btnCancelarTarea" class="btn btn-danger">Cancelar</button>
                        </div>
                    `;

                    $q("#btnCancelarTarea").addEventListener("click", async () => {
                        formtarea.reset();
                        btnGuardarTarea.style.display = 'block';
                        $q("#elegirSubCategoriaTarea").disabled = false;
                        btnsTareaAcciones.innerHTML = "";
                        await renderUItareas();
                        asignarEventosTareas(); // Reasignar eventos después de renderizar
                    });

                    $q("#btnActualizarTarea").addEventListener("click", async () => {
                        const descripcion = $q("#txtDescripcionTarea").value;
                        const tareaExiste = await verificarTareaExistente(descripcion);
                        if (tareaExiste) {
                            alert("Esta tarea ya existe. Crea otra.");
                            return;
                        }
                        const formActualizarTarea = new FormData();
                        formActualizarTarea.append("operation", "actualizarTarea");
                        formActualizarTarea.append("idtarea", idtarea);
                        formActualizarTarea.append("idtipo_prioridad", $q("#tipoPrioridadTarea").value);
                        formActualizarTarea.append("descripcion", $q("#txtDescripcionTarea").value);
                        formActualizarTarea.append("intervalo", $q("#txtIntervaloTarea").value);
                        formActualizarTarea.append("idfrecuencia", $q("#selectFrecuenciaTarea").value);
                        formActualizarTarea.append("idestado", 8);

                        await fetch(`${host}tarea.controller.php`, {
                            method: "POST",
                            body: formActualizarTarea
                        });

                        formtarea.reset();
                        btnGuardarTarea.style.display = 'block';
                        btnsTareaAcciones.innerHTML = "";
                        $q("#elegirSubCategoriaTarea").disabled = false;
                        await renderUItareas();
                        asignarEventosTareas(); // Reasignar eventos después de renderizar
                    });
                });
            });
        }
    }


    async function renderAvt() {

        const avt = await obtenerActivosVinculados()
        console.log("avt gaasaa: ", avt)
        listaActivosAsignados.innerHTML = ""
        for (let p = 0; p < avt.length; p++) {
            listaActivosAsignados.innerHTML += `
                <li class="list-group-item d-flex justify-content-between align-items-center mb-3" data-idtarea="${avt[p].idtarea}">
                    ${avt[p].descripcion} - Tarea N°${avt[p].idtarea}
                    ${avt[p].idestado !== 9 ? `<span class="badge bg-primary rounded-pill btn-eliminar" data-idactivovinculado="${avt[p].idactivo_vinculado}" style="cursor: pointer;">
                        <i class="fa-solid fa-trash"></i>
                    </span>`: ''}
                </li>
            `
        }
    }

    filters.forEach(select => {
        select.addEventListener("change", async () => {
            await filtrarActivosList()
        })
    })

    // *********************** SECCION DE OBTENER DATOS ***********************************

    async function obtenerTareas() {
        const paramsTareasSearch = new URLSearchParams()
        paramsTareasSearch.append("operation", "obtenerTareasPorPlanTarea")
        paramsTareasSearch.append("idplantarea", idplantarea_generado)
        const tareasRegistradasObtenidas = await getDatos(`${host}tarea.controller.php`, paramsTareasSearch)
        console.log("tareasRegistradasObtenidas: ", tareasRegistradasObtenidas)
        return tareasRegistradasObtenidas
    }

    async function obtenerActivosVinculados() {
        const paramsObtenerAVT = new URLSearchParams()
        paramsObtenerAVT.append("operation", "listarActivosPorTareaYPlan")
        paramsObtenerAVT.append("idplantarea", idplantarea_generado)
        const avtData = await getDatos(`${host}activosvinculados.controller.php`, paramsObtenerAVT)
        console.log("avt obtenidos: ", avtData)
        return avtData
    }

    async function obtenerTareaPorId(idtarea) {
        const params = new URLSearchParams()
        params.append("operation", "obtenerTareaPorId")
        params.append("idtarea", idtarea)
        const ultimaTareaAgregada = await getDatos(`${host}tarea.controller.php`, params)
        return ultimaTareaAgregada
    }

    async function obtenerFrecuencias() {
        const paramsFrecuencia = new URLSearchParams()
        paramsFrecuencia.append("operation", "obtenerFrecuencias")
        const frecuencias = await getDatos(`${host}tarea.controller.php`, paramsFrecuencia)
        return frecuencias
    }

    async function obtenerSubCategoriaPorCategoria(idcategoria) {
        const paramsObtenerSub = new URLSearchParams()
        paramsObtenerSub.append("operation", "getSubcategoriaByCategoria")
        paramsObtenerSub.append("idcategoria", idcategoria)
        const data = await getDatos(`${host}subcategoria.controller.php`, paramsObtenerSub)
        return data
    }

    // ************************ FIN SECCCION ***********************************************************

    //******************************** SECCION DE ACTUALIZACIONES ************************************** */

    async function actualizarTareaEstadoPausado(idtarea, pausado) {
        const paramsActualizar = new FormData()
        paramsActualizar.append("operation", "actualizarTareaEstadoPausado")
        paramsActualizar.append("idtarea", idtarea)
        paramsActualizar.append("pausado", pausado)
        const FtareaPausada = await fetch(`${host}tarea.controller.php`, { method: 'POST', body: paramsActualizar })
        const tareaPausada = await FtareaPausada.json()
        return tareaPausada
    }

    // ************************************ FIN DE SECCION ***********************************************

    /* ********************************************* EVENTOS *************************************************** */

    //AGREGAR NUEVA TAREA, FORMATEAR EL FORMULARIO TAREA, HABILITAR CAMPOS ACTIVOS Y RENDERIZAR LA TAREA AGREGADA AL SELECT
    async function verificarTareaExistente(descripcion) {
        const tareasExistentes = await getDatos(`${host}tarea.controller.php`, `operation=obtenerTareasSinActivos`);
        return tareasExistentes.some(tarea => tarea.descripcion === descripcion);
    }

    async function agregarTareaYRenderizar() {

        const agregado = await agregarTareas();
        const dataId = await agregado.json();
        const idtarea_generado = dataId.id;
        const ultimaTareaAgregada = await obtenerTareaPorId(idtarea_generado);

        ulTareasAgregadas.innerHTML += `
            <li class="list-group-item d-flex justify-content-between align-items-center mb-3">
                <p class="tarea-agregada mb-0" data-tarea-id="${ultimaTareaAgregada[0]?.idtarea}">
                    ${ultimaTareaAgregada[0]?.descripcion} - Tarea: ${ultimaTareaAgregada[0]?.idtarea}
                </p>
                <div class="d-flex gap-2">
                    <span class="badge bg-primary rounded-pill btn-eliminar-tarea" data-tarea-id="${ultimaTareaAgregada[0]?.idtarea}" style="cursor: pointer;">
                        <i class="fa-solid fa-trash"></i>
                    </span>
                    <span class="badge bg-primary rounded-pill btn-pausar-tarea" data-tarea-id="${ultimaTareaAgregada[0]?.idtarea}" style="cursor: pointer;">
                        ${ultimaTareaAgregada[0].pausado == 1 ? `<i class="fa-solid fa-play"></i>` : `<i class="fa-solid fa-pause"></i>`}
                    </span>
                </div>
            </li>
        `;
        formtarea.reset();
        habilitarCamposActivo(false);
        await renderTareasSelect();
    }

    async function eliminarTarea(idTarea) {
        const formEliminacionTarea = new FormData();
        formEliminacionTarea.append("operation", "eliminarTarea");
        const eliminado = await fetch(`${host}tarea.controller.php/${idTarea}`, { method: 'POST', body: formEliminacionTarea });
        return await eliminado.json();
    }

    /* async function manejarEventosTarea() {
        const liTareaAgregada = $all(".tarea-agregada");
        const btnsEliminarTarea = $all(".btn-eliminar-tarea");
        const btnsPausarTarea = $all(".btn-pausar-tarea");

        btnsEliminarTarea.forEach(btn => {
            btn.addEventListener("click", async () => {
                const idTarea = parseInt(btn.getAttribute("data-tarea-id"));
                const tareasObtenidasAntesDeEliminar = await obtenerTareas();
                const tarea = tareasObtenidasAntesDeEliminar.find(t => t.idtarea == idTarea);
                if (tarea?.nom_estado === "proceso" || tarea?.trabajado === 1) {
                    alert("Esta tarea no se puede eliminar.");
                    return;
                }

                const eliminado = await eliminarTarea(idTarea);
                if (eliminado.eliminado) {
                    btn.closest("li").remove();
                    if (await obtenerTareas().length === 0) habilitarCamposActivo(true);
                }
                await renderTareasSelect();
            });
        });

        btnsPausarTarea.forEach(btn => {
            btn.addEventListener("click", async () => {
                const idtarea = btn.getAttribute("data-tarea-id");
                const tareaObtenida = await obtenerTareaPorId(idtarea);
                if (tareaObtenida[0].idestado !== 9) { //PAUSAR LA TAREA CUANDO SEA DE TODO MENOS EN PROCESO
                    await actualizarTareaEstadoPausado(idtarea, tareaObtenida[0].pausado === 0 ? 1 : 0);
                    await renderUItareas();
                } else {
                    showToast("No puedes pausar esta tarea porque se encuentra en proceso.", "ERROR", 6000);
                }

            });
        });

        liTareaAgregada.forEach(litarea => {
            litarea.addEventListener("click", async () => {
                const idtarea = litarea.getAttribute("data-tarea-id");
                const tareaObtenida = await obtenerTareaPorId(idtarea);
                $q("#txtDescripcionTarea").value = tareaObtenida[0].descripcion;
                $q("#tipoPrioridadTarea").value = tareaObtenida[0].idtipo_prioridad;
                $q("#selectFrecuenciaTarea").value = tareaObtenida[0].idfrecuencia;
                $q("#txtIntervaloTarea").value = tareaObtenida[0].intervalo;
                btnGuardarTarea.style.display = 'none';
                $q("#elegirSubCategoriaTarea").disabled = true;

                btnsTareaAcciones.innerHTML = `
                    <button type="button" id="btnActualizarTarea" class="btn btn-success">Actualizar</button>
                    <button type="button" id="btnCancelarTarea" class="btn btn-danger">Cancelar</button>
                `;

                $q("#btnActualizarTarea").addEventListener("click", async () => {
                    const formActualizarTarea = new FormData();
                    formActualizarTarea.append("operation", "actualizarTarea");
                    formActualizarTarea.append("idtarea", idtarea);
                    formActualizarTarea.append("descripcion", $q("#txtDescripcionTarea").value);
                    await fetch(`${host}tarea.controller.php`, { method: "POST", body: formActualizarTarea });
                    formtarea.reset();
                    btnGuardarTarea.style.display = 'block';
                    btnsTareaAcciones.innerHTML = "";
                });

                $q("#btnCancelarTarea").addEventListener("click", () => {
                    formtarea.reset();
                    btnGuardarTarea.style.display = 'block';
                    btnsTareaAcciones.innerHTML = "";
                });
            });
        });
    } */

    $q("#form-tarea").addEventListener("submit", async (e) => {
        e.preventDefault();
        let sintareas = false;
        const descripcion = $q("#txtDescripcionTarea").value;
        const tareaExiste = await verificarTareaExistente(descripcion);
        if (tareaExiste) {
            alert("Esta tarea ya existe. Crea otra.");
            return;
        }
        await agregarTareaYRenderizar();
        await renderSubCategorias(idcategoria_generado);
        await renderUbicacion();
        const tareasObtenidasAntesDeEliminar = await obtenerTareas();

        asignarEventosTareas();

        async function asignarEventosTareas() {
            const liTareaAgregada = $all(".tarea-agregada");
            const btnsEliminarTarea = $all(".btn-eliminar-tarea");
            const btnsPausarTarea = $all(".btn-pausar-tarea");

            btnsEliminarTarea.forEach(btn => {
                btn.addEventListener("click", async () => {
                    const idTarea = parseInt(btn.getAttribute("data-tarea-id"));
                    let procesoEncontrado = false;

                    for (let w = 0; w < tareasObtenidasAntesDeEliminar.length; w++) {
                        if (tareasObtenidasAntesDeEliminar[w].idtarea === idTarea) {
                            if (tareasObtenidasAntesDeEliminar[w].nom_estado === "proceso" || tareasObtenidasAntesDeEliminar[w].trabajado === 1) {
                                alert("ESTA TAREA NO SE PUEDE ELIMINAR.");
                                procesoEncontrado = true;
                                break;
                            }
                        }
                    }

                    if (!procesoEncontrado) {
                        const li = btn.closest("li");
                        li.remove();

                        const formEliminacionTarea = new FormData();
                        formEliminacionTarea.append("operation", "eliminarTarea");
                        const eliminado = await fetch(`${host}tarea.controller.php/${idTarea}`, { method: 'POST', body: formEliminacionTarea });
                        const elim = await eliminado.json()
                        console.log("eliminado?: ", elim.eliminado)

                        const tareasRegistradasObtenidas = await obtenerTareas()
                        const avtObtenidas = await obtenerActivosVinculados()
                        console.log("tareasRegistradasObtenidas: ", await tareasRegistradasObtenidas) // me quede aca
                        console.log("avt data hasta el momento: ", avtObtenidas)
                        //ELIMINAR CONTENIDO DE LAS CAJAS DE TEXTO
                        formtarea.reset()

                        if (elim.eliminado) {
                            if (tareasRegistradasObtenidas.length == 0 && avtObtenidas.length == 0) {
                                console.log("ya no hay tareas");
                                habilitarCamposActivo(true)
                            }
                        }

                        await renderUItareas();
                        await renderTareasSelect()
                        asignarEventosTareas(); // Reasignar eventos después de renderizar
                        
                        sintareas = true
                        return
                    }
                });
            });

            btnsPausarTarea.forEach(btn => {
                btn.addEventListener("click", async () => {
                    const idtarea = btn.getAttribute("data-tarea-id");
                    const tareaObtenida = await obtenerTareaPorId(idtarea);

                    if (tareaObtenida[0].idestado !== 9) { //PAUSAR LA TAREA CUANDO SEA DE TODO MENOS EN PROCESO
                        await actualizarTareaEstadoPausado(idtarea, tareaObtenida[0].pausado === 0 ? 1 : 0);
                        await renderUItareas();
                        asignarEventosTareas(); // Reasignar eventos después de renderizar
                    } else {
                        showToast("No puedes pausar esta tarea porque se encuentra en proceso.", "ERROR", 6000);
                    }
                });
            });

            liTareaAgregada.forEach(litarea => {
                litarea.addEventListener("click", async () => {
                    const idtarea = litarea.getAttribute("data-tarea-id");
                    const tareaObtenida = await obtenerTareaPorId(idtarea);

                    $q("#txtDescripcionTarea").value = tareaObtenida[0].descripcion;
                    $q("#txtIntervaloTarea").value = tareaObtenida[0].intervalo;
                    $q("#selectFrecuenciaTarea").value = tareaObtenida[0].idfrecuencia;
                    $q("#tipoPrioridadTarea").value = tareaObtenida[0].idtipo_prioridad;
                    $q("#elegirSubCategoriaTarea").value = tareaObtenida[0].idsubcategoria;

                    btnGuardarTarea.style.display = 'none';
                    $q("#elegirSubCategoriaTarea").disabled = true;
                    btnsTareaAcciones.innerHTML = `
                        <div class="col-md-4">
                            <button type="button" id="btnActualizarTarea" class="btn btn-success">Actualizar</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" id="btnCancelarTarea" class="btn btn-danger">Cancelar</button>
                        </div>
                    `;

                    $q("#btnCancelarTarea").addEventListener("click", async () => {
                        formtarea.reset();
                        btnGuardarTarea.style.display = 'block';
                        $q("#elegirSubCategoriaTarea").disabled = false;
                        btnsTareaAcciones.innerHTML = "";
                        await renderUItareas();
                        asignarEventosTareas(); // Reasignar eventos después de renderizar
                    });

                    $q("#btnActualizarTarea").addEventListener("click", async () => {
                        const descripcion = $q("#txtDescripcionTarea").value;
                        const tareaExiste = await verificarTareaExistente(descripcion);
                        if (tareaExiste) {
                            alert("Esta tarea ya existe. Crea otra.");
                            return;
                        }
                        const formActualizarTarea = new FormData();
                        formActualizarTarea.append("operation", "actualizarTarea");
                        formActualizarTarea.append("idtarea", idtarea);
                        formActualizarTarea.append("idtipo_prioridad", $q("#tipoPrioridadTarea").value);
                        formActualizarTarea.append("descripcion", $q("#txtDescripcionTarea").value);
                        formActualizarTarea.append("intervalo", $q("#txtIntervaloTarea").value);
                        formActualizarTarea.append("idfrecuencia", $q("#selectFrecuenciaTarea").value);
                        formActualizarTarea.append("idestado", 8);

                        await fetch(`${host}tarea.controller.php`, {
                            method: "POST",
                            body: formActualizarTarea
                        });

                        formtarea.reset();
                        btnGuardarTarea.style.display = 'block';
                        btnsTareaAcciones.innerHTML = "";
                        $q("#elegirSubCategoriaTarea").disabled = false;
                        await renderUItareas();
                        asignarEventosTareas(); // Reasignar eventos después de renderizar
                    });
                });
            });
        }

    });


    //AGREGA EL PLAN DE TAREA
    btnGuardarPlanTarea.addEventListener("click", async () => {
        let permitir = true
        const descripcionPlanTarea = $q("#txtDescripcionPlanTarea");
        if (
            !descripcionPlanTarea.value.trim() ||
            !/^[a-zA-Z\s]+$/.test(descripcionPlanTarea.value)
        ) {
            alert("Solo se permite letras y espacios");
            return;
        }

        const paramsBuscarVigentes = new URLSearchParams()
        paramsBuscarVigentes.append("operation", "getPlanesDeTareas")
        paramsBuscarVigentes.append("eliminado", 0)

        const paramsBuscarEliminados = new URLSearchParams()
        paramsBuscarEliminados.append("operation", "getPlanesDeTareas")
        paramsBuscarEliminados.append("eliminado", 1)

        // PRIMER PASO: VERIFICAR SI EL PLAN A REGISTRAR YA EXISTE
        const obtenerPlanDeTareasVigentes = await getDatos(`${host}plandetarea.controller.php`, paramsBuscarVigentes);
        const obtenerPlanDeTareasEliminados = await getDatos(`${host}plandetarea.controller.php`, paramsBuscarEliminados);

        // Comprobar en los planes vigentes
        for (let i = 0; i < obtenerPlanDeTareasVigentes.length; i++) {
            if (descripcionPlanTarea.value === obtenerPlanDeTareasVigentes[i].descripcion) {
                alert("ESTE PLAN YA EXISTE EN VIGENTES, CREA OTRO");
                permitir = false;
                break;
            }
        }

        // Comprobar en los planes eliminados
        if (permitir) {
            for (let i = 0; i < obtenerPlanDeTareasEliminados.length; i++) {
                if (descripcionPlanTarea.value === obtenerPlanDeTareasEliminados[i].descripcion) {
                    alert("ESTE PLAN YA EXISTE EN ELIMINADOS, CREA OTRO");
                    permitir = false;
                    break;
                }
            }
        }

        if (permitir) {
            //SEGUNDO PASO: REGISTRAR PLAN DE TAREA
            const formPlan = new FormData()
            formPlan.append("operation", "actualizarPlanDeTareas")
            formPlan.append("idplantarea", idplantarea_generado)
            formPlan.append("descripcion", descripcionPlanTarea.value)
            formPlan.append("incompleto", incompleto)
            const factualizado = await fetch(`${host}plandetarea.controller.php`, { method: 'POST', body: formPlan })
            const actualizado = await factualizado.json()
            console.log("actualizado: ", actualizado)
            habilitarCamposTarea(false);
            //$q("#btnGuardarPlanTarea").remove()
            //$q("#txtDescripcionPlanTarea").disabled = true
            //btnTerminarPlan.disabled = false
        }
    });

    //AGREGAR UN ACTIVO VINCULADO TAREA
    $q("#btnAgregarActivos").addEventListener("click", async () => {
        estado = false
        const paramsAVTsearch = new URLSearchParams()
        paramsAVTsearch.append("operation", "listarActivosPorTareaYPlan")
        paramsAVTsearch.append("idplantarea", idplantarea_generado)
        const avtdata = await getDatos(`${host}activosvinculados.controller.php`, paramsAVTsearch)
        console.log("avtdata: ", avtdata)


        if (parseInt(selectElegirTareaParaActivo.value) === -1) { // si es que manipulan el console de google
            console.log("eliga una tarea valida")
            return
        }

        // Obtener todas las tareas para verificar estados
        const tareas = await obtenerTareas();
        console.log("TAREAS OBTENIDAS AL MOMENTO DE SER AGREGADA UN ACTIVO: ", tareas);

        for (let e = 0; e < activosElegidos.length; e++) {
            for (let f = 0; f < avtdata.length; f++) {
                const idTarea = activosElegidos[e].idtarea;
                const tarea = tareas.find(t => t.idtarea === idTarea);

                // Verificar si la tarea está en proceso antes de agregar activos
                if (tarea && tarea.nom_estado === "proceso") {
                    alert("Esta tarea ya no puede guardar más activos porque está en proceso");
                    estado = true;
                    return;
                }

                // Verificar si el activo ya está vinculado a la tarea
                const activoYaVinculado = avtdata.some(avt => avt.idactivo === activosElegidos[e].idactivo && avt.idtarea === idTarea);
                if (activoYaVinculado) {
                    alert("Este activo ya está registrado en esa tarea.");
                    estado = true;
                    return;
                }
            }


            const formAVT = new FormData()
            formAVT.append("operation", "insertarActivoPorTarea")
            formAVT.append("idactivo", activosElegidos[e].idactivo)
            formAVT.append("idtarea", activosElegidos[e].idtarea)
            const fAvt = await fetch(`${host}activosvinculados.controller.php`, { method: 'POST', body: formAVT })
            const id = await fAvt.json()
            console.log("ID ACTIVO VINCULADO CREADO: ", id.id)

            const params = new URLSearchParams()
            params.append("operation", "obtenerUnActivoVinculadoAtarea")
            params.append("idactivovinculado", id.id)
            const activoVinculadoTareaObtenido = await getDatos(`${host}activosvinculados.controller.php`, params)
            console.log("activoVinculadoTareaObtenido: ", await activoVinculadoTareaObtenido) // me quede aca

            //RENDERIZAR ACTIVOS VINCULADOS AGREGADOS AL INTERFAZ

            activoVinculadoTareaObtenido.forEach((avt) => {
                listaActivosAsignados.innerHTML += `
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-3" data-idtarea="${avt.idtarea}">
                        ${avt.descripcion} - Tarea N°${avt.idtarea}
                        <span class="badge bg-primary rounded-pill btn-eliminar" data-idactivovinculado="${avt.idactivo_vinculado}" style="cursor: pointer;">
                            <i class="fa-solid fa-trash"></i>
                        </span>
                    </li>
                `
            });
        }

        //registrarActivosOk = true
        activosElegidos = []
        selectElegirTareaParaActivo.value = ""
        //selectSubCategoria.value = ""
        selectUbicacion.value = ""
        const checkboxes = document.querySelectorAll(".activo-checkbox:checked");
        activosList.innerHTML = ""
        checkboxes.forEach(chk => {
            chk.checked = false;  // Deselecciona el checkbox
        });
        //await filtrarActivosList()
    })

    listaActivosAsignados.addEventListener("click", async (event) => {
        if (event.target.closest(".btn-eliminar")) {
            const btn = event.target.closest(".btn-eliminar");
            const idActivoResp = parseInt(btn.getAttribute("data-idactivovinculado"));
            console.log("ID ACTIVO RESP CLICKEADO: ", idActivoResp);

            const li = btn.closest("li");
            li.remove();

            const formEliminacionAVT = new FormData();
            formEliminacionAVT.append("operation", "eliminarActivosVinculadosTarea");

            const eliminado = await fetch(`${host}activosvinculados.controller.php/${idActivoResp}`, {
                method: 'POST',
                body: formEliminacionAVT
            });

            // PRIMERO ELIMINAMOS EL ACTIVO VINCULADO
            const elim = await eliminado.json();
            console.log("eliminado?: ", elim.eliminado);

            // LUEGO CONSULTAMOS CUANTOS ACTIVOS VINCULADOS ESTAN REGISTRADOS AL MOMENTO
            const paramsAVTsearch = new URLSearchParams()
            paramsAVTsearch.append("operation", "listarActivosPorTareaYPlan")
            paramsAVTsearch.append("idplantarea", idplantarea_generado)
            const avtdata = await getDatos(`${host}activosvinculados.controller.php`, paramsAVTsearch)
            console.log("avtdata: ", avtdata)


        }
    })

    //ESTE EVENTO SERVIRA SI SE CAMBIA A ULTIMA MINUTO LA TAREA SELECCIONADA con Activos YA SELECCIONADOS
    selectElegirTareaParaActivo.addEventListener("change", async () => {
        const nuevaIdTarea = parseInt(selectElegirTareaParaActivo.value)
        if (nuevaIdTarea === -1) {
            console.log("Por favor, elige una tarea válida.");
            return;
        }
        activosElegidos.forEach(activo => {
            activo.idtarea = nuevaIdTarea
        })
        console.log("activosElegidos actualizados con la nueva tarea: ", activosElegidos);

    })

    btnTerminarPlan.addEventListener("click", async () => {
        console.log("estando cuando de click al btn terminar plan")
        console.log("pasando por el btn terminar plan")
        habilitarBeforeUnload = false
        // verificar
        const tareas = await obtenerTareas()
        const avt = await obtenerActivosVinculados()
        if (tareas.length == 0 || avt.length == 0) {
            alert("EL PLAN SE MANTIENE INCOMPLETO")
            const formActualizarPlan = new FormData()
            formActualizarPlan.append("operation", "actualizarPlanDeTareas")
            formActualizarPlan.append("idplantarea", idplantarea_generado)
            formActualizarPlan.append("descripcion", $q("#txtDescripcionPlanTarea").value)
            formActualizarPlan.append("incompleto", 1)

            const response = await fetch(`${host}plandetarea.controller.php`, {
                method: "POST",
                body: formActualizarPlan
            })

            const estado = await response.json()
            console.log("Plan actualizado: ", estado)
            if (estado.actualizado) {
                window.location.href = `http://localhost/CMMS/views/plantareas`
            }
        }
        else {
            const formActualizarPlan = new FormData()
            formActualizarPlan.append("operation", "actualizarPlanDeTareas")
            formActualizarPlan.append("idplantarea", idplantarea_generado)
            formActualizarPlan.append("descripcion", $q("#txtDescripcionPlanTarea").value)
            formActualizarPlan.append("incompleto", 0)

            const response = await fetch(`${host}plandetarea.controller.php`, {
                method: "POST",
                body: formActualizarPlan
            })

            const estado = await response.json()
            console.log("Plan actualizado: ", estado)
            if (estado.actualizado) {
                window.location.href = `http://localhost/CMMS/views/plantareas`
            }
        }

    })

    window.addEventListener("beforeunload", (e) => {
        e.preventDefault()
        if (habilitarBeforeUnload) {
            (async () => {
                console.log("holaasdas")
                const tareas = await obtenerTareas()
                console.log("cantidad tareas: ", tareas)
                const avt = await obtenerActivosVinculados()
                console.log("cantidad avt: ", avt)
                if (tareas.length == 0 || avt.length == 0) {
                    console.log("NO HAY NADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
                    const formActualizarPlan = new FormData()
                    formActualizarPlan.append("operation", "actualizarPlanDeTareas")
                    formActualizarPlan.append("idplantarea", idplantarea_generado)
                    formActualizarPlan.append("descripcion", $q("#txtDescripcionPlanTarea").value)
                    formActualizarPlan.append("incompleto", 1)

                    const response = await fetch(`${host}plandetarea.controller.php`, {
                        method: "POST",
                        body: formActualizarPlan
                    })

                    const estado = await response.json()
                    console.log("Plan actualizado: ", estado)
                    if (estado.actualizado) {
                        console.log("Redirigiendo")
                        //window.location.href = `http://localhost/CMMS/views/plantareas`
                    }
                }
                else {
                    const formActualizarPlan = new FormData()
                    formActualizarPlan.append("operation", "actualizarPlanDeTareas")
                    formActualizarPlan.append("idplantarea", idplantarea_generado)
                    formActualizarPlan.append("descripcion", $q("#txtDescripcionPlanTarea").value)
                    formActualizarPlan.append("incompleto", 0)

                    const response = await fetch(`${host}plandetarea.controller.php`, {
                        method: "POST",
                        body: formActualizarPlan
                    })

                    const estado = await response.json()
                    console.log("Plan actualizado: ", estado)
                    if (estado.actualizado) {
                        console.log("Redirigiendo")
                        //window.location.href = `http://localhost/CMMS/views/plantareas`
                    }
                }
            })()

        }
    });

    /* window.addEventListener("unload", () => {
        console.log("peeee")
    }) */
})