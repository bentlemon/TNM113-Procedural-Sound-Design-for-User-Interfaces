// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

SynthDef(\bassDrum, {
	var body, hit, output;

	body = SinOsc.ar(75);
	body = body * EnvGen.ar(Env.perc(0, 0.1, 1, -4));

	output = body;

	Out.ar(0, {output}!2);
}).play;

)