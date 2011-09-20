module RbfSom
  class Rbf
    attr_accessor :k, :patrones, :centroides, :reasignaciones, :first, :pesosSalida, :salidaOculta, :salida, :neuronas

    def initialize(k, patrones, neuronas)
      @k = k
      @patrones = []
      @centroides = []
      @reasignaciones = true
      @first = true
      @neuronas = neuronas
      @pesosSalida = []
      inicializarConjuntos(patrones)
      inicializar_pesos
    end

    def inicializarConjuntos(patrones)
      patrones.each do | patron |
        @patrones << { :patron => patron, :clase => rand(@k) }
      end
    end

    def inicializar_pesos
      for i in 0...@neuronas.last
        aux = []
        for j in 0...@neuronas.first
          aux << 2 * 0.05 * rand - 0.05
        end
        @pesosSalida << aux
      end
    end

    def calcular_centroides
      suma = 0
      while @reasignaciones
        @reasignaciones = false
        calcularCentroides
        reasignar
      end
    end

    def calcularCentroides
      conjunto = []
      @centroides = []
      if first then
        patron = @patrones[rand(@patrones.length)][:patron]
        @centroides << patron
        contador = 1
        while contador != @k
          patron = @patrones[rand(@patrones.length)][:patron]
          if esta_lejos?(patron) then
             @centroides << patron
             contador += 1
          end
        end
        first = false
      else
        @k.times do |i|
          conjunto = getConjunto(i)
          @centroides << media(conjunto)
        end
      end
    end

    def entrenar
      @patrones.each do | patron |
         patron[:patron]
      end
    end

    def esta_lejos?(patron)
      distancias = norma_euclidea(patron)
      if distancias.min < 0.5 then
        false
      else
        true
      end
    end

    def reasignar
      @patrones.each do | patron |
        clase = patron[:clase]
        patron[:clase] = min_norma_euclidea(patron[:patron])
        @reasignaciones = true if  clase != patron[:clase]
      end
    end

    def getConjunto(k)
      conjunto = []
      @patrones.each do | patron |
        conjunto << patron[:patron] if patron[:clase] == k
      end
      conjunto
    end

    # Luego va a tener q ser más generico, para n dimensiones
    def media(conjunto)
      x = 0.0
      y = 0.0
      conjunto.each do  |patron|
        x += patron[0]
        y += patron[1]
      end
      [(x/conjunto.count), (y/conjunto.count)]
    end

    # TODO luego debería hacerlo para n
    def min_norma_euclidea(patron)
      distancias = []
      @centroides.each do |centroide|
        #TODO llamar a funcion norma_eclidea
        distancias << ((patron[0] - centroide[0])**2) + ((patron[1] - centroide[1])**2)
      end
      distancias.index(distancias.min)
    end

    def norma_euclidea(patron)
      distancias = []
      @centroides.each do |centroide|
        #TODO llamar a funcion norma_eclidea
        distancias << ((patron[0] - centroide[0])**2) + ((patron[1] - centroide[1])**2)
      end
      distancias
    end
  end
end
