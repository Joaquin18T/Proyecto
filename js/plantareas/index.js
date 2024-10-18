$(document).ready(async () => {
    //UI VARIABLES
    function $q(object = null) {
        return document.querySelector(object);
    }

    function $all(object = null) {
        return document.querySelectorAll(object);
    }


    const tbodyPlanTareas = $q("#tb-plantareas tbody")
    const tbodyPlanTareasEliminadas = $q("#tb-plantareas-eliminadas tbody");

    let dataTablePlanesEliminados;

    async function getDatos(link, params) {
        let data = await fetch(`${link}?${params}`);
        return data.json();
    }

    await loadFunctions();

    async function loadFunctions() {
        await renderPlanesDeTarea();
        setupTabSwitch()
    }

    async function renderPlanesDeTarea() {
        const planes = await getDatos(`http://localhost/CMMS/controllers/plandetarea.controller.php`, `operation=getPlanesDeTareas&eliminado=0`);
        console.log("planes vigentes: ", planes);
        tbodyPlanTareas.innerHTML = "";
        for (let i = 0; i < planes.length; i++) {
            tbodyPlanTareas.innerHTML += `
                <tr>
                    <th>${planes[i].idplantarea}</th>
                    <td>${planes[i].descripcion}</td>
                    <td>${planes[i].tareas_totales}</td>
                    <td>${planes[i].activos_vinculados}</td>
                    <td>
                        <button class="btn btn-primary btnEditarPlanTarea" data-plan-id="${planes[i].idplantarea}">Editar</button>
                        <button class="btn btn-primary btnEliminarPlan" data-plan-id="${planes[i].idplantarea}">Eliminar</button>
                        <span id="estado-plan">${(planes[i].borrador == 1) ? 'borrador' : ''}</span>
                    </td>
                    <td class="text-danger">${planes[i].incompleto ? "incompleto" : ""}</td>
                </tr>
            `;
        }
        $('#tb-plantareas').DataTable({
            paging: true,
            searching: false,
            lengthMenu: [5, 10, 15, 20],
            pageLength: 5,
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

    async function renderPlanesDeTareaEliminados() {
        const planesEliminados = await getDatos(`http://localhost/CMMS/controllers/plandetarea.controller.php`, `operation=getPlanesDeTareas&eliminado=1`);
        console.log("planes eliminados: ", planesEliminados);
        tbodyPlanTareasEliminadas.innerHTML = "";

        for (let i = 0; i < planesEliminados.length; i++) {
            tbodyPlanTareasEliminadas.innerHTML += `
                <tr>
                    <th>${planesEliminados[i].idplantarea}</th>
                    <td>${planesEliminados[i].descripcion}</td>
                    <td>${planesEliminados[i].tareas_totales}</td>
                    <td>${planesEliminados[i].activos_vinculados}</td>
                    <td>
                        <button class="btn btn-primary btnRestaurarPlan" data-plan-id="${planesEliminados[i].idplantarea}">Restaurar</button>
                    </td>
                    <td class="text-danger">${planesEliminados[i].incompleto ? "incompleto" : ""}</td>
                </tr>
            `;
        }

        if ($.fn.dataTable.isDataTable('#tb-plantareas-eliminadas')) {
            dataTablePlanesEliminados.destroy();
        }
        dataTablePlanesEliminados = $('#tb-plantareas-eliminadas').DataTable({
            paging: true,
            searching: false,
            lengthMenu: [5, 10, 15, 20],
            pageLength: 5,
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

        const btnRestaurar = $all(".btnRestaurarPlan")
        btnRestaurar.forEach(btn => {
            btn.addEventListener("click", async (e) => {
                const idplan = btn.getAttribute("data-plan-id")
                try {
                    const params = new URLSearchParams();
                    params.append("operation", "eliminarPlanDeTarea");
                    params.append("eliminado", 0)

                    // Realizar la solicitud para restaurar el plan
                    const response = await fetch(`http://localhost/CMMS/controllers/plandetarea.controller.php/${idplan}`, { method: 'POST', body: params });
                    const resultado = await response.json();

                    if (resultado.eliminado) {
                        console.log(`Plan de tareas ${idplan} restaurado`);
                        await renderPlanesDeTareaEliminados(); // Volver a renderizar los planes eliminados
                        await loadFunctions(); // Opcional: si también necesitas actualizar la vista de planes vigentes
                    } else {
                        alert(`Error al restaurar el plan de tareas ${idplan}`);
                    }
                } catch (error) {
                    console.error(`Error al restaurar el plan de tareas ${idplan}: `, error);
                }
            })
        })
    }

    function setupTabSwitch() {
        $('#pills-profile-tab').on('click', async () => {
            await renderPlanesDeTareaEliminados();
        });
    }

    // Delegar eventos en el tbody
    tbodyPlanTareas.addEventListener('click', async (e) => {
        if (e.target.classList.contains('btnEditarPlanTarea')) {
            const btnPlan = e.target;
            window.localStorage.clear();
            window.localStorage.setItem("idplantarea", btnPlan.getAttribute("data-plan-id"));
            window.location.href = 'http://localhost/CMMS/views/plantareas/actualizar-plan.php';
        }

        if (e.target.classList.contains('btnEliminarPlan')) {
            const btnPlan = e.target;
            const idPlan = btnPlan.getAttribute('data-plan-id');
            console.log("idplan: ", idPlan);
            const confirmacion = confirm(`¿Estás seguro de que deseas eliminar el plan de tareas con ID ${idPlan}?`);

            if (confirmacion) {
                try {
                    const params = new URLSearchParams();
                    params.append("operation", "eliminarPlanDeTarea");
                    params.append("eliminado", 1)
                    // Hacer solicitud DELETE al servidor --- EN REALIDAD ESTO ES UNA ACTUALIZACION - ELIMINACION LOGICA
                    const Feliminado = await fetch(`http://localhost/CMMS/controllers/plandetarea.controller.php/${idPlan}`, { method: 'POST', body: params });
                    const eliminado = await Feliminado.json();
                    console.log(`Plan de tareas ${idPlan} eliminado?: ${eliminado.eliminado}`);
                    
                    // Eliminar la fila correspondiente en el DOM
                    const filaPlan = btnPlan.closest('tr');
                    if (filaPlan) {
                        filaPlan.remove();
                    } else {
                        console.warn(`No se encontró la fila correspondiente al plan de tareas con ID ${idPlan}`);
                    }

                } catch (error) {
                    console.error(`Error al eliminar el plan de tareas ${idPlan}: `, error);
                }
            }
        }
    });

    const btnInterfazNuevoPlanTarea = $q("#btnInterfazNuevoPlanTarea");
    btnInterfazNuevoPlanTarea.addEventListener('click', () => {
        window.location.href = 'http://localhost/CMMS/views/plantareas/registrar-plan.php';
    });
})