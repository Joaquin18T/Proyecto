document.addEventListener("DOMContentLoaded", () => {
  let myTable = null;

  const host = "http://localhost/CMMS/controllers/";

  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }

  (async () => {
    const data = await getDatos(
      "http://localhost/CMMS/controllers/rol.controller.php",
      "operation=getAll"
    );
    data.forEach((x) => {
      const element = document.createElement("option");
      element.textContent = x.rol;
      element.value = x.idrol;
      selector("rol").appendChild(element);
    });
  })();

  (async () => {
    const data = await getDatos(
      "http://localhost/CMMS/controllers/tipodoc.controller.php",
      "operation=getAll"
    );
    //console.log(data);
    data.forEach((x) => {
      const element = document.createElement("option");
      element.textContent = x.tipodoc;
      element.value = x.idtipodoc;
      selector("tipodoc").appendChild(element);
    });
  })();

  (async () => {
    await showUsuarios();
  })();


  async function showUsuarios() {
    const params = new URLSearchParams();
    params.append("operation", "listOfFilters");
    params.append("idrol", selector("rol").value);
    params.append("estado", selector("estado").value);
    params.append("dato", selector("dato").value);
    params.append("idtipodoc", selector("tipodoc").value);

    const data = await getDatos(`${host}usuarios.controller.php`, params);
    console.log(data);
    
    selector("tb-usuarios tbody").innerHTML = "";
    if(data.length===0){
      selector("tbody-usuarios").innerHTML = `
      <tr>
        <td colspan="8">No encontrado</td>
      </tr>
      `;
    }
    
    data.forEach((x) => {
      selector("tb-usuarios tbody").innerHTML += `
        <tr>
          <td>${x.id_usuario}</td>
          <td>${x.usuario}</td>
          <td>${x.rol}</td>
          <td>${x.nombres}</td>
          <td>${x.tipodoc}</td>
          <td>${x.genero}</td>
          <td>${x.estado==="1"?"Activo":"Baja"}</td>
          <td>
              ${parseInt(x.estado)===0?'Ninguna Accion':
                `<button type="button" class="btn btn-sm btn-outline-secondary update-user" data-iduser=${x.id_usuario}>Update</button>`
              }
          </td>
        </tr>
      `;
    });
    createTable(data);

    chargerEventButtons();
  }

  function createTable(data){
    let rows = $("#tbody-usuarios").find("tr");
    //console.log(rows.length);
    if(data.length>0){
      if (myTable) {
        if (rows.length > 0) {
          myTable.clear().rows.add(rows).draw();
        } else if(rows.length===0){
          myTable.clear().draw(); // Limpia la tabla si no hay filas.
        }
      } else {
        // Inicializa DataTable si no ha sido inicializado antes
        myTable = $("#tb-usuarios").DataTable({
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
  
  function filtersData() {
    const filters = document.querySelectorAll(".filters");

    filters.forEach((x) => {
      x.addEventListener("change", async () => {
        await showUsuarios();
      });
      if (x.id === "dato") {
        x.addEventListener("keyup", async () => {
          await showUsuarios();
        });
      }
    });
  }
  function chargerEventButtons(){
    document.querySelector(".table-responsive").addEventListener("click",(e)=>{
      if(e.target){
        if(e.target.classList.contains("update-user")){
          loadUpdate(e);
        }
      }
    });
  }
  /**
   * Obtiene la id y abre el modal para confirmar la actualizacion
   */
  function loadUpdate(e) {
    const iduser = e.target.getAttribute("data-iduser");
    localStorage.setItem("iduser", iduser);
    console.log(localStorage.getItem("iduser"));

    const modalImg = new bootstrap.Modal(selector("modal-update-user"));
    modalImg.show();
  }

  selector("aceppt-update").addEventListener("click",()=>{
    window.location.href = "http://localhost/CMMS/views/usuarios/update";
  });
  filtersData();
});
