var birdSound1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/bird_bees.wav");
var birdSound2 = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/bird_bees_2.wav");
var windSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/soft_wind.wav");
var stepSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/footstep_snow.wav");
var fireSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/fireplace.wav");
var rainSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/rain_on_surface.wav");


(SynthDef(\birdSound1, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 0);
	var output = sound * level;
	Out.ar(out, output ! 2);
}).add;)

(
SynthDef(\birdSound2, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 0);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;)
(
SynthDef(\windSound, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 0);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;)
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
SynthDef(\rainSound, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 0);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;)
)

(

// Synthinstansen för temperaturen
~temperatureSynth = Synth.new(\temperatureSynth);
~birdSound1 = Synth.new(\birdSound1);
~birdSound2 = Synth.new(\birdSound2);
~windSound = Synth.new(\windSound);
~stepSound = Synth.new(\stepSound);
~fireSound = Synth.new(\fireSound);
~rainSound = Synth.new(\rainSound);


~birdSound1.set(\level, 1);





