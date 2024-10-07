document.addEventListener("DOMContentLoaded", () => {
  let listchks = [];
  let valores = [];
  let contEspecificaciones = 2;
  let isClicked = false;
  let isnoEmpty = false;
  let cap = "";

  let
    txtIdmarca = 0,
    txtModelo = "",
    txtCode = "",
    txtfecha = "",
    txtdescrip = "",
    txtEscec = {},
    iduser = 0;

  let contButtons = document.querySelectorAll(".btnAdd");
  let isvalidate = true;
  let validateEspec = true;

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
    const data = await getDatos("http://localhost/CMMS/controllers/subcategoria.controller.php", "operation=getSubCategoria");
    //console.log(data);
    data.forEach(x => {
      const element = createOption(x.idsubcategoria, x.subcategoria);
      selector("subcategoria").appendChild(element);
    })
  })();

  // selector("subcategoria").addEventListener("change", async () => {
  //   await showMarca(selector("subcategoria").value);
  // });

  function getDate(){
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    const formattedDate = `${year}-${month}-${day}`;
    //selector("fecha").value = formattedDate;
    return formattedDate;
  }

  (() => {
    selector("fecha").value = getDate();
  })();

  // async function showMarca() {
  //   const params = new URLSearchParams();
  //   params.append("operation", "getAll");
  //   //params.append("idsubcategoria", id);
  //   const data = await getDatos("http://localhost/CMMS/controllers/marca.controller.php", params);

  //   for (let i = selector("marca").options.length - 1; i > 0; i--) {
  //     selector("marca").remove(i);
  //   }
  //   data.forEach(x => {
  //     const element = createOption(x.idmarca, x.marca);
  //     selector("marca").appendChild(element);
  //   })
  // }

  (async()=>{
    const params = new URLSearchParams();
    params.append("operation", "getAll");
    //params.append("idsubcategoria", id);
    const data = await getDatos("http://localhost/CMMS/controllers/marca.controller.php", params);

    for (let i = selector("marca").options.length - 1; i > 0; i--) {
      selector("marca").remove(i);
    }
    data.forEach(x => {
      const element = createOption(x.idmarca, x.marca);
      selector("marca").appendChild(element);
    })
  })();

  async function searchCode() {
    const params = new URLSearchParams();
    params.append("operation", "repeatCode");
    params.append("cod_identificacion", selector("codigo").value);
    const data = await getDatos("http://localhost/CMMS/controllers/activo.controller.php", params);
    return data;
  }

  async function saveData() {
    let isUnique = await searchCode();
    //console.log(isUnique);

    if (isUnique.length === 0) {
      txtIdmarca = selector("marca").value;
      txtModelo = selector("modelo").value;
      txtCode = selector("codigo").value;
      txtfecha = selector("fecha").value;
      txtdescrip = selector("descripcion").value;
      //let txtIdUbi = selector("ubicacion").value;

      let subcategoria = selector("subcategoria").value;


      selector("descripcion").addEventListener("keydown", (e) => {
        if (e.key === "Enter") {
          e.preventDefault();
        }
      });

      catchData();
      txtEscec = valores.reduce((acum, objeto) => {
        const clave = String(Object.keys(objeto)[0]);
        acum[clave] = objeto[clave];
        return acum;
      }, {});
      //console.log(txtEscec);

      let list = [subcategoria, txtIdmarca, txtModelo, txtCode, txtdescrip];


      isvalidate = list.every(x => x !== "");
      //console.log(Object.keys(txtEscec).length);
      //console.log(txtIdUbi);

      if (isvalidate && Object.keys(txtEscec).length > 0 && validateEspec) {
        const params = new FormData();
        params.append("operation", "add")
        params.append("idsubcategoria", selector("subcategoria").value);
        params.append("idmarca", txtIdmarca);
        //params.append("idubicacion", txtIdUbi);
        params.append("modelo", txtModelo);
        params.append("cod_identificacion", txtCode);
        params.append("fecha_adquisicion", txtfecha);
        params.append("descripcion", txtdescrip);
        params.append("especificaciones", JSON.stringify(txtEscec))
        let valor = "";

        const option = {
          method: "POST",
          body: params
        };
        fetch(`http://localhost/CMMS/controllers/activo.controller.php`, option)
          .then(response => response.json())
          .then(data => {
            //console.log(data);

            if (data.idactivo > 0) {
              alert("Activo registrado");
              resetUI();
            } else {
              alert("Activo no registrado");
            }

          })
      } else {
        alert("Completa los campos");

        validateEspec = true;
      }
    } else {
      alert("El codigo no es unico");
      //Crear un array de objetos con las alertas, esa funcion tendra que pasarle un parametro, ejm:
      //alertArray("unico") Esta funcion mostrara una alerta de que el codigo no es unico de acuerdo a que debe
      // ser igual que la clave del objeto con el mensaje

    }

  }

  selector("form-activo").addEventListener("submit", (e) => {
    e.preventDefault();
    const dateToday = getDate();
    if(selector("fecha").value>=dateToday){
      if (confirm("Deseas registrar el activo?")) {
        
        saveData();
      }
    }else{
      alert("No puedes asignar una fecha anterior a la actual")
    }
    
  });
  //console.log(new Date());
  //getEspecificaciones();
  function getEspecificaciones() {
    const listEs = selector("list-es");
    const newDiv = document.createElement("div");
    newDiv.classList.add("row");

    newDiv.setAttribute("id", `espec-${contEspecificaciones}`);
    newDiv.classList.add("mt-3");
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
    listEs.appendChild(newDiv);
    contEspecificaciones++;

    newDiv.querySelector(".btnRemove").addEventListener("click", () => {
      listEs.removeChild(newDiv);
      contEspecificaciones--;
      checkButtonAdd();
    });
  }

  function checkButtonAdd() {
    const maxEspecificaciones = 5;
    const btnAdd = document.querySelectorAll(".btnAdd");
    const currentCount = document.querySelectorAll(".btnAdd").length;
    //console.log(currentCount);

    if (currentCount < maxEspecificaciones) {
      btnAdd[currentCount - 1].disabled = false; // Habilitamos el botón si el conteo es menor al máximo
    }
  }


  selector("list-es").addEventListener("click", (e) => {
    if (e.target.classList.contains("btnAdd")) {
      const allDataEs = document.querySelectorAll('.btnAdd');
      catchData();

      if (isnoEmpty) {
        for (let i = 0; i <= allDataEs.length - 1; i++) {
          allDataEs[i].disabled = true;
        }
        if (allDataEs.length < 5) {
          getEspecificaciones();

        } else {
          alert("Limite de 5")
        }
      }

    }
  });

  document.querySelectorAll(".dataEs").forEach(input => {
    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault();
      }
    });
  });


  function catchData() {
    document.querySelectorAll(".dataEs").forEach((input, i) => {
      let valor = input.value;
      if (i % 2 !== 0 && i !== 0) {

        let newObject = {
          [cap]: valor
        };
        let isRepeat = valores.some(obj => obj.hasOwnProperty(cap));
        //console.log(cap);
        isnoEmpty = valor != "" && cap != "";
        if (!isnoEmpty) {
          //alert("Completa los campos");
          validateEspec = false;
        }

        if (!isRepeat && isnoEmpty) {
          valores.push({
            [cap]: valor
          });
          //valoresSend.
          //console.log(valores);
        }
      }
      cap = valor;
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
    selector("codigo").value = "";
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
    valores = []
  }
})