document.addEventListener("DOMContentLoaded", () => {
  const host = "http://localhost/CMMS/controllers/";
  let myTable = null;
  function $selector(value) {
    return document.querySelector(`${value}`);
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
    const data = await getDatos(
      `${host}subcategoria.controller.php`,
      "operation=getSubCategoria"
    );
    //console.log(data);
    data.forEach((x) => {
      let element = createOption(x.idsubcategoria, x.subcategoria);
      $selector("#sb-subcategoria").appendChild(element);
      
    });
    data.forEach((x) => {
      let element = createOption(x.idsubcategoria, x.subcategoria);
      $selector("#subcategoria").appendChild(element);
    });
  })();

  $selector("#sb-subcategoria").addEventListener("change",async()=>{
    const id = $selector("#sb-subcategoria").value;
    await getMarcasSB(id);
  });

  async function getMarcasSB(id){
    const params = new URLSearchParams();
    params.append("operation", "getMarcasBySubcategoria");
    params.append("idsubcategoria", parseInt(id));
    const data = await getDatos(
      `${host}subcategoria.controller.php`,
      params
    );
    const elementsSelect = $selector("#sb-marca");
    for (let i = elementsSelect.childElementCount - 1; i > 0; i--) {
      elementsSelect.remove(i);
    }

    data.forEach((x) => {
      const option = createOption(x.idmarca, x.marca);
      elementsSelect.appendChild(option);
    });
  }


  (async () => {
    const params = new URLSearchParams();
    params.append("operation", "getAll");
    //params.append("idsubcategoria", id);
    const data = await getDatos(
      `${host}marca.controller.php`,
      "operation=getAll"
    );

    //console.log(data);

    data.forEach((x) => {
      const element = createOption(x.idmarca, x.marca);
      $selector("#marca").appendChild(element);
    });
  })();

  (async () => {
    const data = await getDatos(
      `${host}estado.controller.php`,
      "operation=getAllByActivo"
    );
    //console.log(data);
    data.forEach((x) => {
      const element = createOption(x.idestado, x.nom_estado);
      $selector("#estado").appendChild(element);
    });
  })();

  function getDate() {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, "0");
    const day = String(today.getDate()).padStart(2, "0");
    const formattedDate = `${year}-${month}-${day}`;
    //$("fecha").value = formattedDate;
    return formattedDate;
  }

  $selector("#fecha_adquisicion").addEventListener("change", () => {
    const valor = $selector("#fecha_adquisicion").value;
    console.log(valor);
  });

  (async () => {
    await showData();
  })();

  async function showData() {
    let data = [];
    $selector("#table-activos tbody").innerHTML = "";
    const params = new URLSearchParams();
    params.append("operation", "getAllFilters");
    params.append("idsubcategoria", $selector("#subcategoria").value);
    params.append("cod_identificacion", $selector("#cod_identificacion").value);
    params.append("fecha_adquisicion", $selector("#fecha_adquisicion").value);
    params.append(
      "fecha_adquisicion_fin",
      $selector("#fecha_adquisicion_fin").value
    );
    params.append("idestado", $selector("#estado").value);
    params.append("idmarca", $selector("#marca").value);

    data = await getDatos(`${host}activo.controller.php`, params);

    if (data.length === 0) {
      $selector("#table-activos tbody").innerHTML = `
      <tr>
        <td colspan="6">No encontrado</td>
      </tr>
      `;
    }
    data.forEach((x) => {
      let especificaciones = JSON.parse(x.especificaciones);
      $selector("#table-activos tbody").innerHTML += `
      <tr>
        <td>${x.idactivo}</td>
        <td>${x.subcategoria}</td>
        <td>${x.categoria}</td>
        <td>${x.marca}</td>
        <td>${x.modelo}</td>
        <td>${x.cod_identificacion}</td>
        <td>${x.fecha_adquisicion}</td>
        <td>${x.descripcion}</td>
        <td>${x.nom_estado}</td>
        <td><div class="field-espec ms-auto"></div></td>
        <td>
          ${
            x.nom_estado === "Fuera de Servicio"
              ? "Sin Acciones"
              : x.nom_estado === "Baja"
              ? `<button type="button" class="btn btn-sm btn-primary btn-baja" data-id=${x.idactivo}>Detalles</button>`
              : `<button type="button" class="btn btn-sm btn-primary modal-update" data-id=${x.idactivo}>update</button>
          `
          }
        </td>
      </tr>
      `;
      showEspecificaciones(especificaciones);
      especificaciones = "";
    });
    createTable(data);
    chargerEventsButton();
  }

  function chargerEventsButton() {
    document
      .querySelector(".table-responsive")
      .addEventListener("click", async (e) => {
        if (e.target) {
          if (e.target.classList.contains("modal-update")) {
            buttonsUpdate(e);
          } else if (e.target.classList.contains("btn-baja")) {
            await showDetalleBaja(e);
          }
        }
      });
  }

  function createTable(data) {
    let rows = $("#tb-body-activo").find("tr");
    //console.log(rows.length);
    if (data.length > 0) {
      if (myTable) {
        if (rows.length > 0) {
          myTable.clear().rows.add(rows).draw();
        } else if (rows.length === 1) {
          myTable.clear().draw(); // Limpia la tabla si no hay filas.
        }
      } else {
        // Inicializa DataTable si no ha sido inicializado antes
        myTable = $("#table-activos").DataTable({
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

  changeByFilters();
  function changeByFilters() {
    const filters = document.querySelectorAll(".filter");
    $selector("#table-activos tbody").innerHTML = "";
    filters.forEach((x) => {
      x.addEventListener("change", async () => {
        await showData();
      });
      if (x.id === "cod_identificacion") {
        x.addEventListener("keyup", async () => {
          await showData();
        });
      }
    });
  }

  function showEspecificaciones(data = {}) {
    let contain = document.createElement("ul");

    Object.entries(data).forEach(([key, value]) => {
      const element = document.createElement("li");
      element.innerHTML = `<strong>${key}</strong>: ${value}`;
      contain.appendChild(element);
    });

    const fields = document.querySelectorAll(".field-espec");
    fields.forEach((x) => {
      x.appendChild(contain);
    });
  }

  function buttonsUpdate(e) {
    const id = e.target.getAttribute("data-id");
    localStorage.setItem("id", id);

    const modalImg = new bootstrap.Modal($selector("#modal-update"));
    modalImg.show();
  }

  async function showDetalleBaja(e) {
    const id = parseInt(e.target.getAttribute("data-id"));
    console.log(id);

    const desc = await getDescripcion(id);
    $selector("#desc").textContent = desc;

    const dataBaja = await dataActivoBaja(id);

    await showDataBajaActivo(dataBaja);
    showPDF(dataBaja.ruta_doc);

    const sidebar = $selector("#activo-baja-detalle");
    const offCanvas = new bootstrap.Offcanvas(sidebar);

    offCanvas.show();
  }

  async function dataActivoBaja(idactivo) {
    const params = new URLSearchParams();
    params.append("operation", "dataBajaActivo");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${host}bajaActivo.controller.php`, params);
    console.log(data);
    return data[0];
  }

  async function showDataBajaActivo(data) {
    //console.log(data);

    const aprobacion = await getUser(data.aprobacion);

    $selector(
      "#fecha-baja"
    ).innerHTML = `<strong>Fecha de Baja: </strong>${data.fecha_baja}`;
    $selector(
      "#aprobacion"
    ).innerHTML = `<strong>Aprobado por: </strong>${aprobacion.dato} (${aprobacion.usuario})`;
    $selector("#motivo").textContent = data.motivo;
    $selector("#comentario").textContent =
      data.coment_adicionales == null
        ? "Sin ningun comentario"
        : data.coment_adicionales;
  }

  function showPDF(route) {
    let cont = 0;
    let index = 0;
    for (let i = 0; i < route.length; i++) {
      if (route[i] === "/") {
        cont++;
      }
      if (cont === 3) {
        index = i;
        break;
      }
    }
    const newRoute = `http://localhost${route.slice(index, route.length)}`;
    console.log(newRoute);

    $selector("#view-pdf-baja").href = newRoute;
    cont = 0;
    index = 0;
  }

  // $selector("#view-pdf-baja").addEventListener("click",(e)=>{
  //   e.preventDefault();
  //   const sidebar = bootstrap.Offcanvas.getOrCreateInstance(
  //     $selector("#activo-baja-detalle")
  //   );
  //   sidebar.hide();

  // });

  async function getUser(iduser) {
    const params = new URLSearchParams();
    params.append("operation", "getUserById");
    params.append("idusuario", iduser);

    const data = await getDatos(`${host}usuarios.controller.php`, params);

    return data[0];
  }

  async function getDescripcion(idactivo) {
    const params = new URLSearchParams();
    params.append("operation", "getById");
    params.append("idactivo", idactivo);
    const data = await getDatos(`${host}activo.controller.php`, params);

    return data[0].descripcion;
  }

  $selector("#sb-modelo").addEventListener("keyup",()=>{
    let valorModelo = $selector("#sb-modelo").value;
    if(valorModelo.trim().length>3){
      $selector("#registerAceptar").disabled = false;
    }else{
      $selector("#registerAceptar").disabled = true;
    }
  });

  //Datos a enviar a la vista registrar (cantidad de activos a registrar)
  $selector("#toRegistrar").addEventListener("click",()=>{
    const sidebar = $selector("#sbRegistrar");
    const offCanvas = new bootstrap.Offcanvas(sidebar);
    offCanvas.show();
    $selector("#sb-fecha").value = getDate();
  });

  $selector("#registerAceptar").addEventListener("click",()=>{
    const value = parseInt($selector("#cantidadEnviar").value);
    const valueSbFecha = $selector("#sb-fecha").value;

    if(value>0 && (valueSbFecha<=getDate())){
      localStorage.setItem("cantidad", value);
      localStorage.setItem("subcategoria", $selector("#sb-subcategoria").value);
      localStorage.setItem("marca", $selector("#sb-marca").value);
      localStorage.setItem("modelo", $selector("#sb-modelo").value);
      localStorage.setItem("fechaDefault", $selector("#sb-fecha").value);
      $selector("#cantidadEnviar").value = 0;
      $selector("#sb-subcategoria").value = "";
      $selector("#sb-marca").value = "";
      $selector("#sb-modelo").value = "";
      $selector("#sb-fecha").value = "";
      window.location.href = "http://localhost/CMMS/views/activo/register-activo";
      
    }else{
      if(value<0){
        alert("Debes registrar al menos 1");
      }
      if(valueSbFecha>getDate()){
        alert("La fecha no debe ser mayor a la actual");
      }
    }
  });

});
