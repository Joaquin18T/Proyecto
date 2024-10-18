document.addEventListener("DOMContentLoaded",()=>{
  const host = "http://localhost/CMMS/controllers/";
  let myTable = null;
  let idactivo_resp = 0;
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
    const data = await getDatos(`${host}subcategoria.controller.php`, "operation=getSubCategoria");
    //console.log(data);
    data.forEach(x => {
      const element = createOption(x.idsubcategoria, x.subcategoria);
      selector("subcategoria").appendChild(element);
    })
  })();

  (async () => {
    const data = await getDatos("http://localhost/CMMS/controllers/ubicacion.controller.php", "operation=getAll");
    data.forEach(x => {
      //console.log(x);
      const element = createOption(x.idubicacion, x.ubicacion);
      selector("ubicacion").appendChild(element);

      const elementSB = createOption(x.idubicacion, x.ubicacion);
      selector("sb-ubicacion").appendChild(elementSB);
    });
  })();

  (async()=>{
    await showData();
    
  })();
  
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

          <button type="button" data-idresp=${element.idactivo_resp} class="btn btn-sm btn-primary btn-update-ubicacion">Edt. Ub.</button>
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

    buttonDetail();
    btnUpdateUbicacion();
    await usersByActivo();
    
  }
  //createTable();

  searchActivoResponsable();
  function createTable(){
    if (myTable) {
      myTable.clear().rows.add($("#tbody-tb-activo-resp").find("tr")).draw();
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
          emptyTable: "No hay datos disponibles",
          search: "Buscar:",
          info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
        },
      });
    }
  }

  function searchActivoResponsable(){
    const filters = document.querySelectorAll(".filter");
    selector("tb-activo-resp tbody").innerHTML="";
    createTable();
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

  function buttonDetail(){
    const data = listOfButtons("btn-det");

    data.forEach(x=>{
      x.addEventListener("click",async(e)=>{
        console.log(e.target.dataset.idresp);
        let value=e.target.dataset.idresp;
    
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
        
      });
    });
  }

  selector("list-sidebar-activos").addEventListener("change",async()=>{
    const params = new URLSearchParams();
    params.append("operation", "usersByActivo");
    params.append("idactivo", selector("list-sidebar-activos").value);
    const data = await getDataUsuarios(params);
    renderListUsers(data);
  });

  function renderListUsers(data){
    const list = selector("list-users");
    list.innerHTML="";
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

  async function usersByActivo(){
    const dataButtons = document.querySelectorAll(".btn-colab");
    dataButtons.forEach(x=>{
      x.addEventListener("click",async(e)=>{
        const value = e.target.dataset.idactivo;

        const params = new URLSearchParams();
        params.append("operation", "usersByActivo");
        params.append("idactivo", value);

        const data = await getDataUsuarios(params);  
        const sidebar = selector("sidebar");
        const offCanvas = new bootstrap.Offcanvas(sidebar);

        renderListUsers(data);
        
        offCanvas.show();
             
      });
    });
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

  //ACTUALIZAR UBICACION
  function btnUpdateUbicacion() {
    const buttons = document.querySelectorAll(".btn-update-ubicacion");
    buttons.forEach(x=>{
      x.addEventListener("click",async()=>{
        idactivo_resp = x.getAttribute("data-idresp");
        const dataResp = await getResPrincipal(idactivo_resp);
        selector("sb-responsable").value =`${dataResp.apellidos} ${dataResp.nombres} - ${dataResp.usuario}`;
        const sidebar = selector("sb-ubicacion-update");
        const offCanvas = new bootstrap.Offcanvas(sidebar);
        offCanvas.show();
      });
    });
  }

  async function getResPrincipal(id){
    const params = new URLSearchParams();
    params.append("operation", "getResponasblePrin");
    params.append("idactivo_resp", parseInt(id));

    const data = await getDatos(`${host}respActivo.controller.php`,params);
    return data[0];
  }

  selector("form-update-ubicacion").addEventListener("submit",async(e)=>{
    e.preventDefault();
    
    if(confirm("¿Deseas actualizarlo?")){
      const resp = await updateUbicacion();
      if(resp.mensaje==="Historial guardado"){
        alert("Se ha actualizado la ubicacion");
        const sidebar = bootstrap.Offcanvas.getOrCreateInstance(selector("sb-ubicacion-update"));
        sidebar.hide();
        await showData();
      }else{
        alert("Hubo un error al actualizar");
      }
    }
    
  });

  async function updateUbicacion(){
    const params = new FormData();
    params.append("operation", "add");
    params.append("idactivo_resp", parseInt(idactivo_resp));
    params.append("idubicacion", parseInt(selector("sb-ubicacion").value));

    const data = await fetch(`${host}historialactivo.controller.php`, {
      method:'POST',
      body:params
    });
    const addNewUbicacion = await data.json();

    return addNewUbicacion;
  }
});