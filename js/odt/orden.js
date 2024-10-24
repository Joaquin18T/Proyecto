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

  //variables globales
  const host = "http://localhost/CMMS/controllers/";
  let idordengenerada = window.localStorage.getItem("idodt")
  let idtarea = -1
  let iddiagnosticoEntrada = -1
  let iddiagnosticoSalidaGenerado = -1;

  //UI
  const txtDiagnosticoEntrada = $q("#txtDiagnosticoEntrada")
  const txtDiagnosticoSalida = $q("#diagnostico-salida")
  const contenedorDetallesOdtEntrada = $q(".contenedor-detallesOdtEntrada") // DIV
  const contenedorResponsablesOdt = $q(".contenedor-responsablesOdt")
  const contenedorBtnAbrirSideModal = $q("#contenedor-btn-abrirSideModal")
  const contenedorEvidenciaPrevia = $q("#contenedor-evidencia-previa")

  //Ejecutar funciones 
  await obtenerOdt() // paso 1 
  await obtenerDiagnostico(1)
  await obtenerEvidencias() // paso 3
  await obtenerTareaPorId(idtarea) // paso 4
  await obtenerActivosPorTarea(idtarea)
  await obtenerResponsablesAsignados()

  //RENDERIZAR
  await renderDiagnosticoEntrada()
  await renderDetalles()
  await renderResponsables()
  await verificarCantidadEvidenciasEntrada()
  await verificarDiagnosticoSalidaRegistrado()

  //BOTONES
  const evidenciasInput = $q("#evidencias-img-input")
  const btnIniciar = $q("#btn-iniciar")
  const btnFinalizar = $q("#btn-finalizar")



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

  async function obtenerEvidencias() {
    console.log("ID DIAGNOSTICO AAA: ", iddiagnosticoEntrada)
    const params = new URLSearchParams()
    params.append("operation", "obtenerEvidenciasDiagnostico")
    params.append("iddiagnostico", iddiagnosticoEntrada)
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
    console.log("diagnostico de salida: ", diagnosticoObtenido)
    iddiagnosticoEntrada = diagnosticoObtenido[0]?.iddiagnostico
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

  //****************************** FIN DE SECCION DE ACTUALIZACIONES ********************************** */

  // **************************** SECCION DE RENDERIZAR INTERFAZ CON DATOS ****************************** */

  async function renderDiagnosticoEntrada() {
    const diagnosticoEntrada = await obtenerDiagnostico(1) // entrada
    console.log("diagnosticoEntrada: ", diagnosticoEntrada)
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

  async function abrirModalSidebar() {
    const modalEvidenciasContainer = document.getElementById("modal-evidencias-container");
    modalEvidenciasContainer.innerHTML = ''; // Limpiar el contenedor

    const evidenciasObtenidas = await obtenerEvidencias(iddiagnosticoEntrada);
    console.log("Evidencias obtenidas: ", evidenciasObtenidas);

    // Iterar sobre cada evidencia y crear elementos de imagen
    evidenciasObtenidas.forEach(evidenciaObj => {
      const imgSrc = evidenciaObj.evidencia;
      modalEvidenciasContainer.innerHTML += `
        <div class="mb-3 text-center" data-id="${evidenciaObj.idevidencias_diagnostico}">
            <img src="http://localhost/CMMS/dist/images/evidencias/${imgSrc}" width=450 alt="Evidencia ${imgSrc}">            
        </div>
      `
    });
  }

  // ************************* FIN DE SECCION DE MODALES **************************************************

  // *************************** SECCION DE VERIFICACIONES ********************************************

  async function verificarCantidadEvidenciasEntrada() {
    const evidenciasObtenidas = await obtenerEvidencias(iddiagnosticoEntrada);
    console.log("cantidad de evidencias: ", evidenciasObtenidas);
    if (evidenciasObtenidas.length > 1) {
      console.log("hay mucha evidencias apartir de 1s")
      //CREACION DE UN BOTON PARA MOSTRAR EL MODAL SIDEBAR
      contenedorBtnAbrirSideModal.innerHTML = `
        <button class="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRightEvidencias" id="btnAbrirModalSidebar">
          Ver todas las evidencias
        </button> 
      `
      contenedorEvidenciaPrevia.innerHTML = ""
      contenedorEvidenciaPrevia.innerHTML = `
        <img src="http://localhost/CMMS/dist/images/evidencias/${evidenciasObtenidas[0].evidencia}" class="img-fluid rounded-start" alt="...">
      `
      const btnAbrirModalSidebar = $q("#btnAbrirModalSidebar")
      btnAbrirModalSidebar.addEventListener("click", () => {
        console.log("clickeando dxdxdxd")
        abrirModalSidebar()
      })
    } else {
      evidenciasObtenidas.forEach(evidencia => {
        contenedorEvidenciaPrevia.innerHTML = ""
        contenedorEvidenciaPrevia.innerHTML = `
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
      formEvidencia.append("iddiagnostico", iddiagnosticoGenerado);
      formEvidencia.append("evidencia", evidenciaImagen); // Aquí se añade el archivo de evidencia (imagen)

      try {
        const Frespuesta = await fetch(`${host}diagnostico.controller.php`, { method: 'POST', body: formEvidencia })
        const subida = await Frespuesta.json();
        if (subida.guardado === 'success') {
          showToast(subida.message, 'INFO')
          //renderizar imagen

          // Renderizar imagen y botón usando HTML directo
          const imgSrc = URL.createObjectURL(evidenciaImagen); // Crear URL temporal de la imagen

          previewContainer.innerHTML = `
                    <div class="card mb-3 text-center">
                        <img src="${imgSrc}" class="card-img-top modal-img" alt="Evidencia" style="max-width: 500px;">
                        <div class="card-footer">
                            <button class="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRightEvidencias" id="btnAbrirModalSidebar">
                                Ver todas las evidencias
                            </button>
                        </div>
                    </div>
                `;
          //
          const btnAbrirModalSidebar = $q("#btnAbrirModalSidebar")
          btnAbrirModalSidebar.addEventListener("click", () => {
            console.log("clickeando dxdxdxd")
            abrirModalSidebar()
          })

        } else {
          showToast(subida.message, 'ERROR')
        }
      } catch (error) {
        console.error('Error en la petición:', error);
      }

    }
  })

  btnIniciar.addEventListener("click", async ()=>{
    const actualizado = await actualizarDiagnosticoSalida()
    console.log("actualizado diagnostico salida:? ", actualizado)
  })

  // ************************************ FIN DE EVENTOS ************************************************

});
