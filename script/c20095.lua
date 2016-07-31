 
--死蝶「华胥的永眠」
function c20095.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20095.target)
	e1:SetOperation(c20095.activate)
	c:RegisterEffect(e1)
end
function c20095.xfilter(c)
	return c:GetCounter(0x28b)>0 and c:IsCode(20086)
end
function c20095.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE)
	and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
		and Duel.IsExistingMatchingCard(c20095.xfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	local cg=Duel.GetMatchingGroup(c20095.xfilter,tp,LOCATION_SZONE,0,nil)
	local tc=cg:GetFirst()
	local ct=tc:GetCounter(0x28b)
	tc:RemoveCounter(tp,0x28b,ct,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c20095.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
