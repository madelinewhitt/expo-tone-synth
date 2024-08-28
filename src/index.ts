import ToneGeneratorModule from "./ToneGeneratorModule";

export const getIsPlaying = () => ToneGeneratorModule.getIsPlaying();
export const playWhiteNoise = () => ToneGeneratorModule.playWhiteNoise();
export const adjustFrequency = (frequency: number) => ToneGeneratorModule.adjustFrequency(frequency);
export const playSoundFromURL = (URL: string) => ToneGeneratorModule.playSoundFromURL(URL);
export const stopSoundFromURL = (URL: string) => ToneGeneratorModule.stopSoundFromURL(URL);
export const setVolumeForURL = (URL: string, amplitude: number) => ToneGeneratorModule.setVolumeForURL(URL, amplitude)
export const performFFT = () => ToneGeneratorModule.performFFT();
export const setFrequency = async (frequency: number) => ToneGeneratorModule.setFrequency(frequency);
export const stop = async () => ToneGeneratorModule.stop();
