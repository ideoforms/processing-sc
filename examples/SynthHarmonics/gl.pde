/*
 * OpenGL functions
 *
 *--------------------------------------------------------------*/

import com.sun.opengl.util.texture.*;

void initGL()
{
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
}

void initGLdraw()
{
  gl.glClear(GL.GL_DEPTH_BUFFER_BIT);
  gl.glEnable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  gl.glEnable(GL.GL_TEXTURE_2D);
}

void renderImage(float x, float y, float z, float _diam, color _col, float _alpha )
{
  gl.glPushMatrix();
  gl.glTranslatef(x, y, z);
  gl.glScalef(_diam, _diam, _diam);
  gl.glColor4f(red(_col), green(_col), blue(_col), _alpha);
  
  gl.glBegin(GL.GL_POLYGON);
  gl.glTexCoord2f(0, 0);    gl.glVertex2f(-.5, -.5);
  gl.glTexCoord2f(1, 0);    gl.glVertex2f( .5, -.5);
  gl.glTexCoord2f(1, 1);    gl.glVertex2f( .5,  .5);
  gl.glTexCoord2f(0, 1);    gl.glVertex2f(-.5,  .5);
  gl.glEnd();

  gl.glPopMatrix();
}

Texture loadTexture(String file)
{
  Texture tex = null;
  try { tex = TextureIO.newTexture(new File(dataPath(file)), true); }
  catch (IOException e) { println("couldn't load texture " + file); exit(); }
  
  tex.bind();
  gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR);
  gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR);
  
  return tex;
}
