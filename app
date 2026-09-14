<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <title>Admin - MUDITOOO BARBER</title>

  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
    }

    body {
      background: #111;
      color: white;
      padding: 20px;
    }

    .container {
      max-width: 900px;
      margin: auto;
    }

    header {
      text-align: center;
      padding: 25px 0;
    }

    header h1 {
      font-size: 30px;
    }

    header p {
      color: #aaa;
      margin-top: 8px;
    }

    .card {
      background: #1c1c1c;
      border-radius: 15px;
      padding: 20px;
      margin-bottom: 20px;
    }

    .turno {
      background: #292929;
      border-radius: 10px;
      padding: 16px;
      margin-bottom: 12px;
    }

    .turno strong {
      font-size: 18px;
    }

    .turno p {
      color: #bbb;
      margin-top: 6px;
    }

    .boton {
      display: inline-block;
      margin-top: 12px;
      padding: 10px 14px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: bold;
    }

    .cancelar {
      background: #8b2222;
      color: white;
    }

    .mensaje {
      text-align: center;
      color: #aaa;
      padding: 20px;
    }

    .volver {
      display: block;
      text-align: center;
      color: white;
      text-decoration: none;
      margin-top: 20px;
    }
  </style>
</head>

<body>

<div class="container">

  <header>
    <h1>✂️ MUDITOOO BARBER</h1>
    <p>Panel de administrador</p>
  </header>

  <div class="card">

    <h2>📅 Turnos</h2>

    <div id="turnos">
      <p class="mensaje">Cargando turnos...</p>
    </div>

  </div>

  <a href="index.html" class="volver">
    ← Volver a la página
  </a>

</div>


<script>

const SUPABASE_URL =
  "https://tfwejlwycexmcgznxlao.supabase.co";

const SUPABASE_KEY =
  "sb_publishable_RnheFzHcB78UTEaXBYOp9g_ZbktcycR";


async function cargarTurnos() {

  const contenedor =
    document.getElementById("turnos");

  try {

    const respuesta = await fetch(
      SUPABASE_URL +
      "/rest/v1/turnos" +
      "?select=*" +
      "&estado=eq.confirmado" +
      "&order=fecha.asc,hora.asc",
      {
        headers: {
          "apikey": SUPABASE_KEY,
          "Authorization":
            "Bearer " + SUPABASE_KEY
        }
      }
    );

    if (!respuesta.ok) {
      throw new Error("Error al cargar turnos");
    }

    const turnos =
      await respuesta.json();

    if (turnos.length === 0) {

      contenedor.innerHTML =
        '<p class="mensaje">No hay turnos reservados.</p>';

      return;
    }

    contenedor.innerHTML = "";

    turnos.forEach(function(turno) {

      const div =
        document.createElement("div");

      div.className = "turno";

      div.innerHTML = `
        <strong>
          ${turno.fecha} — ${turno.hora}
        </strong>

        <p>
          👤 ${turno.nombre}
        </p>

        <p>
          📱 ${turno.telefono}
        </p>

        <button
          class="boton cancelar"
          onclick="cancelarTurno(${turno.id})"
        >
          Cancelar turno
        </button>
      `;

      contenedor.appendChild(div);

    });

  } catch (error) {

    console.error(error);

    contenedor.innerHTML =
      '<p class="mensaje">No se pudieron cargar los turnos.</p>';

  }

}


async function cancelarTurno(id) {

  const confirmar =
    confirm("¿Querés cancelar este turno?");

  if (!confirmar) {
    return;
  }

  try {

    const respuesta = await fetch(
      SUPABASE_URL +
      "/rest/v1/turnos?id=eq." +
      id,
      {
        method: "PATCH",

        headers: {
          "Content-Type":
            "application/json",

          "apikey":
            SUPABASE_KEY,

          "Authorization":
            "Bearer " + SUPABASE_KEY
        },

        body: JSON.stringify({
          estado: "cancelado"
        })
      }
    );

    if (!respuesta.ok) {
      throw new Error("No se pudo cancelar");
    }

    cargarTurnos();

  } catch (error) {

    console.error(error);

    alert(
      "No se pudo cancelar el turno."
    );

  }

}


cargarTurnos();

</script>

</body>
</html>
