document.addEventListener("DOMContentLoaded",()=>{
  //CONSTANTES
  const host="http://localhost/CMMS/controllers";
  selector("motivo").value="";
  //Variables
  let 
  idactivo = 0,
  idusuario = 0,
  idsolicitud=0;

  async function getDatos(url, params){
    const datos = await fetch(`${url}?${params}`);
    return datos.json();
  }

  function selector(value) {
    return document.querySelector(`#${value}`);
  }
  
  (async()=>{
    const data = await getDatos(`${host}/activo.controller.php`,'operation=getAll');
    data.forEach(x=>{
      selector("tb-activos tbody").innerHTML+=`
        <tr>
          <td>${x.idactivo}</td>
          <td>${x.cod_identificacion}</td>
          <td>${x.modelo}</td>
          <td>${x.fecha_adquisicion}</td>
          <td>${x.usuario==null?"No Asignado":x.usuario}</td>
          <td>${x.nom_estado}</td>
          <td>
            <button type="button" class="btn btn-sm btn-primary" data-idact=${x.idactivo}>
              click me
            </button>
          </td>
        </tr>
      `;
    });
  })();

  selector("tb-activos").addEventListener("click",async(e)=>{
    idactivo= e.target.dataset.idact;
    await getIdUser();
    const data = await duplicateRequest();
    if(data[0].cantidad>0){
      alert("No puedes solicitar otra vez");
    }else{
      const modalImg = new bootstrap.Modal(selector("modal-solicitud"));
      modalImg.show();
    }
  });

  selector("form-solicitud").addEventListener("submit", async(e)=>{
    e.preventDefault();
    await saveSolicitud();
    const myModal = bootstrap.Modal.getOrCreateInstance('#modal-solicitud');
    myModal.hide();
    
  });

  async function getIdUser(){
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", selector("nomuser").textContent);
    const data = await getDatos(`${host}/usuarios.controller.php`, params);
    idusuario =data[0].id_usuario;
    //console.log(idusuario);
    
  }


  async function saveSolicitud(){
    //let value=0;
    if(selector("motivo").value!==""){
      
      const params = new FormData();
      params.append("operation", "add");
      params.append("idactivo", idactivo);
      params.append("idusuario", idusuario);
      params.append("motivo_solicitud", selector("motivo").value);
      console.log(selector("motivo").value);
      
      const option={
        method:"POST",
        body:params
      };
      fetch(`${host}/solicitud.controller.php`, option)
      .then(response=>response.json())
      .then(data=>{
        if(data.respuesta>0){
          //alert("Asignacion registrada")
          console.log(data);
          //createNotification(data.respuesta)
          //idsolicitud=data.respuesta;
          
        }else{
          alert("Hubo un Error");
        }
      });    
    }else{
      alert("Completa el campo");
    }

  }

  async function duplicateRequest(){
    const params = new URLSearchParams();
    params.append("operation","isDuplicate");
    params.append("idusuario",idusuario);
    params.append("idactivo",idactivo);
    const data = await getDatos(`${host}/solicitud.controller.php`, params);
    //console.log(data);
    
    return data;
    
  }



  selector("motivo").addEventListener("click",()=>{
    selector("motivo").setSelectionRange(0, 0);
  });
})