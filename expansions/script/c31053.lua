--梦符『刈安色的迷梦』
function c31053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,31051)
	e1:SetTarget(c31053.target)
	e1:SetOperation(c31053.activate)
	c:RegisterEffect(e1)
end

c31053.DescSetName=0x258

function c31053.filter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0x258 and c:IsLevelBelow(6) and c:IsAbleToHand()
end
function c31053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31053.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c31053.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c31053.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
