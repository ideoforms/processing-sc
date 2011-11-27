/*

SynthDef(\moogsaw, { |freq = 500, amp = 1.0, outbus = 0, pan = 0, cutoff = 120, resonance = 0.7|
	var data;
	
	freq = Lag.kr(freq, 0.1);
	
	data = Saw.ar(freq, amp);
	data = MoogVCF.ar(data, cutoff, resonance);
	data = data + CombN.ar(data, 0.05, 0.05, 0.5, 0.1);
	data = Pan2.ar(data, pan);
	
	Out.ar(outbus, data);
}).store;

*/
