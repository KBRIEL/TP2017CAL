//TP1
class Companiero{
	var energia=0
	var mochila=[]
	
	
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
	var cientifico= rick
	
	
	method cientifico(){
		return  rick
	}
	method cambiarCientifico(unCientifico){
		cientifico=unCientifico
	}
	method estaAlegre(unCientifico, materialARecolectar){
		return materialARecolectar.estaVivo() or
			 not (self.cientifico()==unCientifico) 
	}
	
	override method puedeRecolectar(unMaterial){
		return if (self.estaAlegre(rick, unMaterial ) )
			{super(unMaterial)}
			else{
			(mochila.size()==0)and 
			(self.energia()>=unMaterial.energiaDeRecoleccion())
		}
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
	var companiero = morty
	var mochila=[]
	var experimentosConocidos =#{new ExperimentoBateria(), new ExperimentoCircuito(), new ExperimentoShockElectrico()}
	
	
	method verMochila(){
		return mochila
	}
	
	method vaciarMochila(){
		mochila=[]
	}
	method cambiarCompaniero(unCompaniero){
		companiero=unCompaniero
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
		//agregar un getName a los experimentos, y podriamos comparar con los experimentos que puede realizar
		//experimentosQuePuedeRealizar.contains({e=> e.getName() == unExperimento.getName())})
		
		if (not unExperimento.puedeRealizar(mochila)){
			self.error("No puedo realizar el experimento: " + unExperimento)
		}
		unExperimento.crearExperimento(self)
	}
	method getCompaniero() = companiero
	method getMochila() = mochila
}

//--------------------------------------------------------------------------------------
class Experimento { //Los experimentos una vez creados, tienen el comportamiento de un material, 
				  					   // y son considerados como tal 
	var componentes =#{}
	
	method crearExperimento(unCientifico) //crear experimento incluye el aplicar un efecto, y a�adir el material resultante a la mochila
																						//en caso de ser necesario.
	{
		unCientifico.removerMateriales(componentes) // com�n a todos los experimentos.
		self.aplicarEfecto(unCientifico.getCompaniero())
	}
	method aplicarEfecto(unCompaniero){
		//nothing
	}
	method puedeRealizar(mochila)
}

class ExperimentoBateria inherits Experimento{
	
	override method puedeRealizar(mochila){
		return mochila.any({elem=>elem.gramosDeMetal()>200}) && mochila.any({elem=>elem.esRadioactivo()})
	}
	
	override method crearExperimento(unCientifico){
		componentes = #{unCientifico.getMochila().find({elem=>elem.gramosDeMetal()>200})
					  , unCientifico.getMochila().find({elem=>elem.esRadioactivo()})
					   }
					   super(unCientifico)
					   unCientifico.recibir(#{self})
	}
	override method aplicarEfecto(unCompaniero){
		unCompaniero.cambioEnergia(-5)
	}
	
}

class ExperimentoCircuito inherits Experimento{
	
	override method puedeRealizar(mochila){
		return mochila.any({e => e.electricidadQueConduce() >= 5})
	}

	override method crearExperimento(unCientifico){
		if(self.puedeRealizar(unCientifico.getMochila())){
		componentes = (unCientifico.getMochila().filter({e => e.electricidadQueConduce() >= 5})).asSet() //simplemente para que todos sean conjuntos, no modifica.
			super(unCientifico)
			unCientifico.recibir(#{self}) //<-- recibir(x) espera un conjunto en x.
			}
	}
	
}

class ExperimentoShockElectrico inherits Experimento{
	
	override method puedeRealizar(mochila){
		return mochila.any({e => e.energiaProducida()>0}) && mochila.any({e => e.electricidadQueConduce() > 0})
	}
	
	override method crearExperimento(unCientifico){
	componentes = #{unCientifico.getMochila().find({e => e.energiaProducida()>0})
					, unCientifico.getMochila().find({e => e.electricidadQueConduce() > 0})
					}
					super(unCientifico)
	}
	override method aplicarEfecto(unCompaniero){
		var energiaGanada = componentes.find({e => e.energiaProducida()>0}).energiaProducida() 
											* 
						componentes.find({e => e.electricidadQueConduce() > 0}).electricidadQueConduce()
		/*Fin c�lculo energ�a. */
		unCompaniero.cambioEnergia(energiaGanada)
	}
}


//------------------------------------------------------------------------
class Bateria inherits Material {
	var componentes=#{}
//		constructor (lsComponentes){
//			componentes = (lsComponentes.find({elem=>elem.gramosDeMetal()>200}) 
//						+ lsComponentes.find({elem=>elem.esRadioactivo()})).asSet()
//		}               ^ lata no entiende el mensaje "+"!!

	method puedeRealizar(mochila){
		return mochila.any({elem=>elem.gramosDeMetal()>200}) && mochila.any({elem=>elem.esRadioactivo()})
	}
	
	
	 
	
	override method gramosDeMetal(){
		return componentes.sum({elem=>elem.gramosDeMetal()})
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
		var componentes=#{}
	//	constructor (lsComponentes){
	//	componentes = lsComponentes.filter({e => e.electricidadQueConduce() >= 5}) //<-- devuelve una lista!
	//	}

	
	 
	override method energiaProducida(){
		return 	0
		
		}
		
	override method gramosDeMetal(){
		return componentes.sum({elem=>elem.gramosDeMetal()})
	}	
	
	override method electricidadQueConduce(){
		return componentes.sum({elem=>elem.electricidadQueConduce()})*3
	}	
	
	override method esRadioactivo(){
		return componentes.any({elem =>elem.esRadiactivo()})
	}
}

class ShockElectrico inherits Material {
	var componentes =#{}
	
		
	
	override method gramosDeMetal(){
		return 0
	//nothing
	}
	override method electricidadQueConduce(){
		return 0//nothing
	}

}
//----------------------------------------------------- parte 4

class ParasitoAlienigena {
	var recolector=morty
	var acciones
	var cientifico=rick
	
	constructor(lasAcciones){
		acciones=lasAcciones
	}
	method cambiarRecolector(unRecolector){
		recolector = unRecolector
	}
	method cambiarCientifico(unCientifico){
	cientifico = unCientifico
	}
	method gramosDeMetal(){
		return 10
	}
	method electricidadQueConduce(){
		return false
	}
	method recolector()=recolector
	method esRadioactivo(){
		return false
	}
	method energiaProducida(){
		return 5
	}
	
	method recoleccion(unRecolector){
		acciones.map({elem=>elem.companieroEs(unRecolector)})
		acciones.map({elem=>elem.efecto()})		
	}
	
	method energiaDeRecoleccion(){
		return 0
	}
	method estaVivo(){
		return true
	}
	
}



object entregarTodo{
	var cientifico = rick
	var companiero= morty
	
	method cientificoEs(unCientifico){
		cientifico=unCientifico
	}
	method companieroEs(unCompaniero){
		companiero=unCompaniero
	}
	method efecto(){
		companiero.darObjetosA(cientifico)
	
	}
}

object descartarUnElemento{
	var cientifico = rick
	var companiero= morty
	
	method cientificoEs(unCientifico){
		cientifico=unCientifico
	}
	method companieroEs(unCompaniero){
		companiero=unCompaniero
	}
	method efecto(){
		if (companiero.mochila().size()>0)
			{ companiero.mochila().remove(companiero.mochila().get(0))}
			
	
	}
}

class IncrementaODecrementaEnergia{//la acci�n energiaParaEfecto(porcentaje) se configura al inicio del juego
	var cientifico = rick
	var companiero= morty
	var porcentajeEnergia
	
	constructor( porcentaje){
		porcentajeEnergia = porcentaje
	}
	
	method cientificoEs(unCientifico){
		cientifico=unCientifico/100
	}
	method companieroEs(unCompaniero){
		companiero=unCompaniero
	}
	method energiaParaEfecto(porcentaje){// es el porcentaje ejem 10 es el 10%
		 porcentajeEnergia= porcentaje/100
	}
	method efecto(){
		companiero.cambioEnergia(companiero.energia()* porcentajeEnergia)
	}
}

class ElementoOculto{//la acci�n elementoOculto(unElemento) se configura al inicio del juego
	var cientifico = rick
	var companiero= morty
	var elemento
	 
	constructor( unElemento){
		elemento = unElemento
	}
	method cientificoEs(unCientifico){
		cientifico=unCientifico
	}
	method companieroEs(unCompaniero){
		companiero=unCompaniero
	}
	
	method efecto(){
		companiero.recolectar(elemento)
	}
}


