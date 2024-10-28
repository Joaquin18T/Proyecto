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
  let iddetalleodtGenerado = -1

  //UI
  const txtDiagnosticoEntrada = $q("#txtDiagnosticoEntrada")
  const txtDiagnosticoSalida = $q("#diagnostico-salida")
  const txtFechaInicial = $q("#txtFechaInicial")
  const txtFechaFinal = $q("#txtFechaFinal")
  const txtTiempoEjecucion = $q("#txtTiempoEjecucion")
  const contenedorDetallesOdtEntrada = $q(".contenedor-detallesOdtEntrada") // DIV
  const contenedorResponsablesOdt = $q(".contenedor-responsablesOdt")
  const contenedorEvidenciaPreviaEntrada = $q("#preview-container-entrada")
  const contenedorEvidenciaPreviaSalida = $q("#preview-container")

  //BOTONES
  const evidenciasInput = $q("#evidencias-img-input")
  const btnIniciar = $q("#btn-iniciar")
  const btnFinalizar = $q("#btn-finalizar")
  const btnGuardarDianogstico = $q("#btn-guardar-diagnostico")

  //Ejecutar funciones 
  await obtenerOdt() // paso 1 
  await obtenerDiagnostico(1)
  //await obtenerEvidencias() // paso 3
  await obtenerTareaPorId(idtarea) // paso 4
  await obtenerActivosPorTarea(idtarea)
  await obtenerResponsablesAsignados()

  //RENDERIZAR
  await renderDiagnosticoEntrada()
  await renderDetalles()
  await renderResponsables()
  await verificarCantidadEvidenciasEntrada()
  //alert("holaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  await verificarDiagnosticoSalidaRegistrado()
  await verificarEvidenciasRegistradas()
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
    console.log("evidencias: ", evidencias)
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
    const formRegistroDetalleOdt = new FormData()
    formRegistroDetalleOdt.append("operation", "registrarDetalleOdt")
    formRegistroDetalleOdt.append("idodt", idordengenerada)
    formRegistroDetalleOdt.append("clasificacion", 9)
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

  async function actualizarDetalleOdt(fechaFinal, tiempoEjecucion) {
    const formActualizacion = new FormData()
    formActualizacion.append("operation", "actualizarDetalleOdt");
    formActualizacion.append("iddetalleodt", iddetalleodtGenerado); // El ID generado
    formActualizacion.append("fechafinal", fechaFinal); // Fecha final actual
    formActualizacion.append("tiempoejecucion", tiempoEjecucion); // Tiempo de ejecución calculado
    formActualizacion.append("clasificacion", 11);
    const fActualizado = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formActualizacion })
    const actualizado = await fActualizado.json()
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

  async function renderDiagnosticoEntrada() {
    const diagnosticoEntrada = await obtenerDiagnostico(1) // entrada
    console.log("diagnosticoEntrada: ", diagnosticoEntrada)
    iddiagnosticoEntrada = diagnosticoEntrada[0]?.iddiagnostico
    txtDiagnosticoEntrada.innerHTML = diagnosticoEntrada[0].diagnostico
  }

  async function renderDetalles() {
    //const diagnosticoEntrada = await obtenerDiagnostico(1) // entrada
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
            <div class="card-footer">
              <button class="btn btn-primary btn-evidencia-eliminar" data-id="${evidenciaObj.idevidencias_diagnostico}">Eliminar</button>
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

  async function verificarCantidadEvidenciasEntrada() {
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
  }

  async function verificarDiagnosticoSalidaRegistrado() {
    const diagnostico = await obtenerDiagnostico(2)
    if (diagnostico.length == 1) {
      hayDiagnostico = true
      alert("ya hay un diagnostico registrado")
      txtDiagnosticoSalida.value = diagnostico[0].diagnostico
      console.log("DIAGNOSTICO TRAIDO: ", diagnostico)
      iddiagnosticoSalidaGenerado = diagnostico[0].iddiagnostico
      return
    } else {
      const diagnostico = await registrarDiagnosticoSalida()
      alert("se creo un nuevo diagnostico")
      hayDiagnostico = true
      console.log("id diagnostico generado: ", diagnostico)
      alert("registrando diagn,.....")
      iddiagnosticoSalidaGenerado = diagnostico.id
      console.log("iddiagnosticoSalidaGenerado: ", iddiagnosticoSalidaGenerado)
      return
    }
  }

  async function verificarEvidenciasRegistradas() {
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

  async function verificarDetalleOdtRegistrado() {
    const detalleOdt = await obtenerDetalleOdt()
    console.log("DETALLE ODT DESPUES DE VERIFICAR: ", detalleOdt)
    if (detalleOdt.length == 1 || detalleOdt.length > 1) {
      hayDetalle = true
      alert("ya hay un detalle odt registrado")
      //render *****************************************************************
      txtFechaInicial.innerText = detalleOdt[0].fecha_inicial ? detalleOdt[0].fecha_inicial : ''
      txtFechaFinal.innerText = detalleOdt[0].fecha_final ? detalleOdt[0].fecha_final : ''
      txtTiempoEjecucion.innerText = detalleOdt[0].tiempo_ejecucion ? detalleOdt[0].tiempo_ejecucion : ''
      //fin render *************************************************************
      iddetalleodtGenerado = detalleOdt[0].iddetalleodt
      btnIniciar.disabled = true
      btnIniciar.removeAttribute("id")
      btnFinalizar.disabled = true
      btnFinalizar.removeAttribute("id")
      //console.log("btnIniciar: ", btnIniciar)
      return
    } else {
      btnIniciar.disabled = false
      btnFinalizar.disabled = false
      txtFechaInicial.innerText = ''
      txtFechaFinal.innerText = ''
      txtTiempoEjecucion.innerText = ''
      iddetalleodtGenerado = -1
    }
  }

  // **************************** FIN DE SECCION DE VERIFICACIONES **************************************

  // ***************************************** EVENTOS **************************************************

  evidenciasInput.addEventListener('change', async (e) => {
    if (idordengenerada && iddiagnosticoSalidaGenerado == -1) {
      // Verificar que haya un diagnóstico antes de subir las evidencias
      console.log("NO HAY UNA ORDEN SOBRE QUE TRABAJAR")
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
    const detalleRegistrado = await registrarDetalleOdt()
    btnIniciar.disabled = true
    btnIniciar.removeAttribute("id")
    iddetalleodtGenerado = detalleRegistrado.id
    const detalleOdt = await obtenerDetalleOdt() // detalleRegistrado => id
    console.log("Detalle odt obtenido: ", detalleOdt)
    txtFechaInicial.innerText = `${detalleOdt[0].fecha_inicial}`
    console.log("detalle registrado: ", detalleRegistrado)
  })

  btnGuardarDianogstico.addEventListener("click", async () => {
    const actualizado = await actualizarDiagnosticoSalida()
    console.log("actualizado diagnostico salida:? ", actualizado)
  })

  btnFinalizar.addEventListener("click", async () => {
    // Obtener la fecha actual como fecha final
    const fechaFinal = new Date().toLocaleString('en-CA', { hour12: false }).replace(',', '').replace('/', '-').replace('/', '-');
    console.log("FECHA FINAL OBTENIDA: ", fechaFinal)
    // Obtener el detalle ODT registrado (deberías tener la fecha inicial en la base de datos)
    const detalleOdt = await obtenerDetalleOdt(); // Esto ya trae la fecha_inicial

    if (detalleOdt.length > 0) {
      // Calculamos la fecha inicial (en formato Date)
      const fechaInicial = new Date(detalleOdt[0].fecha_inicial);
      console.log("fechaInicial: ", fechaInicial)
      // Calculamos la diferencia en milisegundos entre fecha_final y fecha_inicial
      const tiempoEjecucionMs = new Date(fechaFinal) - fechaInicial;
      // Convertir la diferencia a horas, minutos y segundos
      const tiempoEjecucionHoras = Math.floor(tiempoEjecucionMs / (1000 * 60 * 60));
      const tiempoEjecucionMinutos = Math.floor((tiempoEjecucionMs % (1000 * 60 * 60)) / (1000 * 60));
      const tiempoEjecucionSegundos = Math.floor((tiempoEjecucionMs % (1000 * 60)) / 1000);

      const tiempoEjecucion = `${tiempoEjecucionHoras.toString().padStart(2, '0')}:${tiempoEjecucionMinutos.toString().padStart(2, '0')}:${tiempoEjecucionSegundos.toString().padStart(2, '0')}`;
      console.log("Tiempo ejecutado (formato HH:MM:SS): ", tiempoEjecucion)

      // Llamamos a la función que actualiza el detalle ODT
      const actualizado = await actualizarDetalleOdt(fechaFinal, tiempoEjecucion);
      console.log("DETALLE ODT ACTUALIZADO??? => ", actualizado)
      if (actualizado.actualizado) {
        const detalleActualizadoData = await obtenerDetalleOdt()
        console.log("detalleActualizadoData: ", detalleActualizadoData)
        txtFechaFinal.innerText = detalleActualizadoData[0].fecha_final
        txtTiempoEjecucion.innerText = detalleActualizadoData[0].tiempo_ejecucion
        //desabilitar el boton finalizar
        btnFinalizar.disabled = true
        btnFinalizar.removeAttribute("id")
      }
      /* if (actualizado.guardado === 'success') {
        alert("El detalle ODT se ha actualizado con éxito.");
      } else {
        alert("Hubo un error al actualizar el detalle ODT.");
      } */
    }
  })

  // ************************************ FIN DE EVENTOS ************************************************

});
