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
    //TABLAS
    const activosList = $q("#activosBodyTable");
    //UL
    const listaActivosAsignados = $q(".listaActivosAsignados")
    // LISTAS
    let activosElegidos = []
    //let activosElegidosPrevia = []
    //SELECTS
    const selectElegirTareaParaActivo = $q("#elegirTareaParaActivo");
    const selectSubCategoria = $q("#elegirSubCategoria")
    const selectUbicacion = $q("#elegirUbicacion")
    //BOTONES
    const btnAgregarActivos = $q("#btnAgregarActivos")
    const btnTerminarPlan = $q("#btnTerminarPlan")
    //ESTADOS
    let habilitarBeforeUnload = true
    //let registrarTareasOk = false
    //let registrarActivosOk = false
    let btnTerminarPlanHabilitado = false

    renderTablaActivos()

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
        selectElegirTareaParaActivo.innerHTML =
            "<option value='-1'>Seleccione una tarea</option>"; // Opción predeterminada

        for (let i = 0; i < data.length; i++) {    
            selectElegirTareaParaActivo.innerHTML += `
                <option value="${data[i].idtarea}">${data[i].descripcion}</option>
            `;
        }
    }

    function renderTablaActivos(){
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

    async function renderSubCategorias() {
        const data = await getDatos(`${host}subcategoria.controller.php`, `operation=getSubCategoria`) 

        selectSubCategoria.innerHTML = `<option selected value="-1">Sub Categoria</option>`
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
        params.append("idsubcategoria", (selectSubCategoria.value.trim() === "" || selectSubCategoria.value == -1) ? null : selectSubCategoria.value) //
        params.append("idubicacion", (selectUbicacion.value.trim() === "" || selectUbicacion.value == -1) ? null : selectUbicacion.value) //
        params.append("cod_identificacion", "")

        const data = await getDatos(`${host}activo.controller.php`, params)        
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

    filters.forEach(select => {
        select.addEventListener("change", async () => {
            await filtrarActivosList()
        })
    })

    async function obtenerTareas() {
        const paramsTareasSearch = new URLSearchParams()
        paramsTareasSearch.append("operation", "obtenerTareasPorPlanTarea")
        paramsTareasSearch.append("idplantarea", idplantarea_generado)
        const tareasRegistradasObtenidas = await getDatos(`${host}tarea.controller.php`,paramsTareasSearch)
        return tareasRegistradasObtenidas
    }

    async function obtenerActivosVinculados(){
        const paramsObtenerAVT = new URLSearchParams()
        paramsObtenerAVT.append("operation", "listarActivosPorTareaYPlan")
        paramsObtenerAVT.append("idplantarea", idplantarea_generado)
        const avtData = await getDatos(`${host}activosvinculados.controller.php`, paramsObtenerAVT)
        return avtData
    }

    async function eliminarPlanTarea(idplantarea) {
        const paramsEliminacion = new FormData()
        paramsEliminacion.append("operation", "eliminarPlanDeTarea")
        const Fborrado = await fetch(`${host}plandetarea.controller.php/${idplantarea}`, { method: 'POST', body: paramsEliminacion })
        const borrado = Fborrado.json()
        return borrado
    }

    /* ********************************************* EVENTOS *************************************************** */

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
            //AGREGA LAS TAREAS AGREGADAS A LA INTERFAZ DE LA LISTA
            ulTareasAgregadas.innerHTML += `
                    <li class="list-group-item d-flex justify-content-between align-items-center tarea-agregada mb-3" data-tarea-id="${ultimaTareaAgregada[0]?.idtarea}">
                        ${ultimaTareaAgregada[0]?.descripcion} - Tarea: ${ultimaTareaAgregada[0]?.idtarea}
                        <span class="badge bg-primary rounded-pill btn-eliminar-tarea" data-tarea-id="${ultimaTareaAgregada[0]?.idtarea}">
                            <i class="fa-solid fa-trash"></i>
                        </span>
                    </li>
              `;

            formtarea.reset()
            habilitarCamposActivo(false) // esto habilita los campos para agregar los activos vinculados a tarea
            await renderTareasSelect()
            await renderSubCategorias()
            await renderUbicacion()
            //registrarTareasOk = true
        
            //confirmarEliminacionTarea()

            const btnsEliminarTarea = $all(".btn-eliminar-tarea")
            btnsEliminarTarea.forEach(btn => {
                btn.addEventListener("click", async ()=>{
                    console.log("eliminado")
                    console.log("data-tarea-id: ", btn.getAttribute("data-tarea-id"))
                    const idTarea = parseInt(btn.getAttribute("data-tarea-id"));
                    console.log("ID tarea CLICKEADO: ", idTarea)
                    const li = btn.closest("li");
                    li.remove();

                    const activosVinculados = document.querySelectorAll(`li[data-idtarea="${idTarea}"]`);
                    activosVinculados.forEach(activo => activo.remove());

                    //ELIMINAMOS LA TAREA
                    const formEliminacionTarea = new FormData();
                    formEliminacionTarea.append("operation", "eliminarTarea")
                    const eliminado = await fetch(`${host}tarea.controller.php/${idTarea}`, {method: 'POST', body:formEliminacionTarea } )
                    const elim = await eliminado.json()
                    console.log("eliminado?: ", elim.eliminado)
                    
                    //CONSULTAMOS LAS TAREAS REGISTRADAS HASTA EL MOMENTO
                    const tareasRegistradasObtenidas = await obtenerTareas()
                    const avtObtenidas = await obtenerActivosVinculados()
                    console.log("tareasRegistradasObtenidas: ", await tareasRegistradasObtenidas) // me quede aca
                    console.log("avt data hasta el momento: ", avtObtenidas)

                    if(elim.eliminado){
                        if(tareasRegistradasObtenidas.length == 0 || avtObtenidas.length == 0){
                            console.log("ya no hay tareas");
                            btnTerminarPlanHabilitado = false;
                            btnTerminarPlan.disabled = true;  
                            habilitarCamposActivo(true)                           
                        }
                    }   
                    await renderTareasSelect()       
                     
                })
            })
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

    //AGREGAR UN ACTIVO VINCULADO TAREA
    $q("#btnAgregarActivos").addEventListener("click", async () => {
        estado = false
        const paramsAVTsearch = new URLSearchParams()
        paramsAVTsearch.append("operation", "listarActivosPorTareaYPlan")
        paramsAVTsearch.append("idplantarea", idplantarea_generado)
        const avtdata = await getDatos(`${host}activosvinculados.controller.php`,paramsAVTsearch)
        console.log("avtdata: ", avtdata)

        if (parseInt(selectElegirTareaParaActivo.value) === -1) { // si es que manipulan el console de google
            console.log("eliga una tarea valida")
            return
        }
        for (let e = 0; e < activosElegidos.length; e++) {
            for (let f = 0; f < avtdata.length; f++) {                
                if(avtdata[f].idactivo == activosElegidos[e].idactivo && avtdata[f].idtarea == activosElegidos[e].idtarea){
                    alert("este activo ya esta registrado a esa tarea .....")
                    estado = true;
                    break;
                }
            }
            if(estado){
                return
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
            const activoVinculadoTareaObtenido = await getDatos(`${host}activosvinculados.controller.php`,params)
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
        selectSubCategoria.value = ""
        selectUbicacion.value = ""
        const checkboxes = document.querySelectorAll(".activo-checkbox:checked");
        activosList.innerHTML = ""
        checkboxes.forEach(chk => {
            chk.checked = false;  // Deselecciona el checkbox
        });

        const avtObtenidos = await obtenerActivosVinculados()
        if(avtObtenidos.length == 0){
            console.log("ya no hay tareas");
            btnTerminarPlanHabilitado = false;
            btnTerminarPlan.disabled = true;
        }else{
            btnTerminarPlanHabilitado = true;
            btnTerminarPlan.disabled = false
        }
    
    })

    listaActivosAsignados.addEventListener("click", async (event)=>{
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
            const avtdata = await getDatos(`${host}activosvinculados.controller.php`,paramsAVTsearch)
            console.log("avtdata: ", avtdata)
    
            if (elim.eliminado) {
                console.log("AVDATA ANTES DE VERIFICAR: ", avtdata);
                console.log("avtdata.length antes de verificar: ", avtdata.length);
                if (avtdata.length === 0) {
                    console.log("ya no hay activos vinculados");
                    btnTerminarPlanHabilitado = false;
                    btnTerminarPlan.disabled = true;
                }
            }
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

    btnTerminarPlan.addEventListener("click", ()=>{
        console.log("estando cuando de click al btn terminar plan")        
        console.log("pasando por el btn terminar plan")
        habilitarBeforeUnload = false
        window.location.href = `http://localhost/CMMS/views/plantareas`               
        
        
    })

    window.addEventListener("beforeunload", (event) => {
        if (habilitarBeforeUnload) {
            (async () => {
                const borrado = await eliminarPlanTarea(window.localStorage.getItem("idplantarea"));
                console.log("borrado?: ", borrado)
                return
            })();
            window.localStorage.removeItem("idplantarea");
            event.preventDefault(); // Ya no es necesario en la mayoría de los navegadores, pero se deja por compatibilidad
            event.returnValue = ''; // Requerido para mostrar el diálogo de confirmación de salida
        }
    });

})