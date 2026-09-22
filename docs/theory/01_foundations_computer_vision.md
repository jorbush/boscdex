# 📐 Chapter 1: Foundations of Computer Vision

Before training a neural network to recognize a *Rovelló* or an *Ou de reig*, we must first understand what an image looks like to a processor, and why traditional programming techniques cannot solve image recognition.

---

## 1. What is an Image to a Computer?

To human eyes, a photograph of a mushroom is a continuous scene of organic shapes, damp moss, and sunlight filtering through pine needles.

To a digital computer, a photograph is simply a **three-dimensional grid of numbers** called a **Tensor**.

```
                ┌──────────────────────────────┐
                │        Color Channels        │
                │    Red       Green    Blue   │
                │   [R]        [G]      [B]    │
                │    │          │        │     │
    Height 224  │    ▼          ▼        ▼     │
   ┌────────────┴──────────────────────────┐   │
   │ [ 234,  45,  12 ]  [ 120, 180,  90 ]  │   │
   │ [ 210,  40,  15 ]  [ 115, 175,  85 ]  │   │
   │  ...                                  │   │
   └───────────────────────────────────────┘   │
                  Width: 224 pixels            │
```

### The Structure of a Digital Pixel
1. **Spatial Dimensions ($H \times W$):** The resolution of the image. In Boscdex's MobileNetV2 pipeline, every input image is resized to **$224 \times 224$ pixels**.
2. **Color Channels ($C$):** Color photographs use the **RGB model**:
   * **Red Channel:** Intensity of red light from `0` (dark) to `255` (maximum bright).
   * **Green Channel:** Intensity of green light from `0` to `255`.
   * **Blue Channel:** Intensity of blue light from `0` to `255`.
3. **Total Data Points:**  
   $$\text{Total Numbers} = 224 \times 224 \times 3 = 150,528 \text{ numbers per photo}$$

When you take a picture of a *Rovelló*, the phone's camera sensor hands the operating system a matrix of **150,528 numbers**, each between `0` and `255`.

---

## 2. Why Traditional Programming Fails on Images

Why can't we just write traditional `if / else` rules like this?

```dart
// ❌ Why rule-based vision is impossible:
if (dominantColor == Color.orange && shape == Shape.umbrella) {
  return "Rovelló";
}
```

1. **Pixel Sensitivity to Angles:** If the mushroom is tilted by $15^\circ$, or if the camera moves two inches to the left, **nearly all 150,528 numbers change completely**, even though the object is identical.
2. **Lighting Variations:** The same *Lactarius deliciosus* under direct Mediterranean midday sun produces bright orange pixels (`R=240, G=140, B=30`). At dusk under a dense beech canopy, the exact same mushroom produces dull brown pixels (`R=110, G=70, B=25`).
3. **The Parameter Explosion Problem:**  
   If you attempted to feed 150,528 inputs into a standard traditional feed-forward neural network (a Dense/Linear layer with 1,000 hidden units), that single layer would require:
   $$150,528 \times 1,000 = 150,528,000 \text{ parameters (weights)}$$
   Over 150 million numbers just for the first layer! The model would immediately run out of memory, overfit on a handful of images, and take days to train.

To solve this, computer vision uses **Convolutions**.

---

## 3. The Convolution Operation (CNNs)

A **Convolutional Neural Network (CNN)** mimics how animal biological visual cortices process sight: rather than looking at all 150,528 pixels at once, it slides small mathematical magnifying glasses called **Kernels (or Filters)** across the image.

### How a Kernel Works
A kernel is typically a tiny $3 \times 3$ matrix of numbers. It slides across the image from left to right, top to bottom:

```
    Input Image (5x5 slice)             Kernel (3x3)
    ┌────┬────┬────┬────┬────┐          ┌────┬────┬────┐
    │  1 │  0 │  0 │  1 │  0 │          │  1 │  0 │ -1 │
    ├────┼────┼────┼────┼────┤          ├────┼────┼────┤
    │  0 │  1 │  1 │  0 │  1 │    *     │  2 │  0 │ -2 │
    ├────┼────┼────┼────┼────┤          ├────┼────┼────┤
    │  1 │  0 │  1 │  1 │  0 │          │  1 │  0 │ -1 │
    ├────┼────┼────┼────┼────┤          └────┴────┴────┘
    │  0 │  1 │  0 │  0 │  1 │          (Vertical Edge Detector)
    ├────┼────┼────┼────┼────┤
    │  1 │  0 │  1 │  0 │  1 │
    └────┴────┴────┴────┴────┘
```

At each position:
1. Multiply the kernel numbers by the corresponding overlapping pixel values.
2. Sum the results together into a single scalar value.
3. Place that value into a new grid called a **Feature Map**.

### Visualizing What Convolutions Detect:
* **Early Layers (Layers 1–10):** Tiny $3\times3$ kernels detect **low-level geometric primitives**:
  - Horizontal lines, vertical edges, diagonal slashes.
  - High-contrast color transitions (e.g. the boundary where an orange cap meets green moss).
* **Middle Layers (Layers 11–35):** Kernels combine early edges to detect **textures and patterns**:
  - Concentric circular rings (characteristic of *Rovelló* caps).
  - Radiating parallel striations (mushroom gills or *làmines*).
  - Sponge-like porous meshes (characteristic of *Cep* hymenium).
  - Flakes and scales (warty spots on *Amanita muscaria*).
* **Deep Layers (Layers 36–64):** Kernels combine textures into **high-level semantic parts**:
  - A complete rounded convex cap.
  - A cylindrical stipe with a bulbous base or volva.
  - The distinctive downward tapering *cama de perdiu* stem.

```
┌─────────────┐      ┌──────────────┐      ┌─────────────┐      ┌──────────────┐
│ Raw Pixels  │ ──►  │ Edges/Lines  │ ──►  │ Gills/Rings │ ──►  │ Cap & Stipe  │
│ [224x224x3] │      │ (Layer 1-10) │      │ (Layer 11)  │      │ (Layer 50+)  │
└─────────────┘      └──────────────┘      └─────────────┘      └──────────────┘
```

### Why Convolutions are Magical:
1. **Weight Sharing:** The same $3\times3$ kernel (only 9 numbers!) is used across every pixel in the entire image. This reduces millions of parameters down to a few thousand.
2. **Translation Invariance:** Because the kernel slides everywhere, if it learns how to detect a mushroom gill, it will recognize that gill whether the mushroom is in the top-left corner, center, or bottom-right corner of your camera screen.

---

## 4. Activation Functions: Introducing Non-Linearity

If you stack 50 convolutional layers on top of each other using only multiplications and additions, the entire 50-layer network mathematically collapses into **a single linear equation**:
$$y = W_2(W_1 x) = (W_2 \cdot W_1)x = W_{combined} x$$

A linear model cannot learn complex organic patterns. To allow the network to learn non-linear shapes (like wavy mushroom caps or ragged volvas), we pass every feature map through an **Activation Function**.

### The ReLU Family
The most widely used activation function in modern vision is **ReLU (Rectified Linear Unit)**:
$$f(x) = \max(0, x)$$

If a number is negative, discard it (`0`). If it is positive, keep it (`x`).

In MobileNetV2, an optimized variant called **ReLU6** is used:
$$f(x) = \min(\max(0, x), 6)$$

```
     f(x)
       ^
     6 ┼─────── (Capped at 6)
       │      /
       │     /
       │    /
  ─────┼───/──────> x
     0 │  0
```

> **Why cap at 6?**  
> On mobile chips (smartphones running ARM processors and NPUs), numbers must be quantized into low-precision 8-bit integers (`INT8`). Capping activations strictly between `0` and `6` prevents numerical overflow and makes inference run up to **$4\times$ faster** on battery-powered mobile devices.

---

## 5. Normalization: Why Preprocessing Matters

Neural networks do not perform well when input numbers are large (like `0` to `255`). Large inputs cause weights to swing violently during training, leading to **exploding gradients** and numerical instability.

Neural networks prefer inputs that are **zero-centered with small standard deviations** (typically centered around $0.0$, between $-1.0$ and $+1.0$).

In MobileNetV2, every input pixel is scaled using this exact mathematical formula:

$$\text{Normalized Pixel} = \frac{\text{Pixel} - 127.5}{127.5}$$

* When $\text{Pixel} = 0 \text{ (pure black)} \implies \frac{0 - 127.5}{127.5} = \mathbf{-1.0}$
* When $\text{Pixel} = 127.5 \text{ (medium grey)} \implies \frac{127.5 - 127.5}{127.5} = \mathbf{0.0}$
* When $\text{Pixel} = 255 \text{ (pure white)} \implies \frac{255 - 127.5}{127.5} = \mathbf{+1.0}$

### The Boscdex Connection:
In [`lib/domain/services/tflite_classifier_service.dart`](file:///Users/jordi/dev/boscdex/lib/domain/services/tflite_classifier_service.dart), our Flutter camera pipeline reads raw RGB bytes:
```dart
floatList[pIdx++] = pixels[offset].toDouble(); // Sends 0.0 to 255.0 to TFLite
```
And inside [`notebooks/boscdex_training_colab.ipynb`](file:///Users/jordi/dev/boscdex/notebooks/boscdex_training_colab.ipynb), our Keras graph wraps this automatically:
```python
x = tf.keras.applications.mobilenet_v2.preprocess_input(inputs)
```
Because `preprocess_input` is compiled directly into the `.tflite` model graph, the model accepts Flutter's $[0, 255]$ raw pixel values and scales them internally into $[-1, 1]$ before passing them into the first convolutional layer.
