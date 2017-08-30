 
--幻爆「近眼花火」
function c21051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21051.condition)
	e1:SetTarget(c21051.target)
	e1:SetOperation(c21051.activate)
	c:RegisterEffect(e1)
end
function c21051.cfilter(c)
	return c:IsSetCard(0x255)
end
function c21051.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21051.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c21051.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>1
		and Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21051.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21051.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		local hg=Duel.GetMatchingGroup(c21051.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		if hg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21032,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local toh=hg:Select(tp,1,1,nil)
			Duel.HintSelection(toh)
			Duel.BreakEffect()
			Duel.SendtoHand(toh,nil,REASON_EFFECT)
		end
	end
end
