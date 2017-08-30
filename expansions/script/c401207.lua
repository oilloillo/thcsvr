--沉没的深海栖舰
function c401207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(401207,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c401207.cost)
	e2:SetTarget(c401207.target1)
	e2:SetOperation(c401207.operation1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetDescription(aux.Stringid(401207,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c401207.cost)
	e3:SetTarget(c401207.target2)
	e3:SetOperation(c401207.operation2)
	c:RegisterEffect(e3)
	--self destroy
     local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetProperty(EFFECT_FLAG_REPEAT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c401207.tdcon)
	e5:SetTarget(c401207.tdtg)
	e5:SetOperation(c401207.tdop)
	c:RegisterEffect(e5)

end
function c401207.cfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(5)
end
function c401207.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c401207.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c401207.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c401207.filter1(c)
	return c:IsLevelBelow(6) and c:IsSetCard(0x911) and c:IsAbleToHand()
end
function c401207.filter2(c)
	return c:IsAttribute(ATTRIBUTE_WATER)  and c:IsAbleToGrave()
end
function c401207.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c401207.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c401207.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c401207.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c401207.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c401207.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c401207.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c401207.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c401207.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x911)
end
function c401207.tdcon(e,tp,eg,ep,ev,re,r,rp)
      return not Duel.IsExistingMatchingCard(c401207.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c401207.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c401207.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
	