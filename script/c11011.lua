 
--魅魔
function c11011.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11011.spcon)
	e1:SetCountLimit(1,11011)
	e1:SetOperation(c11011.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
end
function c11011.spfilter(c)
	return c:IsSetCard(0x208) and c:IsReleasable()
end
function c11011.spcon(e,c)
	if c==nil then return true end
	return --Duel.GetFlagEffect(c:GetControler(),11011)==0 and 
		Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11011.spfilter,c:GetControler(),LOCATION_HAND,0,1,nil)
end
function c11011.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c11011.spfilter,c:GetControler(),LOCATION_HAND,0,1,3,nil)
	Duel.Release(g,REASON_COST)
	local gc=g:GetCount()
	if gc > 3 then gc=3 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(gc*1000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
--	Duel.RegisterFlagEffect(tp,11011,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	if gc>=3 then
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetReset(RESET_EVENT+0xff0000)
		e3:SetTarget(c11011.target)
		e3:SetOperation(c11011.operation)
		c:RegisterEffect(e3)
	end
	if gc>=2 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e4)
	end
	if gc>=1 then
		--local e5=Effect.CreateEffect(c)
		--e5:SetType(EFFECT_TYPE_SINGLE)
		--e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		--e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		--e5:SetValue(1)
		--e5:SetReset(RESET_EVENT+0xff0000)
		--c:RegisterEffect(e5)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e5:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
		e5:SetCondition(c11011.rdcon)
		e5:SetOperation(c11011.rdop)
		c:RegisterEffect(e5)
	end
end
function c11011.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker()
end
function c11011.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,0)
end
function c11011.filter(c)
	return c:IsLevelAbove(9) and c:IsSetCard(0x208) and c:IsAbleToHand()
end
function c11011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11011.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
