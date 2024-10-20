document.addEventListener("DOMContentLoaded", () => {
  async function getResPrincipal(id) {
    const params = new URLSearchParams();
    params.append("operation", "getResponasblePrin");
    params.append("idactivo_resp", parseInt(id));

    const data = await getDatos(`${host}respActivo.controller.php`, params);
    return data[0];
  }

  selector("form-update-ubicacion").addEventListener("submit", async (e) => {
    e.preventDefault();

    if (confirm("¿Deseas actualizarlo?")) {
      const resp = await updateUbicacion();
      if (resp.mensaje === "Historial guardado") {
        console.log("users asignados", users);

        const isCorrect = await createNotificacion(users);
        if (isCorrect) {
          alert("Se ha actualizado la ubicacion");
          users = [];
          selector("sb-ubicacion").value = "";
          const sidebar = bootstrap.Offcanvas.getOrCreateInstance(
            selector("sb-ubicacion-update")
          );
          sidebar.hide();
          await showData();
        }
      } else {
        alert("Hubo un error al actualizar");
      }
    }
  });

  async function updateUbicacion() {
    const params = new FormData();
    params.append("operation", "add");
    params.append("idactivo_resp", parseInt(idactivo_resp));
    params.append("idubicacion", parseInt(selector("sb-ubicacion").value));

    const data = await fetch(`${host}historialactivo.controller.php`, {
      method: "POST",
      body: params,
    });
    const addNewUbicacion = await data.json();

    return addNewUbicacion;
  }

  //ACTUALIZAR UBICACION
  function btnUpdateUbicacion() {
    const buttons = document.querySelectorAll(".btn-update-ubicacion");
    buttons.forEach((x) => {
      x.addEventListener("click", async () => {
        idactivo_resp = x.getAttribute("data-idresp");

        users = await usersActivo(parseInt(x.getAttribute("data-idact")));
        console.log("idactivo", x.getAttribute("data-idact"));

        const dataResp = await getResPrincipal(idactivo_resp);
        selector(
          "sb-responsable"
        ).value = `${dataResp.apellidos} ${dataResp.nombres} - ${dataResp.usuario}`;
        const sidebar = selector("sb-ubicacion-update");
        const offCanvas = new bootstrap.Offcanvas(sidebar);
        offCanvas.show();
      });
    });
  }

  async function addNotificacion(iduser){
    const params = new URLSearchParams();
    params.append("operation", "add");
    params.append("idusuario", parseInt(iduser));
    params.append("tipo","Nueva Ubicacion");
    params.append("mensaje","Se ha actualizado una ubicacion de un activo asignado");

    const data = await fetch(`${host}notificacion.controller.php`,{
      method:'POST',
      body:params
    });
    const resp = await data.json();
    return resp.respuesta;
  }

  async function createNotificacion(data=[]){
    for (let i = 0; i < data.length; i++) {
      let isAdd = await addNotificacion(data[i].id_usuario);
      if(isAdd>0){
        contNof++;
      }
    }
    const isValidate = contNof===data.length?true:false;
    contNof=0;
    return isValidate;
  }
});
//<button type="button" data-idresp=${element.idactivo_resp} data-idact=${element.idactivo} class="btn btn-sm btn-primary btn-update-ubicacion">Edt. Ub.</button>
