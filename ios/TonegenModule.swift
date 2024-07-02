import ExpoModulesCore
import AVFoundation
import UIKit
import Accelerate

public class ToneGenerator {
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let pitchNode = AVAudioUnitTimePitch()
    private var audioPlayers: [AVAudioPlayer] = []
    private var urlToPlayerMap: [URL: AVAudioPlayer] = [:]
    private var buffer: AVAudioPCMBuffer?
    private var frameLength: AVAudioFrameCount = 0
    private var isPlaying: Bool = false

    public func getIsPlaying() -> Bool {
        return isPlaying
    }

    public func play(frequency: Double, amplitudes: [Double] = [1.0], adsr: ADSR? = nil) {
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 11025.0, channels: 1),
              let buffer = createBuffer(frequency: frequency, amplitudes: amplitudes, format: format, adsr: adsr) else {
            fatalError("Unable to create AVAudioFormat or AVAudioPCMBuffer objects")
        }

        self.buffer = buffer

        audioEngine.attach(playerNode)
        audioEngine.attach(pitchNode)
        audioEngine.connect(playerNode, to: pitchNode, format: format)
        audioEngine.connect(pitchNode, to: audioEngine.mainMixerNode, format: format)

        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)

        do {
            try audioEngine.start()
            playerNode.play()
            isPlaying = true
        } catch {
            fatalError("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
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
        audioEngine.attach(pitchNode)
        audioEngine.connect(playerNode, to: pitchNode, format: format)
        audioEngine.connect(pitchNode, to: audioEngine.mainMixerNode, format: format)

        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)

        do {
            try audioEngine.start()
            playerNode.play()
            isPlaying = true
        } catch {
            fatalError("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }

    public func playBrownNoise() {
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 11025.0, channels: 1) else {
            fatalError("Unable to create AVAudioFormat object")
        }

        let frameLength = AVAudioFrameCount(format.sampleRate * 2) // 2 seconds of brown noise
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameLength) else {
            fatalError("Unable to create AVAudioPCMBuffer object")
        }

        guard let floatChannelData = buffer.floatChannelData else {
            fatalError("Unable to access floatChannelData")
        }

        var lastOutput: Float = 0.0
        for frame in 0..<Int(frameLength) {
            let whiteNoise = Float.random(in: -1.0...1.0)
            floatChannelData[0][frame] = lastOutput + (0.02 * whiteNoise)
            lastOutput = floatChannelData[0][frame]
            // Scale to keep within [-1.0, 1.0] range
            floatChannelData[0][frame] *= 0.5
        }

        buffer.frameLength = frameLength
        self.buffer = buffer

        audioEngine.attach(playerNode)
        audioEngine.attach(pitchNode)
        audioEngine.connect(playerNode, to: pitchNode, format: format)
        audioEngine.connect(pitchNode, to: audioEngine.mainMixerNode, format: format)

        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)

        do {
            try audioEngine.start()
            playerNode.play()
            isPlaying = true
        } catch {
            fatalError("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }

    public func playPinkNoise() {
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 11025.0, channels: 1) else {
            fatalError("Unable to create AVAudioFormat object")
        }

        let frameLength = AVAudioFrameCount(format.sampleRate * 2) // 2 seconds of pink noise
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameLength) else {
            fatalError("Unable to create AVAudioPCMBuffer object")
        }

        guard let floatChannelData = buffer.floatChannelData else {
            fatalError("Unable to access floatChannelData")
        }

        var b: [Float] = [0, 0, 0, 0, 0, 0, 0]
        for frame in 0..<Int(frameLength) {
            let whiteNoise = Float.random(in: -1.0...1.0)
            b[0] = 0.99886 * b[0] + whiteNoise * 0.0555179
            b[1] = 0.99332 * b[1] + whiteNoise * 0.0750759
            b[2] = 0.96900 * b[2] + whiteNoise * 0.1538520
            b[3] = 0.86650 * b[3] + whiteNoise * 0.3104856
            b[4] = 0.55000 * b[4] + whiteNoise * 0.5329522
            b[5] = -0.7616 * b[5] - whiteNoise * 0.0168980
            floatChannelData[0][frame] = b[0] + b[1] + b[2] + b[3] + b[4] + b[5] + b[6] + whiteNoise * 0.5362
            // make a new sample app where these knobs are adjustable 
            floatChannelData[0][frame] *= 0.11  // approximate gain normalization
            b[6] = whiteNoise * 0.115926
            floatChannelData[0][frame] = b[0] + b[1] + b[2] + b[3] + b[4] + b[5] + b[6] + whiteNoise * 0.5362
            // Adjusting gain normalization to match new coefficients
            floatChannelData[0][frame] *= 0.15  // approximate gain normalization
            b[6] = whiteNoise * 0.115926
        }

        buffer.frameLength = frameLength
        self.buffer = buffer

        audioEngine.attach(playerNode)
        audioEngine.attach(pitchNode)
        audioEngine.connect(playerNode, to: pitchNode, format: format)
        audioEngine.connect(pitchNode, to: audioEngine.mainMixerNode, format: format)

        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)

        do {
            try audioEngine.start()
            playerNode.play()
            isPlaying = true
        } catch {
            fatalError("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }

    public func changePitch(pitch: Float) {
        print("Changing pitch to \(pitch)")
        pitchNode.pitch = pitch
    }

    public func pinkNoiseTest(coefficient1: Float, coefficient2: Float, coefficient3: Float, coefficient4: Float, 
    coefficient5: Float, coefficient6: Float, pitch: Float) {

        guard let format = AVAudioFormat(standardFormatWithSampleRate: 11025.0, channels: 1) else {
            fatalError("Unable to create AVAudioFormat object")
        }

        let frameLength = AVAudioFrameCount(format.sampleRate * 2) // 2 seconds of pink noise
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameLength) else {
            fatalError("Unable to create AVAudioPCMBuffer object")
        }

        guard let floatChannelData = buffer.floatChannelData else {
            fatalError("Unable to access floatChannelData")
        }

        var b: [Float] = [0, 0, 0, 0, 0, 0, 0]
        for frame in 0..<Int(frameLength) {
            let whiteNoise = Float.random(in: -1.0...1.0)
            b[0] = coefficient1 * b[0] + whiteNoise * 0.0555179
            b[1] = coefficient2 * b[1] + whiteNoise * 0.0750759
            b[2] = coefficient3 * b[2] + whiteNoise * 0.1538520
            b[3] = coefficient4 * b[3] + whiteNoise * 0.3104856
            b[4] = coefficient5 * b[4] + whiteNoise * 0.5329522
            b[5] = coefficient6 * b[5] - whiteNoise * 0.0168980
            floatChannelData[0][frame] = b[0] + b[1] + b[2] + b[3] + b[4] + b[5] + b[6] + whiteNoise * 0.5362
            // Adjusting gain normalization to match new coefficients
            floatChannelData[0][frame] *= 0.15  // approximate gain normalization
            b[6] = whiteNoise * 0.115926
        }

        buffer.frameLength = frameLength
        self.buffer = buffer

        audioEngine.attach(playerNode)
        let pitchNode = AVAudioUnitTimePitch()
        pitchNode.pitch = pitch
        audioEngine.attach(pitchNode)
        audioEngine.connect(playerNode, to: pitchNode, format: format)
        audioEngine.connect(pitchNode, to: audioEngine.mainMixerNode, format: format)

        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)

        do {
            try audioEngine.start()
            playerNode.play()
            isPlaying = true
        } catch {
            fatalError("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }

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

    public func setWhiteNoiseAmplitude(amplitude: Float) {
        playerNode.volume = amplitude
    }

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

    public func playSoundFromURL(from url: URL) {
        let session = URLSession(configuration: .default)
        
        let downloadTask = session.downloadTask(with: url) { [weak self] (location, response, error) in
            guard let self = self else { return }
            if let location = location {
                do {
                    let data = try Data(contentsOf: location)
                    let audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer.numberOfLoops = -1 // Set to loop indefinitely
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

    public func setVolumeForURL(from url: URL, amplitude: Float) {
        if let audioPlayer = urlToPlayerMap[url] {
            audioPlayer.volume = amplitude
        } else {
            print("No audio player found for URL: \(url)")
        }
    }

    public func performFFT() -> [Float] {
        guard let buffer = self.buffer, let floatChannelData = buffer.floatChannelData else {
            fatalError("Buffer or floatChannelData is nil")
        }

        let frameLength = Int(buffer.frameLength)
        
        guard frameLength.isPowerOf2 else {
            fatalError("Frame length must be a power of 2")
        }
        
        let log2n = UInt(log2(Double(frameLength)))
        guard let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else {
            fatalError("FFT setup failed")
        }

        var realp = [Float](repeating: 0.0, count: frameLength / 2)
        var imagp = [Float](repeating: 0.0, count: frameLength / 2)

        var complexBuffer = [DSPComplex](repeating: DSPComplex(real: 0.0, imag: 0.0), count: frameLength / 2)

        for i in 0..<frameLength / 2 {
            complexBuffer[i] = DSPComplex(real: floatChannelData[0][i * 2], imag: floatChannelData[0][i * 2 + 1])
        }

        var splitComplex = DSPSplitComplex(realp: &realp, imagp: &imagp)
        complexBuffer.withUnsafeBufferPointer { pointer in
            vDSP_ctoz(pointer.baseAddress!, 2, &splitComplex, 1, vDSP_Length(frameLength / 2))
        }

        vDSP_fft_zrip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))

        var magnitudes = [Float](repeating: 0.0, count: frameLength / 2)
        vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(frameLength / 2))

        vDSP_destroy_fftsetup(fftSetup)

        return magnitudes.map { sqrt($0) }
    }

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

        AsyncFunction("play") { (frequency: Double, amplitudes: [Double], adsr: [Double]) in
            let adsrEnvelope = ADSR(attack: adsr[0], decay: adsr[1], sustain: adsr[2], release: adsr[3])
            toneGenerator.play(frequency: frequency, amplitudes: amplitudes, adsr: adsrEnvelope)
        }

        AsyncFunction("playWhiteNoise") { () in
            toneGenerator.playWhiteNoise()
        }

        AsyncFunction("playBrownNoise") { () in
            toneGenerator.playBrownNoise()
        }

        AsyncFunction("playPinkNoise") { () in
            toneGenerator.playPinkNoise()
        }

        AsyncFunction("changePitch") { (pitch: Float) in
            toneGenerator.changePitch(pitch: pitch)
        }

        AsyncFunction("pinkNoiseTest") { (coefficient1: Float, coefficient2: Float, coefficient3: Float, coefficient4: Float, 
        coefficient5: Float, coefficient6: Float, pitch: Float) in 
            toneGenerator.pinkNoiseTest(coefficient1: coefficient1, coefficient2: coefficient2, coefficient3: coefficient3,
            coefficient4: coefficient4, coefficient5: coefficient5, coefficient6: coefficient6, pitch: pitch)
        }

        AsyncFunction("stop") { () in
            toneGenerator.stop()
        }

        AsyncFunction("setFrequency") { (frequency: Double, amplitudes: [Double], adsr: [Double]) in
            let adsrEnvelope = ADSR(attack: adsr[0], decay: adsr[1], sustain: adsr[2], release: adsr[3])
            toneGenerator.setFrequency(frequency: frequency, amplitudes: amplitudes, adsr: adsrEnvelope)
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

        AsyncFunction("performFFT") { () in 
            toneGenerator.performFFT() 
        }
    }
}
