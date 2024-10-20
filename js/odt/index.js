$(document).ready(async () => {
    alert("idusuarioxdd: "+ idusuario)
    function $q(object = null) {
        return document.querySelector(object);
    }

    function $all(object = null) {
        return document.querySelectorAll(object);
    }

    async function getDatos(link, params) {
        let data = await fetch(`${link}?${params}`);
        return data.json();
    }

    //variables
    const host = "http://localhost/CMMS/controllers/";




    async function obtenerTareas() {
        const paramsTareasSearch = new URLSearchParams()
        paramsTareasSearch.append("operation", "obtenerTareas")
        const tareasRegistradasObtenidas = await getDatos(`${host}tarea.controller.php`, paramsTareasSearch)
        console.log(tareasRegistradasObtenidas)
        return tareasRegistradasObtenidas
    }

    var kanban = new jKanban({
        element: '#kanban-container', // ID del contenedor
        boards: [
            {
                id: 'b-pendientes',
                title: 'Pendientes',
                class: 'pendientes',
                item: []
            },
            {
                id: 'b-proceso',
                title: 'En Proceso',
                class: 'proceso',
                item: []
            },
            {
                id: 'b-revision',
                title: 'En Revision',
                class: 'revision',
                item: []
            },
            {
                id: 'b-finalizadas',
                title: 'Finalizadas',
                class: 'finalizadas',
                item: []
            }
        ],
        dragBoards: false,
        widthBoard: '400px',
        dropEl: async function (el, target, source, sibling) {
            var cardId = el.getAttribute('data-eid'); // ID de la tarjeta
            var targetBoardId = target.parentElement.getAttribute('data-id'); // ID del board donde cayó la tarjeta
            console.log('Tarjeta ' + cardId + ' fue movida al board ' + targetBoardId);
            if (targetBoardId == "b-proceso") {
                const idOdt = await registrarOdt(cardId)
                console.log(idOdt)
                window.localStorage.setItem("idtarea", cardId)
                window.localStorage.setItem("idodt", idOdt.id)
                window.location.href = `http://localhost/CMMS/views/odt/registrar-odt.php`
            }
            //window.cookie = ``            
        },
        click: function (el) {
            var cardId = el.getAttribute('data-eid'); // Obtener el ID de la tarjeta
            console.log('Hiciste clic en la tarjeta con ID: ' + cardId);
        }
    });

    await renderTareasPendiente()

    async function renderTareasPendiente() {
        const tareas = await obtenerTareas()
        tareas.forEach(tarea => {
            const tareaHTML = `
                <h3 class="card-title">${tarea.descripcion}</h3>
                <p class=" mb-2 text-muted">Inicia: ${tarea.fecha_inicio} - Vence: ${tarea.fecha_vencimiento}</p>                 
                <p class="card-text">Plan de tarea: ${tarea.plantarea}</p>
                <p class="card-text">Activo: ${tarea.activo}</p>
                <p class="card-text"><small class="text-muted">Prioridad: ${tarea.prioridad}</small></p>
            `;
            // Asignar las tareas a diferentes boards según su estado
            switch (tarea.nom_estado) {
                case 'pendiente':
                    kanban.addElement('b-pendientes', {
                        id: tarea.idtarea, // Usamos el idtarea como id de la tarjeta
                        title: tareaHTML // Usamos el HTML que hemos creado
                    });
                    break;
                case 'En Proceso':
                    kanban.addElement('b-proceso', {
                        id: tarea.idtarea,
                        title: tareaHTML
                    });
                    break;
                case 'En Revision':
                    kanban.addElement('b-revision', {
                        id: tarea.idtarea,
                        title: tareaHTML
                    });
                    break;
                case 'Finalizada':
                    kanban.addElement('b-finalizadas', {
                        id: tarea.idtarea,
                        title: tareaHTML
                    });
                    break;
                default:
                    console.log('Estado desconocido:', tarea.nom_estado);
            }
        });

        return tareas
    }

    async function registrarOdt(idtarea) {
        const formOdt = new FormData()
        formOdt.append("operation", "add")
        formOdt.append("idtarea", idtarea)
        formOdt.append("creado_por", idusuario)
        const dataOdt = await fetch(`${host}ordentrabajo.controller.php`, { method: 'POST', body: formOdt })
        const idodt = await dataOdt.json()
        return idodt
    }
})