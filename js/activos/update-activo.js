document.addEventListener("DOMContentLoaded", () => {
  const host = "http://localhost/CMMS/controllers/";
  let contEspecificaciones = 2;
  let valores = [];
  let cap = "";
  let isnoEmpty = false;
  let validateEspec = true;

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

  function getDate() {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, "0");
    const day = String(today.getDate()).padStart(2, "0");
    const formattedDate = `${year}-${month}-${day}`;
    //selector("fecha").value = formattedDate;
    return formattedDate;
  }

  (async () => {
    const data = await getDatos(
      `${host}subcategoria.controller.php`,
      "operation=getSubCategoria"
    );
    //console.log(data);
    data.forEach((x) => {
      const element = createOption(x.idsubcategoria, x.subcategoria);
      selector("subcategoria").appendChild(element);
    });
  })();

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
      selector("marca").appendChild(element);
    });
  })();

  (async () => {
    const id = localStorage.getItem("id");
    const params = new URLSearchParams();
    params.append("operation", "searchByUpdate");
    params.append("idactivo", id);

    const data = await getDatos(`${host}activo.controller.php`, params);
    console.log(data);

    selector("subcategoria").value = data[0].idsubcategoria;
    selector("marca").value = data[0].idmarca;
    selector("modelo").value = data[0].modelo;
    selector("cod_identificacion").value = data[0].cod_identificacion;
    selector("fecha_adquisicion").value = data[0].fecha_adquisicion;
    selector("descripcion").value = data[0].descripcion;
    //console.log(JSON.parse(data[0].especificaciones));
    
    renderEspecificaciones(data[0].especificaciones);
  })();

  function renderEspecificaciones(obj) {
    //console.log("param1",JSON.parse(obj));
    const dataJson = JSON.parse(obj);
    if (Object.values(dataJson).length > 1) {
      getEspecificaciones(dataJson);
    }
    else if (Object.values(dataJson).length === 1) {
      showEspec(dataJson);
    }
  }

  function getEspecificaciones(data) {
    const listEs = selector("list-es");
    //console.log("param", data);
  
    const prop = Object.keys(data)[0];
    showEspec({ [prop]: data[prop] });
    //console.log({ [prop]: data[prop] });
    delete data[prop]; //Elimina la primera propiedad del objeto
    //console.log(data);

    for (let i in data) {
      const newDiv = document.createElement("div");
      newDiv.classList.add("row");

      newDiv.setAttribute("id", `espec-${contEspecificaciones}`);
      newDiv.classList.add("mt-3");
      newDiv.innerHTML = renderElements(i, data[i]);
      listEs.appendChild(newDiv);
      contEspecificaciones++;

      newDiv.querySelector(".btnRemove").addEventListener("click", () => {
        listEs.removeChild(newDiv);
        contEspecificaciones--;
        checkButtonAdd();
      });
    }
  }

  function createEspec() {
    const listEs = selector("list-es");
    const newDiv = document.createElement("div");
    newDiv.classList.add("row");

    newDiv.setAttribute("id", `espec-${contEspecificaciones}`);
    newDiv.classList.add("mt-3");
    if(contEspecificaciones<5){
      newDiv.innerHTML = renderElements();
    }else{
      newDiv.innerHTML = lastEspecificacion();
    }
    listEs.appendChild(newDiv);
    contEspecificaciones++;

    newDiv.querySelector(".btnRemove").addEventListener("click", () => {
      listEs.removeChild(newDiv);
      contEspecificaciones--;
      checkButtonAdd(contEspecificaciones);
    });
  }

  function allSelector(value){
    return document.querySelectorAll(`.${value}`);
  }

  function checkButtonAdd(cont=0) {
    const maxEspecificaciones = 4;
    const btnAdd = document.querySelectorAll(".btnAdd");
    const currentCount = document.querySelectorAll(".btnAdd").length;
    
    const maxInputs = 10;
    const inputsEspec = allSelector("dataEs");
    const countInputs = allSelector("dataEs").length;

    if(cont>2){
      const maxBtnRemove = 4;
      const btnRemove = allSelector("btnRemove");
      const countRemove = allSelector("btnRemove").length;
  
      if(countRemove<maxBtnRemove){
        btnRemove[countRemove-1].disabled = false;
      }
    }

    if (currentCount < maxEspecificaciones) {
      btnAdd[currentCount - 1].disabled = false; // Habilitamos el botón si el conteo es menor al máximo
    }

    if(countInputs<maxInputs){
      inputsEspec[countInputs-1].disabled=false;
      inputsEspec[countInputs-2].disabled=false;
    }
  }

  function disabledEspec(){
    const btnRemove = document.querySelectorAll(".btnRemove");
    const inputsEspec = document.querySelectorAll(".dataEs");

    btnRemove.forEach(x=>{
      x.disabled=true;
    });
    inputsEspec.forEach(x=>{
      x.disabled = true;
    })
  }
  selector("list-es").addEventListener("click", (e) => {
    if (e.target.classList.contains("btnAdd")) {
      const allDataEs = document.querySelectorAll(".btnAdd");
      catchData();

      if (isnoEmpty) {
        for (let i = 0; i <= allDataEs.length - 1; i++) {
          allDataEs[i].disabled = true;
          disabledEspec();
        }
        if (allDataEs.length < 5) {
          createEspec();
        } else {
          alert("Limite de 5");
        }
      }else{
        alert("Completa los campos");
      }
    }
  });


  function catchData() {
    document.querySelectorAll(".dataEs").forEach((input, i) => {
      let valor = input.value;
      if (i % 2 !== 0 && i !== 0) {
        let isRepeat = valores.some((obj) => obj.hasOwnProperty(cap));
        //console.log(cap);
        isnoEmpty = valor != "" && cap != "";
        if (!isnoEmpty) {
          //alert("Completa los campos");
          validateEspec = false;
        }

        if (!isRepeat && isnoEmpty) {
          valores.push({
            [cap]: valor,
          });
        }
      }
      cap = valor;
    });
  }

  function showEspec(data) {
    let cont = 1;
    //console.log(data);
    
    const inputEspec = document.querySelectorAll(".dataEs");
    for (i in data) {
      inputEspec.forEach((x) => {
        if (cont % 2 !== 0) {
          x.value = i;
          console.log(i);
          
        }
        if (cont % 2 === 0) {
          x.value = data[i];
          console.log(data[i]);
        }
        cont++;
      });
    }
    cont=1;
  }

  selector("form-update").addEventListener("submit", async (e) => {
    e.preventDefault();
    catchData();
    //console.log(valores);
    
    if(confirm("¿Estas seguro de actualizar los datos?")){
  
      const especData = valores.reduce((acum, objeto) => {
        const clave = String(Object.keys(objeto)[0]);
        acum[clave] = objeto[clave];
        return acum;
      }, {});
      const params = new FormData();
      params.append("operation", "updateActivo");
      params.append("idactivo", localStorage.getItem("id"));
      params.append("idsubcategoria", selector("subcategoria").value.trim());
      params.append("idmarca", selector("marca").value.trim());
      params.append("modelo", selector("modelo").value.trim());
      params.append("cod_identificacion", selector("cod_identificacion").value.trim());
      params.append("fecha_adquisicion", selector("fecha_adquisicion").value.trim());
      params.append("descripcion", selector("descripcion").value.trim());
      params.append("especificaciones", JSON.stringify(especData));
  
      const data = await fetch(`${host}activo.controller.php`, {
        method: "POST",
        body: params,
      });
  
      const resp = await data.json();
      console.log("respuesta: ", resp);
  
      if (resp.respuesta > 0) {
        alert("Registro actualizado");
        resetUI();
        localStorage.removeItem('id');
        window.location.href="http://localhost/CMMS/views/activo/";
      } else {
        alert("Hubo un error en la actualizacion de datos");
      }
    }
  });

  /**
   *
   * @param {*} prop Clave de la especificacion
   * @param {*} clave Valor de la especificacion
   * @returns una renderizacion al div dataEs
   */
  function renderElements(prop = null, clave = null) {
    return `
    <div class="col-6">
      <div class="form-floating">
        <input type="text" class="form-control w-75 dataEs" required value=${
          prop == null ? "" : prop
        }>
        <label for="">Especificacion ${contEspecificaciones}</label>
      </div>
    </div>
    <div class="col-6">
      <div class="form-floating h-75">
        <input type="text" class="form-control w-75 dataEs" required value=${
          clave == null ? "" : clave
        }>
        <label for="">Valor</label>
      </div>
    </div> 
    <div class="col-3 mt-2">
      <button type="button" class="btn btn-sm btn-primary  btnAdd">AGREGAR</button>
    </div>       
    <div class="col-3 mt-2">
      <button type="button" class="btn btn-sm btn-danger btnRemove">ELIMINAR</button>
    </div>    
    `;
  }

  function lastEspecificacion(){
    return `
    <div class="col-6">
      <div class="form-floating">
        <input type="text" class="form-control w-75 dataEs" required>
        <label for="">Especificacion ${contEspecificaciones}</label>
      </div>
    </div>
    <div class="col-6">
      <div class="form-floating h-75">
        <input type="text" class="form-control w-75 dataEs" required>
        <label for="">Valor</label>
      </div>
    </div> 
    <div class="col-3 mt-2">
      <button type="button" class="btn btn-sm btn-danger btnRemove">ELIMINAR</button>
    </div> 
  `;
  }

  function resetUI() {
    selector("subcategoria").value = "";
    selector("marca").value = "";
    selector("modelo").value = "";
    selector("cod_identificacion").value = "";
    selector("fecha_adquisicion").value = getDate();
    selector("descripcion").value = "";

    valores = [];
    contEspecificaciones = 2;
    const listEs = selector("list-es");

    listEs.innerHTML = `
        <div class="row">
          <div class="col-md-6">
            <div class="form-floating">
             <input type="text" class="form-control w-75 dataEs" required>
              <label for="">Especificacion 1</label>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-floating h-75">
              <input type="text" class="form-control w-75 dataEs" required>
              <label for="">Valor</label>
            </div>
          </div>
          <div class="col-md-2 mt-2">
            <button class="btn btn-sm btn-primary btnAdd" type="button">AGREGAR</button>
          </div>
        </div>
    `;

  }
});
