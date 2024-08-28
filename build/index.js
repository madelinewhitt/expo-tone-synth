import ToneGeneratorModule from "./ToneGeneratorModule";
export const getIsPlaying = () => ToneGeneratorModule.getIsPlaying();
export const playWhiteNoise = () => ToneGeneratorModule.playWhiteNoise();
export const adjustFrequency = (frequency) => ToneGeneratorModule.adjustFrequency(frequency);
export const playSoundFromURL = (URL) => ToneGeneratorModule.playSoundFromURL(URL);
export const stopSoundFromURL = (URL) => ToneGeneratorModule.stopSoundFromURL(URL);
export const setVolumeForURL = (URL, amplitude) => ToneGeneratorModule.setVolumeForURL(URL, amplitude);
export const performFFT = () => ToneGeneratorModule.performFFT();
export const setFrequency = async (frequency) => ToneGeneratorModule.setFrequency(frequency);
export const stop = async () => ToneGeneratorModule.stop();
//# sourceMappingURL=index.js.map