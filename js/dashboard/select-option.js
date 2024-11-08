document.addEventListener("DOMContentLoaded", () => {
  const globals = {
    host: "http://localhost/CMMS/controllers/",
    idusuario: 0,
  };

  //FUNCIONES
    function selector(value) {
      return document.querySelector(`#${value}`);
    }

    async function getDatos(link, params) {
      let data = await fetch(`${link}?${params}`);
      return data.json();
    }

    async function getIdUser() {
      const params = new URLSearchParams();
      params.append("operation", "searchUser");
      params.append("usuario", selector("nomuser").textContent);
      const data = await getDatos(`${globals.host}/usuarios.controller.php`, params);
      return data[0].id_usuario;
      //console.log(idusuario);
    }
  //./FUNCIONES

  //Obtiene las notificaciones desde DB
  (async()=>{
    const id = await getIdUser();
    const params = new URLSearchParams();
    params.append("operation", "listNotf");
    params.append("idusuario", id);

    const data = await getDatos(`${globals.host}notificacion.controller.php`, params);
    //console.log(data);
    
    if(data.length>0){
      data.forEach((x,i)=>{
        if(i<3){
          renderListNotificacion(x.idnotificacion, x.tipo_notificacion, x.mensaje, x.fecha_creacion, x.descripcion_activo);
        }
        renderSBNotificacion(x.idnotificacion, x.tipo_notificacion, x.mensaje, x.fecha_creacion, x.descripcion_activo);
      });
    }
    showNotificationDetail();
  })();
  
  function renderListNotificacion(idnof_activo, tipo, mensaje, fecha, descripcion){
    let notificacion = "";
    notificacion = `
    <a class="list-group-item list-group-item-action border-bottom item-notifi" data-idnofact=${idnof_activo} data-type=${tipo}>
      <div class="d-flex justify-content-between align-items-center containe-data-nof" style="pointer-events:none;">
        <div>
          <h4 class="h5 text-small">${tipo}</h4>
          <h4 class="h6 mb-0 text-small">${mensaje}</h4>
          <p class="font-small mt-1 mb-0">${descripcion}</p>
        </div>
        <div class="text-end pb-5">
          <small class="text-danger ">${fecha}</small>
        </div>
      </div>
    </a>
    `;

    selector("list-notificaciones").innerHTML += notificacion;
  }

  function renderSBNotificacion(idnof_activo, tipo, mensaje, fecha, descripcion){
    let element = "";
    element=`
      <div class="card sb-idnotificacion mb-3" data-idnof_activo=${idnof_activo}>
        <div class="card-body">
          <h5 class="card-title">${tipo}</h5>
          <h6 class="mt-3">${mensaje}</h6>
          <h6 class="card-subtitle mb-2 mt-2 text-body-secondary">${descripcion}</h6>
          <p class="card-text">
            <strong>Fech. Creacion: <small class="text-danger">${fecha}</small></strong>
          </p>
        </div>
      </div>
    `;

    selector("sb-list-notificacion").innerHTML+=element;
  }

  selector("show-all-notificaciones").addEventListener("click",()=>{
    const sidebar = selector("sb-notificacion");
    const offCanvas = new bootstrap.Offcanvas(sidebar);
    offCanvas.show();
  });

  function showNotificationDetail(){
    const NoftElements = document.querySelectorAll(".item-notifi");
    NoftElements.forEach(x=>{
      x.addEventListener("click",async()=>{
        let idnoft = x.getAttribute("data-idnofact"); //idnotificacion 
        let type = x.getAttribute("data-type"); //tipo de notificacion
        
        const op = typeOfDetails(type);

        const details = await getDataDeatailNotification(idnoft, op);
        console.log("datalles", details);

        const fields = validateFieldsByTipo(type, details);
        console.log("fields", fields);
        
        
      });
    });
  }

  async function getDataDeatailNotification(id, operation){
    const params = new URLSearchParams();
    params.append("operation", operation);
    params.append("idnotificacion", parseInt(id));

    const data = await getDatos(`${globals.host}notificacion.controller.php`, params);
    return data[0];
  }

  function typeOfDetails(type){
    let nameOperation = "";
    switch(type){
      case 'Asignacion':
        nameOperation = "detalleAsignacion";
        break;
      case 'Designacion':
        nameOperation = "detalleDesignacion";
        break;
      case 'Baja':
        nameOperation = "detalleBajaActivo";
        break;
      case 'Cambio de ubicacion':
        nameOperation = "detalleUbicacion";
        break;
      case 'Cambio de responsable Principal':
        nameOperation = "detalleResponsableP";
        break;
      case 'Asignacion como responsable principal':
        nameOperation = "detalleResponsableP";
        break;
      //Falta la lista de los activos que no tienen asignaciones, ni en el historial
    }
    return nameOperation;
  }

  function validateFieldsByTipo(tipo, data={}){
    let fields = "";

    switch(tipo){
      case 'Asignacion':
        fields = `
        <p>Activo Asignado: ${data.descripcion}</p>
        <p>Descripcion de la asig.: ${data.des_responsable}</p>
        <p>Responsable de la asig.: ${data.autorizacion}</p>
        <br>
        <p><strong>Datos del activo:</strong></p>
        <p>Codigo: ${data.cod_identificacion}</p>
        <p>Subcategoria: ${data.subcategoria}</p>
        <p>Marca: ${data.marca}</p>
        <p>Modelo: ${data.modelo}</p>
        <p>Ubicacion: ${data.ubicacion}</p>
        <p>Condicion del activo:${data.condicion_equipo}</p>
        <br>
        <p>Fecha Asignacion: ${data.fecha_asignacion}</p>
        <p>Fecha Creacion Notificacion: ${data.fecha_creacion}</p>`;
        break;
      case 'Designacion':
        break;
      case 'Baja':
        break;
      case 'Cambio de ubicacion':
        break;
      case 'Cambio de responsable Principal':
        break;
      case 'Asignacion como responsable principal':
        break;
      //Falta la lista de los activos que no tienen asignaciones, ni en el historial
    }
    return fields;
  }
});
