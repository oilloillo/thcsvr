 
--幻爆「近眼花火」
function c21032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21032.condition)
	e1:SetTarget(c21032.target)
	e1:SetOperation(c21032.activate)
	c:RegisterEffect(e1)
end
function c21032.cfilter(c)
	return c:IsSetCard(0x256) and c:IsLevelAbove(6)
end
function c21032.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21032.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c21032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
end
function c21032.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21032.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	local hg=Duel.GetMatchingGroup(c21032.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if hg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21032,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local toh=hg:Select(tp,1,1,nil)
		Duel.HintSelection(toh)
		Duel.BreakEffect()
		Duel.SendtoHand(toh,nil,REASON_EFFECT)
	end
end
