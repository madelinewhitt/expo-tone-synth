import ToneGeneratorModule from "./ToneGeneratorModule";

export const getIsPlaying = () => ToneGeneratorModule.getIsPlaying();
export const playWhiteNoise = () => ToneGeneratorModule.playWhiteNoise();
export const playPinkNoise = () => ToneGeneratorModule.playPinkNoise();
export const playBrownNoise = () => ToneGeneratorModule.playBrownNoise();
export const setWhiteNoiseAmplitude = async (amplitude: number) => ToneGeneratorModule.setWhiteNoiseAmplitude(amplitude);
export const playSoundFromURL = (URL: string) => ToneGeneratorModule.playSoundFromURL(URL);
export const stopSoundFromURL = (URL: string) => ToneGeneratorModule.stopSoundFromURL(URL);
export const setVolumeForURL = (URL: string, amplitude: number) => ToneGeneratorModule.setVolumeForURL(URL, amplitude)
export const pinkNoiseTest = (coefficient1: number, coefficient2: number, coefficient3: number,
	coefficient4: number, coefficient5: number, coefficient6: number, pitch: number) => ToneGeneratorModule.pinkNoiseTest(coefficient1,
		coefficient2, coefficient3, coefficient4, coefficient5, coefficient6, pitch);
export const changePitch = (pitch: number) => ToneGeneratorModule.changePitch(pitch);
export const play = async (
	frequency: number,
	amplitudes: number[],
	adsr: number[],
) => ToneGeneratorModule.play(frequency, amplitudes, adsr);
export const performFFT = () => ToneGeneratorModule.performFFT();

export const setFrequency = async (
	frequency: number,
	amplitudes: number[],
	adsr: number[],
) => ToneGeneratorModule.setFrequency(frequency, amplitudes, adsr);

export const stop = async () => ToneGeneratorModule.stop();
