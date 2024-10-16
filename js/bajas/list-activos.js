document.addEventListener("DOMContentLoaded",()=>{
  const host = "http://localhost/CMMS/controllers/";
  let globals={
    idactivo:0,
    responsable:0,
    user_responsable:"",
    cod_identificacion:"",
    myTable:null,
    no_responsable:false
  };

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
        <td colspan="7">Sin registro a mostrar</td>
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
          <button type="button" class="btn btn-sm btn-primary sb-registrar" data-id=${x.idactivo} data-user=${x.dato==null?"":x.dato}>Dar Baja</button>
        </td>
      </tr>
      `;
    });
    if(!globals.myTable){
      globals.myTable = new DataTable("#table-activos",{
        searchable:false,
        perPage:5,
        perPageSelect:[5,10,15],
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
        globals.idactivo= x.getAttribute("data-id");
        
        const valor = await getActivoById(parseInt(globals.idactivo));
        selector("activo").value=valor.descripcion;
        globals.cod_identificacion = valor.cod_identificacion;

        let user = x.getAttribute("data-user");
        console.log("user existe", user ==="");
        
        if(user === ""){
          globals.no_responsable=true;
        }else{
          globals.user_responsable = x.getAttribute("data-user");
          console.log("user resp", globals.user_responsable);
        }
        console.log(globals.no_responsable);
        
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
    params.append("code", globals.cod_identificacion);
  
    const data = await fetch(`${host}bajaActivo.controller.php`,{
      method:'POST',
      body:params
    });
    const respuesta = await data.json();
    return respuesta;
  }

  selector("register-baja").addEventListener("submit",async(e)=>{
    e.preventDefault();

    if(confirm("¿Estas seguro de dar de baja al activo?")){
      const path = await saveFile();
      //console.log(path);
      
      if(path.respuesta!=='max'){
        const iduser = await getIdUser(selector("nomuser").textContent);
        const params = new FormData();
        params.append("operation", "add");
        params.append("idactivo", globals.idactivo);
        params.append("motivo", selector("motivo").value);
        params.append("coment_adicionales", selector("comentario").value);
        params.append("ruta_doc", path.respuesta);
        params.append("aprobacion", iduser);
          
        const data = await fetch(`${host}bajaActivo.controller.php`,{
          method:'POST',
          body:params
        });
  
        const msg = await data.json();
        const estadoUP = await updateEstado();
        
        let addNotifi = 0;

        if (!globals.no_responsable) {
          globals.responsable = await getIdUser(globals.user_responsable);
          addNotifi = await addNotificacion(globals.responsable);
        }

        //console.log("responsable: ", globals.responsable);
        const isAdd = verifierAddBaja(globals.no_responsable, msg.id,estadoUP);
        console.log(isAdd);
        
        if(isAdd && globals.no_responsable){
          await addAction();
        }else if(!isAdd && !globals.no_responsable){
          await addAction();
        }else{
          alert("Hubo un error al registrar la baja");

        }
      }else{
        if(path.respuesta==="max"){
          alert("Tu archivo pesa mas de lo permitido");
        }else{
          alert("Hubo un error al obtener la ruta del archivo");
        }
      }
    }

  });

  function verifierAddBaja(no_responsable, add_baja, estado_update){
    let noresp = false;
    if(no_responsable){
      if(estado_update>0 && add_baja>0){
        noresp=true;
      }
    }
    return noresp;
  }

  async function addAction(){
    alert("Se ha registrado la baja del Activo");
    resetUI();
    const sidebar = bootstrap.Offcanvas.getOrCreateInstance(selector("sidebar-baja"));
    sidebar.hide();
    selector("table-activos tbody").innerHTML="";
    await showData();
    
  }

  async function getActivoById(idactivo){
    const params = new URLSearchParams();
    params.append("operation", "getById");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${host}activo.controller.php`, params);
    return data[0];
  }

  async function getIdUser(user){
    let nomusuario= user;
    if(nomusuario.includes("|")){
      const nomuser = nomusuario.split('|');
      console.log(nomuser);
      nomusuario = nomuser[0];
    }
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", nomusuario);
    
    const data = await getDatos(`${host}usuarios.controller.php`, params);
    return data[0].id_usuario;
  }

  async function updateEstado() {
    const params = new URLSearchParams();
    params.append("operation", "updateEstado");
    params.append("idactivo", globals.idactivo);
    params.append("idestado", 4);

    const data = await fetch(`${host}activo.controller.php`, {
      method:'POST',
      body:params
    });

    const msg = await data.json();
    return msg.respuesta;
    
  }

  async function addNotificacion(responsable) {
    const params = new FormData();
    params.append("operation", "add");
    params.append("idusuario", responsable);
    params.append("tipo", "Baja de un activo");
    params.append("mensaje", "Un activo que te asignaron, le dieron de baja");

    const data = await fetch(`${host}notificacion.controller.php`,{
      method:'POST',
      body:params
    });
    const msg = await data.json();

    return msg.respuesta;
  }

  function resetUI(){
    selector("motivo").value="";
    selector("comentario").value="";
    selector("motivo").value="";
    selector("documentacion").value="";

    globals={
      idactivo:0,
      responsable:0,
      user_responsable:"",
      cod_identificacion:"",
      myTable:null,
      no_responsable:false
    };
  }
});