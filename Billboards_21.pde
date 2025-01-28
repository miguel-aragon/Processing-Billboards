/*

Example code to display 3d point as sprites. Note that processing does not make it
easy so we have to trick it. 

Important points:
    I could not manage to pass attributes to the shaders so I passed color and size as textures. 
       However this required special care with the indices in the vertex shader as follows:

    * strokeCap(PROJECT);  ->  Forces processing to display points as quads. From what I can see
                               they are strange quads made of 5 points (4 corners and center).
    * In the vertex shader, this is crucial to get vertex indexing right.
      // Divide by 5 to get the correct index!
      float index = float(gl_VertexID) / pointCount / 5; // OJO!!! 

*/
import peasy.*;
import processing.opengl.*;

PeasyCam cam;
PShader billboardShader;
PShape points;
PImage tex;
PImage colorTexture;
PImage sizeTexture;

void setup() {
    size(800, 600, P3D);
    hint(DISABLE_DEPTH_TEST);
    blendMode(ADD);
    strokeCap(PROJECT);
    
    cam = new PeasyCam(this, 1000);
    cam.setMinimumDistance(100);
    cam.setMaximumDistance(5000);

    // Load the shader
    billboardShader = loadShader("billboard.frag", "billboard.vert");

    // Load the billboard texture
    tex = loadImage("sprite_exponential-032.png"); // Make sure "sprite.png" is in the data folder
    if (tex == null) {
        println("Error: Could not load texture!");
        exit();
    }

    // Generate random colors and sizes
    int pointCount = 10000;
    int off = 1;
    colorTexture = createImage(pointCount*off, 1, RGB);
    sizeTexture = createImage(pointCount*off, 1, RGB);

    //for (int i = 0; i < 8; i++) colorTexture.set(i, 0, color(250,0,0));
    //for (int i = 8; i < 16; i++) colorTexture.set(i, 0, color(0,250,0));
    //for (int i = 16; i < 24; i++) colorTexture.set(i, 0, color(0,0,250));
    //for (int i = 1*off*2; i < 1*off*3; i++) colorTexture.set(i, 0, color(0,0,250));
    
   for (int i = 0; i < pointCount*off; i++) {
      sizeTexture.set(i,  0, color(0.05 * 255));
    }
    for (int i = 1; i < pointCount; i++) {
        // Random color
        float r = random(1.0);
        float g = random(1.0);
        float b = random(1.0);
        colorTexture.set(i, 0, color(r * 255, g * 255, b * 255));

        // Random size
        //float size = random(0.01, 0.05); // Adjust the range as needed
        //sizeTexture.set(i, 0, color(size * 255));
    }
    colorTexture.updatePixels();
    sizeTexture.updatePixels();

    // Set the textures in the shader
    billboardShader.set("texMap", tex);
    billboardShader.set("colorTexture", colorTexture);
    billboardShader.set("sizeTexture", sizeTexture);
    billboardShader.set("pointCount", float(pointCount));

    // Generate 10,000 random points
    points = createShape();
    points.beginShape(POINTS);
    for (int i = 0; i < pointCount; i++) {
        // Random position
        float x = random(-500, 500);
        float y = random(-500, 500);
        float z = random(-500, 500);
        //float x = (pointCount/2-i)*10;
        //float y = 0;
        //float z = 0;
        points.vertex(x, y, z);
    }
    points.endShape();
}

void draw() {
    background(0);

    strokeCap(PROJECT);
    
    // Enable the shader
    shader(billboardShader);

    // Draw the points
    shape(points);
}
