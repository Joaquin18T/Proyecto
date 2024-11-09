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

    async function getDataUserById(id){
      const params = new URLSearchParams();
      params.append("operation", "getUserById");
      params.append("idusuario", id);
  
      const data = await getDatos(`${globals.host}/usuarios.controller.php`, params);
      return data;
    }
  //./FUNCIONES

  //Obtiene las notificaciones desde DB
  (async()=>{
    const id = await getIdUser();
    const params = new URLSearchParams();
    params.append("operation", "listNotf");
    params.append("idusuario", id);

    const data = await getDatos(`${globals.host}notificacion.controller.php`, params);
    console.log(data);
    
    if(data.length>0){
      data.forEach((x,i)=>{
        if(i<3){
          renderListNotificacion(x.idnotificacion, x.tipo_notificacion, x.mensaje, x.fecha_creacion, x.descripcion_activo, x.idactivo_resp);
        }
        renderSBNotificacion(x.idnotificacion, x.tipo_notificacion, x.mensaje, x.fecha_creacion, x.descripcion_activo);
      });
    }
    showNotificationDetail();
  })();
  
  //Renderiza las notificaciones del usuarios en la lista (solo muestra 3)
  function renderListNotificacion(idnof_activo, tipo, mensaje, fecha, descripcion, idresp){
    let notificacion = "";
    notificacion = `
    <a class="list-group-item list-group-item-action border-bottom item-notifi" data-idnofact=${idnof_activo} 
      data-type="${tipo}" data-whResp=${idresp}>
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

  //Renderiza todas las notificaciones en el sidebar
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

  //Evento para ver todas las notificaciones
  selector("show-all-notificaciones").addEventListener("click",()=>{
    const sidebar = selector("sb-notificacion");
    const offCanvas = new bootstrap.Offcanvas(sidebar);
    offCanvas.show();
  });

  //Funcion que muestra los detalles de cada notificacion
  function showNotificationDetail(){
    const NoftElements = document.querySelectorAll(".item-notifi");
    NoftElements.forEach(x=>{
      x.addEventListener("click",async()=>{
        let idnoft = x.getAttribute("data-idnofact"); //idnotificacion 
        let type = x.getAttribute("data-type"); //tipo de notificacion
        let whResp = parseInt(x.getAttribute("data-whResp")); //Obtiene el idresp para validar si tuvo alguna asignacion

        let notResp = 0;
        if(isNaN(whResp)){
          console.log(whResp==null);
          notResp = 1;
        }
        
        const op = typeOfDetails(type, notResp); //Obtiene el nombre de la operacion
        console.log("type", op);
        console.log("idnoft", idnoft);
        const details = await getDataDeatailNotification(idnoft, op); //Obtiene los detalles de la notificacion
        console.log("datalles", details);

        const fields = await validateFieldsByTipo(type, details); //Obtiene los datos a mostrar (HTML + los datos)
        console.log("type", type);
        console.log("fields", fields);
      });
    });
  }

  //Obtiene los detalles de cada notificacion desde la DB
  async function getDataDeatailNotification(id, operation){
    const params = new URLSearchParams();
    params.append("operation", operation);
    params.append("idnotificacion", parseInt(id));

    const data = await getDatos(`${globals.host}notificacion.controller.php`, params);
    return data[0];
  }

  // Funcion que retorna la operacion segun el tipo de notificacion
  function typeOfDetails(type, whResp){
    let nameOperation = "";
    switch(type){
      case 'Asignacion':
        nameOperation = "detalleAsignacion";
        break;
      case 'Designacion':
        nameOperation = "detalleDesignacion";
        break;
      case 'Baja de un activo':
        if(whResp=1){
          nameOperation = "detalleWhResponsable";
        }else{
          nameOperation = "detalleBajaActivo";
        }
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
      case 'Mantenimiento':
        nameOperation = "detallesNoftMantenimiento";
        break;
      //Falta la lista de los activos que no tienen asignaciones, ni en el historial
    }
    return nameOperation;
  }

  //Renderiza los detalles de cada notificacion
  async function validateFieldsByTipo(tipo, data={}){
    let fields = "";
    let dataUser = [];
    switch(tipo){
      case 'Asignacion':
        dataUser = await getDataUserById(data.autorizacion);
        fields = `
        <p>Activo Asignado: ${data.descripcion}</p>
        <p>Descripcion de la asig.: ${data.des_responsable}</p>
        <p>Responsable de la asig.: ${dataUser[0].dato}</p>
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
        <p>Notificado el dia: ${data.fecha_creacion}</p>`;
        break;
      case 'Designacion':
        dataUser = await getDataUserById(data.responsable_accion);
        fields=`
        <p>Activo Designado: ${data.descripcion}</p>
        <p>Responsable de la accion: ${dataUser[0].dato}</p>
        <br>
        <p><strong>Datos del activo:</strong></p>
        <p>Codigo: ${data.cod_identificacion}</p>
        <p>Subcategoria: ${data.subcategoria}</p>
        <p>Marca: ${data.marca}</p>
        <p>Modelo: ${data.modelo}</p>
        <p>Ubicacion: ${data.ubicacion}</p>
        <br>
        <p>Fecha Designacion: ${data.fecha_designacion}</p>
        <p>Notificado el dia: ${data.fecha_creacion}</p>
        `;
        break;
      case 'Baja de un activo':
        dataUser = await getDataUserById(data.aprobacion);
        fields = `
        <p>Activo dado de baja: ${data.descripcion}</p>
        <p>Motivo: ${data.motivo}</p>
        <p>Coment. Adicionales: ${data.coment_adicionales==null?"No tiene comentario adicional":data.coment_adicionales}</p>
        <p>Responsable de la baja: ${dataUser[0].dato}</p>
        <br>
        <p><strong>Datos del activo:</strong></p>
        <p>Codigo: ${data.cod_identificacion}</p>
        <p>Subcategoria: ${data.subcategoria}</p>
        <p>Marca: ${data.marca}</p>
        <p>Modelo: ${data.modelo}</p>
        <p>Ult. ubicacion: ${data.ubicacion}</p>
        <br>
        <p>Fecha de baja: ${data.fecha_baja}</p>
        <p>Notificado el dia: ${data.fecha_creacion}</p>
        `;
        break;
      case 'Cambio de ubicacion':
        dataUser = await getDataUserById(data.responsable_accion);
        fields = `
        <p>Activo Asignado: ${data.descripcion}</p>
        <p>Responsable de la asig.: ${dataUser[0].dato}</p>
        <br>
        <p><strong>Datos del activo:</strong></p>
        <p>Codigo: ${data.cod_identificacion}</p>
        <p>Subcategoria: ${data.subcategoria}</p>
        <p>Marca: ${data.marca}</p>
        <p>Modelo: ${data.modelo}</p>
        <p>Ubicacion: ${data.ubicacion}</p>
        <br>
        <p>Fecha de actualizacion: ${data.fecha_movimiento}</p>
        <p>Notificado el dia: ${data.fecha_creacion}</p>`;
        break;
      case 'Cambio de responsable Principal':
        dataUser = await getDataUserById(data.responsable_accion);
        fields = `
        <p>Activo Asignado: ${data.descripcion}</p>
        <p>Responsable de la asig.: ${dataUser[0].dato}</p>
        <br>
        <p><strong>Datos del activo:</strong></p>
        <p>Codigo: ${data.cod_identificacion}</p>
        <p>Subcategoria: ${data.subcategoria}</p>
        <p>Marca: ${data.marca}</p>
        <p>Modelo: ${data.modelo}</p>
        <br>
        <p>Fecha de Cambio: ${data.fecha_movimiento}</p>
        <p>Notificado el dia: ${data.fecha_creacion}</p>`;
        break;
      case 'Asignacion como responsable principal':
        dataUser = await getDataUserById(data.responsable_accion);
        fields = `
        <p>Activo Asignado: ${data.descripcion}</p>
        <p>Responsable de la asig.: ${dataUser[0].dato}</p>
        <br>
        <p><strong>Datos del activo:</strong></p>
        <p>Codigo: ${data.cod_identificacion}</p>
        <p>Subcategoria: ${data.subcategoria}</p>
        <p>Marca: ${data.marca}</p>
        <p>Modelo: ${data.modelo}</p>
        <br>
        <p>Fecha de Asignaion: ${data.fecha_movimiento}</p>
        <p>Notificado el dia: ${data.fecha_creacion}</p>`;
        break;
      case 'Mantenimiento':
        dataUser = await getDataUserById(data.creado_por);
        fields=`
        <p>Tarea: ${data.tarea}</p>
        <p>Ordenado: ${dataUser[0].dato}</p>
        <br>
        <p>Activos involucrados: ${data.activos}</p>
        <p>Descripcion de la tarea: ${data.descripcionT}</p>
        <p>Prioridad: ${data.tipo_prioridad}.</p>
        <p>Frecuencia: ${data.frecuencia}</p>
        <p>Cant. Intervalo: ${data.cant_intervalo}</p>
        <br>
        <p>Fecha de la orden: ${data.create_at}</p>
        <p>Notificado el dia: ${data.fecha_creacion}</p>
        `;
        break;
      //Falta la lista de los activos que no tienen asignaciones, ni en el historial
    }

    return fields;
  }
});
