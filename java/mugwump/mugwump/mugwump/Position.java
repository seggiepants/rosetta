package mugwump;

import java.util.Random;

/**
 * Utility class to represent a mugwump's position on the map and 
 * if it has been found or not.
 * @author SeggiePants - Implied by the code in Basic Computer Games
 *
 */
public class Position {
	private int x;
	private int y;
	private boolean found;
	
	public int getX() { return this.x; }
	
	public int getY() { return this.y; }
	
	public boolean getFound() { return this.found; }
	public void setFound(boolean value) { this.found = value; }
	
		this.x = 0;
	public Position() {
		this.y = 0;
		this.found = false;
	}
	
	public void RandomPosition(Random r, int maxX, int maxY) {
		this.x = r.nextInt(maxX);
		this.y = r.nextInt(maxY);
		this.found = false;
	}
}
