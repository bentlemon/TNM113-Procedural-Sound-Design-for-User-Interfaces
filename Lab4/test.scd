var birdSound1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/bird_bees.wav");
var windSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/soft_wind.wav");
var stepSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/footstep_snow.wav");
var fireSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/fireplace.wav");
var rainSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/rain_on_surface.wav");

(
SynthDef(\birdSound1, { |out = 0, level = 0, bufnum = 0|
	var sound, output, detune, sine1, sine2;

	sound = PlayBuf.ar(2, bufnum, loop: 1, doneAction: 2);

	sound = LPF.ar(sound, 1000);


	output = sound * level.lag(0.5);

	Out.ar(out, output ! 2);

}).add;

)





(
SynthDef(\windSound, { |out = 0, level = 0, bufnum = 0, modFreq = 0.5, modDepth = 0.1, thunderLevel = 1.5|
	var sound, output, modulator, thunder;

	// Läs in ljudet från bufnum
	sound = PlayBuf.ar(2, bufnum, loop: 1, doneAction: 2);

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
SynthDef(\stepSound, { |out = 0, level = 0, bufnum = 0, cutoffFreq = 780, attackTime = 2, releaseTime = 0.9|
	var sound, output, env, filteredSound;

	sound = PlayBuf.ar(2, bufnum, loop: 1, doneAction: 0);

    env = EnvGen.kr(Env.linen(attackTime, 1, releaseTime), doneAction: 2);
	filteredSound = LPF.ar(sound, cutoffFreq * env);

	output = filteredSound * level.lag(0.04)*2;

	Out.ar(out, output ! 2);
}).add;

)



(
SynthDef(\fireSound, { |out = 0, level = 1, bufnum = 0|
    var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 0);

    var noise = PinkNoise.ar(0.5);

    var fierySound = sound + (noise * 0.001);

    var output = fierySound * level.lag(0.5) * 0.2;

    Out.ar(out, output ! 2);
}).add;

)
(
SynthDef(\rainSound, { |out = 0, level = 0, bufnum = 0, rainLevel = 0.08, cutoffFreq = 1000|
	var sound, rain, filteredRain, output;

	// Läs in ljudet från bufnum
	sound = PlayBuf.ar(2, bufnum, loop: 1, doneAction: 0);

	// Tillämpa lågpassfilter på det befintliga ljudet
	sound = LPF.ar(sound, cutoffFreq);

	// Generera regnljud med slumpmässigt brus
	rain = PinkNoise.ar * rainLevel;

	// Tillämpa ett lågpassfilter på regnljudet för att göra det mjukare
	filteredRain = LPF.ar(rain, cutoffFreq);

	sound = sound * level.lag(0.001) + filteredRain;

	output = sound * level;

	Out.ar(out, output ! 2);
}).add;
s.record(duration: 10);
)




// Synthinstansen för temperaturen
~temperatureSynth = Synth.new(\temperatureSynth);

~fireSound = Synth.new(\fireSound);
~fireSound.set(\level, 1);


~birdSound1 = Synth.new(\birdSound1);
~birdSound1.set(\level, 1);

~windSound = Synth.new(\windSound);
~windSound.set(\level, 1);

~rainSound = Synth.new(\rainSound);
~rainSound.set(\level, 1);

~stepSound = Synth.new(\stepSound);
~stepSound.set(\level, 1);





