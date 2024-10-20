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
    const host = "http://localhost/CMMS/controllers/";
    let tbResponsables = null
    const filters = $all(".filter")
    const npusuario = $q("#txtNombresApellidos") // FILTRO DE NOMBRES Y APELLIDOS
    const documentoIdentidad = $q("#txtDni")
    renderTablaActivos()
    await filtrarUsuariosList()

    async function renderUsuarios() { // RENDERIZAR USUARIOS QUE SERIVIRA PARA ASIGNAR RESPONSABLES AL ODT
        const params = new URLSearchParams();

        // Verifica los valores de los inputs
        console.log("Valor de npusuario:", npusuario.value);
        console.log("Valor de documentoIdentidad:", documentoIdentidad.value);

        params.append("operation", "filtrarUsuarios");
        params.append("numdoc", npusuario.value ? npusuario.value : "");
        params.append("dato", documentoIdentidad.value ? documentoIdentidad.value : "");

        const usuarios = await getDatos(`${host}usuarios.controller.php`, params);
        return usuarios;
    }

    async function filtrarUsuariosList() {
        const usuarios = await renderUsuarios()

        //activosList.innerHTML = "";
        console.log("usuarios fitlrados", usuarios);
        /* for (let i = 0; i < data.length; i++) {
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
        }) */

    }

    filters.forEach(select => {
        select.addEventListener("input", async () => {
            await filtrarUsuariosList()
        })
    })

    function renderTablaActivos() {
        if (tbResponsables) {
            tbResponsables.clear().rows.add($(activosList).find('tr')).draw();
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

});