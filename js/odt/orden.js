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

  //ESTADOS
  let hayDiagnostico = false
  let hayDetalle = false

  //variables globales
  const host = "http://localhost/CMMS/controllers/";
  let idordengenerada = window.localStorage.getItem("idodt")
  let idtarea = -1
  let iddiagnosticoEntrada = -1
  let iddiagnosticoSalidaGenerado = -1;
  let iddiagnosticoGeneradoEntrada = -1
  let iddetalleodtGenerado = -1
  let intervalos = -1
  let frecuencia = ""

  //UI
  const txtDiagnosticoEntrada = $q("#diagnostico-entrada")
  const txtDiagnosticoSalida = $q("#diagnostico-salida")
  const txtFechaInicial = $q("#txtFechaInicial")
  const txtFechaFinal = $q("#txtFechaFinal")
  const txtTiempoEjecucion = $q("#txtTiempoEjecucion")
  const txtIntervalosEjecutados = $q("#txtIntervalosEjecutados")
  const contenedorDetallesOdtEntrada = $q(".contenedor-detallesOdtEntrada") // DIV
  const contenedorResponsablesOdt = $q(".contenedor-responsablesOdt")
  const contenedorEvidenciaPreviaEntrada = $q("#preview-container-entrada")
  const contenedorEvidenciaPreviaSalida = $q("#preview-container-salida")


  //BOTONES
  const evidenciasInputSalida = $q("#evidencias-img-input-salida")
  const evidenciasInputEntrada = $q("#evidencias-img-input-entrada")
  const btnIniciar = $q("#btn-iniciar")
  const btnFinalizar = $q("#btn-finalizar")
  const btnVerDetalles = $q("#btn-verDetalles")
  const btnGuardarDianogsticoSalida = $q("#btn-guardar-diagnostico-salida")
  const btnGuardarDianogsticoEntrada = $q("#btn-guardar-diagnostico-entrada")


  //Ejecutar funciones 
  await obtenerOdt() // paso 1 
  //await obtenerDiagnostico(1)
  await obtenerEvidencias(1) // paso 3
  await obtenerTareaPorId(idtarea) // paso 4
  await obtenerActivosPorTarea(idtarea)
  await obtenerResponsablesAsignados()

  //RENDERIZAR
  //await renderDiagnosticoEntrada()
  await renderDetalles()
  await renderResponsables()
  //alert("holaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  await verificarDetalleOdtRegistrado()
  await verificarDiagnosticoEntradaRegistrado() // DESCOMENTAR LUEGO
  //await verificarCantidadEvidenciasEntrada()
  await verificarDiagnosticoSalidaRegistrado()
  await verificarEvidenciasRegistradas(iddiagnosticoGeneradoEntrada) // DESCOMENTAR LUEGO
  await verificarEvidenciasRegistradas(iddiagnosticoSalidaGenerado) // DESCOMENTAR LUEGO
  await verificarDetalleOdtRegistrado()



  //******************************* SECCION DE OBTENER DATOS ***************************************

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
    //console.log("evidencias: ", evidencias)
    return evidencias
  }

  async function obtenerDiagnostico(tipo) {
    const paramsDiagnosticoBuscar = new URLSearchParams()
    paramsDiagnosticoBuscar.append("operation", "obtenerDiagnostico")
    paramsDiagnosticoBuscar.append("idordentrabajo", idordengenerada)
    paramsDiagnosticoBuscar.append("idtipodiagnostico", tipo)
    const diagnosticoObtenido = await getDatos(`${host}diagnostico.controller.php`, paramsDiagnosticoBuscar)
    console.log("diagnostico de entrada: ", diagnosticoObtenido)
    return diagnosticoObtenido
  }

  async function obtenerTareaPorId(idtarea) {
    const params = new URLSearchParams()
    params.append("operation", "obtenerTareaPorId")
    params.append("idtarea", idtarea)
    const ultimaTareaAgregada = await getDatos(`${host}tarea.controller.php`, params)
    intervalos = ultimaTareaAgregada[0].intervalo
    frecuencia = ultimaTareaAgregada[0].frecuencia
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
    const detalleOdt = getDatos(`${host}ordentrabajo.controller.php`, params)
    return detalleOdt
  }

  //***************************** FIN DE SECCION DE OBTENER DATOS ******************************** */

  // ************************************SECCION DE REGISTROS *************************************

  async function registrarDiagnosticoEntrada() {
    const formDiagnostico = new FormData()
    formDiagnostico.append("operation", "registrarDiagnostico")
    formDiagnostico.append("idordentrabajo", idordengenerada)
    formDiagnostico.append("idtipodiagnostico", 1)
    formDiagnostico.append("diagnostico", "")
    const FidDiagnosticoRegistrado = await fetch(`${host}diagnostico.controller.php`, { method: "POST", body: formDiagnostico })
    const idDiagnosticoRegistrado = await FidDiagnosticoRegistrado.json()
    return idDiagnosticoRegistrado
  }

  async function registrarDiagnosticoSalida() {
    const formDiagnostico = new FormData()
    formDiagnostico.append("operation", "registrarDiagnostico")
    formDiagnostico.append("idordentrabajo", idordengenerada)
    formDiagnostico.append("idtipodiagnostico", 2)
    formDiagnostico.append("diagnostico", txtDiagnosticoSalida.value == "" ? "" : txtDiagnosticoSalida.value)
    const FidDiagnosticoRegistrado = await fetch(`${host}diagnostico.controller.php`, { method: "POST", body: formDiagnostico })
    const idDiagnosticoRegistrado = await FidDiagnosticoRegistrado.json()
    return idDiagnosticoRegistrado
  }

  async function registrarDetalleOdt() {
    const ultimoDetalleOdt = await obtenerDetalleOdt();
    const ultimoIntervaloEjecutado = ultimoDetalleOdt.length > 0
      ? ultimoDetalleOdt[ultimoDetalleOdt.length - 1].intervalos_ejecutados
      : 0;

    if (ultimoIntervaloEjecutado >= intervalos) {
      console.log("El límite de intervalos ha sido alcanzado.");
      return { mensaje: "Límite de intervalos alcanzado" };
    }
    // Incrementar el valor de intervalos ejecutados en 1
    //const nuevoIntervaloEjecutado = ultimoIntervaloEjecutado + 1;
    const formRegistroDetalleOdt = new FormData()
    formRegistroDetalleOdt.append("operation", "registrarDetalleOdt")
    formRegistroDetalleOdt.append("idodt", idordengenerada)
    formRegistroDetalleOdt.append("clasificacion", 9)
    formRegistroDetalleOdt.append("intervalos_ejecutados", ultimoIntervaloEjecutado);

    const fDetalleOdt = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formRegistroDetalleOdt })
    const id = await fDetalleOdt.json()
    return id
  }

  //* ******************************* FIN DE SECCION DE REGISTRO *********************************

  // ******************************* SECCION DE ACTUALIZACIONES ***************************************

  async function actualizarDiagnosticoSalida() {
    const formActualizacion = new FormData()
    formActualizacion.append("operation", "actualizarDiagnostico")
    formActualizacion.append("iddiagnostico", iddiagnosticoSalidaGenerado)
    formActualizacion.append("diagnostico", txtDiagnosticoSalida.value)
    const fActualizado = await fetch(`${host}diagnostico.controller.php`, { method: 'POST', body: formActualizacion })
    const actualizado = await fActualizado.json()
    return actualizado
  }

  async function actualizarDetalleOdt(fechaFinal, tiempoEjecucion, intervalos_ejecutados, clasificacion, iddodt) {
    const ultimoDetalleOdt = await obtenerDetalleOdt();

    const formActualizacion = new FormData()
    formActualizacion.append("operation", "actualizarDetalleOdt");
    formActualizacion.append("iddetalleodt", iddodt ? iddodt : ultimoDetalleOdt[ultimoDetalleOdt.length - 1].iddetalleodt); // El ID generado
    formActualizacion.append("fechafinal", fechaFinal); // Fecha final actual
    formActualizacion.append("tiempoejecucion", tiempoEjecucion); // Tiempo de ejecución calculado
    formActualizacion.append("intervalos_ejecutados", intervalos_ejecutados)
    formActualizacion.append("clasificacion", clasificacion);
    const fActualizado = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formActualizacion })
    const actualizado = await fActualizado.json()
    return actualizado
  }

  async function actualizarDiagnosticoEntrada() {
    const formActualizacion = new FormData()
    formActualizacion.append("operation", "actualizarDiagnostico")
    formActualizacion.append("iddiagnostico", iddiagnosticoGeneradoEntrada)
    formActualizacion.append("diagnostico", txtDiagnosticoEntrada.value == "" ? "" : txtDiagnosticoEntrada.value)
    const fActualizado = await fetch(`${host}diagnostico.controller.php`, { method: 'POST', body: formActualizacion })
    const actualizado = await fActualizado.json()
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

  //****************************** FIN DE SECCION DE ACTUALIZACIONES ********************************** */

  //******************************** SECCION DE ELIMINACIONES ******************************************** */

  async function eliminarEvidenciaOdt(idevidencia) {
    const formEliminacion = new FormData()
    formEliminacion.append("operation", "eliminarEvidencia")
    const fEliminado = await fetch(`${host}diagnostico.controller.php/${idevidencia}`, { method: 'POST', body: formEliminacion })
    const eliminado = await fEliminado.json()
    return eliminado
  }

  // ******************************* FIN DE SECCION DE ELIMINACIONES ****************************************

  // **************************** SECCION DE RENDERIZAR INTERFAZ CON DATOS ****************************** */

  /* async function renderDiagnosticoEntrada() {
    //const diagnosticoEntrada = await obtenerDiagnostico(1) // entrada

    console.log("diagnosticoEntrada: ", diagnosticoEntrada)
    iddiagnosticoEntrada = diagnosticoEntrada[0]?.iddiagnostico
    txtDiagnosticoEntrada.innerHTML = diagnosticoEntrada[0].diagnostico
  } */

  async function renderDetalles() {
    const diagnosticoEntrada = await obtenerDiagnostico(1) // entrada
    const activos = await obtenerActivosPorTarea(idtarea)
    const odt = await obtenerOdt()
    //const tarea = await obtenerTareaPorId(idtarea)
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
          </div>  
          <div class="row">
              <p class="fw-bolder col">Intervalos: </p>
              <p class="fw-normal col">${intervalos} </p>
          </div>       
          <div class="row">
              <p class="fw-bolder col">Frecuencia: </p>
              <p class="fw-normal col">${frecuencia} </p>
          </div>       
              
        `
  }

  async function renderResponsables() {
    const responsables = await obtenerResponsablesAsignados()
    console.log("responsables: ", responsables)
    contenedorResponsablesOdt.innerHTML = ''
    responsables.forEach(responsable => {
      contenedorResponsablesOdt.innerHTML += `
        <li class="list-group-item">${responsable.nombres}</li>   
      `
    });
  }

  // ************************* FIN DE SECCION DE RENDERIZAR INTERFAZ CON DATOS ****************************

  //**************************** SECCION DE MODALES ******************************************************* */

  async function abrirModalSidebar(iddiagnostico) {
    //const modalEvidenciasContainer = document.getElementById("modal-container");
    const bodyModal = $q(".offcanvas-body")
    //modalEvidenciasContainer.innerHTML = ''; // Limpiar el contenedor

    const evidenciasObtenidas = await obtenerEvidencias(iddiagnostico);
    console.log("renderizando evidencias: ", evidenciasObtenidas);


    if (iddiagnostico == null) {
      const detalles = await obtenerDetalleOdt()
      console.log("detalles: ", detalles)
      bodyModal.innerHTML = ''
      bodyModal.innerHTML = '<h2>Ejecuciones: </h2>'
      detalles.forEach((d, key) => {
        bodyModal.innerHTML += `          
          <div class="card mb-3">
            <div class="card-body">
              <h5 class="card-title">Ejecucion N°${key + 1}</h5>
              <p class="card-text"><strong>Fecha inicial: </strong>${d.fecha_inicial}</p>
              <p class="card-text"><strong>Fecha acabado: </strong>${d.fecha_final}</p>
              <p class="card-text"><strong>Tiempo ejecución: </strong>${d.tiempo_ejecucion}</p>             
            </div>
          </div>
        `
      });
      return
    }

    bodyModal.innerHTML = ''
    bodyModal.innerHTML = `<h2>Lista de todas las evidencias</h2>`
    // Iterar sobre cada evidencia y crear elementos de imagen
    evidenciasObtenidas.forEach(evidenciaObj => {
      const imgSrc = evidenciaObj.evidencia;
      bodyModal.innerHTML += `        
        <div>
          <div class="card mb-3 text-center" data-id="${evidenciaObj.idevidencias_diagnostico}">
            <img src="http://localhost/CMMS/dist/images/evidencias/${imgSrc}" class="card-img-top modal-img" width=450 alt="Evidencia ${imgSrc}">            
            <div class="card-footer">
              <button class="btn btn-primary btn-evidencia-eliminar" data-id="${evidenciaObj.idevidencias_diagnostico}">Eliminar</button>
            </div>
          </div>
        </div>        
      `
    });

    const btnsEvidenciaEliminar = $all(".btn-evidencia-eliminar")
    btnsEvidenciaEliminar.forEach(btn => {
      btn.addEventListener("click", async () => {
        const idevidencia = btn.getAttribute("data-id")
        console.log("id evidencia: ", idevidencia)
        const eliminado = await eliminarEvidenciaOdt(idevidencia);
        console.log("evidencia eliminado: ", eliminado)
        const listItem = document.querySelector(`div[data-id="${idevidencia}"]`);
        if (listItem) {
          listItem.remove();
        }
      })
    })
  }

  // ************************* FIN DE SECCION DE MODALES **************************************************

  // *************************** SECCION DE VERIFICACIONES ********************************************

  /* async function verificarCantidadEvidenciasEntrada() {
    const evidenciasObtenidas = await obtenerEvidencias(iddiagnosticoEntrada);
    console.log("cantidad de evidencias: ", evidenciasObtenidas);
    if (evidenciasObtenidas.length > 1) {
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
      evidenciasObtenidas.forEach(evidencia => {
        contenedorEvidenciaPreviaEntrada.innerHTML = ""
        contenedorEvidenciaPreviaEntrada.innerHTML = `
          <img src="http://localhost/CMMS/dist/images/evidencias/${evidenciasObtenidas[0].evidencia}" class="img-fluid rounded-start" alt="...">
        `
      })
    }
  } */

  async function verificarEvidenciasRegistradas(iddiagnostico) {
    const evidenciasObtenidas = await obtenerEvidencias(iddiagnostico);
    console.log("Evidencias obtenidas: ", evidenciasObtenidas);
    //previewContainer.innerHTML = ''
    // Verifica si hay evidencias y selecciona el contenedor adecuado
    if (evidenciasObtenidas.length > 0) {
      let contenedor;

      // Selecciona el contenedor según el tipo de diagnóstico
      if (evidenciasObtenidas[0].idtipo_diagnostico == 2) {
        contenedor = contenedorEvidenciaPreviaSalida;
        console.log("el tipo es 2, idi diagnostico: ", iddiagnostico)
      } else if (evidenciasObtenidas[0].idtipo_diagnostico == 1) {
        contenedor = contenedorEvidenciaPreviaEntrada;
        console.log("el tipo es 1, id diagnostico: ", iddiagnostico)
      } else {
        contenedor = previewContainer; // Contenedor por defecto si no es 1 o 2
      }

      contenedor.innerHTML = '';

      // Genera un id único para el botón basándose en el iddiagnostico
      const botonId = `btnAbrirModalSidebar_${iddiagnostico}`;
      // Añade el botón al contenedor seleccionado
      contenedor.innerHTML += `
      ${evidenciasObtenidas.length > 0 ? `<div class="card container-fluid">
        <img src="http://localhost/CMMS/dist/images/evidencias/${evidenciasObtenidas[0].evidencia}" class="img-fluid card-img-top" alt="...">
        <div class="card-body">
          <button class="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRightEvidencias" id="${botonId}">
                Ver todas las evidencias
            </button>
        </div>
      </div>` : `<p id="no-images-text" class="no-images-text">No hay imágenes seleccionadas aún</p>`}
            
        `;

      const btnAbrirModalSidebar = document.getElementById(botonId);
      btnAbrirModalSidebar.addEventListener("click", async () => {
        console.log("clickeando dxdxdxd");
        await abrirModalSidebar(iddiagnostico);
      });
    }
  }

  async function verificarDiagnosticoSalidaRegistrado() {
    const diagnostico = await obtenerDiagnostico(2)
    const detalleOdt = await obtenerDetalleOdt()
    if (diagnostico.length == 1 || detalleOdt.length > 1) {
      hayDiagnostico = true
      txtDiagnosticoSalida.disabled = false
      btnGuardarDianogsticoSalida.disabled = false
      alert("ya hay un diagnostico de salida registrado")
      txtDiagnosticoSalida.value = diagnostico[0].diagnostico
      console.log("DIAGNOSTICO TRAIDO: ", diagnostico)
      iddiagnosticoSalidaGenerado = diagnostico[0].iddiagnostico
      return
    } else {
      const diagnostico = await registrarDiagnosticoSalida()
      alert("se creo un nuevo diagnostico de salida")
      hayDiagnostico = true
      console.log("id diagnostico generado: ", diagnostico)
      alert("registrando diagn,.....")
      iddiagnosticoSalidaGenerado = diagnostico.id
      console.log("iddiagnosticoSalidaGenerado: ", iddiagnosticoSalidaGenerado)
      return
    }
  }

  async function verificarDiagnosticoEntradaRegistrado() {
    const diagnostico = await obtenerDiagnostico(1)
    const detalleOdt = await obtenerDetalleOdt()
    console.log("diagnostico para verificar: ", diagnostico)
    if (diagnostico.length == 1 || detalleOdt.length > 1) {
      hayDiagnostico = true
      txtDiagnosticoEntrada.disabled = false
      btnGuardarDianogsticoEntrada.disabled = false
      alert("ya hay un diagnostico de entrada registrado")
      txtDiagnosticoEntrada.value = diagnostico[0].diagnostico
      iddiagnosticoGeneradoEntrada = diagnostico[0].iddiagnostico
      return
    } else {
      const diagnostico = await registrarDiagnosticoEntrada()
      //alert("se creo un nuevo diagnostico")
      hayDiagnostico = true
      console.log("id diagnostico entrada generado: ", diagnostico.id)
      iddiagnosticoGeneradoEntrada = diagnostico.id
      return
    }
  }

  /* async function verificarEvidenciasRegistradas() {
    const evidenciasObtenidas = await obtenerEvidencias(iddiagnosticoSalidaGenerado);
    console.log("Evidencias obtenidas: ", evidenciasObtenidas);
    //previewContainer.innerHTML = ''
    if (evidenciasObtenidas.length > 0) {
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
        await abrirModalSidebar(iddiagnosticoSalidaGenerado)
      })
    }
  }
 */
  async function verificarDetalleOdtRegistrado() {
    const detalleOdt = await obtenerDetalleOdt()
    let ultimaPosicion = detalleOdt.length - 1
    console.log("DETALLE ODT DESPUES DE VERIFICAR: ", detalleOdt)
    if (detalleOdt[ultimaPosicion]?.fechaFinal == null && detalleOdt[ultimaPosicion]?.tiempo_ejecucion == null) {
      alert("TIENE UNA EJECUCION PENDIENTE")
      txtIntervalosEjecutados.innerText = detalleOdt[ultimaPosicion]?.intervalos_ejecutados ? detalleOdt[ultimaPosicion].intervalos_ejecutados : ''
      txtFechaInicial.innerText = detalleOdt[ultimaPosicion]?.fecha_inicial ? detalleOdt[ultimaPosicion].fecha_inicial : ''
    }
    else if (detalleOdt[ultimaPosicion]?.intervalos_ejecutados >= intervalos) {
      alert("ESTA ORDEN YA TIENE TODOS LOS INTERVALOS EJECUTADOS")
      txtIntervalosEjecutados.innerText = detalleOdt[ultimaPosicion]?.intervalos_ejecutados ? detalleOdt[ultimaPosicion].intervalos_ejecutados : ''
      btnIniciar.disabled = true
      btnIniciar.removeAttribute("id")
      btnFinalizar.disabled = true
      btnFinalizar.removeAttribute("id")
      return
    } else {
      alert("aun puedes seguir ejecutando la orden")
      //hayDetalle = true
      txtIntervalosEjecutados.innerText = detalleOdt[ultimaPosicion]?.intervalos_ejecutados ? detalleOdt[ultimaPosicion].intervalos_ejecutados : 0
    }
    /* if (detalleOdt.length == 1 || detalleOdt.length > 1) {
      hayDetalle = true
      alert("ya hay un detalle odt registrado")
      //render *****************************************************************
      txtFechaInicial.innerText = detalleOdt[ultimaPosicion].fecha_inicial ? detalleOdt[ultimaPosicion].fecha_inicial : ''
      txtFechaFinal.innerText = detalleOdt[ultimaPosicion].fecha_final ? detalleOdt[ultimaPosicion].fecha_final : ''
      txtTiempoEjecucion.innerText = detalleOdt[ultimaPosicion].tiempo_ejecucion ? detalleOdt[ultimaPosicion].tiempo_ejecucion : ''
      //fin render *************************************************************
      iddetalleodtGenerado = detalleOdt[ultimaPosicion].iddetalleodt
      btnIniciar.disabled = true
      btnIniciar.removeAttribute("id")
      if (detalleOdt[ultimaPosicion]?.tiempo_ejecucion !== null && detalleOdt[ultimaPosicion]?.fecha_final !== null) {
        btnFinalizar.disabled = true
        btnFinalizar.removeAttribute("id")
        //console.log("btnIniciar: ", btnIniciar)
      }

      return
    } else {
      btnIniciar.disabled = false
      btnFinalizar.disabled = false
      txtFechaInicial.innerText = ''
      txtFechaFinal.innerText = ''
      txtTiempoEjecucion.innerText = ''
      iddetalleodtGenerado = -1
    } */
  }

  /* async function verificarEvidenciasRegistradas(iddiagnostico) {
    const evidenciasObtenidas = await obtenerEvidencias(iddiagnostico);
    console.log("Evidencias obtenidas: ", evidenciasObtenidas);
    //previewContainer.innerHTML = ''
    if (evidenciasObtenidas.length > 0) {
      previewContainer.innerHTML += `
        <button class="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRightEvidencias" id="btnAbrirModalSidebar">
            Ver todas las evidencias
        </button>
        `
      const btnAbrirModalSidebar = $q("#btnAbrirModalSidebar")
      btnAbrirModalSidebar.addEventListener("click", () => {
        console.log("clickeando dxdxdxd")
        abrirModalSidebar()
      })
    }
  } */

  // **************************** FIN DE SECCION DE VERIFICACIONES **************************************

  // ***************************************** EVENTOS **************************************************
  evidenciasInputEntrada.addEventListener('change', async (e) => {
    if (idordengenerada && iddiagnosticoGeneradoEntrada == -1) {
      // Verificar que haya un diagnóstico antes de subir las evidencias
      console.log("NO HAY UNA ORDEN de entrada SOBRE QUE TRABAJAR")
      return
    } else {
      const evidenciaImagen = e.target.files[0] //ME QUEE ACAAAAA falta capturar el nombre de imagen y subir la evidencia
      console.log("evidenciaImagen: ", evidenciaImagen)
      console.log(e)
      // Verificar que el archivo exista
      if (!evidenciaImagen) {
        alert("No se ha seleccionado ninguna imagen.");
        return;
      }

      // Crear el objeto FormData y añadir los datos
      const formEvidencia = new FormData();
      formEvidencia.append("operation", "registrarEvidenciaDiagnostico")
      formEvidencia.append("iddiagnostico", iddiagnosticoGeneradoEntrada);
      formEvidencia.append("evidencia", evidenciaImagen); // Aquí se añade el archivo de evidencia (imagen)

      try {
        const Frespuesta = await fetch(`${host}diagnostico.controller.php`, { method: 'POST', body: formEvidencia })
        const subida = await Frespuesta.json();
        if (subida.guardado === 'success') {
          showToast(subida.message, 'INFO')
          //renderizar imagen

          // Renderizar imagen y botón usando HTML directo
          const imgSrc = URL.createObjectURL(evidenciaImagen); // Crear URL temporal de la imagen

          contenedorEvidenciaPreviaEntrada.innerHTML = `
                    <div class="card mb-3 text-center">
                        <img src="${imgSrc}" class="card-img-top modal-img" alt="Evidencia" style="max-width: 500px;">
                        <div class="card-footer">
                            <button class="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRightEvidencias" id="btnAbrirModalSidebarEntrada">
                                Ver todas las evidencias
                            </button>
                        </div>
                    </div>
                `;
          //
          const btnAbrirModalSidebarEntrada = $q("#btnAbrirModalSidebarEntrada")
          btnAbrirModalSidebarEntrada.addEventListener("click", async () => {
            console.log("clickeando dxdxdxd")
            await abrirModalSidebar(iddiagnosticoGeneradoEntrada)
          })

        } else {
          showToast(subida.message, 'ERROR')
        }
      } catch (error) {
        console.error('Error en la petición:', error);
      }
    }
  })

  evidenciasInputSalida.addEventListener('change', async (e) => {
    if (idordengenerada && iddiagnosticoSalidaGenerado == -1) {
      // Verificar que haya un diagnóstico antes de subir las evidencias
      console.log("NO HAY UNA ORDEN de salida SOBRE QUE TRABAJAR")
      return
    } else {
      const evidenciaImagen = e.target.files[0] //ME QUEE ACAAAAA falta capturar el nombre de imagen y subir la evidencia
      console.log("evidenciaImagen: ", evidenciaImagen)
      console.log(e)
      // Verificar que el archivo exista
      if (!evidenciaImagen) {
        alert("No se ha seleccionado ninguna imagen.");
        return;
      }

      // Crear el objeto FormData y añadir los datos
      const formEvidencia = new FormData();
      formEvidencia.append("operation", "registrarEvidenciaDiagnostico")
      formEvidencia.append("iddiagnostico", iddiagnosticoSalidaGenerado);
      formEvidencia.append("evidencia", evidenciaImagen); // Aquí se añade el archivo de evidencia (imagen)

      try {
        const Frespuesta = await fetch(`${host}diagnostico.controller.php`, { method: 'POST', body: formEvidencia })
        const subida = await Frespuesta.json();
        if (subida.guardado === 'success') {
          showToast(subida.message, 'INFO')
          //renderizar imagen

          // Renderizar imagen y botón usando HTML directo
          const imgSrc = URL.createObjectURL(evidenciaImagen); // Crear URL temporal de la imagen

          contenedorEvidenciaPreviaSalida.innerHTML = `
                    <div class="card mb-3 text-center">
                        <img src="${imgSrc}" class="card-img-top modal-img" alt="Evidencia" style="max-width: 500px;">
                        <div class="card-footer">
                            <button class="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRightEvidencias" id="btnAbrirModalSidebarSalida">
                                Ver todas las evidencias
                            </button>
                        </div>
                    </div>
                `;
          //
          const btnAbrirModalSidebarSalida = $q("#btnAbrirModalSidebarSalida")
          btnAbrirModalSidebarSalida.addEventListener("click", async () => {
            console.log("clickeando dxdxdxd")
            await abrirModalSidebar(iddiagnosticoSalidaGenerado)
          })

        } else {
          showToast(subida.message, 'ERROR')
        }
      } catch (error) {
        console.error('Error en la petición:', error);
      }
    }
  })

  btnIniciar.addEventListener("click", async () => {
    const activosPorTarea = await obtenerActivosPorTarea(idtarea); // Obtener los activos asignados a la tarea actual
    let permitir = true;

    // Verificar si algún activo de esta tarea ya está en mantenimiento en otra tarea
    for (let e = 0; e < activosPorTarea.length; e++) {
      const activo = activosPorTarea[e];

      // Comprobar si el activo está en estado "en mantenimiento" (2) pero en otra tarea
      if (activo.idestado === 2 && activo.idtarea !== idtarea) {
        showToast(`El activo con ID ${activo.idactivo} está en mantenimiento en otra tarea y no se puede iniciar esta orden.`, 'ERROR', 6000);
        permitir = false;
        return; // Detener la ejecución si se encuentra un conflicto
      }
    }

    // Si todos los activos están disponibles, procede
    if (permitir) {
      console.log("Iniciando orden...");

      const detalleOdt = await obtenerDetalleOdt();
      let ultimaPosicion = detalleOdt.length - 1;
      let intervalosEjecutados = detalleOdt[ultimaPosicion]?.intervalos_ejecutados || 0;

      // Limitar la cantidad de ejecuciones
      if (intervalosEjecutados >= intervalos) {
        alert("No se pueden ejecutar más intervalos en esta orden.");
        btnIniciar.disabled = true;
        return;
      }

      // Registrar detalles de ejecución de la orden
      const detalleRegistrado = await registrarDetalleOdt();
      iddetalleodtGenerado = detalleRegistrado.id;

      // Actualizar estado de los activos
      for (let o = 0; o < activosPorTarea.length; o++) {
        const activo = activosPorTarea[o];

        // Cambiar el estado del activo a "en mantenimiento" solo si no está ya en estado "2" en esta tarea
        if (activo.idestado !== 2) {
          await actualizarEstadoActivo(activo.idactivo, 2); // Cambiar estado a "en mantenimiento"
          console.log(`Estado actualizado del activo ${activo.idactivo} a 'en mantenimiento'`);
        }
      }

      // Actualizar la interfaz después de registrar el detalle
      const detalleActualizado = await obtenerDetalleOdt();
      txtFechaInicial.innerText = `${detalleActualizado[detalleActualizado.length - 1].fecha_inicial}`;
      btnIniciar.disabled = true;
      btnFinalizar.disabled = false;
      txtFechaFinal.innerText = "";
      txtTiempoEjecucion.innerText = "";
    }

  })

  btnGuardarDianogsticoEntrada.addEventListener("click", async () => {
    const dEntradaActualizada = await actualizarDiagnosticoEntrada()
    console.log("dEntradaActualizada: ", dEntradaActualizada)
  })

  btnGuardarDianogsticoSalida.addEventListener("click", async () => {
    const actualizado = await actualizarDiagnosticoSalida()
    console.log("actualizado diagnostico salida:? ", actualizado)
  })

  btnFinalizar.addEventListener("click", async () => {
    // Obtener el detalle ODT registrado
    const detalleOdt = await obtenerDetalleOdt();

    if (detalleOdt.length > 0) {
      const ultimoDetalle = detalleOdt[detalleOdt.length - 1];

      if (ultimoDetalle.intervalos_ejecutados >= intervalos) {

        console.log("Se ha alcanzado el límite de intervalos ejecutados.");
        btnFinalizar.disabled = true;
        return;
      }

      const fechaFinal = new Date().toLocaleString('en-CA', { hour12: false }).replace(',', '').replace('/', '-').replace('/', '-');
      console.log("FECHA FINAL OBTENIDA: ", fechaFinal);

      const fechaInicial = new Date(ultimoDetalle.fecha_inicial);
      const tiempoEjecucionMs = new Date(fechaFinal) - fechaInicial;

      const tiempoEjecucionHoras = Math.floor(tiempoEjecucionMs / (1000 * 60 * 60));
      const tiempoEjecucionMinutos = Math.floor((tiempoEjecucionMs % (1000 * 60 * 60)) / (1000 * 60));
      const tiempoEjecucionSegundos = Math.floor((tiempoEjecucionMs % (1000 * 60)) / 1000);
      const tiempoEjecucion = `${tiempoEjecucionHoras.toString().padStart(2, '0')}:${tiempoEjecucionMinutos.toString().padStart(2, '0')}:${tiempoEjecucionSegundos.toString().padStart(2, '0')}`;
      console.log("Tiempo ejecutado (formato HH:MM:SS): ", tiempoEjecucion);

      const nuevoIntervalo = ultimoDetalle.intervalos_ejecutados + 1;
      const actualizado = await actualizarDetalleOdt(fechaFinal, tiempoEjecucion, nuevoIntervalo, 9);

      console.log("DETALLE ODT ACTUALIZADO??? => ", actualizado);
      if (actualizado.actualizado) {
        const detalleActualizadoData = await obtenerDetalleOdt();
        console.log("detalleActualizadoData: ", detalleActualizadoData);

        txtFechaFinal.innerText = detalleActualizadoData[detalleActualizadoData.length - 1].fecha_final;
        txtTiempoEjecucion.innerText = detalleActualizadoData[detalleActualizadoData.length - 1].tiempo_ejecucion;
        txtIntervalosEjecutados.innerText = detalleActualizadoData[detalleActualizadoData.length - 1].intervalos_ejecutados;
        btnIniciar.disabled = false
        btnFinalizar.disabled = true
        const detalleOdt = await obtenerDetalleOdt();
        console.log("detalleOdt:_ ", detalleOdt);
        if (detalleOdt[detalleOdt.length - 1]?.intervalos_ejecutados == intervalos) {
          alert("ya ejecutaste todos los intervalos, esta completo");
          btnIniciar.disabled = true;
        }
        if (nuevoIntervalo >= intervalos) {
          const fechaFinal = new Date().toLocaleString('en-CA', { hour12: false }).replace(',', '').replace('/', '-').replace('/', '-');
          console.log("FECHA FINAL OBTENIDA: ", fechaFinal);

          const fechaInicial = new Date(ultimoDetalle.fecha_inicial);
          const tiempoEjecucionMs = new Date(fechaFinal) - fechaInicial;

          const tiempoEjecucionHoras = Math.floor(tiempoEjecucionMs / (1000 * 60 * 60));
          const tiempoEjecucionMinutos = Math.floor((tiempoEjecucionMs % (1000 * 60 * 60)) / (1000 * 60));
          const tiempoEjecucionSegundos = Math.floor((tiempoEjecucionMs % (1000 * 60)) / 1000);
          const tiempoEjecucion = `${tiempoEjecucionHoras.toString().padStart(2, '0')}:${tiempoEjecucionMinutos.toString().padStart(2, '0')}:${tiempoEjecucionSegundos.toString().padStart(2, '0')}`;
          console.log("Tiempo ejecutado (formato HH:MM:SS): ", tiempoEjecucion);

          const nuevoIntervalo = ultimoDetalle.intervalos_ejecutados + 1;
          const actualizado = await actualizarDetalleOdt(fechaFinal, tiempoEjecucion, nuevoIntervalo, 11);

          const detalles = await obtenerDetalleOdt()


          for (let i = 0; i < detalles.length; i++) {
            const actualizadoDodt = await actualizarDetalleOdt(detalles[i].fecha_final, detalles[i].tiempo_ejecucion, detalles[i].intervalos_ejecutados, 11, detalles[i].iddetalleodt);
            console.log("actualizadoDodt => ", actualizadoDodt)
          }

          console.log("DETALLE ODT ACTUALIZADO y detalle actualizado a clasificacion finalizada => ", actualizado);
          btnFinalizar.disabled = true;
          console.log("Se ha alcanzado el límite de intervalos ejecutados.");
        }
      }
    }


  })

  btnVerDetalles.addEventListener("click", async () => {
    await abrirModalSidebar()
  })
  // ************************************ FIN DE EVENTOS ************************************************

});
