(
~g0 = Group.new;
~g1 = Group.new(~g0, \addAfter);
~g2 = Group.new(~g1,\addAfter);

s.queryAllNodes;

~b0 = Buffer.read(s, "/Users/yangj14/Documents/GitHub/iapr/shortwave.wav");

SynthDef(\playsamp, {
	arg obs=0, buf, amp=1;
	var sig;
	sig = BufRd.ar( 1, buf, Phasor.ar(0, BufRateScale.kr(buf), 0, BufFrames.kr(buf)) );
	Out.ar(obs, sig*amp);
}).add;

SynthDef(\lp, {
	arg ibs, obs=0, freq=1000, q=1, amp = 1;
	var sig, in;
	in = In.ar(ibs);
	sig = RLPF.ar(in, freq, q);
	Out.ar(obs, sig*amp);
}).add;

SynthDef(\streson, {
	arg ibs, obs=0, del=0.002, res=0.9;
	var sig, in;
	in = In.ar(ibs);
	sig = Streson.ar(in, del, res, 0.3);
	Out.ar(obs, sig);
}).add;



//Klank.ar
)


~s0 = Synth(\playsamp, [\buf, ~b0], ~g0);
~s0.set(\obs, 30);
~s0.set(\obs, 0);

~s1 = Synth(\lp, [\ibs, 30], ~g1);
~s1.set(\freq, 300);
~s1.set(\freq, 700, \q, 0.1);
~s1.free;

~s2 = Synth(\streson, [\ibs, 30], ~g1);
~s2.set(\del, 0.009, \res, 0.8);
~s2.free;









