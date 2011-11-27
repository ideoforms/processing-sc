/*

SynthDef(\pulser, { |freq = 50, amp = 0.1, pan = 0, outbus = 0|
	var data;
	
	data = Impulse.ar(freq, 0, amp);
	data = Pan2.ar(data, pan);
	data = Decay.ar(data, 0.005);
	data = data * SinOsc.ar(freq);
	
	Out.ar(outbus, data);
}).store;

// reverb
SynthDef(\fx_rev_gverb, { |inbus = 0, outbus = 0, wet = 0.5, fade = 1.0, roomsize = 50, reverbtime = 1.0, damp = 0.995, amp = 1.0|
	var in, out;

	wet = Lag.kr(wet, fade);
	wet = wet * 0.5;

	reverbtime = Lag.kr(reverbtime, fade) * 0.5;
	in = In.ar(inbus, 2) * amp;
	out = GVerb.ar(in, roomsize, reverbtime, damp);
	out = (wet * out) + ((1.0 - wet) * in);

	Out.ar(outbus, out);
}).store;

*/
