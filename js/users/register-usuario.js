document.addEventListener("DOMContentLoaded",async()=>{
  const btnEnviar = selector("btnEnviar");
  let idrol=0;

  blockCamps(true);

  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }
//getAll
  /*
    FUNCIONAMIENTOS PERSONA
  */
  async function personByNumDoc(){
    const data = await getDatos("http://localhost/CMMS/controllers/persona.controller.php",`operation=getByNumCode&num_doc=${selector("numDoc").value}`)
    return data;
    
  }

  (async()=>{
    const data = await getDatos("http://localhost/CMMS/controllers/tipodoc.controller.php", "operation=getAll");
    //console.log(data);
    data.forEach(x => {
      const element = document.createElement("option");
      element.textContent = x.tipodoc;
      element.value = x.idtipodoc;
      selector("tipodoc").appendChild(element);
    });
  })();



  selector("search").addEventListener("click",async()=>{
    const isNumeric = /^[0-9]+$/.test(selector("numDoc").value);
    const minLength = (selector("numDoc").value.length>=8);
    const validaNumDoc = selector("numDoc").value.length===8||selector("numDoc").value.length===20?true:false;
    if(selector("numDoc").value!=="" &&  isNumeric && minLength && validaNumDoc){
      const data = await personByNumDoc();
      const isblock = (data.length>0);
      blockCamps(isblock);
      
      //console.log(isblock);
      
      if(isblock){
        alert("Persona encontrada");
        btnEnviar.disabled=true;
        showDatos(data[0]);
      }else{
        resetUI();
        btnEnviar.disabled=false;
      }      
    }else{
      console.log(isNumeric);
      
      if(selector("numDoc").value===""){alert("Escribe un Num de Doc.");}
      else if(!isNumeric){ alert("Ingresa solo Numeros");}
      else if(!minLength){alert("El minimo es de 8 caracteres");}
      else if(!validaNumDoc){alert("La cantidad de digitos debe ser de 8 o 20");}
    }
    

  });

  function showDatos(data){
    selector("tipodoc").value=data.idtipodoc;
    selector("apellidos").value=data.apellidos;
    selector("nombres").value=data.nombres;
    selector("telefono").value=data.telefono;
    selector("genero").value=data.genero;
    selector("password").value = data.contrasena;
    selector("nacionalidad").value=data.nacionalidad;
    

    //si la persona tiene un usuario creado (crear un array)
    if(data.usuario==undefined){
      //selector("rol").disabled=false;
      alert("No tiene usuario");
      resetUI()
      blockCamps(true);
      //limpiar los campos de usuario y desactivarlos
    }else{
      selector("usuario").value=data.usuario;
      selector("rol").value=data.idrol;
    }
    
  }

  function blockCamps(isblock){
    selector("tipodoc").disabled=isblock;
    selector("apellidos").disabled=isblock;
    selector("nombres").disabled=isblock;
    selector("telefono").disabled=isblock;
    selector("genero").disabled=isblock;
    selector("nacionalidad").disabled=isblock;
    selector("usuario").disabled=isblock;
    selector("password").disabled=isblock;
    selector("rol").disabled=isblock;
  }

  function validateData(){
    const data =[
      selector("tipodoc").value,
      selector("numDoc").value,
      selector("apellidos").value,
      selector("nombres").value,
      selector("genero").value,
      selector("telefono").value,
      selector("nacionalidad").value,
      selector("usuario").value,
      selector("password").value
    ];
    const dataNumber = [idrol];

    let isValidate = data.every(x=>x!=="");
    let isValidateN = dataNumber.every(x=>x>=1);

    return (isValidate && isValidateN);
  }
  
  selector("form-person-user").addEventListener("submit",async (e)=>{
    e.preventDefault();

    const isValidate = validateData();
    const isUserUnike = await searchUser(selector("usuario").value);
    const isTelfUk = await searchTelf(selector("telefono").value);
    const validaNumDoc = selector("numDoc").value.length===8||selector("numDoc").value.length===20?true:false;

    const existNumDoc = await personByNumDoc();
    const numDocExist = (existNumDoc.length<1);
    console.log(existNumDoc);
    
    if(isValidate && isUserUnike.length===0 && isTelfUk.length===0 && numDocExist && validaNumDoc){
      //console.log(selector("password").value);
      
      if(confirm("¿Estas seguro de guardar?")){
        const params = new FormData();
        params.append("operation","add");
        params.append("idtipodoc", selector("tipodoc").value);
        params.append("num_doc", selector("numDoc").value);
        params.append("apellidos", selector("apellidos").value);
        params.append("nombres", selector("nombres").value);
        params.append("genero", selector("genero").value);
        params.append("telefono", selector("telefono").value);
        params.append("nacionalidad", selector("nacionalidad").value);

        const options = {
          method:"POST",
          body:params
        }

        fetch("http://localhost/CMMS/controllers/persona.controller.php", options)
        .then(response=>response.json())
        .then(data=>{
          //console.log(data.respuesta[0]);
          saveUser(data.respuesta[0]);
        });        
      }

    }else{
      if(isUserUnike.length>0){
        alert("El nombre de usuario ya existe, por favor escriba otro");
      }else if(isTelfUk.length>0){
        alert("El numero de telefono ya existe, por favor escriba otro");
      }else if(!numDocExist){
        alert("El num. de doc. ya existe");
      }else if(!validaNumDoc){
        alert("Tu num. de documento debe tener 8 caracteres o 20");
      }
    }

  });

  //Funcion para obtenes valores GET (mejorar el parametro values a un objeto)
  // async function byParams(url, operation, data=[]){
    
  //   const params = new URLSearchParams();
  //   params.append("operation", operation);
  //   params.append(`"${Object.keys(data[0])}"`, data[0].valor);

  //   const dataUser = await fetch(`${url}?${params}`);
  //   return dataUser.json();
  // }

  async function searchTelf(telf){
    const params = new URLSearchParams();
    params.append("operation", "searchTelf");
    params.append("telefono", telf);
    const data = await fetch(`http://localhost/CMMS/controllers/persona.controller.php?${params}`);
    return data.json();
  }

  /*
    FIN FUNCIONAMIENTOS PERSONA
  */
  // ---------------------------------------------------------------------------------------------------
   /*
    FUNCIONAMIENTOS USUARIO
   */ 

  //Funcion Buscar usuario
  async function searchUser(user) {
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", user);

    const data=fetch(`http://localhost/CMMS/controllers/usuarios.controller.php?${params}`);
    return (await data).json();
  }

  (async()=>{
    const data = await getDatos("http://localhost/CMMS/controllers/rol.controller.php", "operation=getAll");
    data.forEach(x=>{
      const element = document.createElement("option");
      element.textContent = x.rol;
      element.value = x.idrol;
      selector("rol").appendChild(element);
    });
    
  })();

  selector("rol").addEventListener("change",()=>{
    idrol = selector("rol").value;
  });

  function saveUser(id){
    const params = new FormData();
    params.append("operation", "add");
    params.append("idpersona", id.idpersona);
    params.append("idrol", idrol);
    params.append("usuario", selector("usuario").value);  // VALIDAR EL USUARIO (QUE SEA UNICO)
    params.append("contrasena", selector("password").value);

    const options = {
      method:"POST",
      body:params
    }

    fetch("http://localhost/CMMS/controllers/usuarios.controller.php", options)
    .then(response=>response.json())
    .then(data=>{
      if(data.respuesta>0){
        alert("Usuario registrado");
        resetUI();
        blockCamps(data.respuesta>0);
        selector("numDoc").value="";
        selector("numDoc").focus();
      }else{
        alert("Usuario no registrado");
      }
    })
  }

  function resetUI(){
    
    selector("tipodoc").value="";
    selector("apellidos").value="";
    selector("nombres").value="";
    selector("telefono").value="";
    selector("genero").value="";
    selector("nacionalidad").value="";
    selector("usuario").value="";
    selector("password").value="";
    selector("rol").value="";
  }
})