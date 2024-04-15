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

	output = body;

	Out.ar(0, {output}!2);
}).play;

)


// Snare drum
(
SynthDef(\snareDrum, { arg t_trig;

}).play;
)

// ClHiHat
(
SynthDef(\clHiHat, { arg t_trig;

}).play;
)

// OpHiHat
(
SynthDef(\opHiHat, { arg t_trig;

}).play;
)

// High tom
(
SynthDef(\highTom, { arg t_trig;

}).play;
)

// Low tom
(
SynthDef(\lowTom, { arg t_trig;

}).play;
)

// Woodblock
(
SynthDef(\woodBlock, { arg t_trig;

}).play;
)

// Cowbell
(
SynthDef(\cowBell, { arg t_trig;

}).play;
)

// Crash
(
SynthDef(\crash, { arg t_trig;

}).play;
)