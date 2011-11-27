class FlowField
{
  int age = 0;
  int width,
      height;
      
  float cell[][];
  float noiseScale = 0.1;
  float noiseRate = 0.00004;
  
  boolean border = false;
  
  FlowField (int width, int height)
  {
    this.width = width;
    this.height = height;
    
    cell = new float[height][width];
    step();
  }
  
  void step()
  {
    for (int y = 0; y < height; y++)
    for (int x = 0; x < width; x++)
      cell[y][x] = noise(x * noiseScale, y * noiseScale, age++ * noiseRate);
    
    if (border)
    {
      for (int x = 0; x < width; x++)
      {
        cell[0][x] = 0.125;
        cell[this.height - 1][x] = 0.375;
      }
      
      for (int y = 0; y < height; y++)
      {
        cell[y][0] = 0.0;
        cell[y][(this.width) - 1] = 0.25;
      }
    }
  }
  
  void draw()
  {
    // draw flowfield
    for (int y = 0; y < field.height; y++)
    {
      for (int x = 0; x < field.width; x++)
      {
        // draw cells
        noStroke();
        fill((float) 0.5 + 0.5 * x / field.width, (float) 0.2 * y / field.height, 0.8);
        rect(x * cellSize, y * cellSize, (x + 1) * cellSize, (y + 1) * cellSize);
        
        // draw windsocks
        pushMatrix();
        
        strokeWeight(1);
        stroke(0, 0, 1, 0.5);
        translate((x + 0.5) * cellSize, (y + 0.5) * cellSize);
        rotate(PI * 4.0 * field.cell[y][x]);
        line(0, 0, 20, 0);
        triangle(18, -2, 22, 0, 18, 2);
        
        popMatrix();
      }
    }
  }
}
