#!/usr/bin/env python3
"""
Train the Boscdex mushroom classifier using MediaPipe Model Maker.

This script fine-tunes an EfficientNet-Lite0 model on the assembled
Catalan mushroom dataset and exports a quantized TFLite model.

Requirements:
    pip install mediapipe-model-maker tensorflow pillow

Usage:
    python train_classifier.py --dataset-dir ./merged --output-dir ./export
    python train_classifier.py --dataset-dir ./merged --output-dir ./export --epochs 20 --batch-size 32
"""

import argparse
import os
from pathlib import Path


def train(dataset_dir: str, output_dir: str, epochs: int, batch_size: int):
    """Train the mushroom classifier with MediaPipe Model Maker."""

    # Lazy imports to provide helpful error messages
    try:
        from mediapipe_model_maker import image_classifier
        import tensorflow as tf
    except ImportError:
        print("Required packages not found. Install with:")
        print("  pip install mediapipe-model-maker tensorflow")
        exit(1)

    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    print(f"\n🍄 Boscdex Model Trainer")
    print(f"   Dataset: {dataset_dir}")
    print(f"   Output:  {output_dir}")
    print(f"   Epochs:  {epochs}")
    print(f"   Batch:   {batch_size}\n")

    # Load dataset (expects one subdirectory per class)
    data = image_classifier.Dataset.from_folder(dataset_dir)

    # Split: 80% train, 10% validation, 10% test
    train_data, remaining = data.split(0.8)
    val_data, test_data = remaining.split(0.5)

    print(f"   Train samples:  {len(train_data)}")
    print(f"   Val samples:    {len(val_data)}")
    print(f"   Test samples:   {len(test_data)}\n")

    # Configure model: EfficientNet-Lite0 with INT8 quantization
    spec = image_classifier.SupportedModels.EFFICIENTNET_LITE0
    hparams = image_classifier.HParams(
        epochs=epochs,
        batch_size=batch_size,
        learning_rate=0.001,
        export_dir=output_dir,
    )

    # Fine-tune
    print("🔧 Training model...")
    model = image_classifier.ImageClassifier.create(
        train_data=train_data,
        validation_data=val_data,
        model_spec=spec,
        hparams=hparams,
    )

    # Evaluate
    print("\n📊 Evaluating on test set...")
    loss, accuracy = model.evaluate(test_data)
    print(f"   Test Loss:     {loss:.4f}")
    print(f"   Test Accuracy: {accuracy:.4f}")

    # Export TFLite model with INT8 quantization
    print("\n📦 Exporting quantized TFLite model...")
    model.export_model(model_name='boscdex_classifier.tflite')

    # Also export labels
    labels_path = output_path / 'labels.txt'
    with open(labels_path, 'w', encoding='utf-8') as f:
        for label in data.label_names:
            f.write(f"{label}\n")

    tflite_path = output_path / 'boscdex_classifier.tflite'
    if tflite_path.exists():
        size_mb = tflite_path.stat().st_size / (1024 * 1024)
        print(f"\n✅ Model exported successfully!")
        print(f"   Model: {tflite_path}")
        print(f"   Size:  {size_mb:.1f} MB")
        print(f"   Labels: {labels_path}")
        print(f"   Classes: {len(data.label_names)}")

        if size_mb > 18:
            print(f"\n⚠️  Warning: Model size ({size_mb:.1f} MB) exceeds 18 MB target.")
            print("   Consider more aggressive quantization or pruning.")
    else:
        print("\n❌ Model export failed. Check logs above.")


def main():
    parser = argparse.ArgumentParser(
        description='Train Boscdex mushroom classifier with MediaPipe Model Maker'
    )
    parser.add_argument(
        '--dataset-dir', type=str, required=True,
        help='Path to dataset directory (one subfolder per species)'
    )
    parser.add_argument(
        '--output-dir', type=str, default='./export',
        help='Output directory for the trained model'
    )
    parser.add_argument(
        '--epochs', type=int, default=15,
        help='Number of training epochs (default: 15)'
    )
    parser.add_argument(
        '--batch-size', type=int, default=32,
        help='Training batch size (default: 32)'
    )
    args = parser.parse_args()
    train(args.dataset_dir, args.output_dir, args.epochs, args.batch_size)


if __name__ == '__main__':
    main()
