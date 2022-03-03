//
//  MP3Encoder.hpp
//  LameDemo
//
//  Created by ForC on 2022/2/4.
//

#ifndef MP3Encoder_hpp
#define MP3Encoder_hpp

#include <stdio.h>
#include <lame/lame.h>

class MP3Encode {
    
private:
    FILE* pcmfile;
    FILE* mp3file;
    lame_t lameClient;
    
public:
    MP3Encode(const char *pcmFilePath, const char *mp3FilePath, int sampleate, int channels, int bitRate);
    void Encode();
    void Destory();
    
};

#endif /* MP3Encoder_hpp */



