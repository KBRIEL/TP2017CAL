//TP1.....

object morty{
	var energia
	var mochila = [] //máximo 3
	
	method puedeRecolectar(_unMaterial){
		return (mochila.size()<3)and 
			(self.energia()>=_unMaterial.gramosDeMetal())
	}
	
	method recolectar(_unMaterial){
		if (not (self.puedeRecolectar(_unMaterial)))
			{
				self.error("No puede recolectar: " + _unMaterial)
			}
			mochila.add(_unMaterial)
			_unMaterial.recoleccion(self)
		
	}
	method darObjetosA(_unCompaniero){
		_unCompaniero.recibir(mochila)
		mochila.clear()
	}
	
	method energia(){
		return energia
	}
	method cambioEnergia(_energia){
		energia= energia + _energia
	}
}

class Materiales {
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
}

class Lata inherits Materiales {
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

class Cable inherits Materiales{
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

class MateriaOscura inherits Materiales{
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
class Fleeb inherits Materiales{
	var materialesConsumidos =[]
	var edad
	constructor(_conjuntoMateriales, _edad){
		materialesConsumidos = _conjuntoMateriales
		edad = _edad
	}
	
	
	override method gramosDeMetal(){
		return materialesConsumidos.sum({elem=>elem.gramosDeMetal()})
	}
	override method electricidadQueConduce(){
		return materialesConsumidos.min({elem=>elem.electricidadQueConduce()})
	}
	override method esRadioactivo(){
		return edad>15
	}
	override method energiaProducida(){
		return materialesConsumidos.max({elem=>elem.energiaProducida()})
	}
	override method recoleccion(recolector){
		recolector.cambioEnergia(- (self.gramosDeMetal()*2))
		if (not self.esRadioactivo())
			{recolector.cambioEnergia(10)}	
	}
}
	
object rick{
	var companiero = morty
	var mochila=[]
	var experimentosConocidos =#{new Bateria()}
	
	method cambiarCompaniero(unCompaniero){
		companiero=unCompaniero
	}
	
	method experimentosQuePuedeRealizar(){
		
	}
	
	method recibir(unosMateriales){
		mochila = mochila + unosMateriales
	}
	
	method realizar(unExperimento){
		
	}
}

class Pepita2 {
	method gramosDeMetal(){
		return 0
	}
}

class Bateria {
		var componentes
		constructor(){}
		constructor (lsComponentes){
			componentes = (lsComponentes.find({elem=>elem.gramosDeMetal()>200}) 
						+ lsComponentes.find({elem=>elem.esRadioactivo()})).asSet()
		}
	
	 method gramosDeMetal(){
		return componentes.sum({elem=>elem.gramosDeMetal()})
	}
	method energiaProducida(){
		return self.gramosDeMetal()*2
	}
	
	method esRadioactivo(){
		return true
	}
	
	method electricidadQueConduce(){
			return 0
		}
	
}

class Circuito {
		var componentes 
		
		constructor (lsComponentes){
			componentes = lsComponentes.filter({e => e.electricidadQueConduce() >= 5})
		}
	
	method energiaProducida(){
		return 	0
		
		}
	method gramosDeMetal(){
		return componentes.sum({elem=>elem.gramosDeMetal()})
	}	
	method electricidadQueConduce(){
		return componentes.sum({elem=>elem.electricidadQueConduce()})*3
	}	
	method esRadioactivo(){
		return componentes.any({elem =>elem.esRadiactivo()})
	}
}

class ShockElectrico {
	
}









