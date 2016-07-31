 
--符器-冻青蛙
function c200217.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCost(c200217.cost)
	e1:SetCondition(c200217.condition)
	e1:SetOperation(c200217.op)
	c:RegisterEffect(e1)
	if not c200217.global_check then
		c200217.global_check=true
		c200217[0]=0
		c200217[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c200217.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge2:SetOperation(c200217.checkop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetOperation(c200217.checkop)
		Duel.RegisterEffect(ge3,0)
	end
end
function c200217.checkop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	if Duel.GetTurnCount()~=c200217[2] then
		c200217[0]=0
		c200217[1]=0
		c200217[2]=Duel.GetTurnCount()
	end
	local tc=eg:GetFirst()
	local p1=false
	while tc do
		if tc:GetSummonPlayer()==turnp then p1=true end
		tc=eg:GetNext()
	end
	if p1 then
		c200217[turnp]=c200217[turnp]+1
		if c200217[turnp]==3 then
			Duel.RaiseEvent(e:GetHandler(),200217,e,0,0,0,0)
		end
	end
end--[[
function c200217.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end]]
function c200217.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() 
--	and Duel.IsPlayerCanDraw(1-tp,1)
end
function c200217.op(e,tp,eg,ep,ev,re,r,rp)
--	Duel.Draw(1-tp,1,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(200217)
	e1:SetCountLimit(1)
	e1:SetOperation(c200217.eop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c200217.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,200217)
	local turnp=Duel.GetTurnPlayer()
	local tph=Duel.GetCurrentPhase()
	if tph==PHASE_DRAW then
		Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if tph==PHASE_STANDBY then
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if tph==PHASE_MAIN1 then 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if (tph==PHASE_BATTLE) or (tph==PHASE_DAMAGE) or (tph==PHASE_DAMAGE_CAL) then 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
	if tph==PHASE_MAIN2 then 
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end