/*

SynthDef(\sine_harmonic, { |outbus = 0, freq = 200, amp = 0.1, gate = 1, pan = 0|
	var data, env;
	
	amp = Lag.kr(amp, 0.4);
	
	// generate, degrade, filter, echo
	data = SinOsc.ar(freq, 0, amp);
	data = Latch.ar(data, Impulse.ar(Rand(1000, 35000)));
	data = LPF.ar(data, 1000);
	data = Pan2.ar(data, pan);
	data = data + CombN.ar(data, 0.5, 0.3, 15.0, 0.3);	

	// envelope
	env = EnvGen.kr(Env.asr(0.5, 1.0, 1.0), gate: gate, doneAction: 2);
	data = data * env;
	
	data = [ data[0], data[1] * Select.kr(IRand(0, 3), [ 1, 1, -1 ]) ];
	
	Out.ar(outbus, data);
}).store;

*/
