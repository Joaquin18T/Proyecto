document.addEventListener("DOMContentLoaded", ()=>{
  const host = "http://localhost/CMMS/controllers/";
  let cont=0;
  let rows=5;
  let myTable=null;
  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }

  (async()=>{
    const data = await getDatos("http://localhost/CMMS/controllers/rol.controller.php", "operation=getAll");
    data.forEach(x=>{
      const element = document.createElement("option");
      element.textContent = x.rol;
      element.value = x.idrol;
      selector("rol").appendChild(element);
    });
  })();

  (async()=>{
    const data = await getDatos("http://localhost/CMMS/controllers/tipodoc.controller.php", "operation=getAll");
    //console.log(data);
    data.forEach(x => {
      const element = document.createElement("option");
      element.textContent = x.tipodoc;
      element.value = x.idtipodoc;
      selector("tipodoc").appendChild(element);
    });
  })();

  (async()=>{
    await showUsuarios();
  })();

  async function showUsuarios(){
    rows=5;    

    if(myTable){
      const table = selector("tb-usuarios");

      table.innerHTML="";
      const colgroup = document.createElement("colgroup");
      const thead = document.createElement("thead");
      const tbody = document.createElement("tbody");

      colgroup.innerHTML=`
                    <col style="width: 0.5%;">
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                    <col style="width: 2%;">
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                    <col style="width: 0.5%;">
      `;
      table.appendChild(colgroup);

      thead.innerHTML=`
                    <tr>
                      <th>ID</th>
                      <th>Nom. Usuario</th>
                      <th>Rol</th>
                      <th>Nombres y Ap.</th>
                      <th>Telefono</th>
                      <th>Genero</th>
                      <th>Nacionalidad</th>
                      <th>Acciones</th>
                    </tr>
      `;
      table.appendChild(thead);
      table.appendChild(tbody);
      loadProperties();
    };
    const params = new URLSearchParams();
    params.append("operation", "listOfFilters");
    params.append("idrol", selector("rol").value);
    params.append("estado", selector("estado").value);
    params.append("dato", selector("dato").value);
    params.append("idtipodoc", selector("tipodoc").value);

    const data = await getDatos(`${host}usuarios.controller.php`,params);
    
    selector("tb-usuarios tbody").innerHTML="";
    data.forEach(x=>{
      selector("tb-usuarios tbody").innerHTML+=`
        <tr>
          <td>${x.id_usuario}</td>
          <td>${x.usuario}</td>
          <td>${x.rol}</td>
          <td>${x.nombres}</td>
          <td>${x.num_doc}</td>
          <td>${x.genero}</td>
          <td>${x.nacionalidad}</td>
          <td><button type="button" class="btn btn-sm btn-outline-secondary update-user" data-iduser=${x.id_usuario}>Update</button></td>
        </tr>
      `;
    });
    
    cont++;

    if(cont===1){
      loadProperties();

    }
    loadUpdate();
  }
  
  filtersData();
  function filtersData(){
    
    const filters = document.querySelectorAll(".filters");

    filters.forEach(x=>{
      x.addEventListener("change",async()=>{
        await showUsuarios();
      });
      if(x.id==="dato"){
        x.addEventListener("keyup", async()=>{
          await showUsuarios();
        });
      }
    });
  }

  /**
   * Obtiene la id y abre el modal para confirmar la actualizacion
   */
  function loadUpdate(){
    
    const buttonsUpdate = document.querySelectorAll(".update-user");
    buttonsUpdate.forEach(x=>{
      x.addEventListener("click",()=>{
        const iduser = x.getAttribute("data-iduser");
        localStorage.setItem('iduser', iduser);
        console.log(localStorage.getItem('iduser'));
        
        const modalImg = new bootstrap.Modal(selector("modal-update-user"));
        modalImg.show();
        ActionButtonUpdate();
      });
    });
  }

  function ActionButtonUpdate(){
    const buttonsAceppt = document.querySelectorAll(".aceppt-update");
    buttonsAceppt.forEach(x=>{
      x.addEventListener("click",()=>{
        const myModal = bootstrap.Modal.getOrCreateInstance('#modal-update-user');
        myModal.hide();
        window.location.href="http://localhost/CMMS/views/usuarios/update.php";
      });
    });
  }

  function loadProperties(){
    myTable = new JSTable("#tb-usuarios",{
      perPage:rows,
      sort:'asc',
      sortable: true,
      searchable:false,
      labels:{
        perPage:"{select} Filas por pagina",
        info:"Mostrando de {start} al {end} de {rows} filas"
      }
    });
  }

});