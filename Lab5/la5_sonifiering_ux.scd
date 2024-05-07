// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

SynthDef(\dataSonification, { arg freq;
	var output = LFTri.ar(freq);

	Out.ar(0, {output}!2);
}).add;

SynthDef(\errorSonification, { arg midiNote1 = 60, midiNote2 = 65, gate = 0, vol = 0.7;

	var sin = SinOsc.ar(rrand(midiNote1, midiNote2).midicps);

	var env = Env.perc(0.001, 0.3, 1.7, -2);
	var out = sin * EnvGen.kr(env, gate, doneAction: 0);

	Out.ar(0, {out * vol}!2);
}).add;

)


(
// Följande registrerar dataSonification synthdefinitionen på servern
//~dataSynth = Synth.new(\dataSonification).register;


// Följande är en OSC-lyssnare för level-meddelanden
OSCdef(\levelListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		// Ta hand om meddelandet om det inte är samma som förra
		if (inputmsg[1].asInteger != ~statusLevel) {
			// Detta plockar ut level ur meddelandet som ett heltal
			// och sparar i environment-variabeln
			~statusLevel = inputmsg[1].asInteger;
			//~statusLevel.postln; // De olika nivåerna
		};



	};
}, 'level');

// Följande är en OSC-lyssnare för data-meddelanden
OSCdef(\dataListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		// Ta hand om meddelandet om det inte är samma som förra
		if (inputmsg[1].asInteger != ~currentData) {
			var frequency;
			// Detta plockar ut datavärdet ur meddelandet som ett heltal
			// och sparar i environment-variabeln
			~currentData = inputmsg[1].asInteger;
			// Följande skickar data-nivån (som en int) till en mapp-funktion
			// som returnerar värdet och sparar det i frequency-variabeln
			frequency = ~mapPitch.value(~currentData);
			// Följande skickar värdet, frekvensen, till synthdefinitionen
			//~dataSynth.set(\freq, frequency);
		};
	};
}, 'data');

// Följande är en OSC-lyssnare för fel-meddelanden
OSCdef(\errorListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		~errorMessage = inputmsg[1];
		~errorMessage.postln;

		if ('Risk for overheating' == ~errorMessage){
			// C6 (middle)
			~errorSynth = Synth.new(\errorSonification).register;
			~errorSynth.set(\vol, 0.4);
			~errorSynth.set(\gate, 1);
		};

		if ('Zero target null' == ~errorMessage){
			~errorSynth = Synth.new(\errorSonification).register;
			~errorSynth.set(\midiNote1, 36);// C2
			~errorSynth.set(\midiNote2, 41); // F2
			~errorSynth.set(\vol, 1.5);
			~errorSynth.set(\gate, 1);
		};

		if ('Bipolar capacity low' == ~errorMessage){
			~errorSynth = Synth.new(\errorSonification).register;
			~errorSynth.set(\midiNote1, 24);// C1
			~errorSynth.set(\midiNote2, 29); // F1
			~errorSynth.set(\vol, 4.5);
			~errorSynth.set(\gate, 1);
		};

		if ('Unstable output' == ~errorMessage){
			~errorSynth = Synth.new(\errorSonification).register;
			~errorSynth.set(\midiNote1, 72);// C5
			~errorSynth.set(\midiNote2, 77); // F5
			~errorSynth.set(\vol, 1.5);
			~errorSynth.set(\gate, 1);
		};

	};
}, 'error');


~mapPitch = { arg freq;
	// Först görs en linjär till linjär mappning av värdet till frekvens (i Hz)
	var frequency = linlin(freq, 0, 300, 220, 880) ;
	// returnerar värdet
	frequency.value;
};

)

// Följande rad kollar vilken lokal address som OSC-lyssnaren använder. Denna måste
// vara samma i båda programmen, så att "monitorGUIt" skickar på rätt address.
NetAddr.localAddr;