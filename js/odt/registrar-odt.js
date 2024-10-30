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

    // VARIABLES
    const idodtgenerada = window.localStorage.getItem("idodt")
    const idtareagenerada = window.localStorage.getItem("idtarea")
    const host = "http://localhost/CMMS/controllers/";
    let tbResponsables = null
    let iddiagnosticoGenerado = -1
    let hayDiagnostico = false
    //CONTAINERS DIV
    const contenedorRegistrarOdt = $q("#contenedor-registrar-odt")
    const previewContainer = $q("#preview-container")
    //INPUTS 
    const filters = $all(".filter")
    const tbodyResponsables = $q("#responsablesBodyTable");
    const npusuario = $q("#txtNombresApellidos") // FILTRO DE NOMBRES Y APELLIDOS
    const documentoIdentidad = $q("#txtDni")
    const txtDiagnosticoEntrada = $q("#diagnostico-entrada")
    const evidenciasInput = $q("#evidencias-img-input")
    //UL
    const ulResponsablesAsignados = $q(".contenedor-responsables-asignados")
    //LISTA
    let responsablesElegidos = []
    //BOTONES
    const btnAgregarResponsable = $q("#btnAgregarResponsable");
    const btnCrearOdt = $q("#btnCrearOdt")
    //renderTablaUsuarios()
    await verificarOdtEstado()
    await verificarFvencimiento()
    await verificarDiagnosticoRegistrado()
    await verificarIdsGenerados() // SI ESTO SUCEDE LO DEMAS EN GENERAL NO DEBERIA DE EJECUTAR
    await filtrarUsuariosList()
    await renderResponsablesOdt()
    await verificarEvidenciasRegistradas()
    await obtenerActivosPorTarea()
    //sestadoBotonConfirmarAsignacion()

    // ************************************ FUNCIONES PARA OBTENER DATOS ************************************
    async function obtenerUsuarios() { // RENDERIZAR USUARIOS QUE SERIVIRA PARA ASIGNAR RESPONSABLES AL ODT
        const params = new URLSearchParams();
        params.append("operation", "filtrarUsuarios");
        params.append("dato", npusuario.value.trim() === "" ? "" : npusuario.value);
        params.append("numdoc", documentoIdentidad.value.trim() === "" ? "" : documentoIdentidad.value);
        const usuarios = await getDatos(`${host}usuarios.controller.php`, params);
        return usuarios;
    }

    async function obtenerUsuario(idusuario) {
        const params = new URLSearchParams()
        params.append("operation", "getUserById")
        params.append("idusuario", idusuario)
        const usuario = await getDatos(`${host}usuarios.controller.php`, params)
        return usuario
    }

    async function obtenerResponsablesAsignados() {
        const params = new URLSearchParams()
        params.append("operation", "obtenerResponsables")
        params.append("idodt", window.localStorage.getItem("idodt"))
        const responsables = getDatos(`${host}responsablesAsignados.controller.php`, params)
        return responsables
    }

    async function obtenerDiagnosticoEntrada() {
        const paramsDiagnosticoBuscar = new URLSearchParams()
        paramsDiagnosticoBuscar.append("operation", "obtenerDiagnostico")
        paramsDiagnosticoBuscar.append("idordentrabajo", window.localStorage.getItem("idodt"))
        paramsDiagnosticoBuscar.append("idtipodiagnostico", 1)
        const diagnosticoObtenido = await getDatos(`${host}diagnostico.controller.php`, paramsDiagnosticoBuscar)
        return diagnosticoObtenido
    }


    async function obtenerEvidencias(iddiagnostico) {
        console.log("ID DIAGNOSTICO AAA: ", iddiagnostico)
        const params = new URLSearchParams()
        params.append("operation", "obtenerEvidenciasDiagnostico")
        params.append("iddiagnostico", iddiagnostico)
        const evidencias = await getDatos(`${host}diagnostico.controller.php`, params)
        return evidencias
    }

    async function obtenerActivosPorTarea() {
        const params = new URLSearchParams()
        params.append("operation", "obtenerActivosPorTarea")
        params.append("idtarea", idtareagenerada)
        const activo = await getDatos(`${host}activo.controller.php`, params)
        console.log("activos: ", activo)
        return activo
    }

    async function obtenerOdtporId() {
        const params = new URLSearchParams()
        params.append("operation", "obtenerOdtporId")
        params.append("idodt", idodtgenerada)
        const odt = await getDatos(`${host}ordentrabajo.controller.php`, params)
        return odt
    }
    // ************************************ FIN DE FUNCIONES PARA OBTENER DATOS ******************************

    // paso 1: FILTRAR Y ELEGIR Y GUARDAR EN UNA LISTA LOS USUARIOS ELEGIDOS A SER RESPONSABLES 
    async function filtrarUsuariosList() {
        const usuarios = await obtenerUsuarios()
        tbodyResponsables.innerHTML = "";
        console.log("usuarios fitlrados", usuarios);
        for (let i = 0; i < usuarios.length; i++) {
            tbodyResponsables.innerHTML += `
            <tr>
                <th scope="row">
                    <input type="checkbox" class="usuario-checkbox" data-idusuario="${usuarios[i].id_usuario}">
                </th>
                <td>${usuarios[i].nombres}</td>
                <td>${usuarios[i].usuario}</td>
                <td>${usuarios[i].rol}</td>
                <td>${usuarios[i].num_doc}</td>
            </tr>
            `;
        }
        //estadoBotonConfirmarAsignacion()
        renderTablaUsuarios()

        const chkUsuarios = $all(".usuario-checkbox")
        chkUsuarios.forEach(chk => {
            const idRespCheckbox = parseInt(chk.getAttribute("data-idusuario"));
            console.log("xd", idRespCheckbox)
            const usuarioEncontrado = responsablesElegidos.find(usuario => usuario.idresponsable === idRespCheckbox);
            if (usuarioEncontrado) {
                chk.checked = true;  // Marcar si ya estaba seleccionado
            }

            chk.addEventListener("change", () => {
                console.log("activos seleccionados despues de cambiar el filtro: ", responsablesElegidos)


                if (chk.checked) {
                    const found = responsablesElegidos.find(usuario => usuario.idresponsable === idRespCheckbox);
                    if (!found) {
                        responsablesElegidos.push({
                            idorden_trabajo: idodtgenerada,
                            idresponsable: idRespCheckbox
                        });
                    }

                } else {
                    // Si está desmarcado
                    responsablesElegidos = responsablesElegidos.filter(usuario => usuario.idresponsable !== idRespCheckbox);
                }

                console.log(responsablesElegidos);
            })
        })

    }

    filters.forEach(select => {
        select.addEventListener("input", async () => {
            await filtrarUsuariosList()
        })
    })

    // ******************************* SECCION DE RENDERIZADO DE DATOS EN INTERFAZ ****************************
    function renderTablaUsuarios() {
        if (tbResponsables) {
            tbResponsables.clear().rows.add($(tbodyResponsables).find('tr')).draw();
        } else {
            // Inicializa DataTable si no ha sido inicializado antes
            tbResponsables = $('#tablaResponsables').DataTable({
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

    async function renderResponsablesOdt() {
        const responsablesData = await obtenerResponsablesAsignados()
        console.log("responsablesData: ", responsablesData)
        for (let i = 0; i < responsablesData.length; i++) {
            ulResponsablesAsignados.innerHTML += `
                <li class="list-group-item d-flex justify-content-between align-items-center mb-3" data-id=${responsablesData[i].idresponsable_asignado} data-idresponsable=${responsablesData[i].idresponsable}>
                    ${responsablesData[i].nombres}
                    <span class="bg-white btn-eliminar-responsable" data-id=${responsablesData[i].idresponsable_asignado} data-idresponsable=${responsablesData[i].idresponsable}>
                        <i class="fa-solid fa-trash text-dark"></i>
                    </span>
                </li>
                
            `
        }
        if (responsablesData.length > 0) {
            alert("SI HAY RESPONSABLES")
        }
        //await crearOdt()
        await eliminarLiResponsable()
    }

    // ****************************** FIN DE SECCIO DE RENDERIZADOS DE DATOS EN INTERFAZ ************************

    // ******************************* EVENTOS *******************************************
    btnAgregarResponsable.addEventListener('click', async () => {
        const checkboxes = $all(".usuario-checkbox") // DESMARCAR TODOS LOS CHECKVBOXES UNA VEZ AGREGADOS
        await registrarResponsable()
        checkboxes.forEach(checkbox => {
            checkbox.checked = false;
        });

        // Limpiar la lista de responsables asignados
        responsablesElegidos = [];
        //estadoBotonConfirmarAsignacion()
    });

    evidenciasInput.addEventListener('change', async (e) => {
        if (iddiagnosticoGenerado == -1) {
            // Verificar que haya un diagnóstico antes de subir las evidencias
            console.log("NO SE CREO UN DIAGNOSTICO , MUY RARO")
            return
        } else {
            const evidenciaImagen = e.target.files[0] //ME QUEE ACAAAAA falta capturar el nombre de imagen y subir la evidencia
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

    btnCrearOdt.addEventListener("click", async () => {
        habilitarBeforeUnload = false;
        //VERIFICAACION        
        const actualizado = await actualizarDiagnosticoEntrada()
        console.log("actualizado diagnostico:? ", actualizado)

        const odtActualizado = await actualizarEstadoOdt()
        console.log("odt actualizado?: ", odtActualizado)
        if (odtActualizado?.actualizado) {
            window.localStorage.clear()
            window.location.href = 'http://localhost/CMMS/views/odt'
            console.log("redirigiendop ....")
        } else {
            //window.location.href = 'http://localhost/CMMS/views/odt'
            console.log("REDIRIGIR PERO NO ACTUALIZO.")
        }
    })

    // ****************************** FIN DE EVENTOS ************************************

    // ********************************* SECCION DE REGISTROS ***********************************
    // REGISTROS FUNCIONES
    async function registrarResponsablesAsignados(idresponsable) {
        console.log("ID ODT A ASIGNARLE: ", window.localStorage.getItem("idodt"))
        const formResponsableAsignado = new FormData()
        formResponsableAsignado.append("operation", "asignarResponsables")
        formResponsableAsignado.append("idordentrabajo", window.localStorage.getItem("idodt"))
        formResponsableAsignado.append("idresponsable", idresponsable)
        const fresponsableId = await fetch(`${host}responsablesAsignados.controller.php`, { method: 'POST', body: formResponsableAsignado })
        const responsableId = await fresponsableId.json()
        return responsableId
    }

    //REGISTRAR A CADA USUARIOS ELEGIDO COMO RESPONSABLE SEGUN LA LISTA
    async function registrarResponsable() {
        /* const chkboxesMarcados = $all(".usuario-checkbox:checked");
        chkboxesMarcados.forEach(chkbox => {
            responsablesElegidos.push(chkbox.value)
            console.log("chk valorr: ", chkbox.value)
        }) */

        console.log('Responsables asignados:', responsablesElegidos);
        // EL ID RESPONSABLE SE REFIERE AL IDUSUARIO , osea son lo mismo solo que yo le puse diferente nombre por tabla
        if (responsablesElegidos.length > 0) {
            for (let i = 0; i < responsablesElegidos.length; i++) {
                const responsableId = await registrarResponsablesAsignados(responsablesElegidos[i].idresponsable);
                console.log("responsableId: ", responsableId.idresponsableasignado) //YA RECIBE EL ID RESPONSABLE ID // ME QUEDE ACA
                const usuarioData = await obtenerUsuario(responsablesElegidos[i].idresponsable)
                console.log("usuarioData: ", usuarioData)
                // responsableId => idresponsable_odt
                // idusuario que pertenece => usuarioData[0].idusuario                
                ulResponsablesAsignados.innerHTML += `
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-3" data-id=${responsableId.idresponsableasignado} data-idresponsable=${usuarioData[0].idusuario}>
                        ${usuarioData[0].dato}
                        <span class="bg-white btn-eliminar-responsable" data-id=${responsableId.idresponsableasignado} data-idresponsable=${usuarioData[0].idusuario}>
                            <i class="fa-solid fa-trash text-dark"></i>
                        </span>
                    </li>
                `
            }
            //await crearOdt() // UNA VEZ TENIENDO RESPONSABLES ASIGNADOS podremos finalizar el registro de la ODT
            await eliminarLiResponsable()
        }
    }

    //ESTO SE EJECUTARA CUANDO SE CREE POR PRIMERA VEZ LA ORDEN DE TRABAJO
    async function registrarDiagnosticoEntrada() {
        const formDiagnostico = new FormData()
        formDiagnostico.append("operation", "registrarDiagnostico")
        formDiagnostico.append("idordentrabajo", window.localStorage.getItem("idodt"))
        formDiagnostico.append("idtipodiagnostico", 1)
        formDiagnostico.append("diagnostico", txtDiagnosticoEntrada.value == "" ? "" : txtDiagnosticoEntrada.value)
        const FidDiagnosticoRegistrado = await fetch(`${host}diagnostico.controller.php`, { method: "POST", body: formDiagnostico })
        const idDiagnosticoRegistrado = await FidDiagnosticoRegistrado.json()
        return idDiagnosticoRegistrado
    }
    //BOTONES FUNCIONES
    /* function estadoBotonConfirmarAsignacion() {
        const checkboxes = $all(".usuario-checkbox");

        // Función para verificar el estado de los checkboxes y activar/desactivar el botón
        function verificarEstadoCheckboxes() {
            const algunoSeleccionado = Array.from(checkboxes).some(chk => chk.checked);
            btnAgregarResponsable.disabled = !algunoSeleccionado; // Desactivar si no hay seleccionado
        }

        // Asignar evento 'change' a cada checkbox
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener("change", verificarEstadoCheckboxes);
        });

        // Llamar a la función para verificar el estado inicial de los checkboxes
        verificarEstadoCheckboxes();
    }
 */

    // *************************** SECCION DE ELIMIACIONES *******************************************
    async function eliminarLiResponsable() {
        const botonesEliminarResponsable = $all(".btn-eliminar-responsable");
        botonesEliminarResponsable.forEach(boton => {
            boton.addEventListener('click', async (event) => {
                const idresponsable = boton.getAttribute("data-id");
                console.log("id responsable: ", idresponsable)
                //alert(idresponsable) DEPURAR CUANDO SEA NECESARIO
                const eliminado = await eliminarResponsablesOdt(idresponsable);
                if (!eliminado.eliminado) {
                    alert("OCURRIO UN ERROR AL ELIMINAR RESPONSABLE")
                }
                console.log("paso...: ", eliminado.eliminado)
                /* console.log("resposables elegidos : ", responsablesElegidos)
                responsablesElegidos = responsablesElegidos.filter(id => id.idresponsable !== idresponsable); */

                // Actualizar el DOM eliminando el elemento <li>
                const listItem = document.querySelector(`li[data-id="${idresponsable}"]`);
                if (listItem) {
                    listItem.remove();
                }
                //VERIFICAR SI HAY AUN RESPONSABLES ASIGNADOS REGISTRADOS 
                /* const responsablesData = await obtenerResponsablesPorOdt(window.localStorage.getItem("idodt"))
                console.log("responsablesData: ", responsablesData)

                if (responsablesData.length > 0) {
                    colResponsablesOk = true
                } else {
                    btnCrearOdt.disabled = true
                } */

            });
        });
    }

    async function eliminarResponsablesOdt(idresponsableasignado) {
        const formEliminacion = new FormData()
        formEliminacion.append("operation", "eliminarResponsableOdt")
        const fResEliminacion = await fetch(`${host}responsablesAsignados.controller.php/${idresponsableasignado}`, { method: 'POST', body: formEliminacion })
        const responsableEliminado = await fResEliminacion.json()
        return responsableEliminado
    }

    async function eliminarEvidenciaOdt(idevidencia) {
        const formEliminacion = new FormData()
        formEliminacion.append("operation", "eliminarEvidencia")
        const fEliminado = await fetch(`${host}diagnostico.controller.php/${idevidencia}`, { method: 'POST', body: formEliminacion })
        const eliminado = await fEliminado.json()
        return eliminado
    }
    // ******************************* FIN DE SECCION DE ELIMINACIONES **********************************

    // *************************** SECCION DE VERIFICACION ***********************************************

    async function verificarDiagnosticoRegistrado() {
        const diagnostico = await obtenerDiagnosticoEntrada()
        if (diagnostico.length == 1) {
            hayDiagnostico = true
            alert("ya hay un diagnostico de salida registrado")
            txtDiagnosticoEntrada.value = diagnostico[0].diagnostico
            iddiagnosticoGenerado = diagnostico[0].iddiagnostico
            return
        } else {
            const diagnostico = await registrarDiagnosticoEntrada()
            //alert("se creo un nuevo diagnostico")
            hayDiagnostico = true
            console.log("id diagnostico salida generado: ", diagnostico.id)
            iddiagnosticoGenerado = diagnostico.id
            return
        }
    }

    async function verificarEvidenciasRegistradas() {
        const evidenciasObtenidas = await obtenerEvidencias(iddiagnosticoGenerado);
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
    }

    async function verificarIdsGenerados() {
        if (iddiagnosticoGenerado == -1 && !window.localStorage.getItem("idodt")) { // SI NO HAY ID GENERADO Y NO EXISTE ESE ITEM EN LOCALSTORAGE
            contenedorRegistrarOdt.innerHTML = ''
            contenedorRegistrarOdt.innerHTML = `
            <div class="container-fluid">
                <div class="row">
                    <h1 class="">No has seleccionado ninguna orden a editar</h1>
                </div>
            </div>
            `
            console.log("BODY BORRADO")
            return
        }
    }

    async function verificarFvencimiento() {
        let existen = false
        const odt = await obtenerOdtporId()
        console.log("odt: ", odt)
        if (odt[0]?.fecha_vencimiento == "0000-00-00" && odt[0]?.hora_vencimiento == "00:00:00") {
            existen = false
            console.log("no existe una fecha ni hora de v")
            return
        }
        else {
            const contenedorFechHoraExistente = $q("#contenedor-fecha-hora")
            if (contenedorFechHoraExistente) {
                contenedorFechHoraExistente.remove();
            }
            existen = true
            return {
                'existen': existen,
                'fecha_vencimiento': odt[0]?.fecha_vencimiento,
                'hora_vencimiento': odt[0]?.hora_vencimiento
            }
        }
    }

    async function verificarOdtEstado() {
        const odtObtenida = await obtenerOdtporId()
        console.log("odtObtenida: ", odtObtenida)
        if (odtObtenida[0]?.clasificacion == 11 || odtObtenida[0]?.idestado == 11 || odtObtenida[0]?.idestado == 10) { //VERIFICAR SI YA ESTA FINALIZADA , SI LO ESTA NO DEBERIA DE MOSTRAR EL REGISTRO
            contenedorRegistrarOdt.innerHTML = `
            <div class="container-fluid">
                <div class="row">
                    <h1 class="">No puedes editar esta orden por que ya fue completada.</h1>
                </div>
            </div>
            `
        } else if (!window.localStorage.getItem("idodt")) {
            contenedorRegistrarOdt.innerHTML = `
            <div class="container-fluid">
                <div class="row">
                    <h1 class="">No has seleccionado ninguna orden a editar.</h1>
                </div>
            </div>
            `
        }
    }

    // ************************* SECCION DE MODALES *******************************************************

    async function abrirModalSidebar() {
        /* const modalSidebar = document.getElementById(modalId); // Obtener el modal por ID
        const bsOffcanvas = new bootstrap.Offcanvas(modalSidebar); // Usar Bootstrap Offcanvas API
        bsOffcanvas.show(); // Mostrar el modal

        console.log('Modal abierto: ' + modalId); // Confirmar que la función se llama
 */
        // Limpiar y rellenar el modal con las evidencias
        const modalEvidenciasContainer = document.getElementById("modal-evidencias-container");
        modalEvidenciasContainer.innerHTML = ''; // Limpiar el contenedor

        // Obtener evidencias desde la API o fuente de datos
        const evidenciasObtenidas = await obtenerEvidencias(iddiagnosticoGenerado);
        console.log("Evidencias obtenidas: ", evidenciasObtenidas);

        // Iterar sobre cada evidencia y crear elementos de imagen
        evidenciasObtenidas.forEach(evidenciaObj => {
            const imgSrc = evidenciaObj.evidencia;
            modalEvidenciasContainer.innerHTML += `
            <div class="card mb-3 text-center" data-id="${evidenciaObj.idevidencias_diagnostico}">
                <img src="http://localhost/CMMS/dist/images/evidencias/${imgSrc}" class="card-img-top modal-img" alt="Evidencia ${imgSrc}">
                <div class="card-footer">
                    <button class="btn btn-primary btn-evidencia-eliminar" data-id="${evidenciaObj.idevidencias_diagnostico}">Eliminar</button>
                </div>
            </div>
            `
            // Acceder a la propiedad 'evidencia' del objeto
            /* const imgElement = document.createElement('img');
            imgElement.src = `http://localhost/CMMS/dist/images/evidencias/${imgSrc}`; // Ajustar la ruta a la imagen
            imgElement.alt = `Evidencia ${imgSrc}`;
            imgElement.classList.add('modal-img'); */ // Añadir clase para estilo (opcional)

            // Añadir la imagen al contenedor del modal
            //modalEvidenciasContainer.appendChild(imgElement);
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
        }) //ME QUEDE ACA FALTA HACER EL SPU ELIMINAR EVIDENCIA DIAGNOSTICO, HACER SU CONTROLER Y SU MODAL Y SU FUNCION PARA JAVASCRIPT

    }

    //************************** FIN SECCION DE MODALES *************************************************** */

    async function actualizarDiagnosticoEntrada() {
        const formActualizacion = new FormData()
        formActualizacion.append("operation", "actualizarDiagnostico")
        formActualizacion.append("iddiagnostico", iddiagnosticoGenerado)
        formActualizacion.append("diagnostico", txtDiagnosticoEntrada.value)
        const fActualizado = await fetch(`${host}diagnostico.controller.php`, { method: 'POST', body: formActualizacion })
        const actualizado = await fActualizado.json()
        return actualizado
    }

    async function actualizarEstadoOdt() {
        //VERIFICACION: 
        const responsablesAsignados = await obtenerResponsablesAsignados()
        const diagnosticoEntrada = await obtenerDiagnosticoEntrada()
        const evidencias = await obtenerEvidencias(iddiagnosticoGenerado)
        const existeFechaVencimiento = await verificarFvencimiento()
        console.log("existeFechaVencimiento???????: ", existeFechaVencimiento)
        //
        const activos = await obtenerActivosPorTarea()
        if (responsablesAsignados.length > 0 && diagnosticoEntrada.length == 1 && evidencias.length > 0) {
            // SI POR LO MENOS HAY RESPONSABLES ASIGNADOS Y HAY DIAGNOSTICO (YA DEBERIA TENER AUTOMATICO) Y SI HAY EVIDENNCIAS
            for (let o = 0; o < activos.length; o++) {
                await actualizarEstadoActivo(activos[o].idactivo, 2)
            }
            for (let i = 0; i < responsablesAsignados.length; i++) {
                await actualizarAsignacionUsuario(responsablesAsignados[i].idresponsable, 6)
            }

        } else {
            for (let o = 0; o < activos.length; o++) {
                await actualizarEstadoActivo(activos[o].idactivo, 1)
            }
            for (let i = 0; i < responsablesAsignados.length; i++) {
                await actualizarAsignacionUsuario(responsablesAsignados[i].idresponsable, 7)
            }
        }

        if (existeFechaVencimiento.existen == true) {
            const formActualizacionFVencimiento = new FormData()
            formActualizacionFVencimiento.append("operation", "actualizarFechaVencimientoOdt")
            formActualizacionFVencimiento.append("idodt", window.localStorage.getItem("idodt"))
            formActualizacionFVencimiento.append("fecha_vencimiento", existeFechaVencimiento.fecha_vencimiento)
            formActualizacionFVencimiento.append("hora_vencimiento", existeFechaVencimiento.hora_vencimiento)
            const FVencimientoActualizado = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formActualizacionFVencimiento })
            const FVactualizado = await FVencimientoActualizado.json()
            console.log("FECHA Y HORA VENCIMIENTO ACTUALIZADAS?: ", FVactualizado)

            const formActualizacion = new FormData()
            formActualizacion.append("operation", "actualizarBorradorOdt")
            formActualizacion.append("idordentrabajo", window.localStorage.getItem("idodt"))
            formActualizacion.append("borrador", (responsablesAsignados.length > 0 && diagnosticoEntrada.length == 1 && evidencias.length > 0) ? 0 : 1)
            const Factualizado = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formActualizacion })
            const actualizado = await Factualizado.json()
            return actualizado
        }

        else {
            let fechaVencimiento = $q("#fecha-vencimiento").value;
            let horaVencimiento = $q("#hora-vencimiento").value;

            if (!fechaVencimiento || !horaVencimiento) {
                alert("Por favor, asegúrese de llenar tanto la fecha como la hora de vencimiento.");
                return;
            }
            // Convertir la fecha y hora de vencimiento en un objeto Date con la zona horaria de Lima
            let fechaHoraVencimiento = new Date(`${fechaVencimiento}T${horaVencimiento}:00-05:00`);

            // Obtener la fecha y hora actual en la zona horaria de Perú (America/Lima)
            let ahora = new Date().toLocaleString("en-US", { timeZone: "America/Lima" });
            let fechaHoraActual = new Date(ahora);

            // Validar que la fecha y hora de vencimiento no sean menores a la fecha y hora actual
            if (fechaHoraVencimiento < fechaHoraActual) {
                alert("La fecha y hora de vencimiento no pueden ser anteriores a la fecha y hora actual.");
                return;
            }


            const formActualizacionFVencimiento = new FormData()
            formActualizacionFVencimiento.append("operation", "actualizarFechaVencimientoOdt")
            formActualizacionFVencimiento.append("idodt", window.localStorage.getItem("idodt"))
            formActualizacionFVencimiento.append("fecha_vencimiento", fechaVencimiento)
            formActualizacionFVencimiento.append("hora_vencimiento", horaVencimiento)
            const FVencimientoActualizado = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formActualizacionFVencimiento })
            const FVactualizado = await FVencimientoActualizado.json()
            console.log("FECHA Y HORA VENCIMIENTO ACTUALIZADAS?: ", FVactualizado)

            const formActualizacion = new FormData()
            formActualizacion.append("operation", "actualizarBorradorOdt")
            formActualizacion.append("idordentrabajo", window.localStorage.getItem("idodt"))
            formActualizacion.append("borrador", (responsablesAsignados.length > 0 && diagnosticoEntrada.length == 1 && evidencias.length > 0) ? 0 : 1)
            const Factualizado = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formActualizacion })
            const actualizado = await Factualizado.json()
            return actualizado
        }
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
    // ******************************** SECCION DE ACTUALIZACIONES ******************************************
});