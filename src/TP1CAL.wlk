//TP1
class Companiero{
	var energia=0
	var mochila=[]
	var cientifico= rick //default
	
	method cambiarCientifico(unCientifico) {
		cientifico=unCientifico
	}
	method getCientifico() = cientifico
	method recolectar(unMaterial){
		if (not (self.puedeRecolectar(unMaterial)))
			{
				self.error("No puede recolectar: " + unMaterial)
			}
			mochila.add(unMaterial)
			unMaterial.recoleccion(self)
		
	}
	
	method darObjetosA(unCientifico){  //cambio nombre de unCompaniero a unCientifico, para evitar confusiones.
		unCientifico.recibir(mochila)
		mochila.clear()
	}
	method energia(){
		return energia
	}
	method cambioEnergia(_energia){
		energia= energia + _energia
		
	}
	method puedeRecolectar(unMaterial){
		return (mochila.size()<3)and 
			(self.energia()>=unMaterial.energiaDeRecoleccion())
	}
	
	method sinEnergia(){
		energia= 0
	}
}

object summer inherits Companiero{
	
	override method puedeRecolectar(unMaterial){
		return (mochila.size()<2)and 
			(self.energia()>=unMaterial.energiaDeRecoleccion()*0.8)
	}
	
	override method darObjetosA(unCientifico){  //cambio nombre de unCompaniero a unCientifico, para evitar confusiones.
		unCientifico.recibir(mochila)
		mochila.clear()
		self.cambioEnergia(-10)
	}
	
}
	
object jerry inherits Companiero{
	
	method estaAlegre() {
		return !cientifico.equals(rick) || mochila.any({e=> e.estaVivo()})
	}
	
	override method puedeRecolectar(unMaterial) {
		return if (self.estaAlegre()) super(unMaterial)
												else{
													(mochila.size()==0)and 
													(self.energia()>=unMaterial.energiaDeRecoleccion()) }
	}
	
}

object morty inherits Companiero{
	
	method mochila(){
		return mochila
	}
}
//-----------------------------------------------------------------------------
class Material {
	method gramosDeMetal()
	method electricidadQueConduce()
	method esRadioactivo(){
		return false
	}
	method energiaProducida(){
		return 0
	}
	method recoleccion(recolector){
		recolector.cambioEnergia(- self.energiaDeRecoleccion())		
	}
	method energiaDeRecoleccion(){
		return self.gramosDeMetal()
	}
	method estaVivo(){
		return false
	}
	
}

class Lata inherits Material {
	var metal
	constructor(cantMetal){
		metal = cantMetal
	}
	override method gramosDeMetal(){
		return metal
	}
	override method electricidadQueConduce(){
		return 0.1 * metal
	}
	
	
}

class Cable inherits Material{
	var longitud
	var seccion
	constructor(_longitud, _seccion){
		longitud = _longitud
		seccion = _seccion
	}
		override method gramosDeMetal(){
			return (longitud /1000) * seccion
		}
		override method electricidadQueConduce(){
			return 3*seccion
		}
		
}

class MateriaOscura inherits Material{
	var materialBase
	constructor(unMaterial){
		materialBase = unMaterial
	}
	override method electricidadQueConduce(){
		return materialBase.electricidadQueConduce() / 2
	}
	override method gramosDeMetal(){
		return materialBase.gramosDeMetal()
	}
	override method energiaProducida(){
		return materialBase.energiaProducida() * 2
	}
	override method recoleccion(recolector){
		materialBase.recoleccion(recolector)
	}
	
}
class Fleeb inherits Material{
	var materialesConsumidos =[]
	var edad
	
	constructor(listaMateriales, _edad){
		materialesConsumidos = listaMateriales
		edad = _edad
	}
	
	
	override method gramosDeMetal(){
		return materialesConsumidos.sum({elem=>elem.gramosDeMetal()})
	}
	override method electricidadQueConduce(){
		return (materialesConsumidos.min({elem=>elem.electricidadQueConduce()})).electricidadQueConduce()
	}
	override method esRadioactivo(){
		return edad>15
	}
	override method energiaProducida(){
		return (materialesConsumidos.max({elem=>elem.energiaProducida()})).energiaProducida()
	}
	override method recoleccion(recolector){
		recolector.cambioEnergia(- (self.energiaDeRecoleccion()))
		if (not self.esRadioactivo())
			{recolector.cambioEnergia(10)}	
	}
	override method energiaDeRecoleccion(){
		return self.gramosDeMetal()*2
	}
	
	override method estaVivo(){
		return true
	}
}

	


//-----------------------------------------------------------------------------------------	
object rick{
	var companiero = morty //default
	var mochila=[]
	var experimentosConocidos =#{experimentoBateria, experimentoCircuito, experimentoShockElectrico}
	var estrategia = inteligenciaAzar //default
	
	method verMochila(){
		return mochila
	}
	
	method vaciarMochila(){
		mochila=[]
	}
	method cambiarCompaniero(unCompaniero){
		companiero=unCompaniero
	}
	method setEstrategia(_estrategia){
		estrategia = _estrategia
	}
	
	method experimentosQuePuedeRealizar(){
		return experimentosConocidos.filter({e => e.puedeRealizar(mochila)})
	}
	
	method recibir(unosMateriales){
		mochila = mochila + unosMateriales
	}
	method removerMateriales(materialesARemover){
		mochila.removeAll(materialesARemover)
	}
	method realizar(unExperimento){
		//experimentosQuePuedeRealizar.contains({e=> e.getName() == unExperimento.getName())})
		
		if (not self.experimentosQuePuedeRealizar().contains(unExperimento)){
			self.error("No puedo realizar el experimento: " + unExperimento)
		}
		unExperimento.crearExperimento(self)
	}
	method conseguirMateriales(bloqueFiltro){
		return estrategia.elegir(mochila.filter(bloqueFiltro))
	}
	method getCompaniero() = companiero
	method getMochila() = mochila
}

//--------------------------------------------------------------------------------------
class Experimento { //Los experimentos una vez creados, tienen el comportamiento de un material, 
				  					   // y son considerados como tal 
	
	method crearExperimento(unCientifico) //crear experimento incluye el aplicar un efecto, y a�adir el material resultante a la mochila
																						//en caso de ser necesario.
	{
		var componentes= self.filtrado(unCientifico)
		unCientifico.removerMateriales(componentes) // com�n a todos los experimentos.
		self.aplicarEfecto(unCientifico.getCompaniero())
		unCientifico.recibir(#{self.nuevoMaterial(componentes)})
	}
	method filtrado(unCientifico)
	method aplicarEfecto(unCompaniero){
		//nothing
	}
	method puedeRealizar(mochila)
	method nuevoMaterial(componentes)
}

object experimentoBateria inherits Experimento{
	
	override method puedeRealizar(mochila){
		return mochila.any({elem=>elem.gramosDeMetal()>200}) && mochila.any({elem=>elem.esRadioactivo()})
	}
	override method filtrado(unCientifico){
		return #{unCientifico.conseguirMateriales({elem=>elem.gramosDeMetal()>200})
					  , unCientifico.conseguirMateriales({elem=>elem.esRadioactivo()})
					   }
	}
	override method nuevoMaterial(componentes){
		return new Bateria(componentes.sum({e=> e.gramosDeMetal()}))
	}
	
	override method aplicarEfecto(unCompaniero){
		unCompaniero.cambioEnergia(-5)
	}
	
}

object experimentoCircuito inherits Experimento{
	
	override method puedeRealizar(mochila){
		return mochila.any({e => e.electricidadQueConduce() >= 5})
	}
	override method nuevoMaterial(componentes){
		return new Circuito(componentes.sum({elem=>elem.gramosDeMetal()}) 
											  , componentes.sum({elem=>elem.electricidadQueConduce()})*3
											  , componentes.any({elem =>elem.esRadiactivo()}))
	}
	override method filtrado(unCientifico){
		return unCientifico.getMochila().filter({e => e.electricidadQueConduce() >= 5}).asSet() //simplemente para que todos sean conjuntos, no modifica.
	}	
}

object experimentoShockElectrico inherits Experimento{
	override method puedeRealizar(mochila){
		return mochila.any({e => e.energiaProducida()>0}) && mochila.any({e => e.electricidadQueConduce() > 0})
	}
	override method nuevoMaterial(componentes){
		self.error('no debería entrar acá')
	}
	override method filtrado(unCientifico){
		self.error('no debería entrar aca')
	}
	
	override method crearExperimento(unCientifico){
	var componentes = #{unCientifico.conseguirMateriales({e => e.energiaProducida()>0})
					, unCientifico.conseguirMateriales({e => e.electricidadQueConduce() > 0})
					}
					self.aplicarEfecto(unCientifico, componentes)
					
	}
	method aplicarEfecto(unCompaniero, componentes){
		var energiaGanada = componentes.find({e => e.energiaProducida()>0}).energiaProducida() 
											* 
						componentes.find({e => e.electricidadQueConduce() > 0}).electricidadQueConduce()
		/*Fin c�lculo energ�a. */
		unCompaniero.cambioEnergia(energiaGanada)
	}
}


//------------------------------------------------------------------------
class Bateria inherits Material {
	var metal
		constructor (_metal){
			metal = _metal
		}
	
	override method gramosDeMetal(){
		return metal
	}
	override method energiaProducida(){
		return self.gramosDeMetal()*2
	}
	
	override method esRadioactivo(){
		return true
	}
	
	override method electricidadQueConduce(){
			return 0
		}
	
}

class Circuito inherits Material {
	var metal
	var electricidadAConducir
	var radioactivo
	
		constructor (_metal, _electricidad, _radioactivo){
			metal = _metal
			electricidadAConducir = _electricidad
			radioactivo = _radioactivo
		}
	 
	override method energiaProducida(){
		return 	0
		
		}
		
	override method gramosDeMetal(){
		return metal
	}	
	
	override method electricidadQueConduce(){
		return electricidadAConducir
	}	
	
	override method esRadioactivo(){
		return radioactivo
	}
}

//----------------------------------------------------- parte 4

class ParasitoAlienigena {
	var acciones
	
	constructor(_acciones){
		acciones= _acciones
	}

	method gramosDeMetal(){
		return 10
	}
	method electricidadQueConduce(){
		return 0
	}
	method esRadioactivo(){
		return false
	}
	method energiaProducida(){
		return 5
	}
	
	method recoleccion(unRecolector){
		acciones.forEach({accion =>
		accion.companieroEs(unRecolector)
		accion.efecto()
		})
	}
	
	method energiaDeRecoleccion(){
		return 0
	}
	method estaVivo(){
		return true
	}
	
}

object entregarTodo{
	var companiero= morty
	
	method companieroEs(unCompaniero){
		companiero=unCompaniero
	}
	method efecto(){
		companiero.darObjetosA(companiero.getCientifico())
	
	}
}

object descartarUnElemento{
	var companiero= morty
	
	method companieroEs(unCompaniero){
		companiero=unCompaniero
	}
	method efecto(){
		if (companiero.mochila().size()>0)
			{ companiero.mochila().remove(companiero.mochila().anyOne())}	
	}
}

class IncrementaODecrementaEnergia{//la acci�n energiaParaEfecto(porcentaje) se configura al inicio del juego
	var companiero= morty
	var porcentajeEnergia
	constructor(_porcentajeEnergia){// es el porcentaje ejem 10 es el 10%
									// positivo suma, negativo resta, ej: -10 resta el 10%
		porcentajeEnergia = _porcentajeEnergia / 100
	}
	method companieroEs(unCompaniero){
		companiero=unCompaniero
	}
	method efecto(){
		companiero.cambioEnergia(companiero.energia()* porcentajeEnergia)
	}
}

class ElementoOculto{//la acci�n elementoOculto(unElemento) se configura al inicio del juego
	var companiero= morty
	var elemento 
	
	constructor(_elemento){
		elemento = _elemento
	}
	method companieroEs(unCompaniero){
		companiero=unCompaniero
	}
	method efecto(){
		companiero.recolectar(elemento)
	}
}

//-----------------------------------------------
//P5

object inteligenciaAzar {
	method elegir(lsMateriales){
		return lsMateriales.anyOne()
	}
}

object inteligenciaMenorMetal{
	method elegir(lsMateriales){
		return lsMateriales.min({e=>e.gramosDeMetal()})
	}
}

object inteligenciaMejorGenerador{
	method elegir(lsMateriales){
		return lsMateriales.max({e=>e.energiaProducida()})
	}
}

object inteligenciaEcologico{ //se considera que si no se cumplen ninguna de las opciones, aplique la estrategia al azar
											                                              	//considerada por defecto ^
	method elegir(lsMateriales){
		var eleccion = inteligenciaAzar.elegir(lsMateriales)
		if (lsMateriales.any({e => e.estaVivo()})){
			eleccion = lsMateriales.find({e => e.estaVivo()})
		}else{
			if (lsMateriales.any({e => e.esRadioactivo()})){
				eleccion = lsMateriales.find({e => e.esRadioactivo()})
			}
		}
		return eleccion
		
		// hubiera preferido dejar 'azar' al inicio, if radioactivo segundo, if esta vivo tercero SIN ELSE intermedio
		// aunque de esa forma hay que leerlo "a la inversa"
	}
}
