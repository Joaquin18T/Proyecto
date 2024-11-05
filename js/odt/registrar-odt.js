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
    //await verificarOdtEstado()
    //await verificarFvencimiento()
    //await verificarDiagnosticoRegistrado()
    //await verificarIdsGenerados() // SI ESTO SUCEDE LO DEMAS EN GENERAL NO DEBERIA DE EJECUTAR
    await filtrarUsuariosList()
    await renderResponsablesOdt()
    //await verificarEvidenciasRegistradas()
    //await obtenerActivosPorTarea()
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
        console.log("CLICK A BTN AGREGAR REASPONSAB LE")
        responsablesElegidos = [];
        const responsablesAsignados = await obtenerResponsablesAsignados()
        console.log("responsablesAsignados: ", responsablesAsignados)
        if (responsablesAsignados.length > 0) {

            for (let i = 0; i < responsablesAsignados.length; i++) {
                await actualizarAsignacionUsuario(responsablesAsignados[i].idresponsable, 6)
            }

        } else {

            for (let i = 0; i < responsablesAsignados.length; i++) {
                await actualizarAsignacionUsuario(responsablesAsignados[i].idresponsable, 7)
            }
        }
        await filtrarUsuariosList()
        //await eliminarLiResponsable()
        //estadoBotonConfirmarAsignacion()
    });

    /* evidenciasInput.addEventListener('change', async (e) => {
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
    }) */

    btnCrearOdt.addEventListener("click", async () => {
        habilitarBeforeUnload = false;
        //VERIFICAACION        
        //const actualizado = await actualizarDiagnosticoEntrada()
        //console.log("actualizado diagnostico:? ", actualizado)

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
                console.log("responsableId: ", responsableId) //YA RECIBE EL ID RESPONSABLE ID // ME QUEDE ACA
                const usuarioData = await obtenerUsuario(responsablesElegidos[i].idresponsable)
                console.log("usuarioData: ", usuarioData)
                // responsableId => idresponsable_odt
                // idusuario que pertenece => usuarioData[0].idusuario                
                ulResponsablesAsignados.innerHTML += `
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-3" data-id="${responsableId.idresponsableasignado}" data-idresponsable="${usuarioData[0].id_usuario}">
                        ${usuarioData[0].dato}
                        <span class="bg-white btn-eliminar-responsable" data-id="${responsableId.idresponsableasignado}" data-idresponsable="${usuarioData[0].id_usuario}">
                            <i class="fa-solid fa-trash text-dark"></i>
                        </span>
                    </li>
                `
            }
            //await crearOdt() // UNA VEZ TENIENDO RESPONSABLES ASIGNADOS podremos finalizar el registro de la ODT
            await eliminarLiResponsable()
        }
    }



    // *************************** SECCION DE ELIMIACIONES *******************************************
    async function eliminarLiResponsable() {
        const botonesEliminarResponsable = $all(".btn-eliminar-responsable");
        botonesEliminarResponsable.forEach(boton => {
            boton.addEventListener('click', async (event) => {
                const idresponsableAsignado = boton.getAttribute("data-id");
                const idresponsable = boton.getAttribute("data-idresponsable")
                console.log("id responsable_asignado: ", idresponsableAsignado)
                console.log("id responsable: ", idresponsable)
                //alert(idresponsableAsignado) DEPURAR CUANDO SEA NECESARIO
                const eliminado = await eliminarResponsablesOdt(idresponsableAsignado);
                if (!eliminado.eliminado) {
                    alert("OCURRIO UN ERROR AL ELIMINAR RESPONSABLE")
                }
                console.log("paso...: ", eliminado.eliminado)
                const usuariosAsignacion = await actualizarAsignacionUsuario(idresponsable, 7)
                console.log("asignacion de usuario actualizado?: ", usuariosAsignacion)
                /* console.log("resposables elegidos : ", responsablesElegidos)
                responsablesElegidos = responsablesElegidos.filter(id => id.idresponsableAsignado !== idresponsableAsignado); */

                // Actualizar el DOM eliminando el elemento <li>
                const listItem = document.querySelector(`li[data-id="${idresponsableAsignado}"]`);
                if (listItem) {
                    listItem.remove();
                }
                await filtrarUsuariosList()

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


    async function actualizarEstadoOdt() {


        const responsablesAsignados = await obtenerResponsablesAsignados()
        console.log("responsablesAsignados: ", responsablesAsignados)

        const formActualizacion = new FormData()
        formActualizacion.append("operation", "actualizarBorradorOdt")
        formActualizacion.append("idordentrabajo", window.localStorage.getItem("idodt"))
        formActualizacion.append("borrador", (responsablesAsignados.length > 0) ? 0 : 1)
        const Factualizado = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formActualizacion })
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