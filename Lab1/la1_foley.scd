// Starta servern
s.boot; // en rad ko körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

// PlayBuf.ar(numChannels, bufnum: 0, rate: 1.0, trigger: 1.0, startPos: 0.0, loop: 0.0, doneAction: 0)

// För start-ljudet
SynthDef(\samplePlayerStart, { arg bufnum = 0;
	var rateMod = 1.0;
    var sound = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum) * rateMod,
		trigger: 1,
		startPos: 0,
		loop: 1,
		doneAction: 0,
	);
	//Sampleplaybackoscillatorn stoppas i sound, och sound i sin tur stoppas i output och output
	//skickas sedan till ljudutgången med Out.ar.
	var output = sound;


	Out.ar(0, output);
}).add;

)


// Klientside skript
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

// Laddar in sound buffers
var startSample = Buffer.read(s,"C:/Users/mahon/Desktop/Cappy_spel/TNM113-Procedural-Sound-Design-for-User-Interfaces/Lab1/Ljudfiler/Start.wav"));
Synth.new(\samplePlayerStart, [\bufnum, startSample]);
~samplePlayerStart.set(\rateMod, 10);

//var lightSample = Buffer.read(s, lightSoundP);
//var mediumSample = Buffer.read(s, mediumSoundP);
//var darkSample = Buffer.read(s, darkSoundP);

// Skapar syntinstancer med hjälp av de olika buffrarna
// Synth.new(defName, args, target, addAction: 'addToHead')

//Synth.new(\samplePlayerLight, [\bufnum, lightSample]);

//Synth.new(\samplePlayerMedium, [\bufnum, mediumSample]);

//Synth.new(\samplePlayerDark, [\bufnum, darkSample]);
)