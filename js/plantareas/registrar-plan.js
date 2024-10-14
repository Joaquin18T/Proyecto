document.addEventListener("DOMContentLoaded", async () => {
    function $(object = null) {
        return document.querySelector(object);
    }

    async function getDatos(link, params) {
        let data = await fetch(`${link}?${params}`);
        return data.json();
    }

    const host = "http://localhost/CMMS/controllers/";
    let idplantarea_generado = -1;
    const btnGuardarPlanTarea = $("#btnGuardarPlanTarea");

    if (window.localStorage.getItem("idplantarea")) {
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
                        $("#btnGuardarPlanTarea").remove()
                        $("#txtDescripcionPlanTarea").disabled = true
                        console.log("ID PLANTAREA GENERADO DSPUES DE RETOMAR: ", idplantarea_generado)
                        return;
                    }
                    window.localStorage.clear()
                    console.log("borrando y creando uno nuevo ...");
                }
            }
        })();
    }

    function habilitarCamposTarea(habilitado = true) {
        $("#txtDescripcionTarea").disabled = habilitado
        $("#fecha-inicio").disabled = habilitado
        $("#fecha-vencimiento").disabled = habilitado
        $("#txtIntervaloTarea").disabled = habilitado
        $("#txtFrecuenciaTarea").disabled = habilitado
        $("#tipoPrioridadTarea").disabled = habilitado
        $("#txtDescripcionPlanTarea").disabled = !habilitado
        $("#btnGuardarPlanTarea").remove()
        $("#btnGuardarTarea").disabled = habilitado
    }

    function habilitarCamposActivos(habilitado = true) {
        $("#btnSeleccionarActivo").disabled = habilitado
        $("#btnConfirmarCambios").disabled = habilitado
    }

    //await loadFunctions()

    async function loadFunctions() {
        await renderPrioridades()
        //await renderActivosList()
    }

    async function renderPrioridades() {
        const data = await getDatos(`${host}tipoprioridad.controller.php`, `operation=getAll`)

        //selects de prioridades
        const selectPrioridades = $("#tipoPrioridadTarea");
        selectPrioridades.innerHTML += `<option selected>Tipo de prioridad</option>`
        for (let i = 0; i < data.length; i++) {
            selectPrioridades.innerHTML += `
                <option value="${data[i].idtipo_prioridad}">${data[i].tipo_prioridad}</option>
              `;
        }
    }

    async function agregarTareas() {
        const descripcionTarea = $("#txtDescripcionTarea");
        const intervaloTarea = $("#txtIntervaloTarea");
        const frecuenciaTarea = $("#txtFrecuenciaTarea");
        const fechaInicioTarea = $("#fecha-inicio");
        const fechaVencimiento = $("#fecha-vencimiento");

        let formTarea = new formTareaData();
        formTarea.append("operation", "tarea")
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

    /* async function renderActivosList() {
        const data = await getDatos(`${host}`)
        console.log("activos totales en toda la bd", data);
        for (let i = 0; i < data.length; i++) {
            const activosList = $("#activosBodyTable");
            activosList.innerHTML += `
                    <tr>
                      <th scope="row">
                        <input type="checkbox" class="activo-checkbox" value="${data[i].idactivo}">
                      </th>
                      <td>${data[i].activo}</td>
                      <td>${data[i].cod_identificacion}</td>
                      <td>${data[i].categoria}</td>
                      <td>${data[i].subcategoria}</td>
                      <td>${data[i].marca}</td>
                      <td>${data[i].modelo}</td>
                    </tr>
                  `;
        }

        new DataTable('#tablaActivos', {
            columnDefs: [
                {
                    orderable: true
                }
            ],
            fixedColumns: {
                start: 2
            },
            order: [[1, 'asc']],
            paging: false,
            scrollCollapse: true,
            scrollX: true,
            scrollY: 300,
            select: {
                style: 'os',
                selector: 'td:first-child'
            }
        });
    } */

    /* *************** SECCION DE RENDERIZADOS SI HAY PLANES EXISTENTES *************** */
    async function renderPlanTarea(txtDescripcion) {
        const descripcionPlanTarea = $("#txtDescripcionPlanTarea");
        descripcionPlanTarea.value = txtDescripcion;
    }

    /* ********************** EVENTOS *************************************************** */
    $("#form-tarea").addEventListener("submit", async (e) => {
        e.preventDefault()
        let permitir = true
        const formtarea = $("#form-tarea");
        //const ulTareasAgregadas = $(".listaTareasAgregadas");
        const tareasExistentes = await getDatos(`${host}tareas.controller.php`, `operation=obtenerTareas`)
        console.log("tareasExistentes: ", tareasExistentes)
        for (let i = 0; i < tareasExistentes.length; i++) {
            if ($("#txtDescripcionTarea").value == tareasExistentes[i].descripcion) {
                alert("ESTA TAREA YA EXISTE, CREA OTRA PEEEEEEE")
                permitir = false
                break;
            }

        }
        if (permitir) {
            const data = await agregarTareas();
            console.log("id obtenido: ", data);
            /* idtarea_generado = data[0].id;
            recursosSeleccionados.forEach(async (recurso) => {
                recurso.idtarea = idtarea_generado;
                console.log(recurso);
                const formRecursos = new FormData();
                formRecursos.append("idrecurso", recurso.idrecurso);
                formRecursos.append("idtarea", recurso.idtarea);
                formRecursos.append("cantidad", recurso.cantidad);
                await axios.post(
                    "/" + rol + "/tareas/plantareas/recursosvinculados/registrar",
                    formRecursos
                );
            });

            console.log(recursosSeleccionados);
            recursosSeleccionados = [];
            console.log(recursosSeleccionados);
            const ultimaTareaAgregada = await axios.get(
                `/transparenciawsrest/consulta/tarea/${idtarea_generado}`
            );
            console.log("la ultima tarea agregada: ", ultimaTareaAgregada.data);

            //Agregar la tarea a la lista de tareas agregadas
            ulTareasAgregadas.innerHTML += `
                <div>
                  <li data-tarea-id="${ultimaTareaAgregada.data[0]?.idtarea}" class="tarea-agregada">
                    ${ultimaTareaAgregada.data[0]?.descripcion} - Tarea: ${ultimaTareaAgregada.data[0]?.idtarea}
                    <button class="btn-eliminar-tarea" data-tarea-id="${ultimaTareaAgregada.data[0]?.idtarea}">Eliminar</button>
                  </li>  						
                </div>
              `;

            //ESTO RENDERIZA LA NUEVA TAREA HACIA EL SELECT DE SELECCIONAR TAREAR PARA ACTIVOS ( ASIGNACION DE ACTIVOS A TAREAS)
            selectElegirTareaParaActivo.innerHTML += `
                <option value="${ultimaTareaAgregada.data[0]?.idtarea}">${ultimaTareaAgregada.data[0]?.descripcion}</option>
              `;
            formtarea.reset()
            habilitarCamposActivos(false)
            confirmarEliminacionTarea() */
        }

    })

    btnGuardarPlanTarea.addEventListener("click", async () => {
        let permitir = true
        const descripcionPlanTarea = $("#txtDescripcionPlanTarea");
        if (
            !descripcionPlanTarea.value.trim() ||
            !/^[a-zA-Z\s]+$/.test(descripcionPlanTarea.value)
        ) {
            alert("Solo se permite letras y espacios");
            return;
        }
        const formPlanTarea = new FormData();
        formPlanTarea.append("descripcion", descripcionPlanTarea.value);
        formPlanTarea.append("borrador", 1) //cuando se registra un nuevo plan se genera en forma borrador
        //PRIMER PASO: VERIFICAR SI EL PLAN A REGISTRAR YA EXISTE
        const obtenerPlanDeTareas = await getDatos(`${host}plandetarea.controller.php`,`operation=getPlanesDeTareas`)
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
            const fregistro = await fetch(`${host}plandetarea.controller.php`, {method: 'POST', body: formPlan})
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

})