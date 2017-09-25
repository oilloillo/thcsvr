--神与道的连结✿丰聪耳神子
function c27501.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c27501.matfilter,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c27501.condition)
	e1:SetOperation(c27501.operation)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27501,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c27501.discon)
	e2:SetCost(c27501.cost)
	e2:SetTarget(c27501.distg)
	e2:SetOperation(c27501.disop)
	c:RegisterEffect(e2)
end
function c27501.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN) and c:IsSetCard(0x208)
end
function c27501.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c27501.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,27501)==0 then
		Duel.Hint(HINT_CARD,0,27501)
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(1,27501)
		e1:SetCondition(c27501.gscon)
		e1:SetOperation(c27501.gsop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetCountLimit(1,275010+EFFECT_COUNT_CODE_DUEL)
		e2:SetCondition(c27501.nycon)
		e2:SetOperation(c27501.nyop)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.RegisterFlagEffect(tp,27501,0,0,1)
end
function c27501.filter(c,e,tp)
	return c:IsCode(27501) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27501.gscon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x912) and Duel.IsExistingMatchingCard(c27501.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c27501.gsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c27501.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c27501.thfilter(c)
	return c:IsSetCard(0x912) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c27501.nycon(e,tp,eg,ep,ev,re,r,rp)
	return (re:GetHandler():IsCode(27092) or re:GetHandler():IsCode(27093)) and Duel.IsExistingMatchingCard(c27501.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c27501.nyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c27501.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c27501.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return ep~=tp and Duel.IsChainNegatable(ev) and c:GetLinkedGroup():IsContains(re:GetHandler())
end
function c27501.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c27501.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c27501.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
