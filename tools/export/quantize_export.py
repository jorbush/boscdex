#!/usr/bin/env python3
"""
Quantize and export the trained model to INT8 TFLite format.

This script provides an alternative quantization pipeline for models
trained outside of MediaPipe Model Maker (e.g., via PyTorch timm + ai-edge-torch).

Requirements:
    pip install tensorflow

Usage:
    python quantize_export.py --saved-model ./saved_model --output ./boscdex_classifier_int8.tflite
    python quantize_export.py --saved-model ./saved_model --output ./boscdex_classifier_int8.tflite --representative-dataset ./dataset
"""

import argparse
import os
import numpy as np
from pathlib import Path


def quantize_and_export(
    saved_model_dir: str,
    output_path: str,
    representative_dataset_dir: str = None,
):
    """Quantize a SavedModel to INT8 TFLite format."""

    try:
        import tensorflow as tf
    except ImportError:
        print("TensorFlow is required. Install with: pip install tensorflow")
        exit(1)

    print(f"\n🍄 Boscdex Model Quantizer")
    print(f"   Input:  {saved_model_dir}")
    print(f"   Output: {output_path}\n")

    # Load converter
    converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)

    # Enable INT8 quantization
    converter.optimizations = [tf.lite.Optimize.DEFAULT]

    # If representative dataset provided, use full integer quantization
    if representative_dataset_dir:
        print("   Using representative dataset for full integer quantization...")

        def representative_dataset_gen():
            """Generate representative samples for calibration."""
            dataset_path = Path(representative_dataset_dir)
            image_files = []
            for ext in ['*.jpg', '*.jpeg', '*.png']:
                image_files.extend(dataset_path.rglob(ext))

            # Use up to 200 representative samples
            np.random.shuffle(image_files)
            for img_path in image_files[:200]:
                try:
                    img = tf.io.read_file(str(img_path))
                    img = tf.image.decode_image(img, channels=3)
                    img = tf.image.resize(img, [224, 224])
                    img = tf.cast(img, tf.float32) / 127.5 - 1.0  # Normalize to [-1, 1]
                    img = tf.expand_dims(img, 0)
                    yield [img.numpy()]
                except Exception:
                    continue

        converter.representative_dataset = representative_dataset_gen
        converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
        converter.inference_input_type = tf.uint8
        converter.inference_output_type = tf.uint8

    # Convert
    print("   Converting model...")
    tflite_model = converter.convert()

    # Save
    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)
    with open(output, 'wb') as f:
        f.write(tflite_model)

    size_mb = output.stat().st_size / (1024 * 1024)
    print(f"\n✅ Model exported successfully!")
    print(f"   Path: {output}")
    print(f"   Size: {size_mb:.1f} MB")

    if size_mb <= 18:
        print(f"   ✓ Within 18 MB target budget")
    else:
        print(f"   ⚠ Exceeds 18 MB target ({size_mb:.1f} MB)")


def main():
    parser = argparse.ArgumentParser(
        description='Quantize and export Boscdex classifier to INT8 TFLite'
    )
    parser.add_argument(
        '--saved-model', type=str, required=True,
        help='Path to TensorFlow SavedModel directory'
    )
    parser.add_argument(
        '--output', type=str, default='./boscdex_classifier_int8.tflite',
        help='Output path for the quantized TFLite model'
    )
    parser.add_argument(
        '--representative-dataset', type=str, default=None,
        help='Path to representative dataset for full INT8 quantization calibration'
    )
    args = parser.parse_args()
    quantize_and_export(args.saved_model, args.output, args.representative_dataset)


if __name__ == '__main__':
    main()
