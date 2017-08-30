--黄金拼图-爱丽丝·卡塔雷特
function c4031103.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4031103,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c4031103.discon)
	e1:SetCountLimit(1,4031103)
	e1:SetCost(c4031103.discost)
	e1:SetTarget(c4031103.distg)
	e1:SetOperation(c4031103.disop)
	c:RegisterEffect(e1)
	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4031103,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c4031103.condition2)
	e3:SetCountLimit(1,4031103)
	e3:SetTarget(c4031103.thtg)
	e3:SetOperation(c4031103.thop)
	c:RegisterEffect(e3)
end
function c4031103.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c4031103.costfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToGraveAsCost() and c:IsLevelBelow(3)
end
function c4031103.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and 
		Duel.IsExistingMatchingCard(c4031103.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c4031103.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c4031103.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c4031103.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c4031103.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c4031103.thfilter(c)
	return c:IsSetCard(0x403) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c4031103.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4031103.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4031103.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4031103.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end