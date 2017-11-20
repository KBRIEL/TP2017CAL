//TP1

object morty{
	var energia = 0
	var mochila = [] //tama�o m�ximo 3
	
	method puedeRecolectar(unMaterial){
		return (mochila.size()<3)and 
			(self.energia()>=unMaterial.energiaDeRecoleccion())
	}
	
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
	method sinEnergia(){
		energia= 0
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
		recolector.cambioEnergia(- self.gramosDeMetal())		
	}
	method energiaDeRecoleccion(){
		return self.gramosDeMetal()
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
		recolector.cambioEnergia(- (self.gramosDeMetal()*2))
		if (not self.esRadioactivo())
			{recolector.cambioEnergia(10)}	
	}
	override method energiaDeRecoleccion(){
		return self.gramosDeMetal()*2
	}
	
}

//-----------------------------------------------------------------------------------------	
object rick{
	var companiero = morty
	var mochila=[]
	var experimentosConocidos =#{new ExperimentoBateria(), new ExperimentoCircuito(), new ExperimentoShockElectrico()}
	
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

//---------------------------------------------------------------------------------------
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
