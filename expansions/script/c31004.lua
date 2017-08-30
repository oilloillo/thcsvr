--橘色的月兔✿铃瑚
function c31004.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c31004.sdcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetTarget(c31004.sptg)
	e2:SetOperation(c31004.spop)
	c:RegisterEffect(e2)
	--mgmg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31004,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetCost(c31004.cost)
	e3:SetTarget(c31004.target)
	e3:SetOperation(c31004.operation)
	c:RegisterEffect(e3)
end

c31004.DescSetName=0x258

function c31004.sdcon(e)
	return e:GetHandler():GetAttack()>e:GetHandler():GetBaseAttack()
end
function c31004.filter(c,e,tp)
	return c:IsSetCard(0x258) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c31004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and not c:IsStatus(STATUS_CHAINING) and Duel.IsExistingMatchingCard(c31004.filter,tp,LOCATION_HAND,0,1,c,e,tp)
		and Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,0,0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
function c31004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local g=Duel.SelectMatchingCard(tp,c31004.filter,tp,LOCATION_HAND,0,1,1,c,e,tp)
		if g:GetCount()==0 then return end
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(2)
		e2:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e2)
	end
end
function c31004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,1,REASON_COST)
end
function c31004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c31004.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,500,REASON_EFFECT)
end
