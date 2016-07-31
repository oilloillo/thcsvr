 
--符器-灵击札
function c200201.initial_effect(c)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e1:SetCondition(c200201.con)
--	e1:SetCost(c200201.cost)
	e1:SetOperation(c200201.op)
	c:RegisterEffect(e1)
end
function c200201.filter(c)
	local x=c:GetOriginalCode()
	return (x>=200001 and x<=200020) or (x==200115) or (x==200215) or (x==200302) or (x==25016)
end
function c200201.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsExistingMatchingCard(c200201.filter,tp,LOCATION_ONFIELD,0,1,nil)
end--[[
function c200201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end]]
function c200201.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
	e1:SetCountLimit(1)
	e1:SetOperation(c200201.rmop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(0)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
end
function c200201.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,200201)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c200201.reop)
		Duel.RegisterEffect(e1,tp)
		tc=tg:GetNext()
	end
end
function c200201.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end