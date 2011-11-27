class Particle
{
  float px, py;
  float vx, vy;
  float fundamental,
      partial,
      span;
  Synth [] synths;
  color col;
  
  Particle(float px, float py)
  {
    this.px = px;
    this.py = py;
    
    vx = vx = random(-1, 1);
    vy = vy = random(-1, 1);
    
    fundamental = 25 * pow(2, floor(random(0, 6)));
    fundamental *= random(0.99, 1.01);
    
    if (random(1.0) < 0.5)
      partial = floor(random(1, random(1, 4)));
    else
      partial = floor(random(1, random(1, 40)));
      
    col = color(random(0.5, 1.0), random(0.5, 1.0), random(0.5, 1.0));
    span = 200 + (10 * partial);
  }
  
  Particle()
  {
    this(random(width), random(height));
  }
  
  void init()
  {
    synths = new Synth[particles.length];
    for (int i = 0; i < particles.length; i++)
    {
      synths[i] = new Synth("sine_harmonic");
      synths[i].set("freq", fundamental * particles[i].partial);
      synths[i].set("amp", 0.0);
      synths[i].create();
    }
  }
  
  void bounce()
  {
    partial *= random(0.95, 1.05);
  }
  
  void move()
  {
    px += vx;
    py += vy;
    
    if (px > width)
      { px = width; vx = -vx; bounce(); }
    if (px < 0)
      { px = 0; vx  = -vx; bounce(); }
    if (py > height)
      { py = height; vy  = -vy; bounce(); }
    if (py < 0)
      { py = 0; vy  = -vy; bounce(); }

    for (int i = 0; i < particles.length; i++)
    {
      Particle peer = particles[i];
      float distance = dist(px, py, peer.px, peer.py);
      
      if ((distance > -1) && (distance < span))
      {
        synths[i].set("amp", 0.1 * (1.0 - distance / span) * (1.0 / peer.partial));
        synths[i].set("pan", (peer.px - px) / span);
        

        // render globe core         
        yellow.bind();
        renderImage(px, py, 0, partial, color(1, 1, 1), 0.8);
        
        // render globe halo
        white.bind();
        renderImage(px, py, 0, distance, color(1, 1, 1), 0.01 * (1 - distance / span));
        
        if (distance > (span * 0.5))
        {
          float radius = distance;
          float alpha = 1 - abs((span * 0.75) - distance) / (span * 0.25);
          
          if (random(1) < 0.0005)
          {
            radius += 50 + random(200);
            synths[(int) random(synths.length)].set("amp", 0.5);
          }
          
          renderImage(px, py, 0, radius, col, alpha * 0.5);
          renderImage(px, py, 0, radius * 2, col, alpha * 0.08);
          renderImage(px, py, 0, radius * 8, col, alpha * 0.04);
        }
      }
    }
  }
  
  void stop()
  {
    for (int i = 0; i < particles.length; i++)
      synths[i].set("gate", 0);
  }
}
