/*

SynthDef(\recordbuf_1, { |bufnum = 0, inbus = 0|
        var data = SoundIn.ar(0);
        RecordBuf.ar(data, bufnum);
}).store;

*/
