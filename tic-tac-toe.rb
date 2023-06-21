class Tablero
  def initialize
    @tablero = Array.new(3) { Array.new(3, " ") }
  end

  def mostrar_tablero
    puts "------------"
    @tablero.each do |fila|
      puts "| #{fila[0]} | #{fila[1]} | #{fila[2]} |"
      puts "------------"
    end
  end

  def casilla_vacia?(fila, columna)
    @tablero[fila][columna] == " "
  end

  def marcar_casilla(fila, columna, marca)
    @tablero[fila][columna] = marca
  end

  def tablero_lleno?
    @tablero.flatten.none? { |casilla| casilla == " " }
  end

  def hay_ganador?
    filas_ganadoras || columnas_ganadoras || diagonales_ganadoras
  end

  private

  def filas_ganadoras
    @tablero.each do |fila|
      return true if fila.uniq.length == 1 && fila[0] != " "
    end
    false
  end

  def columnas_ganadoras
    @tablero.transpose.each do |columna|
      return true if columna.uniq.length == 1 && columna[0] != " "
    end
    false
  end

  def diagonales_ganadoras
    diagonales = [[@tablero[0][0], @tablero[1][1], @tablero[2][2]],
                  [@tablero[0][2], @tablero[1][1], @tablero[2][0]]]
    diagonales.each do |diagonal|
      return true if diagonal.uniq.length == 1 && diagonal[0] != " "
    end
    false
  end
end

class Jugador
  attr_reader :marca

  def initialize(marca)
    @marca = marca
  end

  def realizar_jugada
    puts "Ingrese la fila y columna de su jugada (por ejemplo, 1 2):"
    jugada = gets.chomp.split.map(&:to_i)
    { fila: jugada[0] - 1, columna: jugada[1] - 1 } if jugada.length == 2
  end
end

class Juego
  def initialize
    @tablero = Tablero.new
    @jugador1 = Jugador.new("X")
    @jugador2 = Jugador.new("O")
    @turno_actual = @jugador1
  end

  def jugar
    loop do
      @tablero.mostrar_tablero
      jugada = @turno_actual.realizar_jugada
      if jugada && @tablero.casilla_vacia?(jugada[:fila], jugada[:columna])
        @tablero.marcar_casilla(jugada[:fila], jugada[:columna], @turno_actual.marca)
        break if fin_del_juego
        cambiar_turno
      else
        puts "La jugada ingresada no es válida. Intente nuevamente."
      end
    end
  end

  private

  def fin_del_juego
    if @tablero.hay_ganador?
      @tablero.mostrar_tablero
      puts "¡#{@turno_actual} ha ganado!"
      true
    elsif @tablero.tablero_lleno?
      @tablero.mostrar_tablero
      puts "¡Empate!"
      true
    else
      false
    end
  end

  def cambiar_turno
    @turno_actual = (@turno_actual == @jugador1) ? @jugador2 : @jugador1
  end
end

# Crear un nuevo juego y comenzar a jugar
juego = Juego.new
juego.jugar
