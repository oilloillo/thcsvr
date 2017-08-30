--黄金拼图-大宫忍
function c4031102.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4031102,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c4031102.condition)
	e4:SetCountLimit(1,4031102)
	e4:SetCost(c4031102.discost)
	e4:SetTarget(c4031102.target)
	e4:SetOperation(c4031102.activate)
	c:RegisterEffect(e4)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,4031102)
	e2:SetCost(c4031102.thcost)
	e2:SetTarget(c4031102.thtg)
	e2:SetOperation(c4031102.thop)
	c:RegisterEffect(e2)
	
end
function c4031102.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c4031102.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsActiveType(TYPE_QUICKPLAY)
end
function c4031102.filter(c)
	return c:IsSetCard(0x423) and c:IsAbleToHand() 
end
function c4031102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4031102.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4031102.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4031102.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c4031102.cfilter(c)
	return c:IsSetCard(0x403) and c:IsAbleToRemoveAsCost()
end
function c4031102.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c4031102.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4031102.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4031102.thfilter(c)
	return c:IsSetCard(0x403) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(4031102)
end
function c4031102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4031102.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4031102.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4031102.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end