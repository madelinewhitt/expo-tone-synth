import ExpoModulesCore
import AVFoundation
import UIKit
import Accelerate

public class ToneGenerator {
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let pitchNode = AVAudioUnitTimePitch()
    var eqNode = AVAudioUnitEQ(numberOfBands: 1)
    private var audioPlayers: [AVAudioPlayer] = []
    private var urlToPlayerMap: [URL: AVAudioPlayer] = [:]
    private var buffer: AVAudioPCMBuffer?
    private var frameLength: AVAudioFrameCount = 0
    private var isPlaying: Bool = false

    public func getIsPlaying() -> Bool {
        return isPlaying
    }

    public func playWhiteNoise() {
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 11025.0, channels: 1) else {
            fatalError("Unable to create AVAudioFormat object")
        }

        let frameLength = AVAudioFrameCount(format.sampleRate * 2) // 2 seconds of white noise
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameLength) else {
            fatalError("Unable to create AVAudioPCMBuffer object")
        }

        guard let floatChannelData = buffer.floatChannelData else {
            fatalError("Unable to access floatChannelData")
        }

        for frame in 0..<Int(frameLength) {
            floatChannelData[0][frame] = Float.random(in: -1.0...1.0)
        }

        buffer.frameLength = frameLength
        self.buffer = buffer

        audioEngine.attach(playerNode)
        eqNode.globalGain = 0
        eqNode.bands[0].filterType = .lowPass
        eqNode.bands[0].frequency = 20.0 // Default frequency, can be adjusted, preferably at 0 
        eqNode.bands[0].bypass = false
        audioEngine.attach(eqNode)
        audioEngine.connect(playerNode, to: eqNode, format: format)
        audioEngine.connect(eqNode, to: audioEngine.mainMixerNode, format: format)

        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)

        do {
            try audioEngine.start()
            playerNode.play()
            isPlaying = true
        } catch {
            fatalError("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }

    public func adjustFrequency(frequency: Float) {
        print("Adjusting frequency to \(frequency) Hz")
        eqNode.bands[0].frequency = frequency
    }


    // Stops all sounds from playing simultaneously 
    public func stop() {
        playerNode.stop()
        audioEngine.stop()

        for audioPlayer in audioPlayers {
            audioPlayer.stop()
        }
        audioPlayers.removeAll()
        urlToPlayerMap.removeAll()

        isPlaying = false
    }

    // IP: would like this to set the white noise frequency 
    public func setFrequency(frequency: Double, amplitudes: [Double] = [1.0], adsr: ADSR? = nil) {
        guard let format = buffer?.format,
              let buffer = createBuffer(frequency: frequency, amplitudes: amplitudes, format: format, adsr: adsr) else {
            fatalError("Unable to create AVAudioPCMBuffer object")
        }

        self.buffer = buffer
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        playerNode.play()
    }

    // This takes a url and plays a corresponding sound 
    public func playSoundFromURL(from url: URL) {
        let session = URLSession(configuration: .default)
        
        let downloadTask = session.downloadTask(with: url) { [weak self] (location, response, error) in
            guard let self = self else { return }
            if let location = location {
                do {
                    let data = try Data(contentsOf: location)
                    let audioPlayer = try AVAudioPlayer(data: data)
                    // This loops forever until you tell it not to 
                    audioPlayer.numberOfLoops = -1 
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    self.audioPlayers.append(audioPlayer)
                    self.urlToPlayerMap[url] = audioPlayer  // Save the audio player to the map
                } catch let error {
                    print("Error initializing AVAudioPlayer: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Error downloading audio file: \(error.localizedDescription)")
            }
        }
        
        downloadTask.resume()
    }

    // Maps the url accepted to the corresponding sound playing and stops it 
    public func stopSoundFromURL(from url: URL) {
        if let audioPlayer = urlToPlayerMap[url] {
            audioPlayer.stop()
            print("audioPlayer.stop()")
            if let index = audioPlayers.firstIndex(of: audioPlayer) {
                audioPlayers.remove(at: index)
            }
            urlToPlayerMap.removeValue(forKey: url)
            print("Audio player found")
        } else {
            print("No audio player found for URL: \(url)")
        }
    }

    // Adjusts URL volume, accepts a url and a float to adjust the volume accordingly 
    public func setVolumeForURL(from url: URL, amplitude: Float) {
        if let audioPlayer = urlToPlayerMap[url] {
            audioPlayer.volume = amplitude
        } else {
            print("No audio player found for URL: \(url)")
        }
    }

    // This doesn't work, but it's a function that is supposed to perform an FFT and return
    // an array of floats that can then be graphed in the front-end component 
    // public func performFFT() -> [Float] {
    //     guard let buffer = self.buffer, let floatChannelData = buffer.floatChannelData else {
    //         fatalError("Buffer or floatChannelData is nil")
    //     }

    //     let frameLength = Int(buffer.frameLength)
        
    //     guard frameLength.isPowerOf2 else {
    //         fatalError("Frame length must be a power of 2")
    //     }
        
    //     let log2n = UInt(log2(Double(frameLength)))
    //     guard let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else {
    //         fatalError("FFT setup failed")
    //     }

    //     var realp = [Float](repeating: 0.0, count: frameLength / 2)
    //     var imagp = [Float](repeating: 0.0, count: frameLength / 2)

    //     var complexBuffer = [DSPComplex](repeating: DSPComplex(real: 0.0, imag: 0.0), count: frameLength / 2)

    //     for i in 0..<frameLength / 2 {
    //         complexBuffer[i] = DSPComplex(real: floatChannelData[0][i * 2], imag: floatChannelData[0][i * 2 + 1])
    //     }

    //     var splitComplex = DSPSplitComplex(realp: &realp, imagp: &imagp)
    //     complexBuffer.withUnsafeBufferPointer { pointer in
    //         vDSP_ctoz(pointer.baseAddress!, 2, &splitComplex, 1, vDSP_Length(frameLength / 2))
    //     }

    //     vDSP_fft_zrip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))

    //     var magnitudes = [Float](repeating: 0.0, count: frameLength / 2)
    //     vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(frameLength / 2))

    //     vDSP_destroy_fftsetup(fftSetup)

    //     return magnitudes.map { sqrt($0) }
    // }

    private func createBuffer(frequency: Double, amplitudes: [Double], format: AVAudioFormat, adsr: ADSR? = nil) -> AVAudioPCMBuffer? {
        let sampleRate = format.sampleRate
        frameLength = AVAudioFrameCount(sampleRate / frequency)

        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameLength) else {
            return nil
        }

        guard let floatChannelData = buffer.floatChannelData else {
            return nil
        }

        for frame in 0..<Int(frameLength) {
            let time = Double(frame) / sampleRate
            var sampleValue: Float32 = 0.0

            for (index, amplitude) in amplitudes.enumerated() {
                let harmonicFrequency = frequency * Double(index + 1)
                sampleValue += Float32(amplitude * sin(2.0 * Double.pi * harmonicFrequency * time))
            }

            floatChannelData[0][frame] = sampleValue
        }

        normalize(buffer: buffer)

        if let adsr = adsr {
            applyADSR(buffer: buffer, adsr: adsr)
        }

        buffer.frameLength = frameLength

        return buffer
    }

    private func normalize(buffer: AVAudioPCMBuffer) {
        guard let floatChannelData = buffer.floatChannelData else {
            return
        }

        let frameLength = Int(buffer.frameLength)
        var maxAmplitude: Float32 = 0.0

        for frame in 0..<frameLength {
            maxAmplitude = max(maxAmplitude, abs(floatChannelData[0][frame]))
        }

        if maxAmplitude > 0.0 {
            let normalizationFactor = 1.0 / maxAmplitude
            for frame in 0..<frameLength {
                floatChannelData[0][frame] *= normalizationFactor
            }
        }
    }

    private func applyADSR(buffer: AVAudioPCMBuffer, adsr: ADSR) {
        guard let floatChannelData = buffer.floatChannelData else {
            return
        }

        let sampleRate = buffer.format.sampleRate
        let frameLength = Int(buffer.frameLength)
        let totalDuration = Double(frameLength) / sampleRate

        let attackEnd = Int(adsr.attack * sampleRate)
        let decayEnd = attackEnd + Int(adsr.decay * sampleRate)
        let releaseStart = frameLength - Int(adsr.release * sampleRate)

        for frame in 0..<frameLength {
            let time = Double(frame) / sampleRate
            var amplitude: Float32 = 1.0

            if frame < attackEnd {
                amplitude = Float32(time / adsr.attack)
            } else if frame < decayEnd {
                amplitude = Float32(1.0 - ((time - adsr.attack) / adsr.decay) * (1.0 - adsr.sustain))
            } else if frame < releaseStart {
                amplitude = Float32(adsr.sustain)
            } else {
                amplitude = Float32(adsr.sustain * (1.0 - (time - (totalDuration - adsr.release)) / adsr.release))
            }

            floatChannelData[0][frame] *= amplitude
        }
    }
}

public struct ADSR {
    var attack: Double
    var decay: Double
    var sustain: Double
    var release: Double

    public init(attack: Double, decay: Double, sustain: Double, release: Double) {
        self.attack = attack
        self.decay = decay
        self.sustain = sustain
        self.release = release
    }
}

public class ToneGeneratorModule: Module {
    public func definition() -> ModuleDefinition {
        Name("ToneGenerator")

        let toneGenerator = ToneGenerator()

        Function("getIsPlaying") { () in
            return toneGenerator.getIsPlaying()
        }

        AsyncFunction("playWhiteNoise") { () in
            toneGenerator.playWhiteNoise()
        }

        AsyncFunction("adjustFrequency") { (frequency: Float) in
            toneGenerator.adjustFrequency(frequency: frequency)
        }

        AsyncFunction("stop") { () in
            toneGenerator.stop()
        }

        AsyncFunction("setWhiteNoiseAmplitude") { (amplitude: Float) in
            toneGenerator.setWhiteNoiseAmplitude(amplitude: amplitude)
        }

        AsyncFunction("playSoundFromURL") { (url: URL) in
            toneGenerator.playSoundFromURL(from: url)
        }
        
        AsyncFunction("stopSoundFromURL") { (url: URL) in
            toneGenerator.stopSoundFromURL(from: url)
        }

        AsyncFunction("setVolumeForURL") { (url: URL, amplitude: Float) in
            toneGenerator.setVolumeForURL(from: url, amplitude: amplitude)
        }

        // AsyncFunction("performFFT") { () in 
        //     toneGenerator.performFFT() 
        // }
    }
}
