class Particle
{
  float px, py;
  float vx, vy;
  float hue;
  
  float age = 0;
  float weight;
  
  int id = 0;
  
  float [][] trail;
  int        trail_pos = 0,
             trail_counter = 0,
             trail_length = 0,
             trail_thresh = 0;

  Synth synth;
  
  Particle(int id, float px, float py)
  {
    this.id = id;
    this.px = px;
    this.py = py;
    
    this.trail = new float[200][2];
    
    vx = random(-1, 1);
    vy = random(-1, 1);
    weight = random(3.5, 30.5);
    
    age = random(300);
    
    hue = random(0.5);
    
    synth = new Synth("pulser");
    synth.create();
  }
  
  Particle(int id)
  {
    this(id, width / 2.0 + random(-20, 20), height / 2.0 + random(-20, 20));
  }
  
  void move()
  {
    age++;
        
    vx *= w_inertia;
    vy *= w_inertia;
    
    if (px >= width) px = 0;
    int cellx = (int) px / cellSize;
    int celly = (int) py / cellSize;
    
    vx += w_wind * cos(4 * PI * field.cell[celly][cellx]);
    vy += w_wind * sin(4 * PI * field.cell[celly][cellx]);

    float velocity = dist(0, 0, vx, vy);
    synth.set("freq", velocity * 50.0);
    synth.set("pan", map(px, 0, width, -1, 1));
    
    px += vx;
    if (px < 0) px = width - 1;
    if (py >= width) px = 0;
    
    py += vy;
    if (py < 0) py = height - 1;
    if (py >= height) py = 0;


    // add trail
    if (++trail_counter > trail_thresh)
    {
      trail_counter = 0;
      this.addTrailSegment();
    }
  }
  
  void draw()
  {
    // draw triangular head, facing correct direction
    pushMatrix();

    noFill();
    stroke(0);
    strokeWeight(1.3);
    
    translate(px, py);
    rotate(atan2(vy, vx));
    scale(0.3 + 0.01 * abs(vx) * abs(vy));
    
    popMatrix();
  
  
    // draw tail
    drawTrail(weight);
  }
  
  void addTrailSegment()
  {
      trail[trail_pos][0] = px;
      trail[trail_pos][1] = py;
      
      if (trail_length < w_trail_max_length)
         trail_length++;
         
      // may occur if trail max length changes during execution
      if (trail_length > w_trail_max_length)
         trail_length = (int) w_trail_max_length - 1;
      
      if (++trail_pos >= 200)
        trail_pos = 0;
  }
  
  void drawTrail(float weight)
  {
    int pos,
        pos_last = -1;

    for (int i = 1; i < trail_length - 1; i++)
    {
      pos = trail_pos - i;
      if (pos < 0)
         pos = 200 + trail_pos - i;
      
      strokeWeight(weight * (trail_length - i) / trail_length);
      stroke(0, 0, 0, 0.7 * ((float) trail_length - i) / trail_length);
      //stroke(1, 0, 1, 0.7 * ((float) trail_length - i) / trail_length);
      if (pos_last > -1 &&
         (abs(trail[pos_last][0] - trail[pos][0]) < 100) &&
         (abs(trail[pos_last][1] - trail[pos][1]) < 100)
      )
      //ellipse(trail[pos][0], trail[pos][1], 10, 10);
      line(trail[pos_last][0], trail[pos_last][1], trail[pos][0], trail[pos][1]);
         
      pos_last = pos;
    }
  }
  
  void stop()
  {
    synth.free();
  }
}
