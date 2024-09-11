export declare const getIsPlaying: () => any;
export declare const playWhiteNoise: () => any;
export declare const pause: () => any;
export declare const adjustFrequency: (frequency: number) => any;
export declare const playSoundFromURL: (URL: string) => any;
export declare const stopSoundFromURL: (URL: string) => any;
export declare const setVolumeForURL: (URL: string, amplitude: number) => any;
export declare const performFFT: () => any;
export declare const setFrequency: (frequency: number) => Promise<any>;
export declare const stop: () => Promise<any>;
export declare const adjustMasterVolume: (volume: number) => Promise<any>;
export declare const adjustWhiteNoiseVolume: (volume: number) => Promise<any>;
export declare const checkIfSoundLibraryIsPlaying: () => Promise<boolean>;
export declare const saveSoundToFile: () => any;
export declare const playSoundFromFile: (fileURL: string) => Promise<void>;
export declare const saveSoundPreset: () => Promise<any>;
export declare const loadSoundPreset: (preset: any) => Promise<void>;
export interface URLSound {
    url: string;
    volume: number;
}
export interface SoundPreset {
    isWhiteNoise: boolean;
    frequency?: number;
    volume: number;
    urlSounds: URLSound[];
    eqFrequency: number;
}
//# sourceMappingURL=index.d.ts.map