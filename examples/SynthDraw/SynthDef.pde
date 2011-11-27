/*

SynthDef(\sine_double, { |outbus = 0, amp = 0.5, freqx = 440, freqy = 440, pan = 0|
	var data, sine;
	freqx = Lag.kr(freqx, 0.1);
	freqy = Lag.kr(freqy, 0.1);

	data = SinOsc.ar(freqx) * SinOsc.ar(freqy) * amp;
	data = Pan2.ar(data, pan);

	Out.ar(outbus, data);
}).store;

SynthDef(\fx_comb, { |inbus = 0, outbus = 0, wet = 0.5, delaytime = 0.1, decaytime = 1.0, fade = 0.5|
	var in, out;
	
	wet = Lag.kr(wet, fade);
	delaytime = Lag.kr(delaytime, fade);
	
	in = In.ar(inbus, 2);
	out = CombN.ar(in, 2.0, delaytime, decaytime);
	
	out = (wet * out) + ((1 - wet) * in);
	Out.ar(outbus, out);
}).store;

*/
