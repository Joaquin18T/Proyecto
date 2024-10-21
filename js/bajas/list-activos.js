document.addEventListener("DOMContentLoaded", () => {
  const host = "http://localhost/CMMS/controllers/";
  let globals = {
    idactivo: 0,
    responsable: 0,
    user_responsable: "",
    cod_identificacion: "",
    myTable: null,
    no_responsable: false,
  };
  let isSelect = 0;
  console.log(selector("estado"));

  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  function selectorAll(value) {
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

  (async () => {
    const params = new URLSearchParams();
    params.append("operation", "estadoByRange");
    params.append("menor", 1);
    params.append("mayor", 5);
    const data = await getDatos(`${host}estado.controller.php`, params);
    //console.log(data);
    data.forEach((x) => {
      const element = createOption(x.idestado, x.nom_estado);
      selector("estado").appendChild(element);
    });
  })();

  (async () => {
    await showData();
  })();

  async function showData() {
    const params = new URLSearchParams();
    params.append("operation", "sinServicio");
    params.append("fecha_adquisicion", selector("fecha_adquisicion").value);
    params.append("idestado", selector("estado").value);
    params.append("cod_identificacion", selector("cod_identificacion").value);
    const data = await getDatos(`${host}bajaActivo.controller.php`, params);
    console.log(data);

    selector("table-activos tbody").innerHTML = "";
    if (data.length === 0) {
      selector("table-activos tbody").innerHTML = `
      <tr>
        <td colspan="7">Sin registro a mostrar</td>
      </tr>
      `;
    }

    data.forEach((x) => {
      selector("table-activos tbody").innerHTML += `
      <tr>
        <td>${x.idactivo}</td>
        <td>${x.cod_identificacion}</td>
        <td>${x.descripcion}</td>
        <td>${x.fecha_adquisicion}</td>
        <td>
        ${x.dato == null ? "Sin usuario asignado" : x.dato}
        </td>
        <td>${x.ubicacion == null ? "Sin Ubicacion" : x.ubicacion}</td>
        <td>${x.nom_estado}</td>
        <td>
          <button type="button" class="btn btn-sm btn-primary sb-registrar" data-id=${
            x.idactivo
          } data-user=${x.dato == null ? "" : x.dato}>Dar Baja</button>
        </td>
      </tr>
      `;
    });
    if(isSelect===0){
      createTable(data);
    }
    chargerEventsButtons();
    //console.log(isSelect);
  }

  function createTable(data) {
    let rows = $("#table-activos-tbody").find("tr");
    //console.log(rows.length);
    if(data.length>0){
      if (globals.myTable) {
        if (rows.length > 0) {
          globals.myTable.clear().rows.add(rows).draw();
        } else if (rows.length === 1) {
          globals.myTable.clear().draw(); // Limpia la tabla si no hay filas.
        }
      } else {
        // Inicializa DataTable si no ha sido inicializado antes
        globals.myTable = $("#table-activos").DataTable({
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
            emptyTable: "No se encontraron registros",
          },
        });
        // if (rows.length > 0) {
        //   myTable.rows.add(rows).draw(); // Si hay filas, agrégalas.
        // }
      }
    }
  }

  function chargerEventsButtons(){
    document.querySelector(".table-responsive").addEventListener("click",async(e)=>{
      if(e.target){
        if(e.target.classList.contains("sb-registrar")){
          await btnRegistrar(e);
        }
      }
    });
  }

  async function btnRegistrar(e) {
    globals.idactivo = e.target.getAttribute("data-id");

    const valor = await getActivoById(parseInt(globals.idactivo));
    selector("activo").value = valor.descripcion;
    globals.cod_identificacion = valor.cod_identificacion;

    let user = e.target.getAttribute("data-user");
    console.log("user existe", user === "");

    if (user === "") {
      globals.no_responsable = true;
    } else {
      globals.user_responsable = e.target.getAttribute("data-user");
      console.log("user resp", globals.user_responsable);
    }
    console.log(globals.no_responsable);

    const sidebar = selector("sidebar-baja");
    const offCanvas = new bootstrap.Offcanvas(sidebar);

    offCanvas.show();
  }

  async function saveFile() {
    let params = new FormData();
    let fileInput = selector("documentacion");
    let file = fileInput.files[0];

    params.append("operation", "saveFile");
    params.append("file", file);
    params.append("code", globals.cod_identificacion);

    const data = await fetch(`${host}bajaActivo.controller.php`, {
      method: "POST",
      body: params,
    });
    const respuesta = await data.json();
    return respuesta;
  }
  filtersData();
  function filtersData() {
    const filters = document.querySelectorAll(".filter");
    filters.forEach((x) => {
      x.addEventListener("change", async () => {
        await showData();
      });
      if(x.id==="cod_identificacion"){
        x.addEventListener("keyup",async()=>{
          isSelect=0;
          await showData();
        });
      }
    });
  }

  selector("register-baja").addEventListener("submit", async (e) => {
    e.preventDefault();

    if (confirm("¿Estas seguro de dar de baja al activo?")) {
      
      const path = await saveFile();
      console.log(path);

      if (path.respuesta !== "max") {
        const iduser = await getIdUser(selector("nomuser").textContent);
        const params = new FormData();
        params.append("operation", "add");
        params.append("idactivo", globals.idactivo);
        params.append("motivo", selector("motivo").value);
        params.append("coment_adicionales", selector("comentario").value);
        params.append("ruta_doc", path.respuesta);
        params.append("aprobacion", iduser);

        const data = await fetch(`${host}bajaActivo.controller.php`, {
          method: "POST",
          body: params,
        });

        const msg = await data.json();
        const estadoUP = await updateEstado();

        let addNotifi = 0;

        if (!globals.no_responsable) {
          globals.responsable = await getIdUser(globals.user_responsable);
          addNotifi = await addNotificacion(globals.responsable);
        }

        //console.log("responsable: ", globals.responsable);
        const isAdd = verifierAddBaja(globals.no_responsable, msg.id, estadoUP);
        console.log(isAdd);
        
        
        if (isAdd && globals.no_responsable) {

          isSelect=1;
          await addAction();
        } else if (!isAdd && !globals.no_responsable) {
          isSelect=1;
          await addAction();
        } else {
          alert("Hubo un error al registrar la baja");
        }
      } else {
        if (path.respuesta === "max") {
          alert(`Tu archivo pesa mas de lo permitido`);
        } else {
          alert("Hubo un error al obtener la ruta del archivo");
        }
      }
    }
  });

  function verifierAddBaja(no_responsable, add_baja, estado_update) {
    let noresp = false;
    if (no_responsable) {
      if (estado_update > 0 && add_baja > 0) {
        noresp = true;
      }
    }
    return noresp;
  }

  async function addAction() {
    
    alert("Se ha registrado la baja del Activo");
    resetUI();
    const sidebar = bootstrap.Offcanvas.getOrCreateInstance(
      selector("sidebar-baja")
    );
    sidebar.hide();
    selector("table-activos tbody").innerHTML = "";
    await showData();
  }

  async function getActivoById(idactivo) {
    const params = new URLSearchParams();
    params.append("operation", "getById");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${host}activo.controller.php`, params);
    return data[0];
  }

  async function getIdUser(user) {
    let nomusuario = user;
    if (nomusuario.includes("|")) {
      const nomuser = nomusuario.split("|");
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
      method: "POST",
      body: params,
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

    const data = await fetch(`${host}notificacion.controller.php`, {
      method: "POST",
      body: params,
    });
    const msg = await data.json();

    return msg.respuesta;
  }

  function resetUI() {
    selector("motivo").value = "";
    selector("comentario").value = "";
    selector("motivo").value = "";
    selector("documentacion").value = "";

    globals = {
      idactivo: 0,
      responsable: 0,
      user_responsable: "",
      cod_identificacion: "",
      no_responsable: false,
      myTable: null,
    };
  }
});
