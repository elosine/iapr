( s.waitForBoot{ fork{

	//Granular Synthesis Samples
	~gb1 = Buffer.read(s, "/home/jyang/Documents/iapr/sitar.wav" );


	SynthDef(\grain, {
		arg rate=5, dur = 0.1, amp = 1, buf, envbuf = -1, pitch=1, pan=0, gate=1;
		var sig, env;
		env = EnvGen.ar(Env.asr(0.01, 1, 0.3), gate, doneAction:2);
		sig = GrainBuf.ar(2, Dust.ar(rate), dur, buf, pitch, LFNoise2.kr(0.1).range(0, 1), 2, pan, envbuf);
		Out.ar(0, sig*env*amp);
	}).add;

	//Control Busses
	~b1 = Bus.control(s);
	~b2 = Bus.control(s);

	//Synthdef to set control bus using control rate args
	SynthDef(\kbus,{
		arg obs;
		var val;
		val = \val.kr(0,0.01);
		Out.kr(obs, val);
	}).add;


	//Gets normalized data from Processing
	//Maps to args parameters
	//in this case rate and dur of grain
	OSCdef(\xy,{ |msg|
		var x = msg[1].asFloat;
		var y = msg[2].asFloat;
		x = x.linlin(0.0, 1.0, 5, 60);
		y = y.linlin(0.0, 1.0, 0.01, 1.0);
		~grvalx0.set(\val, x);
		~grvaly0.set(\val, y);
		//msg.postln;
	}, "/xy");

	0.1.wait;

	//start two control bus mapping synths
	~grvalx0 = Synth(\kbus, [\obs, ~b1, \val,0]);
	~grvaly0 = Synth(\kbus, [\obs, ~b2, \val,0]);

	0.1.wait;

	//start granular synth and map args to control busses

	~gr0 = Synth(\grain,[\buf, ~gb1]);

	~gr0.map(\rate, ~b1);
	~gr0.map(\dur, ~b2);
}})

