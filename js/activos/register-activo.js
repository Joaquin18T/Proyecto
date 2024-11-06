document.addEventListener("DOMContentLoaded",()=>{
  const globals={
    datosActivos:[], //Almacena todos los datos de los activos a registrar
    fields:["subcategoria", "marca", "modelo", "fecha", "descripcion"], // Campos que tiene la tabla
    objTemporal:{}, //Objeto temporal para el almacenamientos de datos de los activos
    host: "http://localhost/CMMS/controllers/",
    variableActivos:[],
    cantidadRegistrar:localStorage.getItem("cantidad"),
    list_codes:[],
    contCodeInputs:0,
    contSave:0
  };
  (()=>{
    renderRegisters();
    if(parseInt(globals.cantidadRegistrar)===1){
      //console.log(globals.cantidadRegistrar);
      const btnDeleteB = allSelector("delete-block-activo");
      btnDeleteB.forEach(x=>{x.disabled=true;});

      const btnDeleteSB = allSelector("delete-input");
      btnDeleteSB.forEach(x=>{x.disabled=true;});
    }
  })();

  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  function allSelector(value){
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

  //Obtener fecha actual
  function getDate() {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, "0");
    const day = String(today.getDate()).padStart(2, "0");
    const formattedDate = `${year}-${month}-${day}`;
    //selector("fecha").value = formattedDate;
    return formattedDate;
  }

  (() => {
    const fieldsFecha = allSelector("fecha");
    fieldsFecha.forEach(x=>{
      x.value = getDate();
    });
  })();
  //fecha actual

  //SUBCATEGORIAS
  (async () => {
    const data = await getDatos(
      `${globals.host}subcategoria.controller.php`,
      "operation=getSubCategoria"
    );
    //console.log(data);
    const allCategorias = allSelector("subcategoria");
    data.forEach(x=>{
      chargerData(allCategorias, x.idsubcategoria, x.subcategoria);
    });
    await selectSubCategoria();
  })();

  //Funcion a cargar las opciones en todos los select
  function chargerData(list=[], valor, texto){
    list.forEach(x=>{
      const element = createOption(valor, texto);
      x.appendChild(element);
    });
  }
  //FIN MARCAS

  //MARCAS
  async function selectSubCategoria(){
    const AllSubcategorias = allSelector("subcategoria");
    AllSubcategorias.forEach((x,i)=>{
      x.addEventListener("change",()=>{
        const elements = document.getElementsByClassName(`activo-${i+1}`);
        const id = x.value;
        renderDataMarcas(elements[1], parseInt(id));
      });
    });
    await dataByDefault();
  }

  //Renderiza las opciones en el select categoria segun el numero del activo
  async function renderDataMarcas(element, id){
    const params = new URLSearchParams();
    params.append("operation", "getMarcasBySubcategoria");
    params.append("idsubcategoria", parseInt(id));
    const data = await getDatos(
      `${globals.host}subcategoria.controller.php`,
      params
    );

    for (let i = element.options.length - 1; i > 0; i--) {
      element.remove(i);
    }

    data.forEach((x) => {
      const option = createOption(x.idmarca, x.marca);
      element.appendChild(option);
    });

  }
  //FIN MARCAS

  //Funcion que renderiza dinamicamente la cantidad de activos a registrar
  function renderRegisters(){
    const listRegisters = selector("list-register-activos");
    //const cantidadRegistrar = localStorage.getItem("cantidad");

    for (let i = 0; i < globals.cantidadRegistrar; i++) {
      listRegisters.innerHTML+=elementToPaint(i);
      //Variables/propiedades que usaran en el registro de cada activo
      const utilities = {
        contEspecificaciones:1,
        contEspec:1,
        isnoEmpty:false,
        valores:[],
        cap:"",
        valorEspec:"",
        contCol:0,
        isDuplicate:false,
        clickRemove:false
      };
      globals.variableActivos.push(utilities);
    }
    //console.log("variable por activos", globals.variableActivos);
    verifierAllAddEspec();
    addInputsCode(globals.cantidadRegistrar);
    btnDeleteBlock();

  }

  selector("showSB").addEventListener("click",()=>{
    const sidebar = selector("sb-code");
    const offCanvas = new bootstrap.Offcanvas(sidebar);
    offCanvas.show();
  });

  //CODIGO DE IDENTIFICACION EN EL SIDEBAR
  //Obtiene todos los inputs del sidebar y lo retorna en un array
  function getInputCodes(){
    const data = document.querySelectorAll(".element-cod");
    return [...data];
  }

  function createElementHTML(name_element){
    return document.createElement(name_element);
  }

  //Crea los inputs de cod_identificados segun la cantidad de activos a registrar
  function addInputsCode(cantidad){
    let cont=0;
    for (globals.contCodeInputs; globals.contCodeInputs < cantidad; globals.contCodeInputs++) {
      const container = selector("container-code");
      const div = createElementHTML("div");
      div.classList.add("mb-2", "mt-4", "contain-input-code", `block-${cont+1}`);

      const label = createElementHTML("label");
      label.classList.add("form-label", "text-cont");
      label.textContent = `Codigo del activo Nº. ${globals.contCodeInputs+1}`;

      const input = createElementHTML("input");
      input.setAttribute('maxlength', '15');
      input.classList.add("form-control", "w-50", "element-cod");
      
      const button = createElementHTML("button");
      button.classList.add("btn", "btn-sm", "btn-danger", "delete-input","w-25");
      button.textContent="Delete";

      const divGroup = createElementHTML("div");
      divGroup.classList.add("input-group", 'input-code');

      divGroup.appendChild(input);
      divGroup.appendChild(button);

      div.appendChild(label);
      div.appendChild(divGroup);

      deleteInputCode(div);

      container.appendChild(div);
      cont++;
    }
    cont=0;
    cantidad=0;
  }

  function deleteInputCode(div){
    div.querySelector(".delete-input").addEventListener("click",(e)=>{
      //Proceso de eliminar el bloque 
      globals.cantidadRegistrar -=1;
      
      const parent = e.target.parentNode;

      const listC = div.classList;
      console.log(listC[3]);
      
      const listRegisters = selector("list-register-activos").children;
      for (let i = 0; i < listRegisters.length; i++) {
        if(listRegisters[i].classList[2]===listC[3]){
          const parent = selector("list-register-activos");
          parent.removeChild(listRegisters[i]);
          //console.log(listRegisters[i]);
          
        }
      }
      console.log(selector("list-register-activos"));
      
      //Obtiene el valor del input
      //const input = e.target.closest('.input-group').querySelector('input');

      //Proceso de eliminar el campo cod_identificacion
      list_codes = [];

      const grandParent = parent.parentNode;

      const container = selector("container-code");
      container.removeChild(grandParent);
      globals.contCodeInputs-=1;

      const textLabels = document.querySelectorAll(".text-cont");
      for (let i = 0; i < getInputCodes().length; i++) {
        textLabels[i].textContent = `Codigo del activo Nº. ${i+1}`;
      }

      const btnDeleteSB = allSelector("delete-input");
      if(btnDeleteSB.length===1){
        btnDeleteSB.forEach(x=>{
          x.disabled = true;
        });

        const btnDeleteB = allSelector("delete-block-activo");
        btnDeleteB.forEach(x=>{x.disabled=true;});
      }
    });
  }

  //Guarda los valores del sidebar en una lista
  function getAllCodesSB(){
    const inputsCode = getInputCodes();
    inputsCode.forEach(x=>{
      //console.log(x.value);
      globals.list_codes.push(x.value);
    });
    console.log("Codes",globals.list_codes);
  }

  //Busca en la DB si se repite el codigo 
  async function searchCode(code) {
    const params = new URLSearchParams();
    params.append("operation", "repeatCode");
    params.append("cod_identificacion", code);
    const data = await getDatos(
      "http://localhost/CMMS/controllers/activo.controller.php",
      params
    );
    return data;
  }

  async function validateAllCodes(){
    let cont =0;
    let cap ="";
    const inputsCode = getInputCodes();
    for (let i = 0; i < inputsCode.length; i++) {
      const data = await searchCode(inputsCode[i].value);

      if(data.length===0 && (cap!==inputsCode[i].value)){
        cont++;
        cap = inputsCode[i].value;
      }
    }
    cap="";

    return (cont ===inputsCode.length);
  }

  //./CODIGO DE IDENTIFICACION EN EL SIDEBAR

  //Captura los datos de los campos en formato JSON (Sin las especificaciones)
  function getAllDatosActivo(field, cantidad){
    let listClass = field.classList;//Captura todas las clases del input
    listClass = [...listClass]; //Las clases lo almacenan en un array

    const isSame = globals.fields.filter(x=>listClass.includes(x));
    if(isSame.length>0){
      //console.log("obj temporal", Object.values(globals.objTemporal).length);
      if(Object.values(globals.objTemporal).length<cantidad){
        //console.log(isSame);
        globals.objTemporal[isSame[0]] = field.value;
      }
      if(Object.values(globals.objTemporal).length===cantidad){
        globals.datosActivos.push(globals.objTemporal);
        globals.objTemporal={};
        //globals.objTemporal[isSame[0]] = field.value;
      }
    }
  }

  //Funcion que retorna el HTML del registro de un activo
  function elementToPaint(i){
    return `
  <div class="row mt-2 block-${i+1}">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header d-flex justify-content-between m-0">
        <p class="m-0">Datos del Activo Nº ${i+1}</p>
        <button class="btn btn-sm btn-danger delete-block-activo">Eliminar</button>
      </div>
      <div class="card-body">
        <!-- DATA ACTIVO -->
        <div class="card">
          <div class="card-body">
            <div class="row">
              <div class="col-md-3">
                <label for="subcategoria">SubCategorias</label>
                <select id="subcategoria" class="form-control w-75 subcategoria activo-${i+1}" required autofocus>
                  <option value="">Selecciona</option>
                </select>
              </div>
              <div class="col-md-3">
                <label for="marca">Marca</label>
                <select name="marcas" id="marca" class="form-control w-75 marca activo-${i+1}" style="max-height: 50px; overflow-y: auto;" required>
                  <option value="">Selecciona</option>
                </select>
              </div>
              <div class="col-md-3">
                <label for="modelo">Modelo</label>
                <input type="text" class="form-control w-75 modelo activo-${i+1}" placeholder="Modelo" id="modelo" minlength="3" required>
              </div>
              <div class="col-md-3">
                <label for="fecha">Fecha Adquisicion</label>
                <input type="date" class="form-control w-75 fecha activo-${i+1}" id="fecha" required>
              </div>
            </div>
            <div class="row mt-3">
              <div class="col-6 h-25">
                <label for="descripcion">Descripcion</label>
                <input type="text" class="form-control descripcion activo-${i+1}" style="width: 88%;" id="descripcion">
              </div>
            </div>
          </div>
        </div>
        <!-- ./DATA ACTIVO -->
        <!-- Especificaciones -->
        <div class="card mt-2">
          <div class="card-header m-0">Especificaciones</div>
          <div class="card-body">
            <div class="list-es">
              <div class="row activo-col-espec-${i+1}">
                <div class="col-md-6 activo-row-espec-${i+1}">
                  <div class="row">
                    <div class="col-md-5">
                      <label>Especificacion 1</label>
                      <input type="text" class="form-control dataEs activo-espec-${i+1}" required>
                    </div>
                    <div class="col-md-5">
                      <label>Valor</label>
                      <input type="text" class="form-control dataEs activo-espec-${i+1}" required>
                    </div>
                    <div class="row">
                      <div class="col-4 mt-2">
                        <button class="btn btn-sm btn-primary btnAdd activo-btnAdd-${i+1}" type="button">AGREGAR</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- ./Especificaciones -->
        </div>
      </div>
    </div>
  </div>`;
  }

  function btnDeleteBlock(){
    const btnDeleteB = allSelector("delete-block-activo"); //referencia al boton de eliminar un bloque de registro
    btnDeleteB.forEach((x,i)=>{
      x.addEventListener("click",()=>{
        deleteBlockRegistrar(i+1);
      });
    });
    

  }

  function deleteBlockRegistrar(index){
    const listRegisters = selector("list-register-activos");
    const nameClass = `block-${index}`
    const btnDeleteSB = selector("container-code");    
    let elementClass = "";
    //console.log(nameClass);
    
    for (let i = 0; i < listRegisters.childElementCount; i++) {
      if(nameClass===listRegisters.children[i].classList[2]){
        elementClass = listRegisters.children[i].classList[2];
      }
    }
    for (let i = 0; i < btnDeleteSB.childElementCount; i++) {
      if(elementClass===btnDeleteSB.children[i].classList[3]){
        const parent = selector("list-register-activos");
        parent.removeChild(parent.children[i]);

        //Eliminar el input del SB correspondiente
        btnDeleteSB.removeChild(btnDeleteSB.children[i]);  
        list_codes = [];
        globals.contCodeInputs-=1;
  
        const textLabels = document.querySelectorAll(".text-cont");
        for (let i = 0; i < getInputCodes().length; i++) {
          textLabels[i].textContent = `Codigo del activo Nº. ${i+1}`;
        }
  
        const btnDeleteInputSB = allSelector("delete-input");
        if(btnDeleteInputSB.length===1){
          btnDeleteInputSB.forEach(x=>{
            x.disabled = true;
          });
        }
      }
    }
    const btnDeleteB = allSelector("delete-block-activo");
    if(btnDeleteB.length===1){
      btnDeleteB.forEach(x=>{x.disabled=true});
    }
    
  }

  //AGREGAR Y ELIMINAR ESPECIFICACIONES

  //Funcion que crea una nueva columna de especificaciones
  function createNewColumn(i){
    if(globals.variableActivos[i].contCol===0){
      const column = document.createElement("div");
      const colEspec = document.querySelector(`.activo-col-espec-${i+1}`);
      column.classList.add("col-md-6");
      //console.log("col espec", i);
  
      const row = document.createElement("div");
      row.classList.add("row", `activo-row-espec-${i+1}`);
  
      column.appendChild(row);
      
      colEspec.appendChild(column);
    }
    globals.variableActivos[i].contCol++;
  }

  //Pinta una  nueva fila de especificaciones
  function getEspecificaciones(num_col, i, type=1, clave="", valor="", cont=0, isDisabled=false) {
    const rowEs = allSelector(`activo-row-espec-${i+1}`);
    const listEs = rowEs[num_col];
    const newDiv = document.createElement("div");
    //newDiv.classList.add("col-md-12");
    newDiv.setAttribute("id", `espec-${globals.variableActivos[i].contEspecificaciones}`);
    newDiv.classList.add("mt-3");

    if(type===1){
      if (globals.variableActivos[i].contEspecificaciones <5) {
        newDiv.innerHTML = `
            <div class="row">
              <div class="col-md-5">
                <label for="">Especificacion ${globals.variableActivos[i].contEspecificaciones}</label>
                <input type="text" class="form-control dataEs activo-espec-${i+1}">
              </div>
              <div class="col-md-5">
                <label for="">Valor</label>
                <input type="text" class="form-control dataEs activo-espec-${i+1}">
              </div> 
              <div class="row">
                <div class="col-3 mt-2">
                  <button type="button" class="btn btn-sm btn-primary  btnAdd activo-btnAdd-${i+1}">AGREGAR</button>
                </div>       
                <div class="col-3 mt-2">
                  <button type="button" class="btn btn-sm btn-danger btnRemove activo-btnRemove-${i+1}">ELIMINAR</button>
                </div> 
              </div>          
            </div>
          `;
      } else{
        newDiv.innerHTML = `
          <div class="row">
            <div class="col-md-5">
              <label for="">Especificacion ${globals.variableActivos[i].contEspecificaciones}</label>
              <input type="text" class="form-control dataEs activo-espec-${i+1}">
            </div>
            <div class="col-md-5">
              <label for="">Valor</label>
              <input type="text" class="form-control dataEs activo-espec-${i+1}">
            </div> 
            <div class="row">
              <div class="col-3 mt-2">
                <button type="button" class="btn btn-sm btn-danger btnRemove activo-btnRemove-${i+1}">ELIMINAR</button>
              </div> 
            </div>
          </div>
        `;
      }
    }
    if(type===2){
      newDiv.innerHTML =`
      <div class="row">
        <div class="col-md-5">
          <label for="">Especificacion ${globals.variableActivos[i].contEspecificaciones}</label>
          <input type="text" class="form-control dataEs activo-espec-${i+1}" value=${clave} ${isDisabled?`disabled`:""}>
        </div>
        <div class="col-md-5">
          <label for="">Valor</label>
          <input type="text" class="form-control dataEs activo-espec-${i+1}" value=${valor} ${isDisabled?`disabled`:""}>
        </div> 
        <div class="row">
          <div class="col-3 mt-2">
            <button type="button" class="btn btn-sm btn-primary  btnAdd activo-btnAdd-${i+1}" ${isDisabled?`disabled`:""}>AGREGAR</button>
          </div>  
          ${cont!==0?`
            <div class="col-3 mt-2">
            <button type="button" class="btn btn-sm btn-danger btnRemove activo-btnRemove-${i+1}" ${isDisabled?`disabled`:""}>ELIMINAR</button>
            </div>`:""}     

        </div>          
      </div>
      `;
    }
    listEs.appendChild(newDiv);
    globals.variableActivos[i].contEspecificaciones++;
    //console.log(cont);
    
    if(cont>0){
      newDiv.querySelector(`.activo-btnRemove-${i+1}`).addEventListener("click", () => {
  
        globals.variableActivos[i].clickRemove = true;
        const lastInput = allSelector(`activo-espec-${i+1}`);
        let lastValue = lastInput[lastInput.length - 1].value;
        console.log(globals.variableActivos[i].contEspec);
  
        if (lastValue !== "") {
  
          console.log(globals.variableActivos[i].contEspec);
  
          let test = globals.variableActivos[i].valores.hasOwnProperty(globals.variableActivos[i].contEspec - 1);
  
          if (test) {
            globals.variableActivos[i].valores.splice(globals.variableActivos[i].contEspec - 1, 1);
            console.log(globals.variableActivos[i].valores);
          }
        }
        globals.variableActivos[i].contEspec--;
  
        listEs.removeChild(newDiv);
        globals.variableActivos[i].contEspecificaciones--;
        checkButtonAdd(globals.variableActivos[i].contEspecificaciones, i);
      });

    }
    cont++;
  }

  //Valida acciones antes de agregar una nueva fila de especificaciones
  //deshabilita los campos y botones de la fila anterior
  function checkButtonAdd(cont, i) {
    const maxEspecificaciones = 4;
    const btnAdd = allSelector(`activo-btnAdd-${i+1}`);
    const currentCount = allSelector(`activo-btnAdd-${i+1}`).length;

    const maxInputs = 10;
    const inputEs = allSelector(`activo-espec-${i+1}`);
    const currentinputEs = allSelector(`activo-espec-${i+1}`).length;

    if(cont>2){
      const maxBtnRemove = 4;
      const btnRemove = allSelector(`activo-btnRemove-${i+1}`);
      const countBtnRemove = allSelector(`activo-btnRemove-${i+1}`).length;
  
      if (countBtnRemove<maxBtnRemove) {
        btnRemove[countBtnRemove - 1].disabled = false;
      }
      console.log(countBtnRemove);
      
    }
    //console.log(cont);
    
    if (currentCount <= maxEspecificaciones) {
      btnAdd[currentCount - 1].disabled = false; // Habilitamos el botón si el conteo es menor al máximo
    }
    console.log("botones add actuales", currentCount);
    
    if (currentinputEs < maxInputs) {
      inputEs[currentinputEs - 2].disabled = false;
      inputEs[currentinputEs - 1].disabled = false;
    }

  }

  //Deshabilita una fila de especificaciones
  function disabledFieldsEspec(i) {
    const inputDataEs = allSelector(`activo-espec-${i+1}`);
    const inputRemoveEs = allSelector(`activo-btnRemove-${i+1}`);

    if (globals.variableActivos[i].isnoEmpty && !globals.variableActivos[i].isDuplicate) {
      inputDataEs.forEach((x) => {
        x.disabled = true;
      });
      inputRemoveEs.forEach((x) => {
        x.disabled = true;
      });
    }
  }

  //Funcion con evento click que llama a la funcion verificar la especificacion agregada
  function verifierAllAddEspec(){
    const allListEs = allSelector("list-es");
    allListEs.forEach((x,i)=>{
      x.addEventListener("click",(e)=>{
        verifierAddEspec(e,i);
      });
    });
  }

  //Valida a la hora de agregar una nueva fila de especificaciones
  function verifierAddEspec(e, index){
    if (e.target.classList.contains(`activo-btnAdd-${index+1}`)) {
      const allDataEs = allSelector(`activo-btnAdd-${index+1}`);
      catchDataEspecificaciones(index);

      //console.log("all data", allDataEs.length);
      if (globals.variableActivos[index].isnoEmpty) {
        disabledFieldsEspec(index);
        for (let i = 0; i <= allDataEs.length - 1; i++) {
          if(!globals.variableActivos[index].isDuplicate){
            allDataEs[i].disabled = true;
          }
        }
        if (allDataEs.length < 5) {
          const rowEs = allSelector(`activo-row-espec-${index+1}`); 
          if(!globals.variableActivos[index].isDuplicate){
            //globals.variableActivos[index].clickRemove=false;
            if(rowEs[0].childElementCount===3){
              createNewColumn(index);
              getEspecificaciones(1, index,1,"","",1);
            }else{
              getEspecificaciones(0, index,1,"","",1);
            }
          }else{
            alert("No se puede agregar una especificacion repetida");
          }
          globals.variableActivos[index].contEspec++;
        } else {
          alert("Limite de 5");
        }
      } else {
        if (!blankSpacesEspec(index)) {
          alert("No esta permitido los espacios en blanco");
        }else{
          alert("Completa los campos");
        }
      }
    }
  }


  //Funcion que valida que los campos especificaciones no esten vacios
  function blankSpacesEspec(i) {
    return globals.variableActivos[i].cap.trim().length > 0;
  }

  //Guarda las especificaciones en un array de objetos
  function catchDataEspecificaciones(index){
    const AllEspec = allSelector(`activo-espec-${index+1}`);
    //console.log(AllEspec);

    for (let i = 0; i < AllEspec.length; i++) {
      if(AllEspec[i].value!==""){
        globals.variableActivos[index].isnoEmpty = true;
        if(i===0 || i%2===0){
          globals.variableActivos[index].cap = "";
          globals.variableActivos[index].cap = AllEspec[i].value.trim();
          //globals.variableActivos[index].clickRemove = false;
        }
        const isDuplicate = globals.variableActivos[index].valores.some(x=>x.hasOwnProperty(
          globals.variableActivos[index].cap
        ));

        if(i%2!==0 && !isDuplicate){
          globals.variableActivos[index].isDuplicate=false;
          globals.variableActivos[index].valores.push({
            [globals.variableActivos[index].cap]:AllEspec[i].value.trim()
          });
          
          console.log("lista", globals.variableActivos[index].valores);
          console.log("cap", globals.variableActivos[index].cap);
        }
        if(isDuplicate){
          console.log(globals.variableActivos[index].clickRemove);
          if(globals.variableActivos[index].clickRemove){
            globals.variableActivos[index].isDuplicate=false;

          }else{
            globals.variableActivos[index].isDuplicate=true;
          }
        }
      }else{
        globals.variableActivos[index].isnoEmpty = false;
      }
    }
    globals.variableActivos[index].clickRemove = false;
    
    
  }

  //Funcion que guarda los activos en la DB
  async function saveActivos(cod, idsubcategoria, idmarca, modelo, fecha, descripcion, especificaciones){
    console.log("cod", cod);
    console.log("subcategoria", idsubcategoria);
    console.log("idmarca", idmarca);
    console.log("modelo", modelo);
    console.log("fecha", fecha);
    console.log("descripcion", descripcion);
    console.log("espec", JSON.stringify(especificaciones));
    

    const fields = [cod, idsubcategoria, idmarca, modelo, fecha, descripcion];
    const verifierEmptyField = fields.every(x=>x.trim().length>0); //Todos los elementos deben de cumplir la condicion

    const onlyObject = especificaciones.reduce((acum, objeto) => {
      const clave = String(Object.keys(objeto)[0]);
      acum[clave] = objeto[clave];
      return acum;
    }, {});
    let dataBack = 0;

    const verifyEspec = verifierEspecBlanck();

    if(verifierEmptyField && Object.keys(onlyObject).length>0 && !verifyEspec){
      const params = new FormData();
      params.append("operation", "add");
      params.append("idsubcategoria", idsubcategoria);
      params.append("idmarca", idmarca);
      params.append("modelo", modelo);
      params.append("cod_identificacion", cod);
      params.append("fecha_adquisicion", fecha);
      params.append("descripcion", descripcion);
      params.append("especificaciones", JSON.stringify(onlyObject));

      const data = await fetch(`${globals.host}activo.controller.php`,{
        method:"POST",
        body:params
      });
      const resp = await data.json();

      console.log(resp);
      dataBack = resp.idactivo
      
    }else{
      console.log("vacios", verifierEmptyField);
      console.log("espec", Object.keys(onlyObject).length>0);
      //alert("Completa los campos");
      dataBack = 0;
    }
    return dataBack;
  }

  function validarFechas(){
    let allValidate = false;
    const curentDate = getDate();
    const fieldsFecha = allSelector("fecha");
    fieldsFecha.forEach(x=>{
      if(x.value<=curentDate){
        allValidate = true;
      }
    });
    return allValidate;
  }

  //Evento click del sidebar a la hora de registrar los datos de los activos
  selector("save").addEventListener("click",async()=>{
    const isValid = await validateAllCodes();
    let isEmpty = false;
    if(isValid){
      const validateAllFechas = validarFechas();
      if(validateAllFechas){
        if(confirm("¿Deseas registrar estos activos?")){
          getAllCodesSB();
          recorrerTodosActivos();
          console.log(globals.list_codes);
  
          const allActivos = selector("list-register-activos").childElementCount;
          for (let i = 0; i < allActivos; i++) {
            catchDataEspecificaciones(i);
            isEmpty=false;
            console.log(globals.variableActivos[i].valores);
            const isSave = await saveActivos(globals.list_codes[i], globals.datosActivos[i].subcategoria, globals.datosActivos[i].marca,
              globals.datosActivos[i].modelo, globals.datosActivos[i].fecha, globals.datosActivos[i].descripcion, globals.variableActivos[i].valores 
            );
            if(isSave>0){
              globals.contSave++;
            }else if(isSave===0){
              isEmpty=true;
            }
          }
          if(globals.contSave===allActivos){
            alert("Se han guardado correctamente");
            localStorage.removeItem("cantidad");
            localStorage.removeItem("subcategoria");
            localStorage.removeItem("marca");
            resetUI();
            const sidebar = bootstrap.Offcanvas.getOrCreateInstance(
              selector("sb-code")
            );
            sidebar.hide();
            window.location.href = "http://localhost/CMMS/views/activo";
          }else{
            if(isEmpty){
              alert("Completa los campos");
              globals.list_codes = [];
              globals.datosActivos=[];
            }else{
              alert("Hubo un error al registrar");
            }
            globals.contSave=0;
          }
          
        }
      }else{
        alert("La fecha de adquisicion no debe ser posterior a la fecha actual");
      }
    }else{
      alert("El codigo de identificacion debe ser unico");
    }
      
  });

  function verifierEspecBlanck(){
    let isEmpty = false;
    const allActivos = selector("list-register-activos").childElementCount;

    for (let i = 0; i < allActivos; i++) {
      const AllEspec = allSelector(`activo-espec-${i+1}`);
      AllEspec.forEach(x=>{
        if(x.value===""){isEmpty=true;}
      });
    }

    return isEmpty;
  }

  //Funcion que guarda los datos de los campos
  function recorrerTodosActivos(){
    const allActivos = selector("list-register-activos").childElementCount;
    for (let i = 0; i < allActivos; i++) {
      const elements = document.getElementsByClassName(`activo-${i+1}`);
      
      for (let j = 0; j < elements.length; j++) {
        getAllDatosActivo(elements[j], elements.length);
        
      }
    }
    console.log("global", globals.datosActivos);
  }

  //MOSTRAR LOS DATOS ELEGIDOS EN TODOS LOS BLOQUES EN SB DEL INDEX

  //Funcion que selecciona a la subcategoria
  async function dataByDefault(){
    const idsubcategoria = parseInt(localStorage.getItem("subcategoria"));
    const allCategorias = allSelector("subcategoria");
    
    allCategorias.forEach(x=>{
      x.value = idsubcategoria;
    });

    const idmarca = parseInt(localStorage.getItem("marca"));

    const allMarcas = allSelector("marca");

    allMarcas.forEach((x,i)=>{
      const elements = document.getElementsByClassName(`activo-${i+1}`);
      getMarcasDefault(idsubcategoria,idmarca, elements[1]);
    });

    await getEspecificacionesDefecto(idsubcategoria);
  }

  //Funcion que selecciona a la marca
  async function getMarcasDefault(idsub, idmarca, element){
    const params = new URLSearchParams();
    params.append("operation", "getMarcasBySubcategoria");
    params.append("idsubcategoria", parseInt(idsub));
    const data = await getDatos(
      `${globals.host}subcategoria.controller.php`,
      params
    );

    for (let i = element.options.length - 1; i > 0; i--) {
      element.remove(i);
    }

    data.forEach((x) => {
      const option = createOption(x.idmarca, x.marca);
      element.appendChild(option);
    });

    for (let i = 0; i <element.options.length; i++) {
      element.value = idmarca;
    }
  }

  async function getEspecificacionesDefecto(idsubcategoria=0){
    const params = new URLSearchParams();
    params.append("operation", "getEspecificaciones");
    params.append("idsubcategoria", idsubcategoria);

    const data = await getDatos(`${globals.host}especDefecto.controller.php`, params);

    paintEspecificaciones(data);
    
  }

  function paintEspecificaciones(data){
    const allActivos = selector("list-register-activos").childElementCount;

    for (let i = 0; i < allActivos; i++) {
      const rowEs = allSelector(`activo-row-espec-${i+1}`);
      const colum = rowEs[0];
      colum.innerHTML="";
    }

    renderEspecificaciones(data);

  }

  function renderEspecificaciones(data){
    const allListEs = allSelector("list-es");
    console.log(allListEs);
    
    let cont = 0;
    let isDisabled = true;
    
    allListEs.forEach((a,i)=>{
      for(let x in data){
        getEspecificaciones(0,i,2,x, data[x], cont, isDisabled);
        cont++;
        if(cont===2){isDisabled=false;}
        if(cont===3){
          cont=0;
          isDisabled=true;
        }
      }
    })


  }

  function resetUI(){
    const allCategorias = allSelector("subcategoria");
    const allMarcas = allSelector("marca");
    const allModelos = allSelector("modelo");
    const allFecha = allSelector("fecha");
    const allDescripcion = allSelector("descripcion");

    //globals.contEspecificaciones = 2;
    
    const listRegisters = selector("list-register-activos");

    for (let i = 0; i < listRegisters.childElementCount; i++) {
      allCategorias[i].value="";
      allMarcas[i].value="";
      allModelos[i].value="";
      allFecha[i].value=getDate();
      allDescripcion[i].value="";
      
      globals.variableActivos[i].contEspecificaciones=2;
      globals.variableActivos[i].valores=[];
    }
  }
});