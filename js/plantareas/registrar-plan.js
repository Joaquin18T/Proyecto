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
    let idplantarea_generado = -1;
    let idtarea_generado = -1;
    let idcategoria = -1
    const btnGuardarPlanTarea = $q("#btnGuardarPlanTarea");
    const filters = $all(".filter")
    //TABLAS
    const activosList = $q("#activosBodyTable");
    //UL
    const listaActivosAsignados = $q(".listaActivosAsignados")
    const ulTareasAgregadas = $q(".listaTareasAgregadas");
    // LISTAS
    let activosElegidos = []
    //SELECT - PLAN
    const selectCategoria = $q("#elegirCategoria")
    //SELECT - Tarea
    const selectSubCategoriaTarea = $q("#elegirSubCategoriaTarea")
    //SELECTS -activos
    const selectElegirTareaParaActivo = $q("#elegirTareaParaActivo");
    //const selectSubCategoria = $q("#elegirSubCategoria")
    const selectUbicacion = $q("#elegirUbicacion")
    //BOTONES
    const btnAgregarActivos = $q("#btnAgregarActivos")
    const btnTerminarPlan = $q("#btnTerminarPlan")
    const btnGuardarTarea = $q("#btnGuardarTarea")
    const btnsTareaAcciones = $q("#btnsTareaAcciones") // esto en realidad es un div pero guardara botones

    await renderCategorias()
    await filtrarActivosList()

    function habilitarCamposTarea(habilitado = true) {
        $q("#txtDescripcionTarea").disabled = habilitado
        /* $q("#fecha-inicio").disabled = habilitado
        $q("#hora-inicio").disabled = habilitado
        $q("#fecha-vencimiento").disabled = habilitado
        $q("#hora-vencimiento").disabled = habilitado
 */
        $q("#elegirSubCategoriaTarea").disabled = habilitado
        $q("#txtIntervaloTarea").disabled = habilitado
        $q("#tipoPrioridadTarea").disabled = habilitado
        $q("#selectFrecuenciaTarea").disabled = habilitado
        $q("#txtDescripcionPlanTarea").disabled = !habilitado
        $q("#btnGuardarPlanTarea").remove()
        $q("#btnGuardarTarea").disabled = habilitado
    }

    function habilitarCamposActivo(habilitado = true) {
        selectElegirTareaParaActivo.disabled = habilitado
        //selectSubCategoria.disabled = habilitado
        selectUbicacion.disabled = habilitado
        btnAgregarActivos.disabled = habilitado
    }

    async function loadFunctions() {
        await renderPrioridades()
        await renderFrecuencias()
        await renderSubCategorias(idcategoria)
    }

    // ***************************** seccion de renderizado *******************************************

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
        selectSubCategoriaTarea.innerHTML = `<option selected value="-1">Sub Categoria</option>`

        //selectSubCategoria.innerHTML = `<option selected value="-1">Sub Categoria</option>`
        for (let i = 0; i < subcategorias.length; i++) {
            selectSubCategoriaTarea.innerHTML += `
                <option value="${subcategorias[i].idsubcategoria}">${subcategorias[i].subcategoria}</option>
            `

            //selectSubCategoria.innerHTML += `
            //    <option value="${data[i].idsubcategoria}">${data[i].subcategoria}</option>
            //  `;
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
        const selectFrecuenciaTarea = $q("#selectFrecuenciaTarea");
        /* const fechaInicioTarea = $q("#fecha-inicio");
        const horaInicioTarea = $q("#hora-inicio");
        const fechaVencimiento = $q("#fecha-vencimiento");
        const horaVencimiento = $q("#hora-vencimiento"); */
        const subCategoriaTarea = $q("#elegirSubCategoriaTarea")


        let formTarea = new FormData();
        formTarea.append("operation", "add")
        formTarea.append("idplantarea", idplantarea_generado);
        formTarea.append("idtipo_prioridad", tipoPrioridadTarea.value);
        formTarea.append("descripcion", descripcionTarea.value);
        formTarea.append("idsubcategoria", subCategoriaTarea.value)
        formTarea.append("intervalo", intervaloTarea.value);
        formTarea.append("idfrecuencia", selectFrecuenciaTarea.value);

        /* formTarea.append("fecha_inicio", fechaInicioTarea.value);
        formTarea.append("hora_inicio", horaInicioTarea.value)
        formTarea.append("fecha_vencimiento", fechaVencimiento.value);
        formTarea.append("hora_vencimiento", horaVencimiento.value)
         */
        formTarea.append("idestado", 8);
        //console.log("agregar tareas idplantarea: ", idplantarea_generado)
        const data = await fetch(`${host}tarea.controller.php`, { method: 'POST', body: formTarea })
        return data;
    }

    async function filtrarActivosList() {
        const tarea = await obtenerTareaPorId(selectElegirTareaParaActivo.value.trim())
        console.log("tarea obtenida con filter: ", tarea)
        /* const params = new URLSearchParams()
        params.append("operation", "filtrarActivosResponsablesAsignados")
        params.append("idsubcategoria", (tarea[0]?.idsubcategoria === "" || tarea[0]?.idsubcategoria == -1) ? "" : tarea[0]?.idsubcategoria) //
        params.append("idubicacion", (selectUbicacion.value.trim() === "" || selectUbicacion.value == -1) ? "" : selectUbicacion.value) //
        params.append("cod_identificacion", "")

        const data = await getDatos(`${host}respActivo.controller.php`, params) */
        const params = new URLSearchParams()
        params.append("operation", "listarActivosResponsables")
        params.append("idsubcategoria", (tarea[0]?.idsubcategoria === "" || tarea[0]?.idsubcategoria == -1) ? "" : tarea[0]?.idsubcategoria)
        params.append("idubicacion", (selectUbicacion.value.trim() === "" || selectUbicacion.value == -1) ? "" : selectUbicacion.value)
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
                <td>${data[i].modelo}</td>
                <td>${data[i].nom_estado}</td>
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

    async function renderCategorias() {
        const categorias = await obtenerCategorias()
        selectCategoria.innerHTML = `<option selected value="-1">Sub Categoria</option>`
        for (let i = 0; i < categorias.length; i++) {
            selectCategoria.innerHTML += `
                <option value="${categorias[i].idcategoria}">${categorias[i].categoria}</option>
            `
        }
    }

    // **************************************** FIN SECCION DE RENDERIZADO **************************

    // ************************************ SECCION DE OBTENER DATOS ********************************

    async function obtenerTareas() {
        const paramsTareasSearch = new URLSearchParams()
        paramsTareasSearch.append("operation", "obtenerTareasPorPlanTarea")
        paramsTareasSearch.append("idplantarea", idplantarea_generado)
        const tareasRegistradasObtenidas = await getDatos(`${host}tarea.controller.php`, paramsTareasSearch)
        return tareasRegistradasObtenidas
    }

    async function obtenerActivosVinculados() {
        const paramsObtenerAVT = new URLSearchParams()
        paramsObtenerAVT.append("operation", "listarActivosPorTareaYPlan")
        paramsObtenerAVT.append("idplantarea", idplantarea_generado)
        const avtData = await getDatos(`${host}activosvinculados.controller.php`, paramsObtenerAVT)
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

    async function obtenerCategorias() {
        const categorias = await getDatos(`${host}categoria.controller.php`, `operation=getCategoria`)
        console.log("categorias: ",categorias)
        return categorias
    }

    

    // ******************************************* FIN DE SECCION DE ATUALIZACION **********************************

    /* ********************************************* EVENTOS *************************************************** */



    filters.forEach(select => {
        select.addEventListener("change", async () => {
            await filtrarActivosList()
        })
    })

    //AGREGAR NUEVA TAREA, FORMATEAR EL FORMULARIO TAREA, HABILITAR CAMPOS ACTIVOS Y RENDERIZAR LA TAREA AGREGADA AL SELECT
    $q("#form-tarea").addEventListener("submit", async (e) => {
        e.preventDefault()
        /* let fechaInicioTarea = $q("#fecha-inicio").value;
        let horaInicioTarea = $q("#hora-inicio").value;
        let fechaVencimiento = $q("#fecha-vencimiento").value;
        let horaVencimiento = $q("#hora-vencimiento").value;

        // Combinar fecha y hora en objetos Date para cada uno
        let fechaHoraInicio = new Date(`${fechaInicioTarea}T${horaInicioTarea}:00-05:00`);
        let fechaHoraVencimiento = new Date(`${fechaVencimiento}T${horaVencimiento}:00-05:00`);

        // Obtener la fecha y hora actual en horario de Perú
        let ahora = new Date().toLocaleString("en-US", { timeZone: "America/Lima" });
        let fechaHoraActual = new Date(ahora);

        // Validar que las fechas no sean anteriores a hoy
        if (fechaHoraInicio < fechaHoraActual) {
            alert("La hora de inicio debe ser a partir de la hora actual.");
            return;
        }
        if (fechaHoraVencimiento < fechaHoraActual) {
            alert("La hora de vencimiento debe ser a partir de la hora actual.");
            return;
        }

        // Validar que la fecha de inicio no sea posterior a la fecha de vencimiento
        if (fechaInicioTarea > fechaVencimiento) {
            alert("La fecha de inicio no puede ser posterior a la fecha de vencimiento.");
            return;
        }

        // Validar que la hora de inicio no sea mayor que la hora de vencimiento si ambas fechas son iguales
        if (fechaInicioTarea === fechaVencimiento && horaInicioTarea > horaVencimiento) {
            alert("La hora de inicio no puede ser mayor que la hora de vencimiento en el mismo día.");
            return;
        } */
        let permitir = true
        let sintareas = false;
        const formtarea = $q("#form-tarea");
        const tareasExistentes = await getDatos(`${host}tarea.controller.php`, `operation=obtenerTareasSinActivos`)
        console.log("tareasExistentes: ", tareasExistentes)
        for (let i = 0; i < tareasExistentes.length; i++) {
            if ($q("#txtDescripcionTarea").value == tareasExistentes[i].descripcion) {
                alert("ESTA TAREA YA EXISTE, CREA OTRA PEEEEEEE")
                permitir = false
                break;
            }
        }
        if (permitir) {
            const agregado = await agregarTareas();
            const dataId = await agregado.json()
            console.log("id obtenido: ", dataId.id)
            idtarea_generado = dataId.id;

            const ultimaTareaAgregada = await obtenerTareaPorId(idtarea_generado)
            console.log("la ultima tarea agregada: ", ultimaTareaAgregada);
            //AGREGA LAS TAREAS AGREGADAS A LA INTERFAZ DE LA LISTA
            ulTareasAgregadas.innerHTML += `
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-3">
                        <p class="tarea-agregada" data-tarea-id="${ultimaTareaAgregada[0]?.idtarea}">${ultimaTareaAgregada[0]?.descripcion} - Tarea: ${ultimaTareaAgregada[0]?.idtarea}</p>
                        <span class="badge bg-primary rounded-pill btn-eliminar-tarea" data-tarea-id="${ultimaTareaAgregada[0]?.idtarea}">
                            <i class="fa-solid fa-trash"></i>
                        </span>
                    </li>
              `;

            formtarea.reset()
            habilitarCamposActivo(false) // esto habilita los campos para agregar los activos vinculados a tarea
            await renderTareasSelect()
            await renderSubCategorias(idcategoria)
            await renderUbicacion()
            const tareasObtenidasAntesDeEliminar = await obtenerTareas()

            //registrarTareasOk = true

            //confirmarEliminacionTarea()
            const liTareaAgregada = $all(".tarea-agregada")
            const btnsEliminarTarea = $all(".btn-eliminar-tarea")
            btnsEliminarTarea.forEach(btn => {
                btn.addEventListener("click", async () => {
                    console.log("PUTAAAAAAAAAAAAAAAAAAAAAA: ", tareasObtenidasAntesDeEliminar)
                    console.log("eliminado")
                    console.log("data-tarea-id: ", btn.getAttribute("data-tarea-id"))
                    const idTarea = parseInt(btn.getAttribute("data-tarea-id"));
                    let procesoEncontrado = false;
                    console.log("ID tarea CLICKEADO: ", idTarea)
                    for (let w = 0; w < tareasObtenidasAntesDeEliminar.length; w++) {
                        if (tareasObtenidasAntesDeEliminar[w].idtarea == idTarea && tareasObtenidasAntesDeEliminar[w].nom_estado == "proceso") {
                            alert("ESTA TAREA NO SE PUEDE ELIMINAR POR QUE YA ESTA EN PROCESO")
                            procesoEncontrado = true;
                            break;
                        }
                    }

                    if (!procesoEncontrado) {
                        //console.log("tarea data en else: ", tareasObtenidasAntesDeEliminar[w])
                        console.log("dataidtara: ", idTarea)
                        console.log("ELIMINADO JAAAJJASASJJAJASJASD")
                        const li = btn.closest("li");
                        li.remove();

                        const activosVinculados = document.querySelectorAll(`li[data-idtarea="${idTarea}"]`);
                        activosVinculados.forEach(activo => activo.remove());

                        //ELIMINAMOS LA TAREA
                        const formEliminacionTarea = new FormData();
                        formEliminacionTarea.append("operation", "eliminarTarea")
                        const eliminado = await fetch(`${host}tarea.controller.php/${idTarea}`, { method: 'POST', body: formEliminacionTarea })
                        const elim = await eliminado.json()
                        console.log("eliminado?: ", elim.eliminado)

                        //CONSULTAMOS LAS TAREAS REGISTRADAS HASTA EL MOMENTO
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
                        await renderTareasSelect()
                        sintareas = true
                        return
                    }
                })
            })
            console.log("sintareas? :", sintareas)
            if (!sintareas) {
                liTareaAgregada.forEach(litarea => {
                    litarea.addEventListener("click", async () => {
                        const idtarea = litarea.getAttribute("data-tarea-id")
                        console.log("click a : ", idtarea)
                        const tareaObtenida = await obtenerTareaPorId(idtarea)
                        //RENDERIZAR INFO EN LOS INPUTS Y SELECT de acuerdo a la tarea obtenida
                        $q("#txtDescripcionTarea").value = tareaObtenida[0].descripcion
                        $q("#txtIntervaloTarea").value = tareaObtenida[0].intervalo
                        $q("#selectFrecuenciaTarea").value = tareaObtenida[0].idfrecuencia
                        /* $q("#fecha-inicio").value = tareaObtenida[0].fecha_inicio
                        $q("#hora-inicio").value = tareaObtenida[0].hora_inicio
                        $q("#fecha-vencimiento").value = tareaObtenida[0].fecha_vencimiento
                        $q("#hora-vencimiento").value = tareaObtenida[0].hora_vencimiento
                         */
                        $q("#tipoPrioridadTarea").value = tareaObtenida[0].idtipo_prioridad
                        $q("#elegirSubCategoriaTarea").value = tareaObtenida[0].idsubcategoria
                        //console.log("fecha: ", $q("#fecha-inicio").value)
                        btnGuardarTarea.style.display = 'none'
                        $q("#elegirSubCategoriaTarea").disabled = true

                        btnsTareaAcciones.innerHTML = `
                            <div class="col-md-4">
                                <button type="button" id="btnActualizarTarea" class="btn btn-success">Actualizar</button>
                            </div>
                            <div class="col-md-4">
                                <button type="button" id="btnCancelarTarea" class="btn btn-danger">Cancelar</button>
                            </div>                            
                        `

                        $q("#btnCancelarTarea").addEventListener("click", () => {
                            formtarea.reset()
                            btnGuardarTarea.style.display = 'block'
                            btnsTareaAcciones.innerHTML = ""
                            $q("#elegirSubCategoriaTarea").disabled = false

                        })

                        $q("#btnActualizarTarea").addEventListener("click", async () => {
                            /* let fechaInicioTarea = $q("#fecha-inicio").value;
                            let horaInicioTarea = $q("#hora-inicio").value;
                            let fechaVencimiento = $q("#fecha-vencimiento").value;
                            let horaVencimiento = $q("#hora-vencimiento").value;

                            // Combinar fecha y hora en objetos Date para cada uno
                            let fechaHoraInicio = new Date(`${fechaInicioTarea}T${horaInicioTarea}:00-05:00`);
                            let fechaHoraVencimiento = new Date(`${fechaVencimiento}T${horaVencimiento}:00-05:00`);

                            // Obtener la fecha y hora actual en horario de Perú
                            let ahora = new Date().toLocaleString("en-US", { timeZone: "America/Lima" });
                            let fechaHoraActual = new Date(ahora);

                            // Validar que las fechas no sean anteriores a hoy
                            if (fechaHoraInicio < fechaHoraActual) {
                                alert("La hora de inicio debe ser a partir de la hora actual.");
                                return;
                            }
                            if (fechaHoraVencimiento < fechaHoraActual) {
                                alert("La hora de vencimiento debe ser a partir de la hora actual.");
                                return;
                            }

                            // Validar que la fecha de inicio no sea posterior a la fecha de vencimiento
                            if (fechaInicioTarea > fechaVencimiento) {
                                alert("La fecha de inicio no puede ser posterior a la fecha de vencimiento.");
                                return;
                            }

                            // Validar que la hora de inicio no sea mayor que la hora de vencimiento si ambas fechas son iguales
                            if (fechaInicioTarea === fechaVencimiento && horaInicioTarea > horaVencimiento) {
                                alert("La hora de inicio no puede ser mayor que la hora de vencimiento en el mismo día.");
                                return;
                            } */
                            // Aquí llamas tu función para actualizar la tarea
                            const formActualizarTarea = new FormData()
                            formActualizarTarea.append("operation", "actualizarTarea")
                            formActualizarTarea.append("idtarea", idtarea)
                            formActualizarTarea.append("idtipo_prioridad", $q("#tipoPrioridadTarea").value)
                            formActualizarTarea.append("descripcion", $q("#txtDescripcionTarea").value)

                            //formActualizarTarea.append("fecha_inicio", $q("#fecha-inicio").value)
                            //formActualizarTarea.append("hora_inicio", $q("#hora-inicio").value)
                            //formActualizarTarea.append("fecha_vencimiento", $q("#fecha-vencimiento").value)
                            //formActualizarTarea.append("hora_vencimiento", $q("#hora-vencimiento").value)
                            formActualizarTarea.append("intervalo", $q("#txtIntervaloTarea").value)
                            formActualizarTarea.append("idfrecuencia", $q("#selectFrecuenciaTarea").value)
                            formActualizarTarea.append("idestado", 8)

                            const response = await fetch(`${host}tarea.controller.php`, {
                                method: "POST",
                                body: formActualizarTarea
                            })

                            const result = await response.json()
                            console.log("Tarea actualizada: ", result)

                            const pTareaActual = document.querySelector(`p[data-tarea-id="${idtarea}"]`);
                            pTareaActual.innerHTML = `
                                ${$q("#txtDescripcionTarea").value} - Tarea: ${idtarea}
                                
                            `;

                            // Aquí puedes refrescar la lista de tareas si es necesario o cualquier acción adicional

                            // Limpiar los campos del formulario y volver al estado inicial
                            formtarea.reset()
                            btnGuardarTarea.style.display = 'block'
                            btnsTareaAcciones.innerHTML = ""
                            $q("#elegirSubCategoriaTarea").disabled = false

                        })
                    })
                })
            }

        }
    })

    //AGREGA EL PLAN DE TAREA
    btnGuardarPlanTarea.addEventListener("click", async () => {
        let permitir = true
        const descripcionPlanTarea = $q("#txtDescripcionPlanTarea");
        if (
            !descripcionPlanTarea.value.trim()
            //!/^[a-zA-Z\s]+$/.test(descripcionPlanTarea.value)
        ) {
            alert("Redacte bien su descripcion.");
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
            formPlan.append("operation", "add")
            formPlan.append("descripcion", descripcionPlanTarea.value)
            formPlan.append("idcategoria", selectCategoria.value)
            const fregistro = await fetch(`${host}plandetarea.controller.php`, { method: 'POST', body: formPlan })
            const registro = await fregistro.json()
            console.log("registro: ", registro)
            idcategoria = selectCategoria.value
            idplantarea_generado = registro.id ? registro.id : -1; //EL IDPLANTAREA GENERADO DESPUES DE CREAR EL PLAN SE ASIGNARA A ESA VARIABLE PARA PDOER VINCULAR LAS NEUVAS TAREAS AGREGADAS A ESE PLAN, SI NO ESTA CREADA ENTONCES TOMARA -1 EL CUAL SI INTENTAMOS AGREGAR UNA TAREA PUES NO SE PODRA CON -1
            console.log("idplantarea_generado: ", idplantarea_generado);
            await loadFunctions();
            habilitarCamposTarea(false);
            selectCategoria.disabled = true
            btnTerminarPlan.disabled = false
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
                        <span class="badge bg-primary rounded-pill btn-eliminar" data-idactivovinculado="${avt.idactivo_vinculado}">
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
        await filtrarActivosList()
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
            window.location.href = `http://localhost/CMMS/views/plantareas`
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

})