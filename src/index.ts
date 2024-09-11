import ToneGeneratorModule from "./ToneGeneratorModule";

export const getIsPlaying = () => ToneGeneratorModule.getIsPlaying();
export const playWhiteNoise = () => ToneGeneratorModule.playWhiteNoise();
export const pause = () => ToneGeneratorModule.pause();
export const adjustFrequency = (frequency: number) => ToneGeneratorModule.adjustFrequency(frequency);
export const playSoundFromURL = (URL: string) => ToneGeneratorModule.playSoundFromURL(URL);
export const stopSoundFromURL = (URL: string) => ToneGeneratorModule.stopSoundFromURL(URL);
export const setVolumeForURL = (URL: string, amplitude: number) => ToneGeneratorModule.setVolumeForURL(URL, amplitude);
export const performFFT = () => ToneGeneratorModule.performFFT();
export const setFrequency = async (frequency: number) => ToneGeneratorModule.setFrequency(frequency);
export const stop = async () => ToneGeneratorModule.stop();
export const adjustMasterVolume = async (volume: number) => ToneGeneratorModule.adjustMasterVolume(volume);
export const adjustWhiteNoiseVolume = async (volume: number) => ToneGeneratorModule.adjustWhiteNoiseVolume(volume);
export const checkIfSoundLibraryIsPlaying = (): Promise<boolean> => ToneGeneratorModule.checkIfSoundLibraryIsPlaying();
export const saveSoundToFile = () => ToneGeneratorModule.saveSoundToFile();
export const playSoundFromFile = (fileURL: string): Promise<void> => ToneGeneratorModule.playSoundFromFile(fileURL);


// Save the current sound preset
export const saveSoundPreset = async (): Promise<any> => {
    try {
        const preset = await ToneGeneratorModule.saveCurrentSoundPreset();
        return preset;  // Return the preset so it can be stored on the JS side if needed
    } catch (error) {
        console.error('Error saving sound preset:', error);
        throw error;
    }
};

// Load a sound preset
export const loadSoundPreset = async (preset: any): Promise<void> => {
    try {
        await ToneGeneratorModule.loadSoundFromPreset(preset);
    } catch (error) {
        console.error('Error loading sound preset:', error);
        throw error;
    }
};

// Define SoundPreset, URLSound, and ADSR data structures
export interface URLSound {
    url: string;       // URL of the sound
    volume: number;    // Volume of the sound
}

// Data structure for saving sound presets:
export interface SoundPreset {
    isWhiteNoise: boolean;          // Is white noise playing?
    frequency?: number;             // Frequency for white noise (optional)
    volume: number;                 // Volume level of white noise or sound
    urlSounds: URLSound[];          // Array of URL-based sounds
    eqFrequency: number;            // Frequency for EQ filters
}
