// declaracion e inicializacion
const todoListEl = document.getElementById('todo-list');
const todoInputEl = document.getElementById('todo-input');
const todoFormEl = document.getElementById('todo-form');
const emptyEl = document.getElementById('empty');
const errorEl = document.getElementById('error');

//funcion, declaracion de funciones

//funcion de control de errores
function showError(message){
    errorEl.textContent = message;
    errorEl.style.display = message ? 'block':'none'; // es un operador ternario, si message es true da 'block', si es false da 'none'
}

//carga de tareas al iniciar
window.addEventListener('DOMContentLoaded', loadTodos); //espera a que el html este cargado y ejecuta la funcion loadtodos, antes del css

//funcion de carga--------------
async function loadTodos() {
    try{
        const res = await fetch('/api/todos');//te envio a la principal
        const todos = await res.json();// pero cargando e interpretando el json que teniams cargado
}
    catch(err){
        console.error(err);
        showError('error en la carga de tareas')
    }
}

//funcion de renderizacion (pintando)
function renderTodos(todos){
    //creamos un nuevo elemento  "web"  que ira en la ul de index.html
    todoListEl.innerHTML = '';

        if (!todos.length){// detecta si la lista de tareas (todos) esta vacia, y si lo eytsa muesta msj y encima detiene la ejecucion del codigo
            emptyEl.style.display = 'block';//muestra el tipco no hay tareas o simlires
            return; //aqui se detiene la funcion en este punto
        }
        emptyEl.style.display = 'none';//ocultamos elemento

        //teniendo una lista de tareas en condiciones
        todos.forEach(todo => {
            const li = document.createElement('li');
            li.className = 'todo-item';
            li.dataset.id = todo.id; //se guarda un dato dentro de cada li, o sea se inyecta el registro en cada li
        //ahora pintamos todo
        li.innerHTML = `
        
        <div class="todo-left">
            <input type="checkbox" class="todo-check" ${todo.completed ? 'checked': ''}/>
            <span class="todo-title ${todo.completed ? 'completed' : ''}">
            ${escapeHtml(todo.title)}
            </span>
        </div>
        <div class="todo-action">
            <button class="edit">editar</button>
            <button class="save">guardar</button>
            <button class="delete">borrar</button>
        </div>
        `;
       
            todoListEl.appendChild(li);//añade un elemento al final del array

        });
}

// añadiendo nuevas tareas ----- donde el formulario estara a la escucha continua
todoFormEl.addEventListener('submit', async (e) => {
    e.preventDefault();//eliminamos cualquier tipo de accion predeterminada
    showError('');

    const title = todoInputEl.value.trim(); //quita los espacios del prinipio y del fin
    if (!title){
        showError('Escribe un titulo para la tarea!');
        return;
    }
    try{
        const res = await fetch('/api/todos', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ title })
        });
        
        if(!res.ok){
            const data = await res.json();
            throw new Error(data.error || 'Error al crear la tarea');
        }

        //leer el mensaje da error que devuelve el servidor y lanzar una excepcion con ese msj

        //ahora toca hacer las cosas bien
        todoInputEl.value = '';//limpio el input de cualquier suciedad textual
        await loadTodos();//espera a que se cargue el nuevo listado con todo
}
    catch(err){
        console.error(err);
        showError(err.message);
    }
});

//subcontratando a los eventos: qué hago y cuando se hace
todoListEl.addEventListener('click', async (e) => {
    const li = e.target.closest('.todo-item');
    //encontraremos el elemento "mas cercano" a donde se produjo el clic
    if(!li) return; //por si acaso corto

    const id = li.dataset.id; //obtenemos la id del elemento clicado

    //eliminar
    if (e.target.classList.contains('delete')){await deleteTodo(id);}
    // editar
    if (e.target.classList.contains('edit')){startEdit(li);}
    //guardar
    if (e.target.classList.contains('save')){await saveEdit(li, id);}
    
});

//checkbox para comletar tarea
todoListEl.addEventListener('change', async (e) => {
    if (!e.target.classList.contains('todo-check')) return;

    const li = e.target.closest('.todo-item');
    const id = li.dataset.id;
    const completed = e.target.checked;
    await updateTodo(id, {completed});
});
