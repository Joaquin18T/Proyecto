/* document.addEventListener("DOMContentLoaded", async () => {
    function $(object = null) {
        return document.querySelector(object);
    }

    const host = "http://localhost/CMMS/controllers/";

    if (window.localStorage.getItem("idplantarea")) {
        (async () => {
            const { data } = await fetch(`${host} ${window.localStorage.getItem("idplantarea")}`);
            console.log("verificarTareaInconclusa: ", data);
            if (data.length > 0) {
                if (data[0].cantidad_tareas < 1 || data[0].cantidad_activos < 1) {
                    if (confirm("Tienes un plan de tareas inconcluso, deseas retomarlo?")) {
                        console.log("retomado");
                        idplantarea_generado = data[0].idplantarea;
                        renderPlanTarea(data[0].descripcion);
                        await loadFunctions()
                        habilitarCamposTarea(false);
                        $("#btnGuardarPlanTarea").remove()
                        $("#txtDescripcionPlanTarea").disabled = true
                        console.log("ID PLANTAREA GENERADO DSPUES DE RETOMAR: ", idplantarea_generado)
                        return;
                    }
                    window.localStorage.clear()
                    console.log("borrando y creando uno nuevo ...");
                }
            }
        })();
    }

    await loadFunctions()

    async function loadFunctions(params) {

    }


}) */