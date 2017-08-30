 
--精灵剑舞祭
function c40031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c40031.target)
	e1:SetOperation(c40031.activate)
	c:RegisterEffect(e1)
end
function c40031.cfilter(c)
	return not (c:IsSetCard(0x430) or c:IsSetCard(0x413))
end
function c40031.filter(c)
	return (c:IsSetCard(0x430) or c:IsSetCard(0x413)) and c:IsAbleToHand()
end
function c40031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40031.filter,tp,LOCATION_DECK,0,1,nil)
	and not Duel.IsExistingMatchingCard(c40031.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40031.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40031.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
