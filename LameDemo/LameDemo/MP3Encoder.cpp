//
//  MP3Encoder.cpp
//  LameDemo
//
//  Created by ForC on 2022/2/4.
//

#include "MP3Encoder.h"

MP3Encode::MP3Encode(const char *pcmFilePath, const char *mp3FilePath, int sampleRate, int channels, int bitRate) {
    this->pcmfile = fopen(pcmFilePath, "rb");
    if (this->pcmfile) {
        this->mp3file = fopen(mp3FilePath, "wb");
        if (this->mp3file) {
            this->lameClient = lame_init();
            lame_set_in_samplerate(lameClient, sampleRate);
            lame_set_out_samplerate(lameClient, sampleRate);
            lame_set_num_channels(lameClient, channels);
            lame_set_brate(lameClient, bitRate / 1000);
            lame_init_params(lameClient);
        }
    }
}

void MP3Encode::Encode() {
    int bufferSize = 1024 * 256;
    short *buffer = new short[bufferSize / 2];
    short *leftBuffer = new short[bufferSize / 4];
    short *rightBuffer = new short[bufferSize / 4];
    unsigned char *mp3_buffer = new unsigned char[bufferSize];
    size_t readBufferSize = 0;
    while ((readBufferSize = fread(buffer, 2, bufferSize / 2, pcmfile)) > 0) {
        for (int i = 0; i < readBufferSize; i++) {
            if (i % 2 == 0) {
                leftBuffer[i / 2] = buffer[i];
            }
            else {
                rightBuffer[i / 2] = buffer[i];
            }
        }
        size_t wroteSize = lame_encode_buffer(lameClient, (short int *)leftBuffer, (short int *)rightBuffer, int (readBufferSize / 2), mp3_buffer, bufferSize);
        fwrite(mp3_buffer, 1, wroteSize, mp3file);
    }
    delete [] buffer;
    delete [] rightBuffer;
    delete [] leftBuffer;
    delete [] mp3_buffer;
}

void MP3Encode::Destory() {
    if (this->pcmfile) {
        fclose(this->pcmfile);
    }
    if (this->mp3file) {
        fclose(this->mp3file);
        lame_close(this->lameClient);
    }
}
