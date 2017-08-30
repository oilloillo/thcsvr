 
--红魔✿完全潇洒的女仆
function c22053.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22052,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_MSET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c22053.scon)
	e2:SetTarget(c22053.stg)
	e2:SetOperation(c22053.sop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SSET)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22052,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c22053.condition)
	e4:SetCost(c22053.cost)
	e4:SetTarget(c22053.target)
	e4:SetOperation(c22053.operation)
	c:RegisterEffect(e4)
	if not c22053.global_check then
		c22053.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22053.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c22053.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(22052)==0 then
			tc:RegisterFlagEffect(22052,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c22053.scon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c22053.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22053.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22053.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc==LOCATION_MZONE and re:GetHandler():GetFlagEffect(22052)>0 and Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c22053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c22053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsLocation(LOCATION_MZONE) and re:GetHandler():IsRelateToEffect(re) then
		e:SetLabelObject(re:GetHandler())
	end
end
function c22053.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	re=e:GetLabelObject(re:GetHandler())
	if re then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		re:RegisterEffect(e1)
	end
end
