document.addEventListener("DOMContentLoaded",()=>{
  const host = "http://localhost/CMMS/controllers/";
  let myTable = null;

  function selector(value) {
    return document.querySelector(`#${value}`);
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

  (async () => {
    const data = await getDatos(`${host}subcategoria.controller.php`, "operation=getSubCategoria");
    //console.log(data);
    data.forEach(x => {
      const element = createOption(x.idsubcategoria, x.subcategoria);
      selector("subcategoria").appendChild(element);
    })
  })();

  (async()=>{
    const params = new URLSearchParams();
    params.append("operation", "getAll");
    //params.append("idsubcategoria", id);
    const data = await getDatos(`${host}marca.controller.php`, "operation=getAll");

    //console.log(data);
    
    data.forEach(x => {
      const element = createOption(x.idmarca, x.marca);
      selector("marca").appendChild(element);
    })
  })();

  (async()=>{
    const data = await getDatos(`${host}estado.controller.php`, "operation=getAllByActivo");
    //console.log(data);
    data.forEach(x=>{
      const element = createOption(x.idestado, x.nom_estado);
      selector("estado").appendChild(element);
    });
  })();

  function getDate(){
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    const formattedDate = `${year}-${month}-${day}`;
    //selector("fecha").value = formattedDate;
    return formattedDate;
  }

  selector("fecha_adquisicion").addEventListener("change",()=>{
    const valor = selector("fecha_adquisicion").value;
    console.log(valor);
  });

  (async()=>{
    await showData();
  })();

  async function showData(){
    const params = new URLSearchParams();
    params.append("operation","getAllFilters");
    params.append("idsubcategoria",selector("subcategoria").value);
    params.append("cod_identificacion",selector("cod_identificacion").value);
    params.append("fecha_adquisicion",selector("fecha_adquisicion").value);
    params.append("idestado",selector("estado").value);
    params.append("idmarca",selector("marca").value);

    const data = await getDatos(`${host}activo.controller.php`, params);
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
      let especificaciones = JSON.parse(x.especificaciones);
      selector("table-activos tbody").innerHTML+=`
      <tr >
        <td>${x.idactivo}</td>
        <td>${x.categoria}</td>
        <td>${x.modelo}</td>
        <td>${x.descripcion}</td>
        <td><div class="field-espec ms-auto"></div></td>
        <td>
          ${x.nom_estado==="Fuera de Servicio"?'Sin Acciones':
            x.nom_estado==="Baja"?`<button type="button" class="btn btn-sm btn-primary btn-baja" data-id=${x.idactivo}>Detalles</button>`:
            `<button type="button" class="btn btn-sm btn-primary modal-update" data-id=${x.idactivo}>update</button>
          `}
        </td>
      </tr>
      `;
      showEspecificaciones(especificaciones);
      especificaciones="";
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
    buttonsUpdate();
    showDetalleBaja();
  }
  
  changeByFilters();
  function changeByFilters(){
    const filters = document.querySelectorAll(".filter");
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

  function showEspecificaciones(data={}){
    let contain = document.createElement("ul");

    Object.entries(data).forEach(([key, value])=>{
      const element = document.createElement("li");
      element.innerHTML = `<strong>${key}</strong>: ${value}`;
      contain.appendChild(element);      
    });

    const fields = document.querySelectorAll(".field-espec");
    fields.forEach(x=>{
      x.appendChild(contain);
    });
  }

  function buttonsUpdate(){
    const buttons = document.querySelectorAll(".modal-update");
    buttons.forEach(x=>{
      x.addEventListener("click",(e)=>{
        const id= e.target.dataset.id;
        localStorage.setItem('id', id);
        
        const modalImg = new bootstrap.Modal(selector("modal-update"));
        modalImg.show();
      })
    });
  }

  function showDetalleBaja(){
    const btnBajas = document.querySelectorAll(".btn-baja");

    btnBajas.forEach(x=>{
      x.addEventListener("click",async()=>{
        const id = parseInt(x.getAttribute("data-id"));
        const desc = await getDescripcion(id);
        selector("desc").textContent=desc;

        const dataBaja = await dataActivoBaja(id);
        await showDataBajaActivo(dataBaja);
        showPDF(dataBaja.ruta_doc);

        const sidebar = selector("activo-baja-detalle");
        const offCanvas = new bootstrap.Offcanvas(sidebar);

        offCanvas.show();
      });
    });
  }

  async function dataActivoBaja(idactivo){
    const params = new URLSearchParams();
    params.append("operation", "dataBajaActivo");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${host}bajaActivo.controller.php`, params);
    return data[0];
    
  }

  async function showDataBajaActivo(data){
    const aprobacion = await getUser(data.aprobacion);

    selector("fecha-baja").innerHTML =`<strong>Fecha de Baja: </strong>${data.fecha_baja}`;
    selector("aprobacion").innerHTML = `<strong>Aprobado por: </strong>${aprobacion.dato} (${aprobacion.usuario})`;
    selector("motivo").textContent = data.motivo;
    selector("comentario").textContent = data.coment_adicionales==null?"Sin ningun comentario":data.coment_adicionales;
  }

  function showPDF(route){
    let cont=0;
    let index=0;
    for(let i=0; i<route.length; i++){
      if(route[i]==="/"){
        cont++;
      }
      if(cont===3){
        index = i;
        break;
      }
    }
    const newRoute =`http://localhost${route.slice(index, route.length)}`;
    console.log(newRoute);
    
    selector("view-pdf-baja").href = newRoute;
    cont=0;
    index=0;
  }

  async function getUser(iduser){
    const params = new URLSearchParams();
    params.append("operation", "getUserById");
    params.append("idusuario", iduser);

    const data = await getDatos(`${host}usuarios.controller.php`, params);
    
    return data[0];
  }

  async function getDescripcion(idactivo){
    const params = new URLSearchParams();
    params.append("operation", "getById");
    params.append("idactivo", idactivo);
    const data = await getDatos(`${host}activo.controller.php`,params);
  
    return data[0].descripcion
  }

});