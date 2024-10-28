document.addEventListener("DOMContentLoaded", () => {
  let list_codes = [];
  let onlyOneCall = false;

  let contCodeInputs=0;

  let valores = [];
  let contEspecificaciones = 2;
  let isnoEmpty = false;

  let cap = "";
  let valorEspec = "";
  let txtIdmarca = 0,
    txtModelo = "",
    txtCode = "",
    txtfecha = "",
    txtdescrip = "",
    txtEscec = {},
    contEspec = 1;

  let isvalidate = true;
  let validateEspec = true;

  function getInputCodes(){
    const data = document.querySelectorAll(".element-cod");
    return [...data];
  }

  function createElementHTML(name_element){
    return document.createElement(name_element);
  }

  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }

  // (async()=>{
  //   const data=await getDatos("http://localhost/CMMS/controllers/ubicacion.controller.php", "operation=getAll");
  //   data.forEach(x=>{
  //     //console.log(x);

  //     const element = createOption(x.idubicacion, x.ubicacion);
  //     selector("ubicacion").appendChild(element);
  //   });
  // })();

  (async () => {
    const data = await getDatos(
      "http://localhost/CMMS/controllers/subcategoria.controller.php",
      "operation=getSubCategoria"
    );
    //console.log(data);
    data.forEach((x) => {
      const element = createOption(x.idsubcategoria, x.subcategoria);
      selector("subcategoria").appendChild(element);
    });
  })();

  selector("subcategoria").addEventListener("change", async () => {
    await getMarcas(selector("subcategoria").value);
  });

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
    selector("fecha").value = getDate();
  })();


  async function getMarcas(id){
    const params = new URLSearchParams();
    params.append("operation", "getMarcasBySubcategoria");
    params.append("idsubcategoria", parseInt(id));
    const data = await getDatos(
      "http://localhost/CMMS/controllers/subcategoria.controller.php",
      params
    );

    for (let i = selector("marca").options.length - 1; i > 0; i--) {
      selector("marca").remove(i);
    }
    data.forEach((x) => {
      const element = createOption(x.idmarca, x.marca);
      selector("marca").appendChild(element);
    });
  }

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

  function valideWhiteSpace() {
    txtIdmarca = selector("marca").value;
    txtModelo = selector("modelo").value;
    //txtCode = selector("codigo").value;
    let subcategoria = selector("subcategoria").value;
    txtdescrip = selector("descripcion").value;

    let list = [subcategoria, txtIdmarca, txtModelo, txtdescrip];

    const isValidate = list.every((x) => x.trim().length > 0);
    
    //Validamos que no se puedan registrar campos vacios en el sidebar
    const inputsC = getInputCodes();
    const validateCods = inputsC.every(x=>x.value.trim().length>0);
    console.log("code blank",validateCods);
    
    return isValidate===validateCods;
  }

  async function cascadeAddActivo(data=[]){
    let cont=0;
    for (let i = 0; i < data.length; i++) {
      const isAdd = await saveData(data[i]);
      if (isAdd>0){
        console.log("agregado");
        cont++;
      }
    }
    return (cont===data.length);
  }
  selector("showSB").addEventListener("click",()=>{
    if(parseInt(selector("cantidad").value)>0){

      selector("only-view").disabled=false;
      
      addInputsCode(parseInt(selector("cantidad").value));

      const sidebar = selector("sb-code");
      const offCanvas = new bootstrap.Offcanvas(sidebar);
      offCanvas.show();
    }else{
      alert("Lo minimo es 1");
    }
  });

  function addInputsCode(cantidad){
    // const countInputs = document.querySelectorAll(".element-cod").length;
    // console.log(countInputs);
    
    for (contCodeInputs; contCodeInputs < cantidad; contCodeInputs++) {
      const container = selector("container-code");
      const div = createElementHTML("div");
      div.classList.add("mb-2", "mt-4", "contain-input-code");

      const label = createElementHTML("label");
      label.classList.add("form-label", "text-cont");
      label.textContent = `Codigo del activo Nº. ${contCodeInputs+1}`;

      const input = createElementHTML("input");
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
    }
    cantidad=0;
  }

  function deleteInputCode(div){
    div.querySelector(".delete-input").addEventListener("click",(e)=>{
      getAllCodesSB();
      const parent = e.target.parentNode;

      //Obtiene el valor del input
      const input = e.target.closest('.input-group').querySelector('input');

      list_codes = [];

      const grandParent = parent.parentNode;

      const container = selector("container-code");
      container.removeChild(grandParent);
      selector("cantidad").value-=1;
      contCodeInputs-=1;

      const textLabels = document.querySelectorAll(".text-cont");
      for (let i = 0; i < getInputCodes().length; i++) {
        textLabels[i].textContent = `Codigo del activo Nº. ${i+1}`;
      }

      if(getInputCodes().length===0){
        const sidebar = bootstrap.Offcanvas.getOrCreateInstance(selector("sb-code"));
        sidebar.hide();
        selector("cantidad").value=0;
        selector("only-view").disabled = true;
      }
    });
  }

  function getAllCodesSB(){
    const inputsCode = getInputCodes();
    inputsCode.forEach(x=>{
      //console.log(x.value);
      list_codes.push(x.value);
    });
    console.log(list_codes);
  }

  async function saveData(code) {
    let dataBack=0;
    txtIdmarca = selector("marca").value;
    txtModelo = selector("modelo").value;
    txtCode = code;
    txtfecha = selector("fecha").value;
    txtdescrip = selector("descripcion").value;

    let subcategoria = selector("subcategoria").value;

    selector("descripcion").addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault();
      }
    });

    //catchData();
    txtEscec = valores.reduce((acum, objeto) => {
      const clave = String(Object.keys(objeto)[0]);
      acum[clave] = objeto[clave];
      return acum;
    }, {});
    //console.log(txtEscec);

    let list = [subcategoria, txtIdmarca, txtModelo, txtCode, txtdescrip];

    isvalidate = list.every((x) => x.trim().length > 0);

    if (isvalidate && Object.keys(txtEscec).length > 0 && validateEspec) {
      const params = new FormData();
      params.append("operation", "add");
      params.append("idsubcategoria", selector("subcategoria").value);
      params.append("idmarca", txtIdmarca);
      //params.append("idubicacion", txtIdUbi);
      params.append("modelo", txtModelo);
      params.append("cod_identificacion", txtCode);
      params.append("fecha_adquisicion", txtfecha);
      params.append("descripcion", txtdescrip);
      params.append("especificaciones", JSON.stringify(txtEscec));

      const data = await fetch("http://localhost/CMMS/controllers/activo.controller.php",{
        method: "POST",
        body: params
      });
      
      const respuesta = await data.json();

      dataBack = respuesta.idactivo;
    } else {
      alert("Completa los campos");
      validateEspec = true;
    }
    return dataBack;
  }

  selector("save").addEventListener("click", async(e) => {
    //e.preventDefault();
    const dateToday = getDate();
    catchData();

    const validateJson = valores.every((x) => Object.keys(x).length > 0);
    if (
      selector("fecha").value <= dateToday &&
      validateJson &&
      valideWhiteSpace()
    ) {
      //console.log(valores);
      let isUnique = await validateAllCodes(); 
      const inputsSB = getInputCodes();
      const minCharacteres = inputsSB.every(x=>x.value.length>=15); //el codigo de ident. tiene un minimo de 15
      
      //console.log(list_codes);
      
      if(isUnique && minCharacteres){
        if (confirm("Deseas registrar el activo?")) {
          getAllCodesSB();
          const allSave = await cascadeAddActivo(list_codes);
          if(allSave){
            alert("Los registros se han guardado correctamente");
            list_codes=[];
            const sidebar = bootstrap.Offcanvas.getOrCreateInstance(
              selector("sb-code")
            );
            sidebar.hide();
            selector("cantidad").value=0;
            contCodeInputs=0;
            selector("only-view").disabled = true;
            resetUI();
          }
        }
      }else{
        if(!isUnique){
          alert("El codigo de identificacion debe ser unico");
        }else if(!minCharacteres){
          alert("El minimo de carateres para el codigo de identif. es de 15 caracteres");
        }
      }
    } else {
      if (!valideWhiteSpace()) {
        alert("No se permiten los espacios en blanco");
      } else if (selector("fecha").value > dateToday) {
        alert("No puedes asignar una fecha posterior a la actual");
      }
    }
  });

  function getEspecificaciones() {
    const listEs = selector("list-es");
    const newDiv = document.createElement("div");
    newDiv.classList.add("row");

    newDiv.setAttribute("id", `espec-${contEspecificaciones}`);
    newDiv.classList.add("mt-3");

    if (contEspecificaciones <5) {
      newDiv.innerHTML = `
          <div class="col-6">
            <label for="">Especificacion ${contEspecificaciones}</label>
            <input type="text" class="form-control w-75 dataEs">
          </div>
          <div class="col-6">
            <label for="">Valor</label>
            <input type="text" class="form-control w-75 dataEs">
          </div> 
          <div class="col-3 mt-2">
            <button type="button" class="btn btn-sm btn-primary  btnAdd">AGREGAR</button>
          </div>       
          <div class="col-3 mt-2">
            <button type="button" class="btn btn-sm btn-danger btnRemove">ELIMINAR</button>
          </div> 
        `;

    } else{
      newDiv.innerHTML = `
        <div class="col-6">
          <label for="">Especificacion ${contEspecificaciones}</label>
          <input type="text" class="form-control w-75 dataEs">
        </div>
        <div class="col-6">
          <label for="">Valor</label>
          <input type="text" class="form-control w-75 dataEs">
        </div> 
        <div class="col-3 mt-2">
          <button type="button" class="btn btn-sm btn-danger btnRemove">ELIMINAR</button>
        </div> 
      `;
    }
    listEs.appendChild(newDiv);
    contEspecificaciones++;

    newDiv.querySelector(".btnRemove").addEventListener("click", () => {
      const lastInput = document.querySelectorAll(".dataEs");
      let lastValue = lastInput[lastInput.length - 1].value;
      //console.log(contEspec);

      if (lastValue !== "") {
        let claves = Object.keys(valores);
        let ultimaClave = valores[claves.length - 1]; //ultima clave
        //console.log(ultimaClave);

        console.log(contEspec);

        let test = valores.hasOwnProperty(contEspec - 1);

        if (test) {
          valores.splice(contEspec - 1, 1);
          console.log(valores);
        }
      }
      contEspec--;

      listEs.removeChild(newDiv);
      contEspecificaciones--;
      checkButtonAdd(contEspecificaciones);
    });
  }

  function checkButtonAdd(cont) {
    
    const maxEspecificaciones = 4;
    const btnAdd = document.querySelectorAll(".btnAdd");
    const currentCount = document.querySelectorAll(".btnAdd").length;

    const maxInputs = 10;
    const inputEs = document.querySelectorAll(".dataEs");
    const currentinputEs = document.querySelectorAll(".dataEs").length;

    if(cont>2){
      const maxBtnRemove = 4;
      const btnRemove = document.querySelectorAll(".btnRemove");
      const countBtnRemove = document.querySelectorAll(".btnRemove").length;
  
      if (countBtnRemove<maxBtnRemove) {
        btnRemove[countBtnRemove - 1].disabled = false;
      }
    }
    //console.log(cont);
    
    if (currentCount < maxEspecificaciones) {
      btnAdd[currentCount - 1].disabled = false; // Habilitamos el botón si el conteo es menor al máximo
    }

    if (currentinputEs < maxInputs) {
      inputEs[currentinputEs - 2].disabled = false;
      inputEs[currentinputEs - 1].disabled = false;
    }

  }

  function disabledFieldsEspec() {
    const inputDataEs = document.querySelectorAll(".dataEs");
    const inputRemoveEs = document.querySelectorAll(".btnRemove");

    if (isnoEmpty) {
      inputDataEs.forEach((x) => {
        x.disabled = true;
      });
      inputRemoveEs.forEach((x) => {
        x.disabled = true;
      });
    }
  }

  selector("list-es").addEventListener("click", (e) => {
    if (e.target.classList.contains("btnAdd")) {
      const allDataEs = document.querySelectorAll(".btnAdd");
      //const RemoveDataEs = document.querySelectorAll('.btnRemove');

      catchData();
      console.log("click add", valores);
      if (isnoEmpty) {
        disabledFieldsEspec();
        for (let i = 0; i <= allDataEs.length - 1; i++) {
          allDataEs[i].disabled = true;
          //RemoveDataEs[i].disabled = true;
        }
        if (allDataEs.length < 5) {
          getEspecificaciones();
          contEspec++;
        } else {
          alert("Limite de 5");
        }
      } else {
        if (!blankSpacesEspec()) {
          alert("No esta permitido los espacios en blanco");
        }
      }
    }
  });

  document.querySelectorAll(".dataEs").forEach((input) => {
    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault();
      }
    });
  });

  function blankSpacesEspec() {
    console.log("valor ", valorEspec);

    return cap.trim().length > 0 && valorEspec.trim().length > 0;
  }
  function catchData() {
    document.querySelectorAll(".dataEs").forEach((input, i) => {
      valorEspec = input.value;
      console.log(valorEspec);
      
      if(parseInt(valorEspec)!==undefined){
        
        if(parseInt(valorEspec)<0){
          alert("No se permiten numeros negativos");
        }else{
          if (i % 2 !== 0 && i !== 0) {
            let isRepeat = valores.some((obj) => obj.hasOwnProperty(cap));
            isnoEmpty = valorEspec != "" && cap != "" && blankSpacesEspec();
            if (!isnoEmpty) {
              validateEspec = false;
            }
    
            if (!isRepeat && isnoEmpty) {
              valores.push({
                [cap]: valorEspec,
              });
              //valoresSend.
            }
            console.log(valores);
          }
          cap = valorEspec;
          valorEspec = "";
        }
      }

    });
  }

  function createOption(value, text) {
    const element = document.createElement("option");
    element.value = value;
    element.innerText = text;
    return element;
  }

  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  function resetUI() {
    selector("marca").value = "";
    selector("modelo").value = "";
    //selector("codigo").value = "";
    selector("fecha").value = getDate();
    selector("descripcion").value = "";
    selector("subcategoria").value = "";
    //selector("ubicacion").value="";

    const listEs = selector("list-es");
    listEs.innerHTML = `
    <div class="row">
      <div class="col-6">
        <label for="">Especificacion 1</label>
        <input type="text" class="form-control w-75 dataEs" required>
      </div>
      <div class="col-6 mb-0">
        <label for="">Valor</label>
        <input type="text" class="form-control w-75 dataEs" required>
      </div>
      <div class="col-4 mt-2">
        <button class="btn btn-sm btn-primary btnAdd" type="button">AGREGAR</button>
      </div>
    </div>`;

    contEspecificaciones = 2;
    valores = [];

    selector("container-code").innerHTML="";
  }
});
