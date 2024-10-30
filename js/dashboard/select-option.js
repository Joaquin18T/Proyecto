document.addEventListener("DOMContentLoaded", () => {
  // if (document.getElementById("options-sidebar")) {
  //   const sidebarList = document.getElementById("options-sidebar");

  //   sidebarList.addEventListener("click", (e) => {
  //     if (e.target && e.target.matches("a.nav-link")) {
  //       const aElement = document.querySelectorAll(".nav-link");
  //       aElement.forEach((x) => {
  //         x.addEventListener("click", (e) => {
  //           e.preventDefault();
  //           const hrefValue = enlace.href;
  //           window.location.href = hrefValue;
  //         });
  //       });

  //       let items = sidebarList.querySelectorAll("li");
  //       items.forEach((item) => item.classList.remove("active"));

  //       // Añadir la clase active al li seleccionado
  //       e.target.parentElement.classList.add("active");
  //     }
  //   });
  // }

  //CONSTANTES
  
  const host = "http://localhost/CMMS/controllers/";
  let idusuario=0;

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
    const data = await getDatos(`${host}/usuarios.controller.php`, params);
    return data[0].id_usuario;
    //console.log(idusuario);
  }

  (async () => {
    const id = await getIdUser();
    const params = new URLSearchParams();
    params.append("operation", "listNotf");
    params.append("idusuario", id);
    params.append("idnotificacion", "");

    const data = await getDatos(`${host}notificacion.controller.php`, params);
    console.log("notify",data);
    if(data.length>0){
      const dataResp = await dataRespNof(data[0].idusuario);
      idusuario = await getIdUser();
      //console.log("resp", dataResp);
      const newArray = avoidRepeats(data);
      //const dataCombined = matchList(data, dataResp);
      //console.log("combined", dataCombined);
      //console.log(newArray);
      
      data.forEach((x, i) => {
        if(i<5){
          createNotificacion(
            x.idactivo_resp,
            x.mensaje,
            x.descripcion,
            x.fecha_creacion,
            x.desresp,
            1
          );
        }
        createNotificacion(
          x.idactivo_resp,
          x.mensaje,
          x.descripcion,
          x.fecha_creacion,
          x.desresp,
          2
        );
      });
    }
    showPreviewDetailt();
  })();

  /**
   * Combina dos arrays de objetos segun su posicion
   * @param {*} arr1 Primer array a combinar
   * @param {*} arr2 Segundo array a combinar
   * @returns Retorna la combinacion de los dos array de objetos
   */
  function matchList(arr1=[], arr2=[]){
    const combinar = arr1.map((x, i)=>{
      return {...x, ...arr2[i]}
    });
    return combinar
  }

  function avoidRepeats(list=[]){
    const idDuplicates = new Set();
    const newArray=[];
    list.forEach(x=>{
      if(!idDuplicates.has(x.idnotificacion)){
        newArray.push(x);
        idDuplicates.add(x.idnotificacion);
      }
    });
    console.log(newArray);
    return newArray;
    
  }

  /*
   * Muestra datos importantes de la notificacion
   */
  function showPreviewDetailt() {
    const notfs = document.querySelectorAll(".item-notifi");
    notfs.forEach(x=>{
      x.addEventListener("click", async (e) => {
        console.log("id",e.target.dataset.idresp);
        console.log("iduser", idusuario);
        
        const detail = await showDetail(e.target.dataset.idresp);
        console.log("detalle nof",detail);
        showModal(detail);
      });
    });
  }

  /**
   * devuelve datos de la asignacion
   * @param {*} iduser id del usuario
   * @returns Descripciones de su asignacion
   */
  async function dataRespNof(iduser) {
    const params = new URLSearchParams();
    params.append("operation", "dataRespNotf");
    params.append("idusuario", parseInt(iduser));

    const data = await getDatos(`${host}notificacion.controller.php`, params);
    return data;
  }

  /**
   * Muestra los detalles de la notificacion
   */
  async function showDetail(id) {
    const params = new URLSearchParams();
    params.append("operation", "detalleNotf");
    params.append("idusuario", idusuario);
    params.append("idactivo_resp", parseInt(id));
    //console.log(id);

    const data = await getDatos(`${host}notificacion.controller.php`, params);
    //console.log(data);
    return data;
  }

  /**
   * Muestra los datos en el Modal
   */
  function showModal(data) {
    selector("modal-body-notif").innerHTML = "";
    console.log("data modal", data);

    data.forEach((x) => {
      selector("modal-body-notif").innerHTML = `
                  <p>Activo Asignado: ${x.modelo} ${x.marca}</p>
                  <p>Descripcion de la asig.: ${x.modelo}</p>
                  <br>
                  <p>Activo Solicitado:</p>
                  <p>- Codigo: ${x.cod_identificacion}</p>
                  <p>- Descripcion: ${x.descripcion}</p>
                  <p>- Ubicacion: ${x.ubicacion}</p>
                  <p>- Condicion del Equipo: ${replaceWords(
                    x.condicion_equipo,
                    ["<p>", "</p>"],
                    ""
                  )}</p>
                  <p>- Fecha Asignacion : ${x.fecha_asignacion}</p>
                  <br>
              `;
    });

    const modalImg = new bootstrap.Modal(
      selector("modal-detalle-notificacion")
    );
    modalImg.show();
  }

  /**
   * Reemplaza una cadena
   * @param {*} word 'variable que contiene la cadena'
   * @param {*} rem 'array de elementos que quieres reemplazar'
   * @param {*} remTo 'palabra por la cual vas a reemplazar'
   * @returns
   */
  function replaceWords(word, rem = [], remTo) {
    let newWord = word;
    for (let i = 0; i < rem.length; i++) {
      //const rgx = new RegExp(rem[i], 'g');
      newWord = newWord.replace(rem[i], remTo);
    }
    return newWord;
  }

  function createNotificacion(id,mensaje, descripcion, fecha, descrip_asig, type) {
    let element = "";
    if(type===1){
      element = `
      <a href="#" class="list-group-item list-group-item-action border-bottom item-notifi" data-idresp=${id}>
          <div class="row align-items-center " style="pointer-events:none;">
            <div class="col ps-0 ms-2">
              <div class="d-flex justify-content-between align-items-center">
                <div>
                  <h4 class="h6 mb-0 text-small">${mensaje}</h4>
                </div>
                <div class="text-end">
                  <small class="text-danger">${fecha}</small>
                </div>
              </div>
              <p class="font-small mt-1 mb-0">
                ${descripcion}
              </p>
            </div>
          </div>
          </a>
        `;
      selector("list-notificaciones").innerHTML+=element;
    }else if(type===2){
      element = `
      <div class="card">
        <div class="card-body">
          <div class="row align-items-center">
            <div class="col ps-0 ms-2">
              <div class="d-flex justify-content-between align-items-center">
                <div>
                  <h4 class="h6 mb-0 text-small">${mensaje}</h4>
                </div>
                <div class="text-end">
                  <small class="text-danger">${fecha}</small>
                </div>
              </div>
              <p class="font-small mt-1 mb-0">
                ${descripcion}
              </p>
            </div>
          </div>
        </div>
      </div>
      `;

      selector("sb-list-notificacion").innerHTML+=element;
    }

  }

  function removeExtraBackdrops() {
    // Selecciona todas las capas de sombra (modal-backdrop y offcanvas-backdrop)
    const backdrops = document.querySelectorAll(
      ".modal-backdrop, .offcanvas-backdrop"
    );

    // Si hay más de una capa de sombra, eliminamos las duplicadas
    if (backdrops.length > 1) {
      backdrops.forEach((backdrop, index) => {
        if (index > 0) {
          backdrop.remove();
        }
      });
    }
  }
  $("#modal-update, #activo-baja-detalle").on(
    "shown.bs.modal shown.bs.offcanvas",
    function () {
      removeExtraBackdrops();
    }
  );

  //MOSTRAR NOTIFICACIONES EN EL SIDEBAR

  selector("show-all-notificaciones").addEventListener("click",()=>{


    const sidebar = selector("sb-notificacion");
    const offCanvas = new bootstrap.Offcanvas(sidebar);
    offCanvas.show();
  });

  
});
