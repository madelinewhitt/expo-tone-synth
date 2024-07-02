import ToneGeneratorModule from "./ToneGeneratorModule";
export const getIsPlaying = () => ToneGeneratorModule.getIsPlaying();
export const playWhiteNoise = () => ToneGeneratorModule.playWhiteNoise();
export const playPinkNoise = () => ToneGeneratorModule.playPinkNoise();
export const playBrownNoise = () => ToneGeneratorModule.playBrownNoise();
export const setWhiteNoisePitch = async (pitch) => ToneGeneratorModule.setWhiteNoisePitch(pitch);
export const setWhiteNoiseAmplitude = async (amplitude) => ToneGeneratorModule.setWhiteNoiseAmplitude(amplitude);
export const playSoundFromURL = (URL) => ToneGeneratorModule.playSoundFromURL(URL);
export const stopSoundFromURL = (URL) => ToneGeneratorModule.stopSoundFromURL(URL);
export const setVolumeForURL = (URL, amplitude) => ToneGeneratorModule.setVolumeForURL(URL, amplitude);
export const pinkNoiseTest = (coefficient1, coefficient2, coefficient3, coefficient4, coefficient5, coefficient6, pitch) => ToneGeneratorModule.pinkNoiseTest(coefficient1, coefficient2, coefficient3, coefficient4, coefficient5, coefficient6, pitch);
export const changePitch = (pitch) => ToneGeneratorModule.changePitch(pitch);
export const play = async (frequency, amplitudes, adsr) => ToneGeneratorModule.play(frequency, amplitudes, adsr);
export const performFFT = () => ToneGeneratorModule.performFFT();
export const setFrequency = async (frequency, amplitudes, adsr) => ToneGeneratorModule.setFrequency(frequency, amplitudes, adsr);
export const stop = async () => ToneGeneratorModule.stop();
//# sourceMappingURL=index.js.map