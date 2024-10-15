<?php require_once '../header.php' ?>

<main class="mainActualizarPlan">
	<h1>Actualizar Plan de Tarea</h1>
	<h3>Plan de tarea</h3>
 	<label for="txtDescripcionPlanTarea">Descripcion</label>
	<input type="text" id="txtDescripcionPlanTarea" pattern="[a-zA-Z\s]+" title="Solo se permiten letras y espacios"
		required />
	<hr />
	<h3>Tareas</h3>
	<div style="display: flex">
		<div>
			<form action="" id="form-tarea">
				<label for="">Descripcion</label>
				<input type="text" id="txtDescripcionTarea" required />
				<label for="">Tiempo estimado</label>
				<input type="date" id="fecha-inicio" required />
				<input type="date" id="fecha-vencimiento" required />
				<button type="button" data-bs-toggle="modal" id="btnAsignarRecursos" data-bs-target="#asignarRecursos">
					Asignar recursos
				</button>
				<label for="">Intervalo</label>
				<input type="text" id="txtIntervaloTarea" required />
				<label for="">Frecuencia</label>
				<input type="text" id="txtFrecuenciaTarea" required />
				<select name="" id="tipoPrioridadTarea" required></select>

				<button type="submit" id="btnGuardarTarea">Guardar</button>
			</form>
		</div>
		<div>
			<h4>Tareas agregadas</h4>
			<ul class="listaTareasAgregadas"></ul>
		</div>
	</div>

	<hr />
	<h3>Activos</h3>
	<div style="display: flex">
		<div>
			<button type="button" data-bs-toggle="modal" id="btnSeleccionarActivo" data-bs-target="#seleccionActivo">
				Agregar activo a
			</button>
		</div>
		<div style="display: flex">
			<div>
				<h4>Activos agregadas</h4>
				<ul class="listaActivosAsignados"></ul>
			</div>
			<div>
				<h4>Activos para agregar (VISTA PREVIA)</h4>
				<ul class="listaActivosAsignadosPrevia"></ul>
			</div>
		</div>
	</div>
	<button id="btnConfirmarCambios">Confirmar cambios</button>

	<!-- BOOTSTRAP modal incio ASIGNAR RECURSOS -->
	<div class="modal fade" id="asignarRecursos" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
		aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h1 class="modal-title fs-5" id="staticBackdropLabel">
						Seleccion de recursos
					</h1>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<table class="table table-borderless">
						<thead>
							<tr>
								<th scope="col">#</th>
								<th scope="col">Recurso</th>
								<th scope="col">Costo</th>
								<th scope="col">Stock</th>
								<th scope="col">Cantidad</th>
							</tr>
						</thead>
						<tbody id="recursosBodyTable"></tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary btn-agregar-recursos" disabled>
						Agregar
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- bootrasp modal fin ASIGNAR RECURSOS -->

	<!-- bootstrap modal inicio  SELECCION DE ACTIVOs-->
	<div class="modal fade" id="seleccionActivo" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
		aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog modal-xl">
			<div class="modal-content">
				<div class="modal-header">
					<h1 class="modal-title fs-5" id="staticBackdropLabel">
						Elegir de activo
					</h1>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<table class="table table-borderless">
						<thead>
							<tr>
								<th scope="col">#</th>
								<th scope="col">Activo</th>
								<th scope="col">Código</th>
								<th scope="col">Categoria</th>
								<th scope="col">Subcategoria</th>
								<th scope="col">Marca</th>
								<th scope="col">Modelo</th>
							</tr>
						</thead>
						<tbody id="activosBodyTable"></tbody>
						<tfoot>
							<select name="" id="elegirTareaParaActivo"></select>
						</tfoot>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary btn-agregar-activos">
						Agregar
					</button>
				</div>
			</div>
		</div>
	</div>
</main>

<?php require_once '../footer.php' ?>

<script src="<?= $host ?>js/plantareas/actualizar-plan.js"></script>
<script src="https://unpkg.com/vanilla-datatables@latest/dist/vanilla-dataTables.min.js" type="text/javascript"></script>
</body>
</html>