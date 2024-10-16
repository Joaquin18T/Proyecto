document.addEventListener("DOMContentLoaded", async () => {
    //UI VARIABLES
    const tbodyPlanTareas = $("#tb-plantareas tbody")

    function $(object = null) {
        return document.querySelector(object);
    }

    async function getDatos(link, params) {
        let data = await fetch(`${link}?${params}`);
        return data.json();
    }

    let idplangenerado = -1

    await loadFunctions();

    async function loadFunctions() {
        await renderPlanesDeTarea();
    }

    async function renderPlanesDeTarea() {

        const planes = await getDatos(`http://localhost/CMMS/controllers/plandetarea.controller.php`, `operation=getPlanesDeTareas`)
        console.log("planes: ", planes)
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
                </tr>
            `
        }
        new DataTable("#tb-plantareas", {
            searchable: false,
            perPage: 3,
            perPageSelect: [3, 5, 8, 10],
            labels: {
                perPage: "{select} Filas por pagina",
                noRows: "Registros no encontrados",
                info: "Mostrando {start} a {end} de {rows} filas"
            }
        });
    }

    document.querySelectorAll(".btnEditarPlanTarea").forEach((btnPlan) => {
        btnPlan.addEventListener("click", async (e) => {
            window.location.href = 'http://localhost/CMMS/views/plantareas/actualizar-plan.php'
            window.localStorage.clear()
            window.localStorage.setItem("idplantarea", btnPlan.getAttribute("data-plan-id"))
        })
    })

    document.querySelectorAll(".btnEliminarPlan").forEach((btnPlan) => {
        btnPlan.addEventListener("click", async (e) => {
            const idPlan = btnPlan.getAttribute('data-plan-id');
            console.log("idplan: ", idPlan)
            const confirmacion = confirm(`¿Estás seguro de que deseas eliminar el plan de tareas con ID ${idPlan}?`);

            if (confirmacion) {
                try {
                    const params = new URLSearchParams();
                    params.append("operation", "eliminarPlanDeTarea")
                    // Hacer solicitud DELETE al servidor
                    const Feliminado = await fetch(`http://localhost/CMMS/controllers/plandetarea.controller.php/${idPlan}`, { method: 'POST', body: params })
                    const eliminado = await Feliminado.json()
                    console.log(`Plan de tareas ${idPlan} eliminado?: ${eliminado.eliminado}`);

                    // Eliminar la fila correspondiente en el DOM
                    const filaPlan = e.target.closest('tr');
                    if (filaPlan) {
                        filaPlan.remove();
                    } else {
                        console.warn(`No se encontró la fila correspondiente al plan de tareas con ID ${idPlan}`);
                    }

                } catch (error) {
                    console.error(`Error al eliminar el plan de tareas ${idPlan}: `, error);
                }
            }
        });
    });

    const btnInterfazNuevoPlanTarea = $("#btnInterfazNuevoPlanTarea");
    btnInterfazNuevoPlanTarea.addEventListener('click', () => {
        window.location.href = 'http://localhost/CMMS/views/plantareas/registrar-plan.php'
    })
})