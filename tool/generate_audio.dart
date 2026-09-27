import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() {
  final sfxDir = Directory('assets/audio/sfx');
  final bgmDir = Directory('assets/audio/bgm');
  sfxDir.createSync(recursive: true);
  bgmDir.createSync(recursive: true);

  print('Generating audio assets...');

  // 1. tap.wav (Crisp wooden block / marimba tap)
  _writeWav(
    File('${sfxDir.path}/tap.wav'),
    _generateTone(
      durationSec: 0.09,
      sampleRate: 22050,
      fn: (t) {
        final decay = exp(-35 * t);
        final osc1 = sin(2 * pi * 720 * t);
        final osc2 = sin(2 * pi * 1440 * t) * 0.3;
        return (osc1 + osc2) * decay;
      },
    ),
    sampleRate: 22050,
  );

  // 2. coin.wav (Sparkling golden double ding)
  _writeWav(
    File('${sfxDir.path}/coin.wav'),
    _generateTone(
      durationSec: 0.35,
      sampleRate: 22050,
      fn: (t) {
        double val = 0.0;
        // First ding (B5: 987 Hz)
        if (t < 0.25) {
          final t1 = t;
          val += sin(2 * pi * 987.77 * t1) * exp(-20 * t1) * 0.7;
          val += sin(2 * pi * 1975.5 * t1) * exp(-30 * t1) * 0.3;
        }
        // Second higher ding (E6: 1318 Hz) after 0.08s
        if (t >= 0.08) {
          final t2 = t - 0.08;
          val += sin(2 * pi * 1318.5 * t2) * exp(-14 * t2) * 0.9;
          val += sin(2 * pi * 2637.0 * t2) * exp(-25 * t2) * 0.4;
        }
        return val.clamp(-1.0, 1.0);
      },
    ),
    sampleRate: 22050,
  );

  // 3. word_found.wav (Melodic harp / bell arpeggio: C5 - E5 - G5 - C6)
  _writeWav(
    File('${sfxDir.path}/word_found.wav'),
    _generateTone(
      durationSec: 0.85,
      sampleRate: 22050,
      fn: (t) {
        double val = 0.0;
        final notes = [
          (0.00, 523.25), // C5
          (0.10, 659.25), // E5
          (0.20, 783.99), // G5
          (0.30, 1046.50), // C6
        ];
        for (final note in notes) {
          final startTime = note.$1;
          final freq = note.$2;
          if (t >= startTime) {
            final noteTime = t - startTime;
            final decay = exp(-7 * noteTime);
            val += sin(2 * pi * freq * noteTime) * decay * 0.4;
            // Harmonic chime shimmer
            val += sin(2 * pi * freq * 2 * noteTime) * decay * 0.15;
          }
        }
        return val.clamp(-1.0, 1.0);
      },
    ),
    sampleRate: 22050,
  );

  // 4. level_complete.wav (Grand celebratory fanfare)
  _writeWav(
    File('${sfxDir.path}/level_complete.wav'),
    _generateTone(
      durationSec: 1.6,
      sampleRate: 22050,
      fn: (t) {
        double val = 0.0;
        final notes = [
          (0.00, 523.25), // C5
          (0.12, 659.25), // E5
          (0.24, 783.99), // G5
          (0.36, 1046.50), // C6
          (0.55, 1174.66), // D6
          (0.75, 1318.51), // E6
          (0.95, 1567.98), // G6 (sustained finale)
        ];
        for (int i = 0; i < notes.length; i++) {
          final startTime = notes[i].$1;
          final freq = notes[i].$2;
          final isFinal = (i == notes.length - 1);
          if (t >= startTime) {
            final dt = t - startTime;
            final decayRate = isFinal ? 3.5 : 9.0;
            final decay = exp(-decayRate * dt);
            val += sin(2 * pi * freq * dt) * decay * 0.45;
            val += sin(2 * pi * freq * 1.5 * dt) * decay * 0.15;
          }
        }
        return val.clamp(-1.0, 1.0);
      },
    ),
    sampleRate: 22050,
  );

  // 5. wrong.wav (Soft double wooden thud)
  _writeWav(
    File('${sfxDir.path}/wrong.wav'),
    _generateTone(
      durationSec: 0.28,
      sampleRate: 22050,
      fn: (t) {
        double val = 0.0;
        // First thud
        if (t < 0.15) {
          val += sin(2 * pi * 160 * t) * exp(-28 * t) * 0.7;
        }
        // Second lower thud
        if (t >= 0.12) {
          final t2 = t - 0.12;
          val += sin(2 * pi * 130 * t2) * exp(-30 * t2) * 0.7;
        }
        return val.clamp(-1.0, 1.0);
      },
    ),
    sampleRate: 22050,
  );

  // 6. bird_chirp.wav (টুনটুনি's sweet playful bird chirp)
  _writeWav(
    File('${sfxDir.path}/bird_chirp.wav'),
    _generateTone(
      durationSec: 0.32,
      sampleRate: 22050,
      fn: (t) {
        // Two quick ascending chirps
        double val = 0.0;
        if (t < 0.14) {
          final sweepFreq = 2200 + 1600 * (t / 0.14);
          val += sin(2 * pi * sweepFreq * t) * sin(pi * (t / 0.14)) * 0.7;
        } else if (t >= 0.16) {
          final t2 = t - 0.16;
          final sweepFreq = 2600 + 1800 * (t2 / 0.16);
          val += sin(2 * pi * sweepFreq * t2) * sin(pi * (t2 / 0.16)) * 0.8;
        }
        return val.clamp(-1.0, 1.0);
      },
    ),
    sampleRate: 22050,
  );

  // 7. nature.wav (Calm ambient looping drone / bamboo flute harmony)
  _writeWav(
    File('${bgmDir.path}/nature.wav'),
    _generateTone(
      durationSec: 4.0,
      sampleRate: 22050,
      fn: (t) {
        // Pentatonic chord harmony (D4 = 293.66, F#4 = 369.99, A4 = 440.0, D5 = 587.33)
        final envelope = sin(pi * (t / 4.0)); // smooth loop envelope
        final tremolo = 1.0 + 0.15 * sin(2 * pi * 4 * t);
        final o1 = sin(2 * pi * 293.66 * t);
        final o2 = sin(2 * pi * 440.00 * t) * 0.7;
        final o3 = sin(2 * pi * 587.33 * t) * 0.4;
        final o4 = sin(2 * pi * 739.99 * t) * 0.25;
        return (o1 + o2 + o3 + o4) * 0.25 * envelope * tremolo;
      },
    ),
    sampleRate: 22050,
  );

  print('All 7 audio assets generated successfully in assets/audio/!');
}

List<int> _generateTone({
  required double durationSec,
  required int sampleRate,
  required double Function(double t) fn,
}) {
  final numSamples = (durationSec * sampleRate).toInt();
  final samples = Int16List(numSamples);
  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final val = fn(t).clamp(-1.0, 1.0);
    samples[i] = (val * 32767).toInt();
  }
  return samples.buffer.asUint8List();
}

void _writeWav(File file, List<int> pcmBytes, {required int sampleRate}) {
  final numSamples = pcmBytes.length ~/ 2;
  final byteRate = sampleRate * 1 * 2; // 1 channel, 16-bit (2 bytes)
  final dataSize = numSamples * 2;
  final totalSize = 36 + dataSize;

  final header = ByteData(44);
  // RIFF
  header.setUint8(0, 0x52); // R
  header.setUint8(1, 0x49); // I
  header.setUint8(2, 0x46); // F
  header.setUint8(3, 0x46); // F
  header.setUint32(4, totalSize, Endian.little);
  header.setUint8(8, 0x57);  // W
  header.setUint8(9, 0x41);  // A
  header.setUint8(10, 0x56); // V
  header.setUint8(11, 0x45); // E
  // fmt
  header.setUint8(12, 0x66); // f
  header.setUint8(13, 0x6D); // m
  header.setUint8(14, 0x74); // t
  header.setUint8(15, 0x20); // ' '
  header.setUint32(16, 16, Endian.little); // subchunk1size (16 for PCM)
  header.setUint16(20, 1, Endian.little);  // audioFormat (1 for PCM)
  header.setUint16(22, 1, Endian.little);  // numChannels (1 = mono)
  header.setUint32(24, sampleRate, Endian.little);
  header.setUint32(28, byteRate, Endian.little);
  header.setUint16(32, 2, Endian.little);  // blockAlign (numChannels * bitsPerSample/8)
  header.setUint16(34, 16, Endian.little); // bitsPerSample
  // data
  header.setUint8(36, 0x64); // d
  header.setUint8(37, 0x61); // a
  header.setUint8(38, 0x74); // t
  header.setUint8(39, 0x61); // a
  header.setUint32(40, dataSize, Endian.little);

  final builder = BytesBuilder();
  builder.add(header.buffer.asUint8List());
  builder.add(pcmBytes);

  file.writeAsBytesSync(builder.toBytes());
  print('Saved ${file.path} (${file.lengthSync()} bytes)');
}
