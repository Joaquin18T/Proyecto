let permisos={
  "Usuario" : {
    "activos":{
      "asignarActivo":{"read":true,"create":true,"update":false,"delete":false
      },
      "Responsables":{"read":true,"create":true,"update":false,"delete":false}
    },
    "ODT":{
      "read":true,
      "create": true,
      "update":false,
      "delete":false
    },
    "planTarea":{
      "read":true,
      "create": false,
      "update":false,
      "delete":false
    },
    "bajaActivo":{
      "read":true,
      "create": true,
      "update":false,
      "delete":false
    },
    "usuarios":{
      "ListaUsuario":{
        "read":false,
        "create": false,
        "update":false,
        "delete":false
      },
      "PermisoRol":{
        "read":false,
        "create": false,
        "update":false,
        "delete":false
      },
    }
  },
  "Administrador" : {
    "activos":{
      "asignarActivo":{"read":true,"create":true,"update":false,"delete":false}
    },
    "ODT":{
      "read":true,
      "create": true,
      "update":true,
      "delete":false
    },
    "PlanTarea":{
      "read":true,
      "create": true,
      "update":false,
      "delete":false
    },
    "BajaActivo":{
      "read":true,
      "create": true,
      "update":true,
      "delete":false
    },
    "usuarios":{
      "ListaUsuario":{
        "read":false,
        "create": false,
        "update":false,
        "delete":false
      },
      "PermisoRol":{
        "read":false,
        "create": false,
        "update":false,
        "delete":false
      },
    }
  }
};

//Agregar
permisos.Usuario["Test"]={
  "read":false,
  "create": false,
  "update":false,
  "delete":false
}

//Eliminar
delete permisos.Usuario.activos["Test"];