# ⚡ Chapter 3: Training Mechanics, Loss & Optimization

In Chapter 2, we saw how the MobileNetV2 backbone compresses a $224 \times 224 \times 3$ photograph into **1,280 Global Average Pooling (GAP) feature numbers**.

Now, how does the model convert those 1,280 numbers into a prediction like *"Rovelló (82%)"*? And how does it mathematically learn from its mistakes during training?

---

## 1. The Classification Head: From Features to Logits

The **Classification Head** is a single **Dense (Fully Connected) Linear Layer**.

It takes the 1,280 input features from GAP and computes a raw score for each of our 47 Catalan species:

```
    GAP Features (1,280 floats)         Weights Matrix (1280 x 47)           Logits (47 floats)
    ┌───────────────────────────┐         ┌────────────────────────┐         ┌─────────────────┐
    │ x₀:  0.428 (orange hue)   │         │ W (60,160 weights)     │         │ z₀:  +3.42 (Rovelló)
    │ x₁:  1.891 (decurrent gill│    •    │                        │    + b  │ z₁:  -1.20 (Cep)
    │ x₂:  0.050 (scales)       │         │ + 47 class biases      │         │ z₂:  +0.15 (Rossinyol)
    │ ...                       │         │                        │         │ ...             │
    │ x₁₂₇₉: 0.112 (pore sponge)│         └────────────────────────┘         │ z₄₆: -2.85 (Fredolic)
    └───────────────────────────┘                                            └─────────────────┘
```

### The Math Behind the Head:
For each species $i$ (from 0 to 46):

$$\text{logit}_i = \left( \sum_{j=0}^{1279} W_{j, i} \cdot x_j \right) + b_i$$

* $W_{j, i}$ is the **weight** connecting feature $j$ to species $i$.
  * If feature $j$ represents *"orange concentric rings"*, its weight for *Lactarius deliciosus* (Rovelló) will be strongly positive ($+2.5$).
  * Its weight for *Trompeta de la mort* (black trumpet) will be strongly negative ($-3.1$).
* $b_i$ is the **bias** (the default baseline score for that species).

**Total Parameters in Head:**
$$1,280 \times 47 = 60,160 \text{ weights} + 47 \text{ biases} = \mathbf{60,207 \text{ numbers (240.8 KB)}}$$

The resulting 47 numbers ($z_0, z_1, \dots, z_{46}$) are called **Logits**. Logits are unconstrained real numbers: they can be negative ($-4.5$), positive ($+6.2$), or zero.

---

## 2. The Softmax Function: Converting Logits into Probabilities

Users don't want to see a raw logit like `logit: 3.42`. They want to see a confidence percentage: *"82% confidence"*.

To turn 47 arbitrary real numbers into a valid probability distribution where **all values are between 0% and 100% and their sum equals exactly 100%**, we apply the **Softmax function**:

$$P(\text{species}_i) = \frac{e^{\text{logit}_i}}{\sum_{k=0}^{46} e^{\text{logit}_k}}$$

```
     Raw Logit (z)                   Exponent e^z                     Softmax Probability
  ┌─────────────────┐             ┌─────────────────┐              ┌──────────────────────┐
  │ z₀ = +3.42      │  exp(z)     │ e³·⁴² = 30.57   │   Divide by  │ p₀ = 30.57 / 37.12 = 82.4% (Rovelló)
  │ z₁ = +0.85      │ ──────────► │ e⁰·⁸⁵ =  2.34   │ ───────────► │ p₁ =  2.34 / 37.12 =  6.3% (Ou de reig)
  │ z₂ = -1.20      │             │ e⁻¹·² =  0.30   │   sum (37.12)│ p₂ =  0.30 / 37.12 =  0.8% (Cep)
  └─────────────────┘             └─────────────────┘              └──────────────────────┘
```

### Why Exponentiation ($e^z$)?
1. **Guarantees Positivity:** Even if a logit is negative, $e^{-2.5} \approx 0.082 > 0$. Probabilities can never be negative.
2. **Magnifies Winners:** Exponentiation exponentially rewards the top candidate while suppressing noise from runner-ups.

### The Numerical Stability Trick:
When calculating $e^z$, if a logit is large (e.g. $z = 100$), $e^{100} \approx 2.6 \times 10^{43}$, which triggers an arithmetic overflow error in 32-bit floating point hardware.

To prevent this, our Flutter implementation in [`TfliteClassifierService`](file:///Users/jordi/dev/boscdex/lib/domain/services/tflite_classifier_service.dart) subtracts the maximum logit before exponentiating:

$$\text{exp}(z_i - \max(z))$$

Mathematically, shifting all logits by a constant does not change the resulting probabilities, but it guarantees that the largest exponent is $e^0 = 1.0$, preventing any numerical overflow!

---

## 3. The Loss Function: Categorical Cross-Entropy

How does TensorFlow evaluate how "wrong" the model's prediction is during training? It uses **Categorical Cross-Entropy Loss**.

Suppose the true label for a photo is **Rovelló** (class index 0). In one-hot encoding, the ground-truth target is:
$$y = [1.0, 0.0, 0.0, \dots, 0.0]$$

The cross-entropy loss formula is:

$$\mathcal{L} = -\sum_{i=0}^{46} y_i \ln(p_i) = -\ln(p_{\text{correct}})$$

> [!TIP]
> **Modern Advancement — Label Smoothing:** In production, hard one-hot targets cause overconfidence and logit saturation. See [Chapter 6: Modern Optimization & TTA](06_modern_optimization_and_tta.md) for how Boscdex replaced hard cross-entropy with **Label-Smoothed Cross-Entropy ($\alpha = 0.10$)** and **Safety-Priority Class Weights**, lifting Top-3 accuracy to 96.3%.

The loss is simply the **negative natural logarithm of the probability assigned to the correct class**:

```
      Loss (L)
        ^
        │
   4.0  ┼       \
        │        \
   2.0  ┼         \
        │          \
   0.0  ┼───────────\───────> Probability of Correct Class (p)
        0.0        0.5     1.0 (100% confident & right -> Loss = 0.0)
```

* **If the model predicts 99% for Rovelló:** $\mathcal{L} = -\ln(0.99) = \mathbf{0.01}$ (Near zero penalty).
* **If the model predicts 50% for Rovelló:** $\mathcal{L} = -\ln(0.50) = \mathbf{0.69}$ (Moderate penalty).
* **If the model predicts 1% for Rovelló:** $\mathcal{L} = -\ln(0.01) = \mathbf{4.60}$ (Severe penalty).
* **If the model predicts 0% for Rovelló:** $\mathcal{L} = -\ln(0.00) \to \mathbf{\infty}$ (Massive infinite penalty).

The goal of training is simple: **tune the weights to make Loss as close to 0.0 as possible across all training images.**

---

## 4. Backpropagation & The Adam Optimizer

How do we adjust 25,620 weights in the head (and millions in the backbone) to reduce the loss?

### Gradient Descent
Using the **Chain Rule of Calculus**, TensorFlow calculates the **derivative (gradient)** of the loss with respect to every single weight in the network:

$$\frac{\partial \mathcal{L}}{\partial W_{j, i}}$$

This number tells us: *"If I increase this weight by a tiny amount, will the loss go up or down?"*

We then update every weight in the opposite direction of the gradient:

$$W_{\text{new}} = W_{\text{old}} - \alpha \cdot \frac{\partial \mathcal{L}}{\partial W}$$

Where $\alpha$ is the **Learning Rate** (the step size).

### Why the Adam Optimizer?
In our Colab training script, we use the **Adam (Adaptive Moment Estimation)** optimizer. 

Unlike basic Stochastic Gradient Descent (SGD) which uses a fixed step size for all weights, Adam:
1. Maintains an exponential moving average of past gradients (**Momentum**): prevents the model from getting stuck in local valleys.
2. Adapts the learning rate individually for each parameter: weights that receive rare updates take larger steps, while frequently updated weights take smooth, cautious steps.

---

## 5. The Two-Phase Training Strategy

In [`notebooks/boscdex_mushroom_training_colab.ipynb`](file:///Users/jordi/dev/boscdex/notebooks/boscdex_mushroom_training_colab.ipynb), you will notice that training is divided into two distinct phases. Why?

```
┌────────────────────────────────────────────────────────────────────────┐
│ Phase 1: Classification Head Warmup (12 Epochs)                        │
│   • Base MobileNetV2: FROZEN (trainable = False)                       │
│   • Classification Head: TRAINABLE                                     │
│   • Learning Rate: α = 0.001 (1e-3)                                    │
│   • Goal: Initialize the 25,620 head weights to sensible values        │
│           WITHOUT destroying the pre-trained ImageNet filters.         │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ Phase 2: Deep Surgical Fine-Tuning (12 Epochs)                         │
│   • Base MobileNetV2: Layers 0-99 FROZEN, Layers 100+ UNFROZEN         │
│   • Classification Head: TRAINABLE                                     │
│   • Learning Rate: α = 0.00001 (1e-5)  <-- 100x smaller!               │
│   • Goal: Gently adapt deep mushroom shape detectors to Catalan pine   │
│           needle clutter, moss, and local lighting without forgetting  │
│           general visual knowledge.                                    │
└────────────────────────────────────────────────────────────────────────┘
```

> ⚠️ **What happens if you skip Phase 1 and unfreeze everything immediately?**  
> Because the classification head starts with random weights, its initial gradients are massive and chaotic. If these chaotic gradients backpropagate into MobileNetV2, they completely scramble the pre-trained ImageNet weights (a disaster called **Catastrophic Forgetting**). Freezing the backbone in Phase 1 protects the pre-trained features until the head is stable.

---

## 6. Data Augmentation: Teaching Botanical Invariance

A mushroom photographed in the Catalan Pyrenees has an important botanical property: **Radial Symmetry**.

A *Rovelló* or *Cep* is still a *Rovelló* or *Cep* whether it is rotated $90^\circ$, flipped left-to-right, viewed in harsh direct sunlight, or partially covered by a pine needle.

To prevent the model from memorizing specific pixel orientations, our training pipeline applies **Dynamic Data Augmentation** on the fly:

```python
data_augmentation = tf.keras.Sequential([
    tf.keras.layers.RandomFlip("horizontal"),
    tf.keras.layers.RandomRotation(0.20),  # Rotates by up to +/- 72 degrees
    tf.keras.layers.RandomZoom(0.15),      # Zooms in/out by 15%
    tf.keras.layers.RandomContrast(0.10),  # Simulates canopy shade vs direct sun
])
```

Every time the model sees an image during training, it receives a freshly augmented variant:
* One epoch it sees the mushroom upright.
* The next epoch it sees it tilted $25^\circ$ with higher contrast.
* The next epoch it sees it horizontally flipped and slightly zoomed in.

This forces the neural network to ignore orientation and zoom, and focus strictly on true morphological traits: concentric rings, gill structures, and cap texture.
