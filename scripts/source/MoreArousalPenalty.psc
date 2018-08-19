Scriptname MoreArousalPenalty extends ReferenceAlias  

Event OnInit()
	Actor selfact = self.GetActorRef()
	SexLab.TrackActor(selfact, "MyTracking")
	
	RegisterForModevent("MyTracking_End", "SexLabMapSexEnd")
	RegisterForModevent("sla_UpdateComplete", "OnArousalComputed")
	
EndEvent

Event SexLabMapSexEnd(Form FormRef, int tid)
	Utility.Wait(5)
	self.ReSpell()
EndEvent

Event OnArousalComputed(string eventName, string argString, float argNum, form sender)
	self.ReSpell()
EndEvent

Event OnCellLoad()
	Utility.Wait(5)
	self.ReSpell()
EndEvent

Function ReSpell()
	Actor selfact = self.GetActorRef()
	int arousal = selfact.GetFactionRank(sla_Arousal)
	
	debug.trace("[SSLMAP] Computed Arousal " + arousal)
	if (arousal < SSLMAP50.GetValue())
		self.dispellif(selfact, SSLMap50Magic)
		self.dispellif(selfact, SSLMap70Magic)
		self.dispellif(selfact, SSLMap90Magic)
	elseif (arousal < SSLMAP70.GetValue()) ; 50-69
		self.dispellif(selfact, SSLMap70Magic)
		self.dispellif(selfact, SSLMap90Magic)

		self.addspellif(selfact, SSLMap50Magic)
	elseif (arousal < SSLMAP90.GetValue()) ; 70-89
		self.dispellif(selfact, SSLMap50Magic)
		self.dispellif(selfact, SSLMap90Magic)

		self.addspellif(selfact, SSLMap70Magic)
	else ; 90-
		self.dispellif(selfact, SSLMap50Magic)
		self.dispellif(selfact, SSLMap70Magic)
		
		self.addspellif(selfact, SSLMap90Magic)
	endif
EndFunction

Function addspellif(Actor act, Spell spl)
	if !(act.HasSpell(spl))
		act.AddSpell(spl, false)
	endif
EndFunction

Function dispellif(Actor act, Spell spl)
	if (act.HasSpell(spl))
		act.RemoveSpell(spl)
	endif
EndFunction

SexLabFramework Property SexLab  Auto
Faction Property sla_Arousal  Auto  

GlobalVariable Property SSLMAP50  Auto  
GlobalVariable Property SSLMAP70  Auto  
GlobalVariable Property SSLMAP90  Auto  

SPELL Property SSLMap50Magic  Auto  
SPELL Property SSLMap70Magic  Auto  
SPELL Property SSLMap90Magic  Auto  

