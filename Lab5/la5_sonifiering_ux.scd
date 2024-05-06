// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

/*SynthDef(\dataSonification, { arg freq ;
	var output = LFTri.ar(0);

	Out.ar(0, {output}!2);
}).add;*/

(

SynthDef(\dataLevels, { arg freq, trig;

	var detuneAmount = 0.1;
	var detune = freq * detuneAmount;
	var sine1 = SinOsc.ar(freq: freq + detune);
	var sine2 = SinOsc.ar(freq: freq - detune);
	var output = sine1 + sine2 / 2;
	output = output * EnvGen.ar(Env.perc(0.01, 0.1, 1, 0), trig, doneAction: 2) * 0.5;


	Out.ar(0, {output}!2);
}).add;

)


)


(
// Följande registrerar dataSonification synthdefinitionen på servern
~dataSynth = Synth.new(\dataSonification).register;
~dataLevels = Synth.new(\dataLevels).register;

// Följande är en OSC-lyssnare för level-meddelanden
// 0, 1, 2, 3
OSCdef(\levelListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		// Ta hand om meddelandet om det inte är samma som förra
		if (inputmsg[1].asInteger != ~statusLevel) {
			// Detta plockar ut level ur meddelandet som ett heltal
			// och sparar i environment-variabeln
			~statusLevel = inputmsg[1].asInteger;
			if(~statusLevel == 0) {

				~statusLevel.postln;
			};
			if(~statusLevel == 1) {
				~dataLevels = Synth.new(\dataLevels, [\freq, 392.00]);
				//~statusLevel.postln;

			};
			if(~statusLevel == 2) {
				~dataLevels = Synth.new(\dataLevels, [\freq, 440.00]);

				//~statusLevel.postln;
			};
			if(~statusLevel == 3){
				~dataLevels = Synth.new(\dataLevels, [\freq, 493.88]);

				//~statusLevel.postln;

			};

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
			~dataSynth.set(\freq, frequency);
		};
	};
}, 'data');

// Följande är en OSC-lyssnare för fel-meddelanden
// Meddelanderna
OSCdef(\errorListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		// Detta plockar ut felmeddelandet ur meddelandet
		// och sparar i environment-variabeln
		~errorMessage = inputmsg[1];
		~errorMessage.postln;
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