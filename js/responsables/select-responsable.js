document.addEventListener("DOMContentLoaded", () => {
  const host="http://localhost/CMMS/controllers";
  let idactivo = 0;

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
    params.append("operation", "searchDescripcion");
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
        element.textContent = `${x.descripcion} - ${x.subcategoria}`;
        element.value = x.idactivo;
      
        element.addEventListener("click",async (e)=>{
          selector("activo").value = `${x.descripcion} - ${x.subcategoria}`;
          lista.innerHTML="";
          lista.style.display = "none";
          //list.classList.remove('visible');
          //idactivo = x.idactivo;
          //o
          idactivo = e.target.value;
          let data = await filterUsuarios(e.target.value);
          await showDataTable(data)
          console.log(data);
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

  async function showDataTable(data){
    selector("tb-colaboradores tbody").innerHTML="";
    if(data.length===0){
      selector("tb-colaboradores tbody").innerHTML=`<tr><td colspan=6 class="text-center">No hay resultados</td></tr>`;
    }
    console.log(data);
    
    data.forEach((x, index)=>{
      selector("tb-colaboradores tbody").innerHTML+=`
        <tr>
          <td class="text-center">${index+1}</td>
          <td class="text-left">${x.nombres}</td>
          <td class="text-center">${x.rol}</td>
          <td class="text-center">${x.cantidad}</td>
          <td class="text-center">${x.estado}</td>
          <td class="text-center">${x.es_responsable==="0"?"Colaborador":"Responsable"}</td>
          <td class="text-center"><button type="button" class="btn btn-sm btn-success btn-add" data-idresp=${x.idactivo_resp}>Asignar</button></td>
        </tr>
      `;
    });
    addEventResp();
  }

  function addEventResp(){
    const buttons = document.querySelectorAll(".btn-add");
    buttons.forEach(x=>{
      x.addEventListener("click",async()=>{
        //Agregar alerta sobre que eligio a un usuario que ya es responsable principal
        const {respuesta} = await getResponsable();
        if(respuesta>0){
          alert("Ya elegiste un responsable al activo elegido");
        }else{
          if(confirm("¿Deseas que el usuario sea el responsable principal?")){
            const id = x.getAttribute("data-idresp");
            const {respuesta} = await addResponsable(id);
            console.log(respuesta);
            alert("Has elegido al responsable principal");
          }
        }
      });
    });
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

})