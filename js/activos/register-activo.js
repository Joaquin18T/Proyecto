document.addEventListener("DOMContentLoaded",()=>{
  const globals={
    datosActivos:[], //Almacena todos los datos de los activos a registrar
    fields:["subcategoria", "marca", "modelo", "fecha", "descripcion"], // Campos que tiene la tabla
    objTemporal:{}, //Objeto temporal para el almacenamientos de datos de los activos
    variableActivos:[],
  };
  (()=>{
    renderRegisters();
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

  //SUBCATEGORIAS
  (async () => {
    const data = await getDatos(
      "http://localhost/CMMS/controllers/subcategoria.controller.php",
      "operation=getSubCategoria"
    );
    //console.log(data);
    const allCategorias = allSelector("subcategoria");
    data.forEach(x=>{
      chargerData(allCategorias, x.idsubcategoria, x.subcategoria);
    });
    selectSubCategoria();
  })();

  //Funcion a cargar las opciones en todos los select
  function chargerData(list=[], valor, texto){
    list.forEach(x=>{
      const element = createOption(valor, texto);
      x.appendChild(element);
    });
  }
  //FIN SUBCATEGORIAS

  //CATEGORIAS
  function selectSubCategoria(){
    const AllSubcategorias = allSelector("subcategoria");
    AllSubcategorias.forEach((x,i)=>{
      x.addEventListener("change",()=>{
        const elements = document.getElementsByClassName(`activo-${i+1}`);
        const id = x.value;
        renderDataMarcas(elements[1], parseInt(id));
      });
    });
  }

  //Renderiza las opciones en el select categoria segun el numero del activo
  async function renderDataMarcas(element, id){
    const params = new URLSearchParams();
    params.append("operation", "getMarcasBySubcategoria");
    params.append("idsubcategoria", parseInt(id));
    const data = await getDatos(
      "http://localhost/CMMS/controllers/subcategoria.controller.php",
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
  //FIN CATEGORIAS

  //Funcion que renderiza dinamicamente la cantidad de activos a registrar
  function renderRegisters(){
    const listRegisters = selector("list-register-activos");
    const cantidadRegistrar = localStorage.getItem("cantidad");

    for (let i = 0; i < cantidadRegistrar; i++) {
      listRegisters.innerHTML+=elementToPaint(i);
      //Variables/propiedades que usaran en el registro de cada activo
      const utilities = {
        contEspecificaciones:2,
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
    console.log("variable por activos", globals.variableActivos);
    verifierAllAddEspec();
  }

  selector("showSB").addEventListener("click",()=>{
    const allActivos = selector("list-register-activos").childElementCount;
    for (let i = 0; i < allActivos; i++) {
      const elements = document.getElementsByClassName(`activo-${i+1}`);
      
      for (let j = 0; j < elements.length; j++) {
        getAllDatosActivo(elements[j], elements.length);
        
      }
    }
    console.log("global", globals.datosActivos);
    
  });

  //Captura los datos de los campos en formato JSON
  function getAllDatosActivo(field, cantidad){
    let listClass = field.classList;
    listClass = [...listClass];

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
  <div class="row mt-2">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">Datos del Activo Nº ${i+1}</div>
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
  function getEspecificaciones(num_col, i) {
    const rowEs = allSelector(`activo-row-espec-${i+1}`);
    const listEs = rowEs[num_col];
    const newDiv = document.createElement("div");
    //newDiv.classList.add("col-md-12");

    newDiv.setAttribute("id", `espec-${globals.variableActivos[i].contEspecificaciones}`);
    newDiv.classList.add("mt-3");

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
    listEs.appendChild(newDiv);
    globals.variableActivos[i].contEspecificaciones++;

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

  //Valida a la hora de agregar una nueva fila de especificaciones
  function verifierAllAddEspec(){
    const allListEs = allSelector("list-es");
    allListEs.forEach((x,i)=>{
      x.addEventListener("click",(e)=>{
        verifierAddEspec(e,i);
      });
    });
  }
  
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
              getEspecificaciones(1, index);
            }else{
              getEspecificaciones(0, index);
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
});