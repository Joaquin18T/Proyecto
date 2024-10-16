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
    const btnGuardarPlanTarea = $q("#btnGuardarPlanTarea");
    const filters = $all(".filter")
    //UL
    //const listaActivosAsignadosPrevia = $q(".listaActivosAsignadosPrevia")
    // LISTAS
    let activosElegidos = []
    //let activosElegidosPrevia = []
    //SELECTS
    const selectElegirTareaParaActivo = $q("#elegirTareaParaActivo");
    const selectSubCategoria = $q("#elegirSubCategoria")
    const selectUbicacion = $q("#elegirUbicacion")
    //BOTONES
    //const btnConfirmarCambios = $q("#btnConfirmarCambios")
    const btnAgregarActivos = $q("#btnAgregarActivos")
    //ESTADOS

    /* if (window.localStorage.getItem("idplantarea")) {
        (async () => {
            const params = new URLSearchParams()
            params.append("operation", "verificarPlanInconcluso")
            params.append("idplantarea", window.localStorage.getItem("idplantarea"))
            const data = await getDatos(`${host}plandetarea.controller.php`, params);
            console.log("verificarTareaInconclusa: ", data);
            if (data.length > 0) {
                if (data[0].cantidad_tareas < 1 || data[0].cantidad_activos < 1) {
                    if (confirm("Tienes un plan de tareas inconcluso, deseas retomarlo?")) {
                        console.log("retomado");
                        idplantarea_generado = data[0].idplantarea;
                        renderPlanTarea(data[0].descripcion);
                        await loadFunctions()
                        habilitarCamposTarea(false);
                        habilitarCamposActivo(false)
                        $q("#btnGuardarPlanTarea").remove()
                        $q("#txtDescripcionPlanTarea").disabled = true
                        console.log("ID PLANTAREA GENERADO DSPUES DE RETOMAR: ", idplantarea_generado)
                        return;
                    }
                    window.localStorage.clear()
                    console.log("borrando y creando uno nuevo ...");
                }
            }
        })();
    } */

    function habilitarCamposTarea(habilitado = true) {
        $q("#txtDescripcionTarea").disabled = habilitado
        $q("#fecha-inicio").disabled = habilitado
        $q("#fecha-vencimiento").disabled = habilitado
        $q("#txtIntervaloTarea").disabled = habilitado
        $q("#txtFrecuenciaTarea").disabled = habilitado
        $q("#tipoPrioridadTarea").disabled = habilitado
        $q("#txtDescripcionPlanTarea").disabled = !habilitado
        $q("#btnGuardarPlanTarea").remove()
        $q("#btnGuardarTarea").disabled = habilitado
    }

    function habilitarCamposActivo(habilitado = true) {
        selectElegirTareaParaActivo.disabled = habilitado
        selectSubCategoria.disabled = habilitado
        selectUbicacion.disabled = habilitado
        //btnConfirmarCambios.disabled = habilitado
        btnAgregarActivos.disabled = habilitado
    }

    async function loadFunctions() {
        await renderPrioridades()
        //await renderActivosList()           
    }


    async function renderTareasSelect() { // ESTO RENDERIZARA LAS TAREAS EN EL SELECT
        const params = new URLSearchParams()
        params.append("operation", "obtenerTareasPorPlanTarea")
        params.append("idplantarea", idplantarea_generado)
        const data = await getDatos(`${host}tarea.controller.php`, params)

        console.log("tareas obtenidas recien creadas: ", data)
        console.log("idplantarea_generado: ", idplantarea_generado)
        //ulTareasAgregadas.innerHTML = "";
        selectElegirTareaParaActivo.innerHTML =
            "<option value='-1'>Seleccione una tarea</option>"; // Opción predeterminada

        for (let i = 0; i < data.length; i++) {
            /* ulTareasAgregadas.innerHTML += `
              <li data-tarea-id="${data[i].idtarea}">${data[i].descripcion}</li>
            `; */
            selectElegirTareaParaActivo.innerHTML += `
                <option value="${data[i].idtarea}">${data[i].descripcion}</option>
            `;
        }
    }

    async function renderUbicacion() {
        const data = await getDatos(`${host}ubicacion.controller.php`, `operation=getAll`)
        selectUbicacion.innerHTML += `<option selected>Ubicacion</option>`
        for (let i = 0; i < data.length; i++) {
            selectUbicacion.innerHTML += `
                <option value="${data[i].idubicacion}">${data[i].ubicacion}</option>
              `;
        }
    }

    async function renderSubCategorias() {
        const data = await getDatos(`${host}subcategoria.controller.php`, `operation=getSubCategoria`)

        selectSubCategoria.innerHTML += `<option selected>Sub Categoria</option>`
        for (let i = 0; i < data.length; i++) {
            selectSubCategoria.innerHTML += `
                <option value="${data[i].idsubcategoria}">${data[i].subcategoria}</option>
              `;
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

    async function agregarTareas() {
        const descripcionTarea = $q("#txtDescripcionTarea");
        const intervaloTarea = $q("#txtIntervaloTarea");
        const frecuenciaTarea = $q("#txtFrecuenciaTarea");
        const fechaInicioTarea = $q("#fecha-inicio");
        const fechaVencimiento = $q("#fecha-vencimiento");

        let formTarea = new FormData();
        formTarea.append("operation", "add")
        formTarea.append("idplantarea", idplantarea_generado);
        formTarea.append("idtipo_prioridad", tipoPrioridadTarea.value);
        formTarea.append("descripcion", descripcionTarea.value);
        formTarea.append("fecha_inicio", fechaInicioTarea.value);
        formTarea.append("fecha_vencimiento", fechaVencimiento.value);
        formTarea.append("cant_intervalo", intervaloTarea.value);
        formTarea.append("frecuencia", frecuenciaTarea.value);
        formTarea.append("idestado", 8);
        //console.log("agregar tareas idplantarea: ", idplantarea_generado)
        const data = await fetch(`${host}tarea.controller.php`, { method: 'POST', body: formTarea })
        return data;
    }

    async function filtrarActivosList() {
        const params = new URLSearchParams()
        params.append("operation", "searchActivoResponsable")
        params.append("idsubcategoria", selectSubCategoria.value) //
        params.append("idubicacion", selectUbicacion.value) //
        params.append("cod_identificacion", "")

        const data = await getDatos(`${host}activo.controller.php`, params)
        const activosList = $q("#activosBodyTable");
        activosList.innerHTML = "";
        //        activosList.innerHTML = ""
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


        //const chkActivo = $all(".activo-checkbox:checked")

    }

    function agregarActivosTarea() {
        /* activosElegidos.forEach(activo => {
            activosElegidosPrevia.push({
                idact_resp: parseInt(activo.idact_resp),
                idactivo: parseInt(activo.idactivo),
                descripcion: activo.descripcion,
                idtarea: parseInt(activo.idtarea)
            })
        })
        activosElegidos = []
        console.log("ACTIVS ELEGIDOS YA ELIMNADOS PQ YA PASARON A PREVIA: ", activosElegidos)
        console.log("Activos agregados a la nueva lista previa:", activosElegidosPrevia); */
        //LOGICA DE AGREGADO DE ACTIVOS VINCULADOS A TAREA A LA BD
    }

    filters.forEach(select => {
        select.addEventListener("change", async () => {
            await filtrarActivosList()
        })
    })

    /* function renderActivosPrevia() {
        console.log("aaaaaaaaaaaaaaa: ", activosElegidosPrevia)
        activosElegidosPrevia.forEach((activo, key) => {
            listaActivosAsignadosPrevia.innerHTML += `
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    ${activo.descripcion}
                    <span class="badge bg-primary rounded-pill btn-eliminar " data-id="${key}" data-idactresp="${activo.idact_resp}">
                        <i class="fa-solid fa-trash"></i>
                    </span>
                </li>
            `
        });
        const btnsEliminar = document.querySelectorAll(".btn-eliminar");
        btnsEliminar.forEach(btn => {
            btn.addEventListener("click", function () {
                const idActivoResp = parseInt(this.getAttribute("data-idactresp"));
                console.log("ID ACTIVO RESP CLICKEADO: ", idActivoResp)
                const li = this.closest("li");
                li.remove();
                activosElegidosPrevia = activosElegidosPrevia.filter(activo => activo.idact_resp !== idActivoResp);
                console.log("Lista de activos actualizada: ", activosElegidosPrevia);
            });
        });
        console.log("LISTA DE ACTIVOS ELEGIDOS PREVIA ACTUALIZADA DESPUES DE ELMINAR: ", activosElegidosPrevia)
    } */
    /* *************** SECCION DE RENDERIZADOS SI HAY PLANES EXISTENTES *************** */
    /* async function renderPlanTarea(txtDescripcion) {
        const descripcionPlanTarea = $q("#txtDescripcionPlanTarea");
        descripcionPlanTarea.value = txtDescripcion;
    }
 */

    function renderActivosVinculadosAgregados() {

    }
    /* ********************** EVENTOS *************************************************** */
    //AGREGAR NUEVA TAREA, FORMATEAR EL FORMULARIO TAREA, HABILITAR CAMPOS ACTIVOS Y RENDERIZAR LA TAREA AGREGADA AL SELECT
    $q("#form-tarea").addEventListener("submit", async (e) => {
        e.preventDefault()
        let permitir = true
        const formtarea = $q("#form-tarea");
        const ulTareasAgregadas = $q(".listaTareasAgregadas");
        const tareasExistentes = await getDatos(`${host}tarea.controller.php`, `operation=obtenerTareas`)
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

            const params = new URLSearchParams()
            params.append("operation", "obtenerTareaPorId")
            params.append("idtarea", idtarea_generado)
            const ultimaTareaAgregada = await getDatos(`${host}tarea.controller.php`, params)
            console.log("la ultima tarea agregada: ", ultimaTareaAgregada);

            ulTareasAgregadas.innerHTML += `
                <div>
                  <li data-tarea-id="${ultimaTareaAgregada[0]?.idtarea}" class="tarea-agregada">
                    ${ultimaTareaAgregada[0]?.descripcion} - Tarea: ${ultimaTareaAgregada[0]?.idtarea}
                    <button class="btn-eliminar-tarea" data-tarea-id="${ultimaTareaAgregada[0]?.idtarea}">Eliminar</button>
                  </li>  						
                </div>
              `;

            formtarea.reset()
            habilitarCamposActivo(false) // esto habilita los campos para agregar los activos vinculados a tarea
            await renderTareasSelect()
            await renderSubCategorias()
            await renderUbicacion()
            //confirmarEliminacionTarea()
        }

    })

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
        //const formPlanTarea = new FormData();
        //formPlanTarea.append("descripcion", descripcionPlanTarea.value);
        //formPlanTarea.append("borrador", 1) //cuando se registra un nuevo plan se genera en forma borrador

        //PRIMER PASO: VERIFICAR SI EL PLAN A REGISTRAR YA EXISTE
        const obtenerPlanDeTareas = await getDatos(`${host}plandetarea.controller.php`, `operation=getPlanesDeTareas`)
        for (let i = 0; i < obtenerPlanDeTareas.length; i++) {
            if (descripcionPlanTarea.value == obtenerPlanDeTareas[i].descripcion) {
                alert("ESTE PLAN YA EXISTE, CREA OTRO")
                permitir = false
                break;
            }

        }
        if (permitir) {
            //SEGUNDO PASO: REGISTRAR PLAN DE TAREA
            const formPlan = new FormData()
            formPlan.append("operation", "add")
            formPlan.append("descripcion", descripcionPlanTarea.value)
            const fregistro = await fetch(`${host}plandetarea.controller.php`, { method: 'POST', body: formPlan })
            const registro = await fregistro.json()
            console.log("registro: ", registro)
            idplantarea_generado = registro.id ? registro.id : -1; //EL IDPLANTAREA GENERADO DESPUES DE CREAR EL PLAN SE ASIGNARA A ESA VARIABLE PARA PDOER VINCULAR LAS NEUVAS TAREAS AGREGADAS A ESE PLAN, SI NO ESTA CREADA ENTONCES TOMARA -1 EL CUAL SI INTENTAMOS AGREGAR UNA TAREA PUES NO SE PODRA CON -1
            console.log("idplantarea_generado: ", idplantarea_generado);
            //GUARDAR EL ID DEL PLAN TAREA SERVIRA PARA VERIFICAR CUANDO SE VA SIN HABER TERMINADO DE COMPLETAR TODO "BORRADOR".
            window.localStorage.clear();
            window.localStorage.setItem("idplantarea", idplantarea_generado);
            await loadFunctions();
            habilitarCamposTarea(false);
        }
    });

    $q("#btnAgregarActivos").addEventListener("click", async () => {
        if (parseInt(selectElegirTareaParaActivo.value) === -1) { // si es que manipulan el console de google
            console.log("eliga una tarea valida")
            return
        }
        for (let e = 0; e < activosElegidos.length; e++) {
            const formAVT = new FormData()
            formAVT.append("operation", "insertarActivoPorTarea")
            formAVT.append("idactivo", activosElegidos[e].idactivo)
            formAVT.append("idtarea", activosElegidos[e].idtarea)
            const fAvt = await fetch(`${host}activosvinculados.controller.php`, { method: 'POST', body: formAVT })
            const id = await fAvt.json()
            console.log("ID ACTIVO VINCULADO CREADO: ", id)

            const params = new URLSearchParams()
            params.append("operation", "obtenerUnActivoVinculadoAtarea")
            params.append("idactivovinculado", id)
            const activoVinculadoTareaObtenido = await getDatos(`${host}activosvinculados.controller.php`,params)
            console.log("activoVinculadoTareaObtenido: ", activoVinculadoTareaObtenido) // me quede aca
        }

        //agregarActivosTarea()
        //console.log("lista de activos agregados: ", activosElegidosPrevia)
        activosElegidos = []
        selectElegirTareaParaActivo.value = ""
        selectSubCategoria.value = ""
        selectUbicacion.value = ""
        const checkboxes = document.querySelectorAll(".activo-checkbox:checked");
        checkboxes.forEach(chk => {
            chk.checked = false;  // Deselecciona el checkbox
        });
        //renderActivosPrevia()
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

})