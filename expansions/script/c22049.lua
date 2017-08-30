 
--红魔 七曜的魔女
function c22049.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x813),1)
	c:EnableReviveLimit()
	--Attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(0x1f)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22049,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c22049.condition)
	e3:SetTarget(c22049.target)
	e3:SetOperation(c22049.operation)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22049,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c22049.setcost)
	e4:SetTarget(c22049.settg)
	e4:SetOperation(c22049.setop)
	c:RegisterEffect(e4)
	--indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetCountLimit(1)
	e5:SetValue(c22049.valcon)
	c:RegisterEffect(e5)
end
function c22049.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c22049.filter2(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c22049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22049.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22049.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22049.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22049.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22049.filter(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c22049.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c22049.filter,tp,LOCATION_DECK,0,2,nil) end
end
function c22049.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22049.filter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22049.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
