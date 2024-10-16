document.addEventListener("DOMContentLoaded",()=>{
  selector("usuario").disabled=true;
  //blockCamps(true);
  function selector(value) {
    return document.querySelector(`#${value}`);
  }

  async function getDatos(link, params) {
    let data = await fetch(`${link}?${params}`);
    return data.json();
  }

  (async()=>{
    const data = await getDatos("http://localhost/CMMS/controllers/tipodoc.controller.php", "operation=getAll");
    console.log(data);
    data.forEach(x => {
      const element = document.createElement("option");
      element.textContent = x.tipodoc;
      element.value = x.idtipodoc;
      selector("tipodoc").appendChild(element);
    });
  })();

  (async()=>{
    const iduser = localStorage.getItem("iduser");
    const params = new URLSearchParams();
    params.append("operation","getUsuarioPersona");
    params.append("idusuario",iduser);

    const data = await getDatos("http://localhost/CMMS/controllers/usuarios.controller.php", params);
    //console.log(data);
    
    if(data.length>0){
      showDatos(data[0]);
    }
  })();

  async function personByNumDoc(){
    const data = await getDatos("http://localhost/CMMS/controllers/persona.controller.php",`operation=getByNumCode&num_doc=${selector("numDoc").value}`)
    return data;
    
  }

  selector("search").addEventListener("click",async()=>{
    const isNumeric = /^[0-9]+$/.test(selector("numDoc").value);
    const minLength = (selector("numDoc").value.length>=8);
    if(selector("numDoc").value!=="" &&  isNumeric && minLength){
      const data = await personByNumDoc();
      const isblock = (data.length>0);
      blockCamps(isblock);
      
      //console.log(isblock);
      
      if(isblock){
        alert("Persona encontrada");
        blockCamps(true);
        //btnEnviar.disabled=true;
        showDatos(data[0]);
      }else{
        resetUI();
        btnEnviar.disabled=false;
      }      
    }else{
      //console.log(isNumeric);
      
      if(selector("numDoc").value===""){alert("Escribe un Num de Doc.");}
      else if(!isNumeric){ alert("Ingresa solo Numeros");}
      else if(!minLength){alert("El minimo es de 8 caracteres");}
      blockCamps(true);
    }
    
  });


  function showDatos(data){
    selector("numDoc").value = data.num_doc==undefined?selector("numDoc").value:data.num_doc;
    selector("tipodoc").value=data.idtipodoc;
    selector("apellidos").value=data.apellidos;
    selector("nombres").value=data.nombres;
    selector("telefono").value=data.telefono;
    selector("genero").value=data.genero;
    selector("rol").value=parseInt(data.idrol);
    selector("usuario").value=data.usuario;
    selector("rol").value=data.idrol;
    
    if(data.usuario!==null){
      //selector("rol").value=data.idrol;
      selector("usuario").value=data.usuario;
    }else{
      //selector("rol").disabled=false;
      alert("No tiene usuario");
      //limpiar los campos de usuario y desactivarlos
    }
    
  }

  async function searchTelf(telf){
    const params = new URLSearchParams();
    params.append("operation", "searchTelf");
    params.append("telefono", telf);
    const data = await fetch(`http://localhost/CMMS/controllers/persona.controller.php?${params}`);
    return data.json();
  }

  function blockCamps(isblock){
    selector("tipodoc").disabled=isblock;
    selector("apellidos").disabled=isblock;
    selector("nombres").disabled=isblock;
    //selector("telefono").disabled=isblock;
    selector("genero").disabled=isblock;
    selector("usuario").disabled=isblock;
    selector("rol").disabled=isblock;
  }

  async function updateDataPerson(idpersona){
    //console.log(idpersona);
    
    const params = new FormData();
    params.append("operation", "updatePersona");
    params.append("idpersona", idpersona);
    params.append("idtipodoc", selector("tipodoc").value);
    params.append("num_doc", selector("numDoc").value);
    params.append("apellidos", selector("apellidos").value);
    params.append("nombres", selector("nombres").value);
    params.append("genero", selector("genero").value);
    params.append("telefono", selector("telefono").value);

    const data = await fetch("http://localhost/CMMS/controllers/persona.controller.php",{
      method:'POST',
      body:params
    });

    const resp = await data.json();
    if(resp.respuesta>0){
      alert("Datos actualizados");
      resetUI();
      selector("numDoc").value = "";
      window.location.href="http://localhost/CMMS/views/usuarios/";
    }else{
      alert("Hubo un error en la actualizacion");
    }
  }

  //USUARIOS

  (async()=>{
    const data = await getDatos("http://localhost/CMMS/controllers/rol.controller.php", "operation=getAll");
    data.forEach(x=>{
      const element = document.createElement("option");
      element.textContent = x.rol;
      element.value = x.idrol;
      selector("rol").appendChild(element);
    });
    
  })();

  async function searchUser(user) {
    const params = new URLSearchParams();
    params.append("operation", "searchUser");
    params.append("usuario", user);

    const data=fetch(`http://localhost/CMMS/controllers/usuarios.controller.php?${params}`);
    return (await data).json();
  }

  selector("form-update-user").addEventListener("submit",async(e)=>{
    e.preventDefault();

    //const isUserUnike = await searchUser(selector("usuario").value);
    //const isTelfUk = await searchTelf(selector("telefono").value);

    const validaNumDoc = selector("numDoc").value.length>8&&selector("numDoc").value.length<20?false:true;
    const existNumDoc = await personByNumDoc();    

    const existND = (existNumDoc.length)<1;
    if(validaNumDoc){
      if(confirm("¿Estas seguro de actualizar los datos del usuario?")){
        const iduser = localStorage.getItem('iduser');
        const params = new FormData();
        params.append("operation", "updateUser");
        params.append("idusuario", iduser);
        params.append("idrol", parseInt(selector("rol").value));
        params.append("usuario", selector("usuario").value);
  
        const data = await fetch("http://localhost/CMMS/controllers/usuarios.controller.php",{
          method:'POST',
          body:params
        });
  
        const resp = await data.json();
  
        if(resp.respuesta>0){
          await updateDataPerson(resp.respuesta);
        }else{
          alert("Hubo un error en la actualizacion de datos del usuario");
        }

      }
    }else{
      if(!validaNumDoc){
        alert("Tu num. de documento debe tener 8 caracteres o 20");
      }
      // else if(!existND){
      //   alert("El Num Doc, ya existe");
      // }
      
      
    }
  });

  

  /**
   * Limpia los Campos de Texto y de seleccion.
   */
  function resetUI(){
    
    selector("tipodoc").value="";
    selector("apellidos").value="";
    selector("nombres").value="";
    selector("telefono").value="";
    selector("genero").value="";
    selector("usuario").value="";
    selector("rol").value="";
  }
});