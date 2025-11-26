// declaracion e inicializacion --------------------------------------------
const express = require('express'); //importacion del framework express
const path = require ('path');

const app = express();
const PORT = 3000;

// MIDDLEWARE de parseo a JSO
app.use(express.json());

//ahora, vamos a ver donde estan los archivos estaticos (imagenes html etc)
app.use(express.static(path.join(__dirname,'public')));

// BBDD en memoria
let todos = []; // creacion de una lista vacia , array vacio sin elementos
let nextId = 1; //sirve para asignar identificadores unidos (ID) a cada tarea que agregues

//RUTAS API CRUD ---------------------------------------------------------------


// READ - Obtener todas las tareas si un cliente visita la URL
app.get('/api/todos', (req, res) => {res.json(todos)});

// CREATE (C) - Crear una tarea
app.post('/api/todos', (req, res) => {
    //titulo 
    const { title } = req.body;
    //el titulo esta vacio o solo tiene espacios?
    if (!title || !title.trim()){return res.status(400).json({error: 'el titulo es obligatorio'});
  }
    //creacion del nuevo elemento en el array, es decir, un nuevo objeto
    const newTodo = {
        id: nextId++,
        title: title.trim(),
        completed: false,
        createAt: new Date()
    };
  
    //grabando!
    todos.push(newTodo); //añade el resgistro al array
    res.status(201).json(newTodo); //creado!!
});