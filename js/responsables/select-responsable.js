document.addEventListener("DOMContentLoaded", () => {
  const host="http://localhost/CMMS/controllers";
  let idactivo = 0;
  let myTable = null;
  selector("tb-colaboradores tbody").innerHTML=`<tr><td colspan=7 class="text-center">No hay resultados</td></tr>`;
  
  /**
   * Selecciona elementos mediante la id
   */
  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  /**
   * Obtiene datos de la DB (GET)
   */
  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }

  //Elegir un activo para filtrar a los usuarios
  selector("activo").addEventListener("keyup",async()=>{
    let valor = selector("activo").value;

    const params = new URLSearchParams();
    params.append("operation", "searchActivoResp");
    params.append("descripcion", valor);
    const data = await getDatos(`${host}/activo.controller.php`, params);
    //console.log(data);

    const lista = selector("list");

    lista.innerHTML="";
    lista.style.display="block";
    //list.classList.add('visible');

    if(data.length>0){
      data.forEach(x=>{
        const element = document.createElement("li");
        element.textContent = `${x.cod_identificacion} - ${x.descripcion}`;
        element.value = x.idactivo;
      
        element.addEventListener("click",async (e)=>{
          selector("activo").value = `${x.cod_identificacion} - ${x.descripcion}`;
          lista.innerHTML="";
          lista.style.display = "none";
          //list.classList.remove('visible');
          //idactivo = x.idactivo;
          //o
          
          idactivo = parseInt(e.target.value);
          console.log("idactivo", idactivo);

          const data = await filterUsuarios(idactivo);
          await showDataTable(data);
          await showDataActivo(idactivo);
          const ubi = await showUbicacion(idactivo);

          if(ubi.length===0){
            selector("ubicacion").value="No ha sido asignado";
          }else{
            selector("ubicacion").value = ubi[0].ubicacion;
          }
          //idactivo=0;
          //console.log(data);
        });
        
        lista.appendChild(element);
      });
      
    }else{
      const element = document.createElement("li");
      element.textContent="No hay resultados";
      element.style.cursor='default';
      lista.appendChild(element);
    }
  });

  document.addEventListener("click",(e)=>{
    if(!selector("activo").contains(e.target) && !selector("list").contains(e.target)){
      selector("list").style.display = "none";
      //selector("list").classList.remove('visible');
    }
  });

  async function filterUsuarios(idactivo){
    const params = new URLSearchParams();
    params.append("operation", "searchByActivo");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${host}/activo.controller.php`, params);
    return data;
  }
  
  chargerEventsButtons();
  async function showDataTable(data=[]){
    //console.log(data);
    selector("tb-colaboradores tbody").innerHTML="";
    if(data.length==0){
      selector("tb-colaboradores tbody").innerHTML=`<tr><td colspan=7 class="text-center">No hay resultados</td></tr>`;
    }
    
    //console.log(data.length);
  
    data.forEach((x, index)=>{
      selector("tb-colaboradores tbody").innerHTML+=`
        <tr>
          <td class="text-center">${index+1}</td>
          <td class="text-left">${x.nombres}</td>
          <td class="text-center">${x.rol}</td>
          <td class="text-center">${x.cantidad}</td>
          <td class="text-center">${x.es_responsable==="0"?"Colaborador":"Responsable"}</td>
          <td class="text-center"><button type="button" class="btn btn-sm btn-success btn-add" data-idresp=${x.idactivo_resp}>Asignar</button></td>
        </tr>
      `;
    });
    createTable(data);
  }
  

  function createTable(data){
    if(data.length>0){
      let rows = $("#tbody-colaboradores").find("tr");
  
      if (myTable) {
        if (rows.length > 0) {
          myTable.clear().rows.add(rows).draw();
        } else if(rows.length===1){
          myTable.clear().draw(); // Limpia la tabla si no hay filas.
        }
      }
      if(!myTable){
        // Inicializa DataTable si no ha sido inicializado antes
        myTable = $("#tb-colaboradores").DataTable({
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

  function chargerEventsButtons(){
    document.querySelector(".table-responsive").addEventListener("click",async(e)=>{
      if(e.target){
        if(e.target.classList.contains("btn-add")){
          await addEventResp(e);
        }
      }
    });
  }

  async function addEventResp(e){
    const {respuesta} = await getResponsable();
    if(respuesta>0){
      alert("Ya elegiste un responsable al activo elegido");
    }else{
      if(confirm("¿Deseas que el usuario sea el responsable principal?")){
        const id = e.target.getAttribute("data-idresp");
        const {respuesta} = await addResponsable(id);
        console.log(respuesta);
        
        if(respuesta>0){
          console.log(respuesta);
          const notifi = await addNotificacion(id);
          console.log("notifi",notifi);
          if(notifi.respuesta>0){
            const historial = await addHistorial(id);
            console.log("historial", historial);
            if(historial.mensaje>0){
              alert("Has elegido al responsable principal");
            }
          }          
        }
      }
    }
  }


  async function addResponsable(idresp){
    const params = new FormData();
    params.append("operation", "chooseResponsable");
    params.append("idactivo_resp", idresp);

    const data = await fetch(`${host}/respActivo.controller.php`,{
      method:'POST',
      body:params
    });

    return await data.json();
  }

  async function getResponsable() {
    const params = new URLSearchParams();
    params.append("operation", "existeResponsable");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${host}/respActivo.controller.php`, params);
    return data;
  }

  async function showDataActivo(id){
    const params = new URLSearchParams();
    params.append("operation", "searchByUpdate");
    params.append("idactivo", parseInt(id));

    const data = await getDatos(`${host}/activo.controller.php`, params);
    selector("subcategoria").value = data[0].subcategoria;
    selector("marca").value = data[0].marca;
    selector("modelo").value = data[0].modelo;
    selector("fecha").value = data[0].fecha_adquisicion;
    selector("estado").value = data[0].nom_estado;

    showEspecificaciones(data[0].especificaciones);
    
  }

  async function showUbicacion(id){
    const params = new URLSearchParams();
    params.append("operation", "getUbiOnlyActivo");
    params.append("idactivo", parseInt(id));

    const data = await getDatos(`${host}/historialactivo.controller.php`, params);

    return data;
  }

  function showEspecificaciones(data){
    const convertData = JSON.parse(data);
    console.log(convertData);

    selector("lista-espec").innerHTML="";
    selector("title").innerHTML = "Especificaciones";

    for (const key in convertData) {
      const li = document.createElement("li");
      li.innerHTML=`<strong>${key}: </strong>${convertData[key]}`;
      selector("lista-espec").appendChild(li);
    }

  }

  async function getIdUserLoged(){
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", selector("nomuser").textContent);

    const data = await getDatos(`${host}/usuarios.controller.php`, params);
    return data;
  }

  async function addNotificacion(idactivo_resp){
    const params = new FormData();
    params.append("operation","add");
    params.append("idactivo_resp", idactivo_resp);
    params.append("tipo","Asignacion como responsable principal");
    params.append("mensaje", "Te han asignado como responsable principal de un activo");
    params.append("idactivo", idactivo);

    const resp = await fetch(`${host}/notificacion.controller.php`,{
      method:'POST',
      body:params
    });
    const data = await resp.json();
    return data;
  }

  async function addHistorial(idactivo_resp){
    const user = await getIdUserLoged();
    const ubi = await showUbicacion(idactivo);
    console.log(user);
    
    const params = new FormData();
    params.append("operation", "add");
    params.append("idactivo_resp", idactivo_resp);
    params.append("idubicacion", ubi[0].idubicacion);
    params.append("accion", "Asignacion como responsable principal");
    params.append("responsable_accion", user[0].id_usuario);
    params.append("idactivo", "");

    const resp = await fetch(`${host}/historialactivo.controller.php`,{
      method:'POST',
      body:params
    });

    const data = await resp.json();
    return data;
  }
})