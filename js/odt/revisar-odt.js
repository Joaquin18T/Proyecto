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
    const txtDiagnosticoEntrada = $q("#txtDiagnosticoEntrada")
    const txtDiagnosticoSalida = $q("#txtDiagnosticoSalida")
    const txtComentario = $q("#comentario")
    const btnFinalizar = $q("#btn-finalizar")
    const contenedorResponsablesOdt = $q(".contenedor-responsablesOdt")
    const contenedorDetallesOdtEntrada = $q(".contenedor-detallesOdtEntrada") // DIV
    const contenedorDetallesOdtSalida = $q(".contenedor-detallesOdtSalida") // DIV
    const contenedorEvidenciaPreviaEntrada = $q("#preview-container-entrada")
    const contenedorEvidenciaPreviaSalida = $q("#preview-container-salida")



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
        const activo = await obtenerActivosPorTarea(idtarea)
        const tarea = await obtenerTareaPorId(idtarea)
        contenedorDetallesOdtEntrada.innerHTML = `
          <div class="row">
              <p class="fw-bolder col">Activo: </p>
              <p class="fw-normal d-flex align-items-center col">${activo[0].subcategoria} ${activo[0].marca}</p>
          </div>
          <div class="row">
              <p class="fw-bolder col">Fecha programada: </p>
              <p class="fw-normal d-flex align-items-center col">${tarea[0].fecha_inicio}</p>
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

    // **************************** FIN DE SECCION DE VERIFICACIONES **************************************

    // ****************************** SECCION DE EVENTOS **************************************************

    btnFinalizar.addEventListener("click", async () => {
        const registrado = await registrarComentario()
        console.log("comentario registrado? : ", registrado)
        const actualizadoODT = await actualizarEstadoOdt(11, idordengenerada)
        console.log("odt actualizado a finalizado?: ", actualizadoODT)
        if(actualizadoODT.actualizado){
            window.location.href = `http://localhost/CMMS/views/odt`
        }
    })

    //******************************* FIN DE EVENTOS ***************************************************** */

    // ************************** SECCION DE ACTUALIZACIONES ***********************************************

    async function actualizarEstadoOdt(idestado, idodt) {
        const formActualizacionEstadoOdt = new FormData()
        formActualizacionEstadoOdt.append("operation", "actualizarEstadoOdt")
        formActualizacionEstadoOdt.append("idodt", idodt)
        formActualizacionEstadoOdt.append("idestado", idestado)
        const Factualizado = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formActualizacionEstadoOdt })
        const actualizado = await Factualizado.json()
        return actualizado
    }

    // ******************** FIN DE SECCION DE ACTUALIZACIONES **********************************************
});