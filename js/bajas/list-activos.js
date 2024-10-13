document.addEventListener("DOMContentLoaded",()=>{
  const host = "http://localhost/CMMS/controllers/";
  let idactivo=0;
  let myTable = null;

  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  function selectorAll(value){
    return document.querySelectorAll(`.${value}`);
  }

  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }

  function createOption(value, text) {
    const element = document.createElement("option");
    element.value = value;
    element.innerText = text;
    return element;
  }

  (async()=>{
    const params = new URLSearchParams();
    params.append("operation", "estadoByRange");
    params.append("menor", 1);
    params.append("mayor", 5);
    const data = await getDatos(`${host}estado.controller.php`,params);
    //console.log(data);
    data.forEach(x=>{
      const element = createOption(x.idestado, x.nom_estado);
      selector("estado").appendChild(element);
    });
  })();

  selector("fecha_adquisicion").addEventListener("change",()=>{
    const valor = selector("fecha_adquisicion").value;
    console.log(valor);
  });

  (async()=>{
    await showData();
  })();

  async function showData(){
    const params = new URLSearchParams();
    params.append("operation","sinServicio");
    params.append("fecha_adquisicion",selector("fecha_adquisicion").value);
    params.append("idestado",selector("estado").value);

    const data = await getDatos(`${host}bajaActivo.controller.php`, params);
    console.log(data);
    
    selector("table-activos tbody").innerHTML="";
    if(data.length===0){
      selector("table-activos tbody").innerHTML=`
      <tr>
        <td colspan="6">No encontrado</td>
      </tr>
      `;
    }
    
    
    data.forEach(x=>{
      selector("table-activos tbody").innerHTML+=`
      <tr>
        <td>${x.idactivo}</td>
        <td>${x.cod_identificacion}</td>
        <td>${x.descripcion}</td>
        <td>${x.fecha_adquisicion}</td>
        <td>
          ${x.dato==null?"Sin usuario asignado":x.dato}
        </td>
        <td>${x.ubicacion==null?"Sin Ubicacion":x.ubicacion}</td>
        <td>
          <button type="button" class="btn btn-sm btn-primary sb-registrar" data-id=${x.idactivo}>Dar Baja</button>
        </td>
      </tr>
      `;
    });
    if(!myTable){
      myTable = new DataTable("#table-activos",{
        searchable:false,
        perPage:3,
        perPageSelect:[3,7,10],
        labels:{
          perPage:"{select} Filas por pagina",
          noRows: "No econtrado",
          info:"Mostrando {start} a {end} de {rows} filas"
        }
      });
    }
    btnRegistrar();
  }

  function btnRegistrar(){
    const btnRegistrar = selectorAll("sb-registrar");
    btnRegistrar.forEach(x=>{
      x.addEventListener("click",async()=>{
        idactivo= x.getAttribute("data-id");
        
        const valor = await getActivoById(parseInt(idactivo));
        selector("activo").value=valor.descripcion;

        const sidebar = selector("sidebar-baja");
        const offCanvas = new bootstrap.Offcanvas(sidebar);

        offCanvas.show();
      })
    });
  }  
  async function saveFile(){
    let params = new FormData();
    let fileInput = selector("documentacion");
    let file = fileInput.files[0];
  
    params.append("operation", "saveFile");
    params.append("file", file);
  
    const data = await fetch(`${host}bajaActivo.controller.php`,{
      method:'POST',
      body:params
    });
    const respuesta = await data.json();
    return respuesta;
  }

  selector("register-baja").addEventListener("submit",async(e)=>{
    e.preventDefault();
    const path = await saveFile();
    if(path.respuesta!==''){
      const iduser = await getIdUser();
      const params = new FormData();
      params.append("operation", "add");
      params.append("idactivo", idactivo);
      params.append("motivo", selector("motivo").value);
      params.append("coment_adicionales", selector("comentario").value);
      params.append("ruta_doc", path.respuesta);
      params.append("aprobacion", iduser);

      console.log("idactivo", idactivo);
      console.log("motivo", selector("motivo").value);
      console.log("comentario", selector("comentario").value);
      console.log("ruta", path.respuesta);
      console.log("aprobacion", iduser);
      

      const data = await fetch(`${host}bajaActivo.controller.php`,{
        method:'POST',
        body:params
      });

      const msg = await data.json();
      console.log(msg);
      

    }else{
      alert("Hubo un error al obtener la ruta del archivo");
    }

  });

  async function getActivoById(idactivo){
    const params = new URLSearchParams();
    params.append("operation", "getById");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${host}activo.controller.php`, params);
    return data[0];
  }

  async function getIdUser(){
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", selector("nomuser").textContent);
    
    const data = await getDatos(`${host}usuarios.controller.php`, params);
    return data[0].id_usuario;
  }
});