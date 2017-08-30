--山彦する咆哮
function c10114.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0xc)
	e1:SetCondition(c10114.condition)
	e1:SetTarget(c10114.target)
	e1:SetOperation(c10114.activate)
	c:RegisterEffect(e1)
end
function c10114.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return tp~=Duel.GetTurnPlayer() and bit.band(ph,PHASE_MAIN2+PHASE_END)==0
end
function c10114.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x527)
end
function c10114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetMatchingGroupCount(c10114.cfilter,tp,LOCATION_MZONE,0,nil)>0 then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c10114.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
end
