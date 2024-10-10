document.addEventListener("DOMContentLoaded",()=>{
  let dataTable = null;
  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  (async()=>{
    const data = await getDatos(`http://localhost/CMMS/controllers/respActivo.controller.php`,"operation=getAll");
    //selector("imgTest").src=Object.values(JSON.parse(data[1].imagenes))[0].url;
    
    data.forEach((element,i) => {
      selector("tb-activo-resp tbody").innerHTML+=`
      <tr class="text-center">
        <td>${i+1}</td>
        <td>${element.cod_identificacion}</td>
        <td>${element.descripcion}</td>
        <td>${element.ubicacion}</td>
        <td><button type="button" data-idactivo=${element.idactivo} class="btn btn-sm btn-primary btn-colab">Ver colab</button></td>
        <td><button type="button" data-idresp=${element.idactivo_resp} class="btn btn-sm btn-primary btn-det" data-bs-toggle="modal" 
        data-bs-target="#modal-activo-resp">Click me</button></td>
      </tr>
      `;
    });

    if(!dataTable){
      dataTable =new DataTable("#tb-activo-resp", {
        searchable:false,
        perPage: 5, // Número de filas por página
        perPageSelect: [5, 10, 15] // Opciones para cambiar cantidad de filas
      });
    }
    
    data.forEach(x => {
      const option = document.createElement("option");
      option.textContent = x.descripcion;
      option.value = x.idactivo;
      selector("list-sidebar-activos").appendChild(option);
    });

    buttonDetail();
    await usersByActivo();
  })();

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
      li.classList.add('list-group-item');
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
    const dataButtons = listOfButtons("btn-colab");
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
    // let valor = "";
    // data.forEach(x=>{
    //   x.addEventListener("click",(e)=>{
    //     valor=e.target.dataset
        
    //   });
    // });
    // console.log(valor);
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

})