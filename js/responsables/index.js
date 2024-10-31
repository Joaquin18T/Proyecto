document.addEventListener("DOMContentLoaded",()=>{
  const host = "http://localhost/CMMS/controllers/";
  let myTable = null;
  let idactivo_resp = 0;
  let users=[];
  let contNof = 0;
  function selector(value) {
    return document.querySelector(`#${value}`);
  }
  function createOption(value, text) {
    const element = document.createElement("option");
    element.value = value;
    element.innerText = text;
    return element;
  }

  (async () => {
    const data = await getDatos("http://localhost/CMMS/controllers/ubicacion.controller.php", "operation=getAll");
    
    data.forEach((x,i) => {
      //console.log(x);
      if(i<5){
        const element = createOption(x.idubicacion, x.ubicacion);
        selector("ubicacion").appendChild(element);
      }
    });
  
  })();

  (async () => {
    const data = await getDatos(`${host}subcategoria.controller.php`, "operation=getSubCategoria");
    //console.log(data);
    data.forEach(x => {
      const element = createOption(x.idsubcategoria, x.subcategoria);
      selector("subcategoria").appendChild(element);
    })
  })();

  (async()=>{
    await showData();
    
  })();
  chargerEventsButtons();
  async function showData(){
    selector("tb-activo-resp tbody").innerHTML="";
    const params = new URLSearchParams();
    params.append("operation", "searchActivoResp");
    params.append("idsubcategoria", selector("subcategoria").value);
    params.append("idubicacion", selector("ubicacion").value);
    params.append("cod_identificacion", selector("cod_identificacion").value);
    const data = await getDatos(`http://localhost/CMMS/controllers/respActivo.controller.php`,params);
    //selector("imgTest").src=Object.values(JSON.parse(data[1].imagenes))[0].url;

    
    if(data.length===0){
      selector("tb-activo-resp tbody").innerHTML=`
      <tr>
        <td colspan="6">No encontrado</td>
      </tr>
      `;
    }
    data.forEach((element,i) => {
      selector("tb-activo-resp tbody").innerHTML+=`
      <tr>
        <td>${i+1}</td>
        <td>${element.cod_identificacion}</td>
        <td>${element.subcategoria}</td>
        <td>${element.descripcion}</td>
        <td>${element.ubicacion}</td>
        <td><button type="button" data-idactivo=${element.idactivo} class="btn btn-sm btn-primary btn-colab">Ver colab</button></td>
        <td>
          <button type="button" data-idresp=${element.idactivo_resp} class="btn btn-sm btn-primary btn-det" data-bs-toggle="modal" 
          data-bs-target="#modal-activo-resp">Detalles</button>
          <button type="button" data-idresp=${element.idactivo_resp} data-idactivo=${element.idactivo} 
          class="btn btn-sm btn-primary btn-update">Editar A.</button>
        </td>
      </tr>
      `;
    });

    data.forEach(x => {
      const option = document.createElement("option");
      option.textContent = x.descripcion;
      option.value = x.idactivo;
      selector("list-sidebar-activos").appendChild(option);
    });

    createTable(data);
  }

  function chargerEventsButtons(){
    document.querySelector(".table-responsive").addEventListener("click",async(e)=>{
      if(e.target){
        if(e.target.classList.contains("btn-colab")){
          await usersByActivo(e);
        }
        else if(e.target.classList.contains("btn-det")){
          await buttonDetail(e);
        }else if(e.target.classList.contains("btn-update")){
          btnActualizarAsg(e);
        }

      }
    });
  }

  function btnActualizarAsg(e){
    //delegacion de eventos
    console.log(e.target.getAttribute("data-idactivo"));
        
    if(confirm("¿Deseas actualizar sus asignaciones?")){
      const id = e.target.getAttribute("data-idresp");
      const idactivo = e.target.getAttribute("data-idactivo");
      localStorage.setItem("idresp_act", parseInt(id));
      localStorage.setItem("idactivo", parseInt(idactivo));
      myTable = null;
      window.location.href=`http://localhost/CMMS/views/responsables/update-asignacion`;
    }
  }
  
  function createTable(data){
    let rows = $("#tbody-tb-activo-resp").find("tr");
    //console.log(rows.length);
    if(data.length>0){
      if (myTable) {
        if (rows.length > 0) {
          myTable.clear().rows.add(rows).draw();
        } else if(rows.length===1){
          myTable.clear().draw(); // Limpia la tabla si no hay filas.
        }
      } else {
        // Inicializa DataTable si no ha sido inicializado antes
        myTable = $("#tb-activo-resp").DataTable({
          paging: true,
          searching: false,
          lengthMenu: [5, 10, 15, 20],
          pageLength: 5,
          language: {
            lengthMenu: "Mostrar _MENU_ filas por página",
            paginate: {
              previous: "Anterior",
              next: "Siguiente",
            },
            search: "Buscar:",
            info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
            emptyTable: "No se encontraron registros"
          },
        });
      }
    }
  }
  searchActivoResponsable();
  function searchActivoResponsable(){
    const filters = document.querySelectorAll(".filter");
    selector("tb-activo-resp tbody").innerHTML="";
    filters.forEach(x=>{
      x.addEventListener("change",async()=>{
        await showData();
      });
      if(x.id==="cod_identificacion"){
        x.addEventListener("keyup",async()=>{
          await showData();
        });
      }
    });
  }
  //ubicacion
  async function buttonDetail(e){
    console.log(e.target.getAttribute("data-idresp"));
    let value=e.target.getAttribute("data-idresp");

    const data = await getDatos("http://localhost/CMMS/controllers/respActivo.controller.php",`operation=getById&&idactivo_resp=${value}`);
    let condicion = replaceWords(data[0].condicion_equipo,['<p>','</p>'],'');   
    
    const autorizacion = await getUserById(data[0].autorizacion);
    const especificaciones = stringToJson(data[0].especificaciones);
    selector("div-content").innerHTML="";
    selector("div-content").innerHTML=`
      <p><strong>Marca:</strong> <span>${data[0].marca}</span></p>
      <p><strong>Modelo:</strong> <span>${data[0].modelo}</span></p>
      <p><strong>Descripcion:</strong> <span>${data[0].descripcion}</span></p>
      <p><strong>Fecha Adquisición:</strong> <span>${data[0].fecha_adquisicion}</span></p>
      <p><strong>Condición:</strong> <span>${condicion}</span></p>
      <p><strong>Ubicación Actual:</strong> <span>${data[0].ubicacion}</span></p>
      <p><strong>Estado:</strong> <span>${data[0].nom_estado}</span></p>
      <p><strong>Autorizacion:</strong> <span>${autorizacion[0].usuario}</span></p>
      <div id="espec"><strong>Especificaciones: </strong> 
        
      </div>
    `;
    showEspecificaciones(especificaciones);
  }

  selector("list-sidebar-activos").addEventListener("change",async()=>{
    const data = await usersActivo(selector("list-sidebar-activos").value);
    console.log("sb activos", data);
    
    renderListUsers(data);
  });

  async function usersActivo(valor){
    const params = new URLSearchParams();
    params.append("operation", "usersByActivo");
    params.append("idactivo", parseInt(valor));
    const data = await getDataUsuarios(params);
    return data;
  }
  
  function renderListUsers(data=[]){
    const list = selector("list-users");
    list.innerHTML="";
    console.log("colabs", data);
    
    if(data.length===0){
      const li = document.createElement("li");
      li.classList.add('list-group-item', 'mt-2');
      li.innerHTML="<strong>No tiene colaboradores asignados</strong>";
      list.appendChild(li);
    }else{
      data.forEach(x=>{
        const li = document.createElement("li");
        li.classList.add('list-group-item', 'mt-2');
        li.innerHTML=`
          <strong>Usuario: </strong>${x.usuario}<br>
          <strong>Apellidos: </strong>${x.apellidos}<br>
          <strong>Nombres: </strong>${x.nombres}<br>
          <strong>Fecha asig.: </strong>${x.fecha_asignacion}<br>
          <strong>Tipo Asig.: </strong>${parseInt(x.es_responsable)===0?'Colaborador':'Responsable Principal'}<br>
        `;
        list.appendChild(li);
      });
    }
  }

  async function usersByActivo(e){
    const value = e.target.getAttribute("data-idactivo");

    const params = new URLSearchParams();
    params.append("operation", "usersByActivo");
    params.append("idactivo", value);

    const data = await getDataUsuarios(params);  
    const sidebar = selector("sidebar");
    const offCanvas = new bootstrap.Offcanvas(sidebar);

    renderListUsers(data);
    
    offCanvas.show();
         
  }

  async function getDataUsuarios(params){
    return await getDatos(`http://localhost/CMMS/controllers/respActivo.controller.php`, params);
  }

  function listOfButtons(classButton){
    const data = document.querySelectorAll(`.${classButton}`);
    return data;
  }

  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }

  /**
  * Reemplaza una cadena
  * @param {*} word 'variable que contiene la cadena'
  * @param {*} rem 'array de elementos que quieres reemplazar'
  * @param {*} remTo 'palabra por la cual vas a reemplazar'
  * @returns 
  */
  function replaceWords(word, rem=[], remTo){
    for (let i = 0; i < rem.length; i++) {
      //const rgx = new RegExp(rem[i], 'g');
      word = word.replace(rem[i], remTo);
    }
    return word;
  }
  
  async function getUserById(id){
    const params = new URLSearchParams();
    params.append("operation", "getUserById");
    params.append("idusuario", id);
    const data = await getDatos(`http://localhost/CMMS/controllers/usuarios.controller.php`, params);
    return data;
  }

  /**
   * Convierte de string a JSON
   * @param {*} cadena cadena  a convertir
   * @returns Un objeto (JSON)
   */
  function stringToJson(cadena){
    return JSON.parse(cadena);
  }

  function showEspecificaciones(data={}){
    let contain = document.createElement("ul");

    Object.entries(data).forEach(([key, value])=>{
      const element = document.createElement("li");
      element.innerHTML = `<strong>${key}</strong>: ${value}`;
      contain.appendChild(element);      
    });
    selector("espec").appendChild(contain);
  }
});