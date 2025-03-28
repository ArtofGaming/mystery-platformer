using Godot;
using System;

public partial class CaveGenerator : Node
{
	/*
	Steps:
	1. Generate Grid
	2. Randomly generate appearance of cells
	3. Account for other cells
	4. Find "rooms"
	5. Connect all rooms together
	Different Scripts:
	6. Identify number of suspects + 1
	7. Randomly place suspects
	8. Place one clue in separate rooms other than the starting room
	9. Place player in starter room and let them loose
	*/
	
	int gridHeight = 30;
	int gridWidth = 30;
	Cell[] grid;
	
	void GenerateCellGrid (gridHeight,gridWidth)
	{
		for (int y = 0; i < gridHeight; i++)
		{
			for (int x = 0; i < gridWidth; i++)
			{
				grid.Append(new Cell);
			}
		}
	}
	
	
}
