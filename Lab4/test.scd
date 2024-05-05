var birdSound1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/bird_bees.wav");
var windSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/soft_wind.wav");
var stepSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/footstep_snow.wav");
var fireSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/fireplace.wav");
var rainSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/rain_on_surface.wav");


(
SynthDef(\birdSound1, { |out = 0, level = 0, bufnum = 0, detuneAmount = 0.5|
	var sound, output;

	sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 2);

	sound = LPF.ar(sound, 1000);

	var detune = SoundIn.ar(0) * detuneAmount;
	var sine1 = SinOsc.ar(freq: SoundIn.ar(0) + detune);
	var sine2 = SinOsc.ar(freq: SoundIn.ar(0) - detune);

	sound = sound * (sine1 + sine2 / 2);

	output = sound * level;

	Out.ar(out, output ! 2);
}).add;
)


(
(
SynthDef(\windSound, { |out = 0, level = 0, bufnum = 0, modFreq = 0.5, modDepth = 0.1, thunderLevel = 1.5|
	var sound, output, modulator, thunder;

	// Läs in ljudet från bufnum
	sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 2);

	// Skapa en lågfrekvent sinusvåg som modulerar amplituden för vindens fluktuationer
	modulator = SinOsc.ar(freq: modFreq, mul: modDepth);

	// Skapa åskljud genom att generera slumpmässiga transienter
	thunder = WhiteNoise.ar(0.1) * Impulse.ar(0.8);

	sound = sound + (thunder * thunderLevel);

	sound = sound * (1 + modulator);

	output = sound * level;

	Out.ar(out, output ! 2);
}).add;
)




(
SynthDef(\stepSound, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 0);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;)
(
SynthDef(\fireSound, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 0);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;)
(
SynthDef(\rainSound, { |out = 0, level = 0, bufnum = 0, rainLevel = 0.1, cutoffFreq = 1000|
	var sound, rain, filteredRain, output;

	// Läs in ljudet från bufnum
	sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 0);

	// Tillämpa lågpassfilter på det befintliga ljudet
	sound = LPF.ar(sound, cutoffFreq);

	// Generera regnljud med slumpmässigt brus
	rain = PinkNoise.ar * rainLevel;

	// Tillämpa ett lågpassfilter på regnljudet för att göra det mjukare
	filteredRain = LPF.ar(rain, cutoffFreq);

	// Blanda regnljudet med det befintliga ljudet
	sound = sound + filteredRain;

	output = sound * level;

	Out.ar(out, output ! 2);
}).add;
)


(

// Synthinstansen för temperaturen
~temperatureSynth = Synth.new(\temperatureSynth);
~birdSound1 = Synth.new(\birdSound1);

~stepSound = Synth.new(\stepSound);
~fireSound = Synth.new(\fireSound);



~birdSound1.set(\level, 1);

~windSound = Synth.new(\windSound);
~windSound.set(\level, 1);

~rainSound = Synth.new(\rainSound);
~rainSound.set(\level, 1);






