--梦符『绯色的噩梦』
function c31051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,31051)
	e1:SetTarget(c31051.target)
	e1:SetOperation(c31051.activate)
	c:RegisterEffect(e1)
end
function c31051.filter(c)
	return c:IsSetCard(0x273) and c:IsAbleToHand()
end
function c31051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31051.filter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end
function c31051.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c31051.filter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
