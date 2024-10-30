$(document).ready(async () => {
    //alert("idusuario: " + idusuario)
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

    //VARIABLES
    let idtarea = -1
    let iddiagnosticoEntrada = -1
    let iddiagnosticoSalida = -1
    const host = "http://localhost/CMMS/controllers/";
    let idordengenerada = window.localStorage.getItem("idodt")

    //UI
    const contenedorRevisarOdt = $q("#contenedor-revisar-odt")
    const txtDiagnosticoEntrada = $q("#txtDiagnosticoEntrada")
    const txtDiagnosticoSalida = $q("#txtDiagnosticoSalida")
    const txtComentario = $q("#comentario")
    const btnFinalizar = $q("#btn-finalizar")
    const contenedorResponsablesOdt = $q(".contenedor-responsablesOdt")
    const contenedorDetallesOdtEntrada = $q(".contenedor-detallesOdtEntrada") // DIV
    const contenedorDetallesOdtSalida = $q(".contenedor-detallesOdtSalida") // DIV
    const contenedorEvidenciaPreviaEntrada = $q("#preview-container-entrada")
    const contenedorEvidenciaPreviaSalida = $q("#preview-container-salida")


    //EJECUTAR PRIMERO LO GENERAL
    await verificarOdtEstado()

    //Ejecutar funciones 
    await renderUI()

    //RENDERIZAR
    await verificarCantidadEvidenciasEntrada()
    await verificarEvidenciasRegistradas()
    /* await renderDiagnosticoEntrada()
    await renderDetalles()
    await renderResponsables()
    
    await verificarDiagnosticoSalidaRegistrado()
    await verificarEvidenciasRegistradas()
    await verificarDetalleOdtRegistrado() */

    // ******************* SECCION DE OBTENER DATOS ********************************************************

    async function obtenerOdt() {
        const params = new URLSearchParams()
        params.append("operation", "obtenerTareaDeOdtGenerada")
        params.append("idodt", idordengenerada)
        const odt = await getDatos(`${host}ordentrabajo.controller.php`, params)
        idtarea = odt[0].idtarea
        console.log("odt: ", odt)
        return odt
    }

    async function obtenerEvidencias(iddiagnostico) {
        console.log("ID DIAGNOSTICO AAA: ", iddiagnostico)
        const params = new URLSearchParams()
        params.append("operation", "obtenerEvidenciasDiagnostico")
        params.append("iddiagnostico", iddiagnostico)
        const evidencias = await getDatos(`${host}diagnostico.controller.php`, params)
        console.log("evidencias: ", evidencias)
        return evidencias
    }

    async function obtenerDiagnostico(tipo) {
        const paramsDiagnosticoBuscar = new URLSearchParams()
        paramsDiagnosticoBuscar.append("operation", "obtenerDiagnostico")
        paramsDiagnosticoBuscar.append("idordentrabajo", idordengenerada)
        paramsDiagnosticoBuscar.append("idtipodiagnostico", tipo)
        const diagnosticoObtenido = await getDatos(`${host}diagnostico.controller.php`, paramsDiagnosticoBuscar)
        console.log("diagnostico : ", diagnosticoObtenido)
        return diagnosticoObtenido
    }

    async function obtenerTareaPorId(idtarea) {
        const params = new URLSearchParams()
        params.append("operation", "obtenerTareaPorId")
        params.append("idtarea", idtarea)
        const ultimaTareaAgregada = await getDatos(`${host}tarea.controller.php`, params)
        console.log("tarea obtenida: ", ultimaTareaAgregada)
        return ultimaTareaAgregada
    }

    async function obtenerActivosPorTarea(idtarea) {
        const params = new URLSearchParams()
        params.append("operation", "obtenerActivosPorTarea")
        params.append("idtarea", idtarea)
        const activo = await getDatos(`${host}activo.controller.php`, params)
        console.log("activo: ", activo)
        return activo
    }

    async function obtenerResponsablesAsignados() {
        const params = new URLSearchParams()
        params.append("operation", "obtenerResponsables")
        params.append("idodt", idordengenerada)
        const responsables = getDatos(`${host}responsablesAsignados.controller.php`, params)
        return responsables
    }

    async function obtenerDetalleOdt() {
        const params = new URLSearchParams()
        params.append("operation", "obtenerDetalleOdt")
        params.append("idordentrabajo", idordengenerada)
        const detalleOdt = await getDatos(`${host}ordentrabajo.controller.php`, params)
        console.log("detalle odt: ", detalleOdt)
        return detalleOdt
    }

    async function obtenerOdtporId() {
        const params = new URLSearchParams()
        params.append("operation", "obtenerOdtporId")
        params.append("idodt", idordengenerada)
        const odt = await getDatos(`${host}ordentrabajo.controller.php`, params)
        return odt
    }

    // ******************* FIN SECCION DE OBTENER DATOS ****************************************************

    // *********************************** SECCION DE REGISTROS **********************************************

    async function registrarComentario() {
        const formRegistro = new FormData()
        formRegistro.append("operation", "registrarComentarioOdt")
        formRegistro.append("idodt", idordengenerada)
        formRegistro.append("comentario", txtComentario.value)
        formRegistro.append("revisadopor", idusuario)
        const Fcomentario = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formRegistro })
        const comentario = await Fcomentario.json()
        return comentario
    }

    async function registrarHistorialOdt() {
        const formRegistroHistorialOdt = new FormData()
        formRegistroHistorialOdt.append("operation", "registrarHistorialOdt")
        formRegistroHistorialOdt.append("idodt", idordengenerada)
        const Fcomentario = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formRegistroHistorialOdt })
        const comentario = await Fcomentario.json()
        return comentario
    }

    // ******************************* FIN DE SECCION DE REGISTROS *******************************************

    // ********************** SECCION DE RENDERIZADO DE DATOS **************************************************

    async function renderUI() {
        await obtenerOdt() // paso 1 
        const diagnosticoEntrada = await obtenerDiagnostico(1)
        const diagnosticoSalida = await obtenerDiagnostico(2)

        txtDiagnosticoEntrada.innerText = diagnosticoEntrada[0].diagnostico
        iddiagnosticoEntrada = diagnosticoEntrada[0]?.iddiagnostico
        iddiagnosticoSalida = diagnosticoSalida[0]?.iddiagnostico
        txtDiagnosticoSalida.innerText = diagnosticoSalida[0].diagnostico

        const detalleOdt = await obtenerDetalleOdt()
        contenedorDetallesOdtSalida.innerHTML = `

            <div class="row">
                <p class="fw-bolder col">Fecha inicial: </p>
                <p class="fw-normal d-flex align-items-center col">${detalleOdt[0].fecha_inicial}</p>
            </div>
            <div class="row">
                <p class="fw-bolder col">Fecha acabado: </p>
                <p class="fw-normal d-flex align-items-center col">${detalleOdt[0].fecha_final}</p>
            </div>
            <div class="row">
                <p class="fw-bolder col">Tiempo de ejecucion: </p>
                <p class="fw-normal d-flex align-items-center col">${detalleOdt[0].tiempo_ejecucion}</p>
            </div>
        `
        //await obtenerEvidencias() // paso 3
        const activos = await obtenerActivosPorTarea(idtarea)
        //const tarea = await obtenerTareaPorId(idtarea)
        const odt = await obtenerOdt()

        contenedorDetallesOdtEntrada.innerHTML = ``
        contenedorDetallesOdtEntrada.innerHTML += `
            <div class="row">
              <p class="fw-bolder col">Activos: </p>
            </div>`
        for (let i = 0; i < activos.length; i++) {
            contenedorDetallesOdtEntrada.innerHTML += `          
            <p class="fw-normal d-flex align-items-center col">${activos[i].descripcion} - Cod: ${activos[i].cod_identificacion}</p>
        `
        }

        contenedorDetallesOdtEntrada.innerHTML += `
          <div class="row">
              <p class="fw-bolder col">Fecha programada: </p>
              <p class="fw-normal d-flex align-items-center col">${odt[0].fecha_inicio} - ${odt[0].hora_inicio}</p>
              <p class="fw-bolder col">Fecha vencimiento: </p>
              <p class="fw-normal d-flex align-items-center col">${odt[0].fecha_vencimiento} - ${odt[0].hora_vencimiento}</p>
          </div>        
        `

        const responsables = await obtenerResponsablesAsignados()
        console.log("responsables: ", responsables)
        contenedorResponsablesOdt.innerHTML = ''
        responsables.forEach(responsable => {
            contenedorResponsablesOdt.innerHTML += `
        <li class="list-group-item">${responsable.nombres}</li>   
      `
        });
    }

    // ********************** FIN SECCION DE RENDERIZADO DE DATOS ***********************************************

    //**************************** SECCION DE MODALES ******************************************************* */

    async function abrirModalSidebar(iddiagnostico) {
        const modalEvidenciasContainer = document.getElementById("modal-evidencias-container");
        modalEvidenciasContainer.innerHTML = ''; // Limpiar el contenedor

        const evidenciasObtenidas = await obtenerEvidencias(iddiagnostico);
        console.log("Evidencias obtenidas: ", evidenciasObtenidas);

        // Iterar sobre cada evidencia y crear elementos de imagen
        evidenciasObtenidas.forEach(evidenciaObj => {
            const imgSrc = evidenciaObj.evidencia;
            modalEvidenciasContainer.innerHTML += `
                <div class="card mb-3 text-center" data-id="${evidenciaObj.idevidencias_diagnostico}">
                    <img src="http://localhost/CMMS/dist/images/evidencias/${imgSrc}" class="card-img-top modal-img" width=450 alt="Evidencia ${imgSrc}">                                
                </div>
            `
        });
    }

    // ************************* FIN DE SECCION DE MODALES **************************************************

    async function verificarCantidadEvidenciasEntrada() {
        const evidenciasObtenidas = await obtenerEvidencias(iddiagnosticoEntrada);
        console.log("cantidad de evidencias: ", evidenciasObtenidas);
        if (evidenciasObtenidas.length > 1 || evidenciasObtenidas.length == 1) {
            console.log("hay mucha evidencias apartir de 1s")
            //CREACION DE UN BOTON PARA MOSTRAR EL MODAL SIDEBAR      
            contenedorEvidenciaPreviaEntrada.innerHTML = ""
            contenedorEvidenciaPreviaEntrada.innerHTML = `
            <div class="card mb-3 text-center">

                <img src="http://localhost/CMMS/dist/images/evidencias/${evidenciasObtenidas[0].evidencia}" class="img-fluid rounded-start card-img-top" alt="..." style="max-width: 500px;">
                <div class="card-footer">
                    <button class="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRightEvidencias" id="btnAbrirModalSidebarEntrada">
                        Ver todas las evidencias
                    </button> 
                </div>
            </div>   
            
          `
            const btnAbrirModalSidebarEntrada = $q("#btnAbrirModalSidebarEntrada")
            btnAbrirModalSidebarEntrada.addEventListener("click", async () => {
                console.log("clickeando dxdxdxd")
                await abrirModalSidebar(iddiagnosticoEntrada)
            })
        } else {
            contenedorEvidenciaPreviaEntrada.innerHTML = ""
            contenedorEvidenciaPreviaEntrada.innerHTML = `
            <p>No hay evidencias</p>
            `
        }
    }

    async function verificarEvidenciasRegistradas() {
        const evidenciasObtenidas = await obtenerEvidencias(iddiagnosticoSalida);
        console.log("Evidencias obtenidas: ", evidenciasObtenidas);
        //previewContainer.innerHTML = ''
        if (evidenciasObtenidas.length > 1 || evidenciasObtenidas.length == 1) {
            contenedorEvidenciaPreviaSalida.innerHTML = ""
            contenedorEvidenciaPreviaSalida.innerHTML = `
            <div class="card mb-3 text-center">
                <img src="http://localhost/CMMS/dist/images/evidencias/${evidenciasObtenidas[0].evidencia}" class="card-img-top modal-img" alt="Evidencia" style="max-width: 500px;">
                <div class="card-footer">
                    <button class="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRightEvidencias" id="btnAbrirModalSidebarSalida">
                        Ver todas las evidencias
                    </button>
                </div>
            </div>        
            `
            const btnAbrirModalSidebarSalida = $q("#btnAbrirModalSidebarSalida")
            btnAbrirModalSidebarSalida.addEventListener("click", async () => {
                console.log("clickeando dxdxdxd")
                await abrirModalSidebar(iddiagnosticoSalida)
            })
        } else {
            contenedorEvidenciaPreviaSalida.innerHTML = ""
            contenedorEvidenciaPreviaSalida.innerHTML = `
            <p>No hay evidencias</p>
            `
        }
    }

    async function verificarOdtEstado() {
        const odtObtenida = await obtenerOdtporId()
        if (odtObtenida[0]?.idestado == 11) { //VERIFICAR SI YA ESTA FINALIZADA , SI LO ESTA NO DEBERIA DE MOSTRAR EL REGISTRO
            contenedorRevisarOdt.innerHTML = `
            <div class="container-fluid">
                <div class="row">
                    <h1 class="">No puedes revisar esta orden por que ya fue finalizada.</h1>
                </div>
            </div>
            `
        } else if (!window.localStorage.getItem("idodt")) {
            contenedorRevisarOdt.innerHTML = `
            <div class="container-fluid">
                <div class="row">
                    <h1 class="">No has seleccionado ninguna orden a revisar.</h1>
                </div>
            </div>
            `
        }
    }

    // **************************** FIN DE SECCION DE VERIFICACIONES **************************************

    // ****************************** SECCION DE EVENTOS **************************************************

    btnFinalizar.addEventListener("click", async () => {
        const registrado = await registrarComentario()
        console.log("comentario registrado? : ", registrado)
        const actualizadoODT = await actualizarEstadoOdt(11, idordengenerada)
        console.log("odt actualizado a finalizado?: ", actualizadoODT)
        if (actualizadoODT.actualizado) {
            const registrado = await registrarHistorialOdt()
            console.log("historial odt registrado?: ", registrado)
            const estadoTareaActualizada = await actualizarTareaEstado(idtarea, 8)
            console.log("ESTADO DE TAREA ACTUALIZADA?: ", estadoTareaActualizada)
            window.localStorage.clear()
            //window.location.href = `http://localhost/CMMS/views/odt`
            console.log("redirigiendo...")
        }
    })

    //******************************* FIN DE EVENTOS ***************************************************** */

    // ************************** SECCION DE ACTUALIZACIONES ***********************************************

    async function actualizarEstadoOdt(idestado, idodt) {
        //ACTUALIZACION DE ESTADOS DE ACTIVOS Y USUARIOS ASIGNADOS (RESPONSABLES): 
        const activos = await obtenerActivosPorTarea(idtarea)
        console.log("ACTIVOS ANTES DE ACTUALIZAR SUS ESTADOS: ", activos)
        const responsablesAsignados = await obtenerResponsablesAsignados()
        for (let o = 0; o < activos.length; o++) {
            const actualizadoActivoEstado = await actualizarEstadoActivo(activos[o].idactivo, 1)
            console.log("actualizadoActivoEstado: ", actualizadoActivoEstado)
        }
        for (let i = 0; i < responsablesAsignados.length; i++) {
            const actualizadoAsignacionUsuario = await actualizarAsignacionUsuario(responsablesAsignados[i].idresponsable, 7)
            console.log("actualizadoAsignacionUsuario: ", actualizadoAsignacionUsuario)
        }

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

    async function actualizarAsignacionUsuario(idusuario, asignacion) {
        const formActualizacion = new FormData()
        formActualizacion.append("operation", "updateAsignacion")
        formActualizacion.append("idusuario", idusuario)
        formActualizacion.append("asignacion", asignacion)
        const Factualizado = await fetch(`${host}usuarios.controller.php`, { method: 'POST', body: formActualizacion })
        const actualizado = await Factualizado.json()
        return actualizado
    }

    async function actualizarTareaEstado(idtarea, estado) {
        const formActualizacion = new FormData()
        formActualizacion.append("operation", "actualizarTareaEstado")
        formActualizacion.append("idtarea", idtarea)
        formActualizacion.append("idestado", estado)
        const Factualizado = await fetch(`${host}tarea.controller.php`, { method: 'POST', body: formActualizacion })
        const actualizado = await Factualizado.json()
        return actualizado
    }

    // ******************** FIN DE SECCION DE ACTUALIZACIONES **********************************************
});