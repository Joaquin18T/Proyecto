document.addEventListener("DOMContentLoaded", () => {
  const globals = {
    id: localStorage.getItem("idresp_act"),
    idactivo: localStorage.getItem("idactivo"),
    host: "http://localhost/CMMS/controllers/",
    myTable:null,
    contNof:0,
    contResP:0,
    contDes:0,
    contIdResP:0,
    contIdResDes:0,
  };
  console.log(globals.id);
  
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
    params.append("idactivo", globals.idactivo);
    const data = await getDatos(`${globals.host}activo.controller.php`, params);
    console.log(data);
    
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
    params.append("idactivo", globals.idactivo);

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
    await getUbicacion();
  })();

  async function showDataUsuario(){
    const data = await usersByActivo();
    //console.log(data);
    
    data.forEach(x=>{
      selector("tb-asignacion").innerHTML+=`
      <tr>
        <td>${x.id_usuario}</td>
        <td>${x.apellidos}</td>
        <td>${x.nombres}</td>
        <td>${x.usuario}</td>
        <td><input type="checkbox" class="chk_es_responsable" data-es=${x.es_responsable} data-iduser=${x.id_usuario} data-idresp=${x.idactivo_resp}></td>
        <td><input type="checkbox" class="chk_designar" data-iduser=${x.id_usuario} data-idresp=${x.idactivo_resp} checked></td>
      </tr>
      `;
    });
    checkingChkEs_resp();
    getChksBefore();
  }

  function getChksBefore(){
    globals.contDes = contChks(".chk_designar", "data-iduser");
    globals.contResP = contChks(".chk_es_responsable", "data-iduser");
    globals.contIdResP = contChks(".chk_es_responsable", "data-idresp");
    globals.contIdResDes = contChks(".chk_designar", "data-idresp");

    console.log("before chks");
    console.log("chksResP", globals.contResP);
    console.log("chksDes", globals.contDes);
    
  }

  function checkingChkEs_resp(){
    const chks = document.querySelectorAll(".chk_es_responsable");
    chks.forEach(x=>{
      const es_resp = x.getAttribute("data-es");
      if(es_resp==="1"){x.checked=true;}
    });
  }

  selector("update-test").addEventListener("click",async(e)=>{
    e.preventDefault();
    const chkEsResP =  contChks(".chk_es_responsable", "data-iduser"); //muestra los id que estan marcados
    const chkDes = contChks(".chk_designar", "data-iduser");//muestra los id que estan marcados

    const diferentCL = getDiferent(globals.contDes[1], chkDes[1]); //idusuario

    const chkIdRespDes = contChks(".chk_designar", "data-idresp");
    const diferentRespCL = getDiferent(globals.contIdResDes[1], chkIdRespDes[1]); //idactivo_resp

    const verifyCL = isSameChks(globals.contDes, chkDes);
    const verifyRP = isSameChks(globals.contResP, chkEsResP);

    //console.log(verifyRP);
    
    // console.log("diferente user", diferentCL);
    // console.log("diferente resp_act", diferentRespCL);
    

    if(!verifyCL){
      const data = await cascadeUpdateAsignacion(diferentCL, diferentRespCL,"Designacion", "Te han designado de un activo");
      console.log("designacion", data);
    }
    if(!verifyRP){
      const data = await changeResponsableP();
      console.log("change principal", data);
    }
    
  });

  function isSameChks(before=[], after=[]){
    const data = before.some(b=>after.includes(b));
    return data;
  }

  async function cascadeUpdateAsignacion(data_user=[], data_resp=[], tipo, msg){
    let cont=0;
    for (let i = 0; i < data_user.length; i++) {
      const isAdd = await addNotificacion(data_user[i], tipo, msg);
      const updateAsg = await updateAsignacion(data_user[i], data_resp[i]);
      console.log(updateAsg);
      
      if(isAdd>0 && updateAsg>0){
        cont++;
      }
    }
    
    return (cont===data_user.length);
  }

  async function changeResponsableP(){
    const chkEsResP =  contChks(".chk_es_responsable", "data-iduser");
    const diferentRP = getDiferent(globals.contResP[1], chkEsResP[1]);

    const chkIdRespRP = contChks(".chk_es_responsable", "data-idresp"); //cuenta los chekcbox seleccionados de la columna resp_p
    const diferentRespRP = getDiferent(globals.contIdResP[1], chkIdRespRP[1]);// obtiene la diferencia de que checkbox cambio

    let isChange = false;
    console.log("iduser", diferentRP);
    console.log("idact_resp", diferentRespRP);
    
    const autorizacion = await getIdUser();
    const params = new FormData();
    params.append("operation", "updateResponsableP");
    params.append("idactivo_resp", diferentRespRP[0]);
    params.append("idactivo", globals.idactivo);
    params.append("idusuario", diferentRP[0]);
    params.append("es_responsable", '0');
    params.append("autorizacion", autorizacion);

    const data = await fetch(`${globals.host}respActivo.controller.php`,{
      method:'POST',
      body:params
    });
    const resp = await data.json();
    const isAdd = await addNotificacion(diferentRP[0], "Cambio de responsable Principal", "Ya no eres responsable principal del activo");

    if(isAdd>0 && resp.respuesta>0){
      isChange = true;
    }
    return isChange;
  }


  async function updateAsignacion(iduser, idresp){
    const autorizacion = await getIdUser();
    const params = new FormData();
    params.append("operation", "updateAsignacion");
    params.append("idactivo_resp", idresp);
    params.append("idactivo", globals.idactivo);
    params.append("idusuario", iduser);
    params.append("autorizacion", autorizacion);

    const data = await fetch(`${globals.host}respActivo.controller.php`,{
      method:'POST',
      body:params
    });
    const resp = await data.json();
    return resp.respuesta;
  }

  function getDiferent(before=[], after=[]){
    const data = before.filter(b=>!after.includes(b));
    return data
  }

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

  async function getUbicacion(){
    const params = new URLSearchParams();
    params.append("operation", "ubiByActivo");
    params.append("idactivo", globals.idactivo);

    const data = await getDatos(`${globals.host}historialactivo.controller.php`, params);
    
    selector("ubicacion").value = data[0].idubicacion;
  }

  async function addNotificacion(iduser, tipoMsg, msg){
    const params = new URLSearchParams();
    params.append("operation", "add");
    params.append("idusuario", iduser);
    params.append("tipo", tipoMsg);
    params.append("mensaje", msg);

    const data = await fetch(`${globals.host}notificacion.controller.php`,{
      method:'POST',
      body:params
    });
    const resp = await data.json();
    return resp.respuesta;
  }


  async function updateUbicacion() {
    const params = new FormData();
    params.append("operation", "add");
    params.append("idactivo_resp", parseInt(globals.id));
    params.append("idubicacion", parseInt(selector("ubicacion").value));

    const data = await fetch(`${globals.host}historialactivo.controller.php`, {
      method: "POST",
      body: params,
    });
    const addNewUbicacion = await data.json();

    return addNewUbicacion;
  }

  async function addNotificacionUbi(iduser){
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
      let isAdd = await addNotificacionUbi(data[i].id_usuario);
      if(isAdd>0){
        globals.contNof++;
      }
    }
    const isValidate = globals.contNof===data.length?true:false;
    globals.contNof=0;
    return isValidate;
  }

  async function getIdUser(){
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", selector("nomuser").textContent);
    const data = await getDatos(`${globals.host}usuarios.controller.php`, params);
    return data[0].id_usuario;
  }
});
//<button type="button" data-idresp=${element.idactivo_resp} data-idact=${element.idactivo} class="btn btn-sm btn-primary btn-update-ubicacion">Edt. Ub.</button>
