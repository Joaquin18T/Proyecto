document.addEventListener("DOMContentLoaded",()=>{
  const host="http://localhost/CMMS/controllers";
  let estado={
    valor:""
  };
  let valores={idusuario:0, idactivo:0, idsolicitud:0, idadmin:0};
  

  async function getDatos(url, params){
    const datos = await fetch(`${url}?${params}`);
    return datos.json();
  }

  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  async function chargeData(){
    const params = new URLSearchParams();
    params.append("operation", "getSolicitud");
    params.append("estado", "pendiente");
    selector("tb-solicitudes tbody").innerHTML="";
    const data = await getDatos(`${host}/solicitud.controller.php`, params);

    if(data.length===0){selector("tb-solicitudes tbody").innerHTML=`<tr><td colspan="7" class="text-center">No hay solicitudes pendientes</td></tr>`}
    data.forEach((x,i)=>{
      selector("tb-solicitudes tbody").innerHTML+=`
        <tr>
          <td>${i+1}</td>
          <td>${x.usuario}</td>
          <td>${x.modelo}</td>
          <td>${x.cod_identificacion}</td>
          <td>${x.fecha_solicitud}</td>
          <td>
            <button type="button" class="btn btn-sm btn-primary btn-motivo" data-id=${x.idsolicitud}>
              Ver Motivo
            </button>
          </td>
          <td>
            <button type="button" class="btn btn-sm btn-success btn-action" 
            data-idsoli=${x.idsolicitud} data-idactivo=${x.idactivo} 
            data-iduser=${x.id_usuario} data-estado="aprobado">Si</button>

            <button type="button"  class="btn btn-sm btn-danger btn-action"
              data-idsoli=${x.idsolicitud} data-idactivo=${x.idactivo}
              data-iduser=${x.id_usuario} data-estado="rechazado">No</button>
          </td>
        </tr>
      `;
    });

    btnActions();
    showMotivo();
  }

  selector("tb-solicitudes").addEventListener("click",(e)=>{
    const data = e.target.dataset;
    valores.idsolicitud = data.idsoli;
    valores.idusuario = data.iduser;
    valores.idactivo=data.idactivo;
    //console.log(valores);
  });

  async function btnActions(){
    await getIdUser();
    document.querySelectorAll(`.btn-action`).forEach(x=>{
      x.addEventListener("click",()=>{
        selector("admin-message").value="";
        const action = x.getAttribute("data-estado");
        estado.valor=action;
        console.log(action);
        
        selector("titleModal").textContent=action==="aprobado"?"APROBAR SOLICITUD":"RECHAZAR SOLICITUD";
        const modal = new bootstrap.Modal(document.getElementById('modal-action'));
        modal.show();
      });
    });
  }

  async function saveUpdate(){
    const params = new FormData();
    params.append("operation", "verifierSoli");
    params.append("idsolicitud", valores.idsolicitud);
    params.append("idactivo", valores.idactivo);
    params.append("idusuario", valores.idusuario);
    params.append("estado_solicitud", estado.valor);
    params.append("idautorizador", valores.idadmin);
    params.append("coment_autorizador", selector("admin-message").value);

    const options={
      method:"POST",
      body:params
    }

    fetch(`${host}/solicitud.controller.php`, options)
    .then(response=>response.json())
    .then(data=>{
      
      if(data.respuesta){ 
        createNotification();
        chargeData();
      }else{
        alert("Hubo un error");
      }
    });
    //await chargeData();
    
  }

  selector("form-check-request").addEventListener("submit",async(e)=>{
    e.preventDefault();
    saveUpdate();
    const myModal = bootstrap.Modal.getOrCreateInstance('#modal-action');
    myModal.hide();
  });



  async function getIdUser(){
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", selector("nomuser").textContent);
    const data = await getDatos(`${host}/usuarios.controller.php`, params);
    valores.idadmin =data[0].id_usuario;
  }

  async function getMotivo(id){
    const params = new URLSearchParams();
    params.append("operation", "showMotivo");
    params.append("idsolicitud", id);
    const data = await getDatos(`${host}/solicitud.controller.php`, params);
    return data;
  }

  async function showMotivo(){
    
    document.querySelectorAll(".btn-motivo").forEach(x=>{
      x.addEventListener("click",async()=>{
        const id = x.getAttribute("data-id");
        const motivo= await getMotivo(id);
        selector("motivo-user").value="";
        selector("motivo-user").value=motivo[0].motivo_solicitud;
        const modal = new bootstrap.Modal(document.getElementById('modal-motivo'));
        modal.show();
      });
    });
  }

  async function createNotification(){
    const params = new FormData();
    params.append("operation", "add");
    params.append("idusuario", valores.idusuario);
    params.append("idsolicitud", valores.idsolicitud);
    params.append("mensaje", estado.valor==="aprobado"?"!Tu solicitud ha sido aceptada¡":"Tu solicitud ha sido rechazada");

    const options={
      method:"post",
      body:params
    };

    fetch(`${host}/notificacion.controller.php`, options)
    .then(response=>response.json())
    .then(data=>{
      if(data.respuesta>0){
        alert(`Solicitud ${estado.valor==="aprobado"?"Aprobada":"Rechazada"}`);
      }
    });
  }

  chargeData();
})