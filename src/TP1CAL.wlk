//TP1

object morty{
	var energia
	var mochila = [] //máximo 3
	
	method puedeRecolectar(_unMaterial){
		
	}
	
	method recolectar(_unMaterial){
		
	}
	method darObjetosA(_unCompaniero){
		
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
}
class Fleeb inherits Materiales{
	var materialesConsumidos =[]
	var edad
	constructor(_conjuntoMateriales, _edad){
		materialesConsumidos = _conjuntoMateriales
		edad = _edad
	}
	
}