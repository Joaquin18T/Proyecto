// const routes = {
//     "registerActivo":"http://localhost/CMMS/views/activo/register-activo.php",
//     "Activos":"http://localhost/CMMS/views/activo/",
//     "Responsables":"http://localhost/CMMS/views/responsables/resp-activo.php",
//     "ODT":'http://localhost/CMMS/views/modules/Activo/registerActivo.php',
//     "planTarea":'http://localhost/CMMS/views/modules/Activo/registerActivo.php',
//     "bajaActivo":'http://localhost/CMMS/views/modules/Activo/registerActivo.php',
//     "ListaUsuario":'http://localhost/CMMS/views/modules/Activo/registerActivo.php',
//     "PermisoRol":'http://localhost/CMMS/views/modules/Activo/registerActivo.php'
//   };

//   let rolUser = document.querySelector("#rolUser").innerText;
//   let show=[];
//   function showModule(){
//     fetch(`http://localhost/CMMS/controllers/permisos.api.php?rol=${rolUser}`)
//     .then(response=>response.json())
//     .then(data=>{
//       renderModules(data.respuesta);
//     });
//     //.catch(e=>{console.error(e)})
//   }
//   showModule();
//   function renderModules(permisos){
//     let menu = document.querySelector("#menu");

//     for(const modulo in permisos){
//       const subModule = permisos[modulo];

//       const moduleItem = document.createElement("li");
//       moduleItem.textContent = modulo;

//       const subList = document.createElement("ul");

//       for(const sub in subModule){
        
//         const acciones = subModule[sub];
        
//         if(typeof acciones ==="object" && !Array.isArray(acciones)){
//           const hasPermission = Object.values(acciones).some(permiso=>permiso);
          
//           const subItem = document.createElement("li");
//           const subLink = document.createElement("a");

//           subLink.textContent = sub;
//           //console.log(sub);
          
//           //console.log(routes[sub]);
          
//           subLink.href = routes[sub]||'#';

//           if(!hasPermission){
//             subItem.classList.add('disabled');
//             subLink.href="#";
          
//           }
//           subItem.appendChild(subLink);
//           subList.appendChild(subItem);

//         }
//       }
//       if(subList.children.length>0){

//         moduleItem.appendChild(subList);
//       }
//       menu.appendChild(moduleItem);

//     }
//   }


