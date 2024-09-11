import ToneGeneratorModule from "./ToneGeneratorModule";
export const getIsPlaying = () => ToneGeneratorModule.getIsPlaying();
export const playWhiteNoise = () => ToneGeneratorModule.playWhiteNoise();
export const pause = () => ToneGeneratorModule.pause();
export const adjustFrequency = (frequency) => ToneGeneratorModule.adjustFrequency(frequency);
export const playSoundFromURL = (URL) => ToneGeneratorModule.playSoundFromURL(URL);
export const stopSoundFromURL = (URL) => ToneGeneratorModule.stopSoundFromURL(URL);
export const setVolumeForURL = (URL, amplitude) => ToneGeneratorModule.setVolumeForURL(URL, amplitude);
export const performFFT = () => ToneGeneratorModule.performFFT();
export const setFrequency = async (frequency) => ToneGeneratorModule.setFrequency(frequency);
export const stop = async () => ToneGeneratorModule.stop();
export const adjustMasterVolume = async (volume) => ToneGeneratorModule.adjustMasterVolume(volume);
export const adjustWhiteNoiseVolume = async (volume) => ToneGeneratorModule.adjustWhiteNoiseVolume(volume);
export const checkIfSoundLibraryIsPlaying = () => ToneGeneratorModule.checkIfSoundLibraryIsPlaying();
export const saveSoundToFile = () => ToneGeneratorModule.saveSoundToFile();
export const playSoundFromFile = (fileURL) => ToneGeneratorModule.playSoundFromFile(fileURL);
// Save the current sound preset
export const saveSoundPreset = async () => {
    try {
        const preset = await ToneGeneratorModule.saveCurrentSoundPreset();
        return preset; // Return the preset so it can be stored on the JS side if needed
    }
    catch (error) {
        console.error('Error saving sound preset:', error);
        throw error;
    }
};
// Load a sound preset
export const loadSoundPreset = async (preset) => {
    try {
        await ToneGeneratorModule.loadSoundFromPreset(preset);
    }
    catch (error) {
        console.error('Error loading sound preset:', error);
        throw error;
    }
};
//# sourceMappingURL=index.js.map