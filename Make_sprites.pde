PImage pointTexture;
int textureSize = 32; // Size of the texture
float maxDistance; // Maximum distance for the profiles

void setup() {
    size(800, 800);
    pointTexture = createImage(textureSize, textureSize, RGB);
    maxDistance = dist(0, 0, textureSize / 2, textureSize / 2); // Calculate max distance from center

    // Generate textures with different profiles and save them
    PImage gaussianTexture = generatePointTexture("gaussian");
    PImage linearTexture = generatePointTexture("linear");
    PImage exponentialTexture = generatePointTexture("exponential");

    // Display textures
    image(gaussianTexture, 0, 0);
    image(linearTexture, 300, 0);
    image(exponentialTexture, 600, 0);

    // Save textures as PNG files
    gaussianTexture.save("data/sprite_gauss-032.png");
    linearTexture.save("data/sprite_linear-032.png");
    exponentialTexture.save("data/sprite_exponential-032.png");

    println("Textures saved as PNG files.");
}

PImage generatePointTexture(String profile) {
    PImage img = createImage(textureSize, textureSize, RGB);

    for (int x = 0; x < img.width; x++) {
        for (int y = 0; y < img.height; y++) {
            float distance = dist(x, y, img.width / 2, img.height / 2); // Distance from center
            float intensity;

            // Apply chosen profile
            switch (profile) {
                case "gaussian":
                    intensity = gaussianProfile(distance);
                    break;
                case "linear":
                    intensity = linearProfile(distance);
                    break;
                case "exponential":
                    intensity = exponentialProfile(distance);
                    break;
                default:
                    intensity = 0;
            }

            // Map intensity to a grayscale value (0-255)
            int colorValue = (int) constrain(intensity * 255, 0, 255);
            img.set(x, y, color(colorValue));
        }
    }

    return img;
}

float gaussianProfile(float distance) {
    float sigma = maxDistance / 8; // Standard deviation
    return exp(-sq(distance) / (2 * sq(sigma))); // Gaussian function
}

float linearProfile(float distance) {
    return max(0, pow((maxDistance - distance) / maxDistance,4)); // Linear decay
}

float exponentialProfile(float distance) {
    float decayRate = 0.2; // Rate of decay
    return exp(-decayRate * distance); // Exponential decay
}
