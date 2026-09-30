#!/usr/bin/env python3
"""
Generate authentic 8-bit retro sound effects (WAV) for Boscdex.
Emulates Game Boy / NES PSG (Programmable Sound Generator) square wave and noise channels.
"""
import math
import os
import struct
import wave

SAMPLE_RATE = 22050  # Classic low-res retro sample rate

def square_wave(freq, duty=0.5):
    """Generates a square wave sample generator with specified duty cycle."""
    phase = 0.0
    phase_inc = freq / SAMPLE_RATE
    while True:
        yield 1.0 if (phase % 1.0) < duty else -1.0
        phase += phase_inc

def generate_tone(freqs_and_durations, duty=0.5, volume=0.5, vibrato=False, decay=True):
    """
    freqs_and_durations: list of (frequency_hz, duration_sec)
    """
    samples = []
    for freq, duration in freqs_and_durations:
        num_samples = int(duration * SAMPLE_RATE)
        phase = 0.0
        phase_inc = freq / SAMPLE_RATE
        for i in range(num_samples):
            t = i / SAMPLE_RATE
            # Optional vibrato
            current_freq = freq
            if vibrato and freq > 0:
                current_freq += math.sin(2 * math.pi * 6.0 * t) * (freq * 0.02)
                phase_inc = current_freq / SAMPLE_RATE

            val = 1.0 if (phase % 1.0) < duty else -1.0
            phase += phase_inc

            # Envelope
            env = 1.0
            if decay:
                env = max(0.0, 1.0 - (i / num_samples))
            
            samples.append(val * volume * env)
    return samples

def generate_shutter():
    """Generates an 8-bit mechanical camera shutter click (noise burst + mechanical thud)."""
    samples = []
    # 1. Initial click (15ms white noise with fast decay)
    import random
    random.seed(42)
    click_samples = int(0.018 * SAMPLE_RATE)
    for i in range(click_samples):
        env = (1.0 - (i / click_samples)) ** 2
        samples.append((random.random() * 2.0 - 1.0) * 0.45 * env)

    # 2. Brief mechanical pause (35ms silence)
    pause_samples = int(0.035 * SAMPLE_RATE)
    samples.extend([0.0] * pause_samples)

    # 3. Second heavier clack (45ms: 180Hz square drop to 90Hz + noise)
    clack_samples = int(0.055 * SAMPLE_RATE)
    phase = 0.0
    for i in range(clack_samples):
        t = i / clack_samples
        f = 180.0 * (1.0 - t * 0.5)
        phase += f / SAMPLE_RATE
        sq = 1.0 if (phase % 1.0) < 0.5 else -1.0
        noise = (random.random() * 2.0 - 1.0) * 0.3
        env = (1.0 - t) ** 1.5
        samples.append((sq * 0.7 + noise * 0.3) * 0.5 * env)

    return samples

def generate_blip():
    """Short crisp 8-bit UI selection blip (30ms)."""
    samples = []
    num_samples = int(0.035 * SAMPLE_RATE)
    phase = 0.0
    for i in range(num_samples):
        t = i / num_samples
        # Quick pitch rise from 1000Hz to 1600Hz
        freq = 1000.0 + 600.0 * t
        phase += freq / SAMPLE_RATE
        val = 1.0 if (phase % 1.0) < 0.5 else -1.0
        env = 1.0 - (t ** 2)
        samples.append(val * 0.35 * env)
    return samples

def generate_discovery():
    """
    Authentic Pokédex discovery fanfare!
    Fast arpeggio: C5 -> E5 -> G5 -> C6 (held with vibrato).
    """
    # C5=523.25, E5=659.25, G5=783.99, C6=1046.50
    notes = [
        (523.25, 0.07),
        (659.25, 0.07),
        (783.99, 0.07),
        (1046.50, 0.32),
    ]
    samples = []
    # Note 1-3: fast staccato square wave (duty 0.25 for crisp retro bite)
    for freq, dur in notes[:-1]:
        samples.extend(generate_tone([(freq, dur)], duty=0.25, volume=0.42, decay=True))
    # Final note: sustained C6 with vibrato
    samples.extend(generate_tone([notes[-1]], duty=0.5, volume=0.48, vibrato=True, decay=True))
    return samples

def generate_badge():
    """
    Victory triumph fanfare for unlocking an Insignia!
    G4 -> C5 -> E5 -> G5 -> E5 -> G5 (longer triumph).
    """
    # G4=392.00, C5=523.25, E5=659.25, G5=783.99
    notes = [
        (392.00, 0.08),
        (523.25, 0.08),
        (659.25, 0.08),
        (783.99, 0.12),
        (659.25, 0.08),
        (783.99, 0.40),
    ]
    samples = []
    for i, (freq, dur) in enumerate(notes):
        is_last = (i == len(notes) - 1)
        duty = 0.5 if is_last else 0.25
        samples.extend(generate_tone([(freq, dur)], duty=duty, volume=0.44, vibrato=is_last, decay=True))
    return samples

def write_wav(filename, samples):
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with wave.open(filename, 'w') as wav_file:
        # Mono, 16-bit PCM, 22050 Hz
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(SAMPLE_RATE)
        
        # Clip and convert to 16-bit signed integers
        raw_data = bytearray()
        for s in samples:
            clamped = max(-1.0, min(1.0, s))
            int_val = int(clamped * 32767.0)
            raw_data.extend(struct.pack('<h', int_val))
            
        wav_file.writeframes(raw_data)
    print(f"Generated {filename} ({len(samples)} samples, {len(raw_data)} bytes)")

def main():
    target_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'audio')
    target_dir = os.path.abspath(target_dir)

    write_wav(os.path.join(target_dir, 'shutter.wav'), generate_shutter())
    write_wav(os.path.join(target_dir, 'blip.wav'), generate_blip())
    write_wav(os.path.join(target_dir, 'discovery.wav'), generate_discovery())
    write_wav(os.path.join(target_dir, 'badge.wav'), generate_badge())
    print("All 8-bit sound effects generated successfully!")

if __name__ == '__main__':
    main()
