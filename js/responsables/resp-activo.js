document.addEventListener("DOMContentLoaded", async () => {
  const host = "http://localhost/CMMS/controllers";
  let idactivo = 0;
  let cont = 0;
  let acumMB = 0;
  let listImages = {};
  let contImages = 1;
  let isClicked = false;
  let userList = [];
  let maxResp = false;
  //let isComplete=false;

  tinymce.init({
    selector: '#condicion',
    resize: false,
    height: 300
  });

  selector("activo").addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
    }
  });

  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  function getImages() {
    let valor = selector("imageInput").files;

    if(valor.length+contImages>5){
      alert("No puedes seleccionar mas de 5 imagenes");
    }else{
      let file = new FileReader();
      let contentImages = selector("imagePreview");
  
      let image = valor[0];
      let imageInMB = (image.size / (1024 * 1024)).toFixed(2); // convierte de bites a megabytes
      acumMB+=parseFloat(imageInMB);
      // console.log("Peso: ", imageInMB);
      // console.log("Suma: ", acumMB.toFixed(2));
      
      file.readAsDataURL(image);
  
      file.onload = function() {
        const colDiv = document.createElement("div");
        colDiv.id=`image${contImages}`;
        colDiv.classList.add('col-md-12', 'mb-1');
  
        let img = document.createElement("img");
        img.src = file.result;
        img.height=200;
        img.width=400;
  
        listImages[`image${contImages}`] ={
          url:img.src,
          name: image.name
        }

        img.classList.add('rounded');
        
        console.log(listImages);

        const button = document.createElement("button");
        button.classList.add("btn", "btn-sm", "btn-danger", "w-25", "mt-2", "mb-3", "btn-delete-image");
        button.textContent = "Eliminar";
        button.setAttribute("data-filename", image.name);
        
        colDiv.appendChild(img);
        colDiv.appendChild(button)
        contentImages.appendChild(colDiv);
  
        contImages++;
        selector("show-sb-images").disabled = false;
        deleteImage();
      }
      file.onerror = function() {
        console.error(file.error);
  
      }

    }
  }

  selector("show-sb-images").addEventListener("click",()=>{
    const sidebar = selector("sb-imagenes");
    const offCanvas = new bootstrap.Offcanvas(sidebar);
    offCanvas.show();
  });

  function deleteImage(){
    const buttons = document.querySelectorAll(".btn-delete-image");
    buttons.forEach(x=>{
      x.addEventListener("click",(e)=>{
        let dataImage = e.target.dataset.filename;
        let isSame = "";
        for(let i in listImages){
          if(dataImage===listImages[i].name){
            isSame=i;
          }
          //console.log(i);
        }
        
        if(isSame!=""){
          console.log("Imagen eliminada ", dataImage);
          delete listImages[isSame]; //elimina una propiedad del objeto
          console.log("parent", e.target.parentNode);
          
          const parent = selector("imagePreview");
          parent.removeChild(e.target.parentNode);   
        }

        if(Object.keys(listImages).length===0){
          selector("show-sb-images").disabled = true;
          const sidebar = bootstrap.Offcanvas.getOrCreateInstance(selector("sb-imagenes"));
          sidebar.hide();
        }

        console.log(listImages);
        
        dataImage="";
      });
    });
  }


  function startText(select) {
    select.setSelectionRange(0, 0); //Ubicar el cursor al principio
  }
  selector("descripcion").addEventListener("click", () => {
    startText(selector("descripcion"));
  });
  selector("condicion").addEventListener("click", () => {
    startText(selector("condicion"));
  });


  selector("imageInput").addEventListener("change", () => {
    getImages();
  });

  /**
  * Reemplaza una cadena
  * @param {*} word 'variable que contiene la cadena'
  * @param {*} rem 'array de elementos que quieres reemplazar'
  * @param {*} remTo 'palabra por la cual vas a reemplazar'
  * @returns 
  */
    function replaceWords(word, rem=[], remTo){
      for (let i = 0; i < rem.length; i++) {
        //const rgx = new RegExp(rem[i], 'g');
        word = word.replace(rem[i], remTo);
      }
      return word;
    }

  async function getData(iduser) {
    let isSaved = false;
    let contUsers = userList.length;
    let valueIntegers = [idactivo, contUsers];
    //console.log("parse",contUsers);

    let isvalidIntegers = valueIntegers.every(x => x !== 0);

    let valueStrings = [selector("descripcion").value, selector("condicion").value];
    let isvalidStrings = valueStrings.every(x => x !== "");
    if (isvalidIntegers && isvalidStrings && Object.keys(listImages).length > 0) {
      let valor = await getIdRol();
      const params = new FormData();
      params.append("operation", "add");
      params.append("idactivo", idactivo);
      params.append("idusuario", iduser);
      //console.log(listImages);
      
      const condicion = tinymce.get('condicion').getContent();
      //const desp = replaceWords(selector("descripcion").value,['<p>','</p>'],'');
      params.append("descripcion", selector("descripcion").value);
      params.append("condicion_equipo", replaceWords(condicion,['<p>','</p>'],'').trim());
      params.append("imagenes", JSON.stringify(listImages));
      params.append("autorizacion", valor[0].id_usuario);
      params.append("solicitud", 1); //CONFIRMAR ESTO AL PROFESOR


      const options = {
        method: "POST",
        body: params
      };
      const data = await fetch("http://localhost/CMMS/controllers/respActivo.controller.php", options);
      let x = await data.json();

      if (x.idresp > 0) {
        const valor = await createNotification(x.idresp, idactivo);
        if (valor > 0) {
          const msg = await addHistorialActivo(x);
          if (msg.mensaje != "") {
            isSaved = true;
            console.log(cont);
            
            if (cont === userList.length - 1) {
              alert("REGISTRO GUARDADO");
              userList=[];
              selector("activo").value = "";
              selector("imageInput").value = "";
              selector("imagePreview").innerHTML = "";
              selector("ubicacion").value = "";
              selector("ubicacion").disabled=false;
              cont=0;
              const data = document.querySelectorAll(".list-chk");
              data.forEach(x => {
                x.checked = false;
              });
              //isComplete=true;
              selector("descripcion").value = "";
              tinymce.get('condicion').setContent("<p></p>");
            }
            if(userList.length>0){
              cont++;

            }
          }
        }
      } else {
        alert("Registro no guardado");
      }
    } else {
      alert("Completa los campos");

    }
    
    return isSaved;
  }


  async function getIdRol() {
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", selector("nomuser").textContent);
    const data = await getDatos(`http://localhost/CMMS/controllers/usuarios.controller.php`, params);
    return data;

  }

  async function getResponsable() {
    let cont=0;
    for(let i=0; i<userList.length; i++){
      const params = new URLSearchParams();
      params.append("operation", "repeatAsignacion");
      params.append("idactivo", idactivo);
      params.append("idusuario", userList[i]);
  
      const data = await getDatos(`${host}/respActivo.controller.php`, params);
      //console.log("responsables rept ", data[0].cantidad);
      
      if(data[0].cantidad>0){
        cont++;
      }
    }
    console.log("responsables rept cont", cont);
    
    return cont;
  }

  async function contColaboradores() {
    const params = new URLSearchParams();
    params.append("operation", "maxColaboradores");
    params.append("idactivo", idactivo);

    const data = await getDatos(`${host}/respActivo.controller.php`, params);
    return data;
  }

  async function createNotification(id, idactivo=0) {

    const params = new FormData();
    params.append("operation", "add");
    params.append("idactivo_resp", id);
    params.append("tipo", "Asignacion");
    params.append("mensaje", "Te han asignado un activo!");
    params.append("idactivo", idactivo===0?"":idactivo);

    const options = {
      method: "post",
      body: params
    };

    const data = await fetch(`${host}/notificacion.controller.php`, options);
    let valor = await data.json();

    return (valor.respuesta > 0);
  }


  async function addHistorialActivo(id) {
    const iduser = await getIdUser(selector("nomuser").textContent);

    const params = new FormData();
    params.append("operation", "add");
    params.append("idactivo_resp", id.idresp);
    params.append("idubicacion", selector("ubicacion").value);
    params.append("accion", "Nueva Asignacion");
    params.append("responsable_accion", iduser);

    const option = {
      method: "POST",
      body: params
    };
    const data = await fetch(`http://localhost/CMMS/controllers/historialactivo.controller.php`, option);
    return await data.json();
  }

    /**
   * Obtiene el idusuario segun el nombre del usuario
   * @param {*} user nombre del usuario
   * @returns El id del usuario
   */
  async function getIdUser(user) {
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", user);

    const data = await getDatos(
      `${host}/usuarios.controller.php`,
      params
    );
    return data[0].id_usuario;
  }

  selector("form-responsables").addEventListener("submit", async (e) => {
    e.preventDefault();
    await validateUsers();
    //console.log(replaceWords(selector("condicion").value,['<p>','</p>'],'').trim());
    if(userList.length===0){
      alert("Elige al menos un usuario para la asignacion");
      maxResp=true;
    }
    if(acumMB>3.50){
      alert(`Limite permitido de imagenes (3.5MB/${acumMB}MB)`);
      //console.log(acumMB>3.70);
      maxResp=true;
    }
    if(!maxResp){
      if (confirm("¿Estas seguro de registrar?")){
        await addOnCascade();
      }
    }
  });

  document.addEventListener("click", (event) => {
    const activoInput = selector("activo");
    const list = selector("list");

    // Verificar si el clic ocurrió fuera del input y de la lista
    if (!activoInput.contains(event.target) && !list.contains(event.target)) {
      list.classList.remove('visible'); // Ocultar lista
    }
  });

  selector("activo").addEventListener("keyup", async () => {
    let valor = selector("activo").value;
    let list = selector("list");

    const params = new URLSearchParams();
    params.append("operation", "searchDescripcion");
    params.append("descripcion", valor);

    fetch(`http://localhost/CMMS/controllers/activo.controller.php?${params}`)
      .then(response => response.json())
      .then(data => {
        console.log(data);

        list.innerHTML = "";
        list.style.display = 'block';

        list.classList.add('visible');
        if (data.length > 0) {
          data.forEach(x => {
            const option = document.createElement("li");
            option.textContent = `${x.descripcion}`;
            //option.setAttribute("data-id", `${x.idsolicitud}`);

            option.addEventListener("click", async() => {
              selector("activo").value = `${x.descripcion}`;
              list.innerHTML = "";
              list.classList.remove('visible');
              idactivo = x.idactivo;
              await getUbiByActivo();
            });
            list.appendChild(option);
          });
        } else {

          const option = document.createElement("li");
          option.textContent = "No encontrado";
          list.appendChild(option);
        }

      });
  });

  
  (async () => {
    let user = "";
    if (selector("rolUser").textContent != "Administrador") {
      user = selector("nomuser").textContent;
    }
    //console.log(user);

    const data = await getDatos("http://localhost/CMMS/controllers/usuarios.controller.php", `operation=getData`);

    data.forEach(x => {
      selector("tb-users tbody").innerHTML += `
      <tr>
        <td>${x.id_usuario}</td>
        <td>${x.usuario}</td>
        <td>${x.rol}</td>
        <td class="text-center">
          <input type="checkbox" class="list-chk" data-idusuario="${x.id_usuario}" required/>
        </td>
      </tr>
    `;
    });
    selectChks();
  })();

  function selectChks() {
    document.querySelectorAll(".list-chk").forEach(chk => {
      //const data = document.querySelectorAll(".list-chk");
      chk.addEventListener("change", (e) => {
        if (e.target.checked) {
          isClicked = true;
          userList.push(parseInt(e.target.dataset.idusuario));
          //console.log(e.target.dataset.idusuario);

        } else {
          isClicked = false;
        }
      });
    });
  }

  selector("modalResp").addEventListener("click",()=>{
    //userList=[];
    const modalResp = new bootstrap.Modal(selector("modalResponsables"));
    modalResp.show();
  });

  selector("btmM-save").addEventListener("click", async() => {
    if(validateCheckBox()>=1){
      isClicked=true;
    }else{isClicked=false;}
    if (!isClicked) {
      alert("Tienes que seleccionar al menos 1");

    } else {
      await validateUsers()

      if(!maxResp){
        alert("correcto");
        
        console.log(userList);
        
        const myModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalResponsables'));
        myModal.hide();
        
      }

    }
  });

  //Boton de cerrar modal de usuarios
  selector("btn-modalRes-cerrar").addEventListener("click",()=>{
    userList=[];
    console.log("a");
    
    const myModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalResponsables'));
    myModal.hide();
    
  });

  function validateCheckBox(){
    let contChks =0;
    userList=[];
    document.querySelectorAll(".list-chk").forEach(x=>{
      if(x.checked){
        contChks++;
        userList.push(parseInt(x.getAttribute("data-idusuario")));
        console.log(x.getAttribute("data-idusuario"));
      }
      
    });
    return contChks;
  }

  async function addOnCascade() {
    for (let i = 0; i < userList.length; i++) {
      const data = await getData(userList[i]);
      console.log("cascade: ", data);

      if (!data) {
        alert("Hubo un error al registrar");
        break;
      }
    }
  }

  async function getUbiByActivo(){
    const params = new URLSearchParams();
    params.append("operation", 'getUbiOnlyActivo');
    params.append("idactivo", idactivo);
    const data = await getDatos(`${host}/historialactivo.controller.php`, params);
    if(data.length>0){
      selector("ubicacion").value=data[0].idubicacion;
      selector("ubicacion").disabled=true;
    }else{
      selector("ubicacion").value="";
      selector("ubicacion").disabled=false;
    }
  }

  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }

  async function validateUsers(){
    const cantResp = await contColaboradores();
    console.log("cant res: ",cantResp);
    
    if(cantResp>= 3){
      alert("El activo seleccionado ha superado el limite de colaboradores, es necesario asignar un responsable principal");
      
      maxResp = true;
    }else{
      maxResp=false;
    }

    if(userList.length>=4 && cantResp!==-1){
      alert("Has seleccionado la cantidad maxima de usuarios");
      maxResp = true;
    }

    const cantRepeat = await getResponsable();
    //console.log(cantRepeat);
    
    if(cantRepeat>0){
      alert(`Has elegido a un usuario ya asignado (${cantRepeat})`);
      maxResp=true;
    }
    console.log("submit", userList);
  }


  function createOption(value, text) {
    const element = document.createElement("option");
    element.value = value;
    element.innerText = text;
    return element;
  }

  (async () => {
    const data = await getDatos("http://localhost/CMMS/controllers/ubicacion.controller.php", "operation=getAll");
    data.forEach(x => {
      //console.log(x);

      const element = createOption(x.idubicacion, x.ubicacion);
      selector("ubicacion").appendChild(element);
    });
  })();


  // (async()=>{
  //   const params = new URLSearchParams();
  //   params.append("operation", "showImages");
  //   params.append("idactivo_resp", 2);
  //   const data = await getDatos("http://localhost/CMMS/controllers/respActivo.controller.php", params);
  //   console.log(JSON.parse(data[0].imagenes).image1.url);
  //   selector("imgtest").src=JSON.parse(data[0].imagenes).image1.url;
  // })();
//modalResponsables
})