// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

// Bass drum
(
SynthDef(\bassDrum, { arg t_trig = 1;
	var body, hit, output;

	body = SinOsc.ar(75);
	body = body * EnvGen.ar(Env.perc(0, 0.1, 1, -4), t_trig);

	hit = LFSaw.ar(120, mul:0.2) * EnvGen.ar(Env.perc(0, 0.01, 1, -4), t_trig);

	output = (body + hit)*0.1;

	Out.ar(0, {output}!2);
}).play;

)


// Snare drum
(
SynthDef(\snareDrum, { arg t_trig = 1;
	var body, hit, output, noise;

	body = SinOsc.ar(220);
	body = body * EnvGen.ar(Env.perc(0, 0.1, 1, -4), t_trig);

	hit = SinOsc.ar(360) * EnvGen.ar(Env.perc(0, 0.01, 1, -4), t_trig);
	hit = hit*0.9;

	noise = WhiteNoise.ar(0.15); // Ljudnivå 0.25
	noise = HPF.ar(noise, 750) * EnvGen.ar(Env.perc(0, 0.12, 1, -4), t_trig);

	output = (body + hit + noise) * 0.2;

	Out.ar(0, {output}!2) ;

}).play;
)

// ClHiHat
(
SynthDef(\clHiHat, { arg t_trig = 1;
	var body, hit, output, noise;

	noise = WhiteNoise.ar(0.25); // Ljudnivå 0.25
	noise = HPF.ar(noise, 1500);

	output = noise * EnvGen.ar(Env.perc(0.005, 0.025, 1, -1)) * 0.2;

	Out.ar(0, {output}!2);

}).play;
)

// OpHiHat
(
SynthDef(\opHiHat, { arg t_trig = 1;
	var tones, noise, output;

	tones = (LFPulse.ar(2000, width:0.5) + LFPulse.ar(1150, width:0.5) + LFPulse.ar(820, width:0.5) + LFPulse.ar(465, width:0.5)) / 4;
	tones = tones*EnvGen.ar(Env.perc(0.005, 0.0025, 1, -1));

	noise = WhiteNoise.ar(0.1); // Ljudnivå 0.25
	noise = HPF.ar(noise, 1000)* EnvGen.ar(Env.perc(0.005, 0.7, 1, -1));

	output = (noise + (tones / 2))*0.2;

	Out.ar(0, {output}!2);
}).play;
)

// High tom
(
SynthDef(\highTom, { arg t_trig = 1;
	var body, pitchEnvelope, output;

	// Range går från freq * 1 till freq * 3 till freq * 1
	pitchEnvelope = EnvGen.ar(Env.perc(0, 0.1, 1, -4), t_trig).range(1, 3);
	body = SinOsc.ar(75 * pitchEnvelope);
	body = body * EnvGen.ar(Env.perc(0, 0.6, 1, -4), t_trig);

	output = body* 0.15;

	Out.ar(0, {output}!2);
}).play;
)

// Low tom
(
SynthDef(\lowTom, { arg t_trig = 1;
	var body, pitchEnvelope, output;
	pitchEnvelope = EnvGen.ar(Env.perc(0, 0.1, 1, -4), t_trig).range(1, 4);
	body = SinOsc.ar(50 * pitchEnvelope);
	body = body * EnvGen.ar(Env.perc(0, 0.7, 1, -4), t_trig);

	output = body* 0.15;

	Out.ar(0, {output}!2);

}).play;
)

// Woodblock
(
SynthDef(\woodBlock, { arg t_trig = 1;
	var body, output;

	body = SinOsc.ar(480) * EnvGen.ar(Env.perc(0, 0.12, 1, -8), t_trig);

	output = body* 0.09;

	Out.ar(0, {output}!2);
}).play;
)

// Cowbell
(
SynthDef(\cowBell, { arg t_trig = 1;
	var body, output;

	body = LFPulse.ar(freq:540, width:0.4) + LFPulse.ar(freq:800);
	body = body * EnvGen.ar(Env.perc(0, 0.5, 1, -4), t_trig);

	output = body * 0.015;

	Out.ar(0, {output}!2);
}).play;
)

// Crash
(
SynthDef(\crash, { arg t_trig = 1;
	var tones, noise, output;

	tones = (LFPulse.ar(2000, width:0.5) + LFPulse.ar(1150, width:0.5) + LFPulse.ar(820, width:0.5) + LFPulse.ar(465, width:0.5)) / 4;

	noise = WhiteNoise.ar(0.25);

	output = noise + tones;

	output = RHPF.ar(output, 5000)*EnvGen.ar(Env.perc(0.005, 0.5, 1, -4)) * 0.15;

	Out.ar(0, {output}!2);

}).play;
)