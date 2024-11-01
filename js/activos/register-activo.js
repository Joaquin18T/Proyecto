document.addEventListener("DOMContentLoaded",()=>{
  const globals={
    datosActivos:[],
    fields:["subcategoria", "marca", "modelo", "fecha", "descripcion"],
    objTemporal:{}
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
    }
  }

  selector("showSB").addEventListener("click",()=>{
    const allActivos = selector("list-register-activos").childElementCount;
    for (let i = 0; i < allActivos; i++) {
      const elements = document.getElementsByClassName(`activo-${i+1}`);
      
      for (let j = 0; j < elements.length; j++) {
        getAllDatosActivo(elements[j], elements.length, i);
        
      }
    }
    console.log("global", globals.datosActivos);
    
  });

  function getAllDatosActivo(field, cantidad, index){
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
            <div id="list-es">
              <div class="row">
                <div class="col-md-3">
                  <label>Especificacion 1</label>
                  <input type="text" class="form-control w-75 dataEs" required>
                </div>
                <div class="col-md-3 mb-0">
                  <label>Valor</label>
                  <input type="text" class="form-control w-75 dataEs" required>
                </div>
              </div>
              <div class="row">
                <div class="col-4 mt-2">
                  <button class="btn btn-sm btn-primary btnAdd" type="button">AGREGAR</button>
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
});