document.addEventListener("DOMContentLoaded", () => {
  const globals = {
    host: "http://localhost/CMMS/controllers/",
    myTable: null,
    idactivo: 0,
    cod_identificacion: "",
    responsable: false,
    idactivo_resp: 0,
    nom_resp_principal: "",
  };
  let isSelect = 0; //Controlar cuando renderizar la tabla
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

  function selectorAll(value) {
    return document.querySelectorAll(`.${value}`);
  }

  //CAMPOS INPUTS (buscador, estado)

  //Estados
  (async () => {
    const params = new URLSearchParams();
    params.append("operation", "estadoByRange");
    params.append("idestado", 4);
    params.append("menor", 1);
    params.append("mayor", 6);
    const data = await getDatos(`${globals.host}estado.controller.php`, params);
    //console.log(data);

    data.forEach((x) => {
      const element = createOption(x.idestado, x.nom_estado);
      selector("estado").appendChild(element);
    });
  })();
  //Mostrar datos en la tabla
  (async () => {
    await showDatos();
  })();

  chargerEventsButtons();

  async function showDatos() {
    const params = new URLSearchParams();
    params.append("operation", "sinServicio");
    params.append("fecha_adquisicion", selector("fecha_adquisicion").value);
    params.append("idestado", selector("estado").value);
    params.append("cod_identificacion", selector("cod_identificacion").value);

    const data = await getDatos(
      `${globals.host}bajaActivo.controller.php`,
      params
    );
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
          <button type="button" class="btn btn-sm btn-primary sb-registrar" 
          data-idactivo=${x.idactivo} 
          data-idresp=${x.idactivo_resp}
          data-user=${x.dato == null ? "" : x.dato} 
          >Dar Baja</button>
        </td>
      </tr>
      `;
    });

    if (isSelect === 0) {
      createTable(data);
    }
  }
  //Crea la tabla DataTable
  function createTable(data) {
    let rows = $("#table-activos-tbody").find("tr");
    //console.log(rows.length);
    if (data.length > 0) {
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

  //Function de filtrado
  changeByFilters();
  function changeByFilters() {
    const filters = document.querySelectorAll(".filter");
    selector("table-activos tbody").innerHTML = "";
    filters.forEach((x) => {
      x.addEventListener("change", async () => {
        await showDatos();
      });
      if (x.id === "cod_identificacion") {
        x.addEventListener("keyup", async () => {
          await showDatos();
        });
      }
    });
  }
  //./CAMPOS INPUTS (buscador, estado)

  //Funcion con evento de delegacion
  function chargerEventsButtons() {
    document
      .querySelector(".table-responsive")
      .addEventListener("click", async (e) => {
        if (e.target) {
          if (e.target.classList.contains("sb-registrar")) {
            await btnMostrarSB(e);
          }
        }
      });
  }

  //Muestra el SB
  async function btnMostrarSB(e) {
    globals.idactivo = parseInt(e.target.getAttribute("data-idactivo")); //almacena el id activo a dar de baja
    console.log("idactibo btn", globals.idactivo);
    
    //Datos a mostrar en el SB
    const valor = await getActivoById(globals.idactivo); //Obtiene datos del activo por la id
    selector("activo").value = valor.descripcion;
    globals.cod_identificacion = valor.cod_identificacion;

    let user = e.target.getAttribute("data-user"); //usuario responsable principal
    //console.log(user);//muestra al responsable principal

    globals.idactivo_resp = parseInt(e.target.getAttribute("data-idresp")); // almacenar el idactivo_resp seleccionado
    if (user === "") {
      console.log("no RP");
    } else {
      console.log("si RP");
      globals.responsable = true; //confirma que el seleccionado tiene RP
      globals.nom_resp_principal = user; //almacena el nombre del RP
    }
    console.log("idactivi_resp btnRegistrar", globals.idactivo_resp);

    const sidebar = selector("sidebar-baja");
    const offCanvas = new bootstrap.Offcanvas(sidebar);
    offCanvas.show();
  }

  /**
   * Guarda el documento y obtiene la direccion donde se almacena
   * @returns El link donde se almacena el documento
   */
  async function saveFile() {
    let params = new FormData();
    let fileInput = selector("documentacion");
    let file = fileInput.files[0];

    params.append("operation", "saveFile");
    params.append("file", file);
    params.append("code", globals.cod_identificacion);

    const data = await fetch(`${globals.host}bajaActivo.controller.php`, {
      method: "POST",
      body: params,
    });
    const respuesta = await data.json();
    return respuesta;
  }

  //Evento que registra la baja
  selector("register-baja").addEventListener("submit", async (e) => {
    e.preventDefault();

    if (confirm("¿Estas seguro de dar de baja al activo?")) {
      const path = await saveFile();
      console.log(path); //muestra la direccion del doc
      console.log("idactivo submit", globals.idactivo);
      
      if(path.respuesta!=="max"){
        const idBaja = await addBaja(path); //Obtiene el id de baja agregado
        const respEstado = await updateEstado(); //actualiza el estado del activo
        console.log("idbaja", idBaja);
        console.log("estado update", respEstado);
  
        let isRight = false;
        if (idBaja > 0 && respEstado > 0) {
          //Hay responsable principal a la hora de baja
          if (globals.responsable) {
            console.log("idactivo rp", globals.idactivo);
            
            const isOkey = await existResponsablePrin();
            if(isOkey){
              isRight = true;
            }else{
              alert("Hubo un error al dar de baja con el responsable Principal");
            }
          }else{
            const isOkey = await noExistResponsablePrin();
            if(isOkey){
              isRight = true;
            }else{
              alert("Hubo un error al dar de baja sin el responsable principal");
            }
          }
        }
  
        if(isRight){
          isSelect=1;
          await addAction();
          //isRight=false;
        }
      }else{
        alert(`Tu archivo pesa mas de lo permitido`);
      }
    }
  });

  /**
   * Guarda la baja del activo
   * @returns El id de la baja
   */
  async function addBaja(path) {
    const iduser = await getIdUser(selector("nomuser").textContent); //Almacena el id del que hace la baja
    const params = new FormData();
    params.append("operation", "add");
    params.append("idactivo", globals.idactivo);
    params.append("motivo", selector("motivo").value);
    params.append("coment_adicionales", selector("comentario").value);
    params.append("ruta_doc", path.respuesta);
    params.append("aprobacion", iduser);

    console.log("path", path);
    console.log("idactivo", globals.idactivo);

    const data = await fetch(`${globals.host}bajaActivo.controller.php`, {
      method: "POST",
      body: params,
    });

    const resp = await data.json();
    console.log("respuesta baja", resp);

    return resp.id;
  }

  async function existResponsablePrin() {
    let allOkey = false;
    //Obtener el idactivo_resp
    //Obtener el idactivo
    //Almacena el id responsable principal del activo
    const responP = await getResPrincipal(globals.idactivo_resp,globals.idactivo);

    //Obtiene la ultima id ubicacion del activo
    console.log("idact_resp P", responP.idactivo_resp);
    console.log("idactivo", globals.idactivo);
    
    const dataUbi = await getUbicacion(responP.idactivo_resp);
    console.log("id ubi", dataUbi);
    //Agregar al historial la baja
    const iduser = await getIdUser(selector("nomuser").textContent);
    const addHis = await addHistorial(responP.idactivo_resp,dataUbi.idubicacion, "Baja de activo", iduser);

    console.log("historial baja", addHis);
    if(addHis>0){
      const addNof = await addNotificacion(responP.idactivo_resp, globals.idactivo);
      if(addNof>0){
        allOkey = true;
      }else{
        alert("Hubo un error al registar una notificacion de la baja");
      }
    }else{
      alert("Hubo un error al registrar el historial de la baja");
    }
    return allOkey;
  }

  async function noExistResponsablePrin() {
    const tieneColabs = await verificarResponsable(globals.idactivo); //Verifica si el activo tiene usuarios asignados
    let isOkey = false;
    let idrespactivo = 0;
    let respIdUbi = 0;

    console.log("tiene colabs", tieneColabs);
    const iduser = await getIdUser(selector("nomuser").textContent);
    //Tiene al menos un usuario asignado
    if(tieneColabs){
      idrespactivo = globals.idactivo_resp;//almacena el idactivo_resp
      console.log("idresp act no", idrespactivo);
      const {idubicacion} = await getUbicacion(idrespactivo);
      respIdUbi = idubicacion; //almacena la id ubicacion

    }else if(!tieneColabs){
      //No tiene colabs, pero pudo haberlos tenido(designados)
      const dataIdResp = await getAnyIdResp(globals.idactivo);

      if(dataIdResp.length>0){
        const {idubicacion} = await getAnyIdUbicacion(dataIdResp[0].idactivo_resp);
        respIdUbi = idubicacion;
      }else{
        respIdUbi = 6;//Aun no tiene una ubicacion establecida
      }
    }
    console.log("idubi no rp", respIdUbi);
    
    const addHis = await addHistorial(idrespactivo, respIdUbi, "Baja de activo",iduser);
    console.log("add his no rp", addHis);
    
    if(addHis>0){
      const addNof = await addNotificacion(idrespactivo, globals.idactivo);
      if(addNof>0){
        isOkey = true;
        idrespactivo = 0;
        respIdUbi = 0;
      }
    }
    return isOkey;
  }

  //FUNCIONES A USAR------------------------------------------------------------------------------------>
  async function addAction() {
    alert("Se ha registrado la baja del Activo");
    resetUI();
    const sidebar = bootstrap.Offcanvas.getOrCreateInstance(
      selector("sidebar-baja")
    );
    sidebar.hide();
    selector("table-activos tbody").innerHTML = "";
    await showDatos();
  }

  /**
   * Obtiene datos de un activo mediante su id
   * @param {*} idactivo idactivo
   * @returns Retorna datos del activo
   */
  async function getActivoById(idactivo) {
    const params = new URLSearchParams();
    params.append("operation", "getById");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${globals.host}activo.controller.php`, params);
    return data[0];
  }

  /**
   * Obtiene el idusuario segun el nombre del usuario
   * @param {*} user nombre del usuario
   * @returns El id del usuario
   */
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

    const data = await getDatos(
      `${globals.host}usuarios.controller.php`,
      params
    );
    return data[0].id_usuario;
  }

  /**
   * Actualiza el estado del activo a baja
   * @returns Entre 1 y  -1 si se ha actualizado el estado del activo
   */
  async function updateEstado() {
    const params = new URLSearchParams();
    params.append("operation", "updateEstado");
    params.append("idactivo", globals.idactivo);
    params.append("idestado", 4);

    const data = await fetch(`${globals.host}activo.controller.php`, {
      method: "POST",
      body: params,
    });

    const msg = await data.json();
    return msg.respuesta;
  }

  /**
   * Obtiene el idactivo resp del responsable P.
   * @param {*} idresp idactivo responsable
   * @param {*} idactivo id activo
   * @returns el id activo responsable del responsable principal del activo
   */
  async function getResPrincipal(idresp, idactivo) {
    const params = new URLSearchParams();
    params.append("operation", "getResponasblePrin");
    params.append("idactivo_resp", idresp);
    params.append("idactivo", idactivo);

    const data = await getDatos(
      `${globals.host}respActivo.controller.php`,
      params
    );
    return data[0];
  }

  /**
   * obtiene la ubicacion actual y lo muestra en el select
   */
  async function getUbicacion(idresp) {
    const params = new URLSearchParams();
    params.append("operation", "ubiByActivo");
    params.append("idactivo", globals.idactivo);
    params.append("idactivo_resp", idresp);

    const data = await getDatos(`${globals.host}historialactivo.controller.php`,params);
    return data[0];
  }

  /**
   * Crea un registro en el historial
   * @param {*} id idActivo_resp puede ser 0
   * @param {*} idubi idActivo_resp
   * @param {*} accion idActivo_resp
   * @returns Retorna un mensaje
   */
  async function addHistorial(id = 0, idubi = 0, accion = "", resp_accion=0) {
    //Insercion al historial

    const params = new FormData();
    params.append("operation", "add");
    params.append("idactivo_resp", id === 0 ? "" : id);
    params.append("idubicacion", idubi);
    params.append("accion", accion);
    params.append("responsable_accion", resp_accion);
    params.append("idactivo", globals.idactivo);

    const data = await fetch(`${globals.host}historialactivo.controller.php`, {
      method: "POST",
      body: params,
    });
    const addNewUbicacion = await data.json();

    return addNewUbicacion.mensaje;
  }

  //Agrega una notificacion
  /**
   * Registra una notificacion
   * @param {*} responsable id del responsable a notificar
   * @param {*} idactivo id activo
   * @returns Entre 1 y -1 para saber si se ha registrado o no
   */
  async function addNotificacion(responsable=0, idactivo=0) {
    const params = new FormData();
    params.append("operation", "add");
    params.append("idactivo_resp", responsable===0?"":responsable);
    params.append("tipo", "Baja de un activo");
    params.append("mensaje", "Un activo que te asignaron, le dieron de baja");
    params.append("idactivo", idactivo===0?"":idactivo);

    const data = await fetch(`${globals.host}notificacion.controller.php`, {
      method: "POST",
      body: params,
    });
    const msg = await data.json();

    return msg.respuesta;
  }

  async function verificarResponsable(idactivo) {
    const params = new URLSearchParams();
    params.append("operation", "verificarExisteColaboradores");
    params.append("idactivo", idactivo);

    const datos = await getDatos(`${globals.host}respActivo.controller.php`, params);
    console.log("cantidad colab: ", datos);
    
    return (datos[0].colaboradores>0);
  }

  /**
   * Obtiene el idactivo_resp sin importar su designacion
   * @param {*} idactivo id del activo
   * @returns una IdActivo_resp del activo, para saber si fue asignado en algun momento
   */
  async function getAnyIdResp(idactivo){
    const params = new URLSearchParams();
    params.append("operation", "getAnyIdResp");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${globals.host}respActivo.controller.php`, params);
    return data;
  }

  /**
   * Obtiene la ultima ubicacion del activo, donde no tiene ningun usuario asignado actualmente
   * @param {*} idactivo_resp idactivo_resp
   * @returns la ultima ubicacion del activo
   */
  async function getAnyIdUbicacion(idactivo_resp) {
    const params = new URLSearchParams();
    params.append("operation", "getAnyIdUbicacion");
    params.append("idactivo_resp", idactivo_resp);

    const data = await getDatos(`${globals.host}respActivo.controller.php`, params);
    return data[0];
  }

  /**
   * Reestablece la interfaz
   */
  function resetUI() {
    selector("motivo").value = "";
    selector("comentario").value = "";
    selector("motivo").value = "";
    selector("documentacion").value = "";

    globals.idactivo = 0;
    globals.responsable = 0;
    globals.cod_identificacion = "";
    globals.myTable = null;
  }
});
