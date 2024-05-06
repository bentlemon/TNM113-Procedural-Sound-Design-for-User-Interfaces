
(

SynthDef(\dataLevels, { arg freq;

	var detuneAmount = 0.1;
	var detune = freq * detuneAmount;
	var sine1 = SinOsc.ar(freq: freq + detune);
	var sine2 = SinOsc.ar(freq: freq - detune);
	var output = sine1 + sine2 / 2;


	Out.ar(0, {output}!2);
}).add;

)

~dataLevels = Synth.new(\dataLevels);
~dataLevels.set(\freq, 261.63);

~dataLevels = Synth.new(\dataLevels);
~dataLevels.set(\freq, 246.94);

~dataLevels = Synth.new(\dataLevels);
~dataLevels.set(\freq, 220.00);

~dataLevels = Synth.new(\dataLevels);
~dataLevels.set(\freq, 0);

