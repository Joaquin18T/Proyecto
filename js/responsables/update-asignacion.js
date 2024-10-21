document.addEventListener("DOMContentLoaded", () => {
  const globals = {
    id: localStorage.getItem("idresp_act"),
    idactivo: localStorage.getItem("idactivo"),
    host: "http://localhost/CMMS/controllers/",
    myTable:null,
    contNof:0,
    contResP:0,
    contDes:0
  };
  console.log(globals.idactivo);
  
  function selector(value) {
    return document.querySelector(`#${value}`);
  }
  function createOption(value, text) {
    const element = document.createElement("option");
    element.value = value;
    element.innerText = text;
    return element;
  }

  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }

  (async()=>{
    const params = new URLSearchParams();
    params.append("operation", "searchByUpdate");
    params.append("idactivo", globals.id);
    const data = await getDatos(`${globals.host}activo.controller.php`, params);
    
    showDataActivo(data[0]);
    await showDataUsuario();
  })();

  function showDataActivo(data){
    selector("cod_identificacion").value=data.cod_identificacion;
    selector("marca").value=data.marca;
    selector("modelo").value=data.modelo;
    selector("descripcion").value=data.descripcion;
    selector("estado").value=data.nom_estado;
  }

  async function usersByActivo(){
    const params = new URLSearchParams();
    params.append("operation", "usersByActivo");
    params.append("idactivo", globals.id);

    const data = await getDatos(`${globals.host}respActivo.controller.php`, params);
    return data;
  }

  (async () => {
    const data = await getDatos("http://localhost/CMMS/controllers/ubicacion.controller.php", "operation=getAll");
    data.forEach(x => {
      //console.log(x);
      const element = createOption(x.idubicacion, x.ubicacion);
      selector("ubicacion").appendChild(element);
    });
  })();

  async function showDataUsuario(){
    const data = await usersByActivo();
    console.log(data);
    
    data.forEach(x=>{
      selector("tb-asignacion").innerHTML+=`
      <tr>
        <td>${x.id_usuario}</td>
        <td>${x.apellidos}</td>
        <td>${x.nombres}</td>
        <td>${x.usuario}</td>
        <td><input type="checkbox" class="chk_es_responsable" data-es=${x.es_responsable} data-iduser=${x.id_usuario}></td>
        <td><input type="checkbox" class="chk_designar" data-iduser=${x.id_usuario} checked></td>
      </tr>
      `;
    });
    checkingChkEs_resp();
  }

  function checkingChkEs_resp(){
    const chks = document.querySelectorAll(".chk_es_responsable");
    chks.forEach(x=>{
      const es_resp = x.getAttribute("data-es");
      if(es_resp==="1"){x.checked=true;}
    });
  }

  selector("update-test").addEventListener("click",()=>{
    const chkEsResP =  contChks(".chk_es_responsable", "data-iduser");
    const chkDes = contChks(".chk_designar", "data-iduser");

    console.log("cont chkEsResP", chkEsResP);
    console.log("cont chkDes", chkDes);
    
  });

  function contChks(nameSelector, nameAttribute){
    const chks = document.querySelectorAll(`${nameSelector}`);
    let cont=0;
    const ids=[];

    chks.forEach(x=>{
      if(x.checked){
        ids.push(parseInt(x.getAttribute(`${nameAttribute}`)));
        cont ++;
      }
    });

    return [cont, ids];
  }
  
  async function getResPrincipal(id) {
    const params = new URLSearchParams();
    params.append("operation", "getResponasblePrin");
    params.append("idactivo_resp", parseInt(id));

    const data = await getDatos(`${globals.host}respActivo.controller.php`, params);
    return data[0];
  }

  selector("update-asignacion").addEventListener("submit", async (e) => {
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

    const data = await fetch(`${globals.host}historialactivo.controller.php`, {
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

    const data = await fetch(`${globals.host}notificacion.controller.php`,{
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
        globals.contNof++;
      }
    }
    const isValidate = globals.contNof===data.length?true:false;
    globals.contNof=0;
    return isValidate;
  }
});
//<button type="button" data-idresp=${element.idactivo_resp} data-idact=${element.idactivo} class="btn btn-sm btn-primary btn-update-ubicacion">Edt. Ub.</button>
