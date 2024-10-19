document.addEventListener("DOMContentLoaded", () => {
  //CONSTANTES
  const host = "http://localhost/CMMS/controllers/";

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
    console.log(id);

    const data = await getDatos(`${host}notificacion.controller.php`, params);
    console.log(data);

    
    //Mostrar las notificaciones en la lista
    data.forEach((x) => {
      // selector("list-notificaciones").innerHTML += `
      //           <li class="element-notificacion">
      //               <div class="dropdown-item w-100" data-idsoli=${
      //                 x.idnotificacion
      //               }>
      //                   <p>${x.mensaje}</p>
      //                   <p>${x.descripcion}</p>
      //                   <p>Fecha: ${x.fecha_creacion}</p>
      //                   <p>Descripcion Asig: ${replaceWords(
      //                     x.desresp,
      //                     ["<p>", "</p>"],
      //                     ""
      //                   )}</p>
      //               </div>
      //           </li>
      //           <br>
      //       `;
      createNotificacion(x.mensaje, x.descripcion, x.fecha_creacion, x.desresp);
    });
    showPreviewDetailt();
  })();

  /*
   * Muestra datos importantes de la notificacion
   */
  function showPreviewDetailt() {
    selector("list-notificaciones").addEventListener("click", async (e) => {
      const detail = await showDetail(e.target.dataset.idsoli);
      showModal(detail);
    });
  }

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
    params.append("idnotificacion", id);
    console.log(id);

    const data = await getDatos(`${host}notificacion.controller.php`, params);
    //console.log(data);
    return data;
  }

  /**
   * Muestra los datos en el Modal
   */
  function showModal(data) {
    console.log(data);

    selector("modal-body-notif").innerHTML = "";
    data.forEach((x) => {
      selector("modal-body-notif").innerHTML = `
                <p>Fecha de Creacion: ${x.fecha_creacion}</p>
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

  function createNotificacion(mensaje, descripcion, fecha, descrip_asig) {
    const element=`
    <a href="#" class="list-group-item list-group-item-action border-bottom">
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
    </a>
    `;

    selector("list-notificaciones").appendChild(element);
  }
});
