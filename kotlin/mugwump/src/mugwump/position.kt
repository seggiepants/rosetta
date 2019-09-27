package mugwump

class position {
	var x: Int = 0
		private set
	var y: Int = 0
		private set
	var found: Boolean = false
	
	init {
		// Ok this is redundant.
		x = 0
		y = 0
		found = false
	}
	
	fun randomPosition(maxX: Int, maxY: Int) {
		x = (0 until maxX).random()
		y = (0 until maxY).random()
		found = false
	}
	
}