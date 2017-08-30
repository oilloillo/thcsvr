 
--符器-伊吹瓢
function c200210.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c200210.cost)
	e1:SetTarget(c200210.target)
	e1:SetOperation(c200210.operation)
	c:RegisterEffect(e1)
end
function c200210.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c200210.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c200210.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,2,REASON_EFFECT)
	if ct==0 then return end
	Duel.BreakEffect()
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
