--虹符『雨伞风暴』
function c26092.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetTarget(c26092.target)
	e1:SetOperation(c26092.activate)
	c:RegisterEffect(e1)
end
function c26092.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
		return g:GetCount()>0 and g:FilterCount(Card.IsSetCard,nil,0x229)==g:GetCount() end
end
function c26092.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c26092.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	Duel.ChangePosition(g,0x1,0x1,0x4,0x4)
	local og=Duel.GetOperatedGroup()
	if og:FilterCount(Card.IsType,nil,TYPE_RITUAL)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if og:FilterCount(Card.IsType,nil,TYPE_FUSION)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		sg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(c26092.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	and Duel.SelectYesNo(tp,aux.Stringid(26092,0)) then
		local ogc=og:FilterCount(Card.IsType,nil,TYPE_FLIP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectTarget(tp,c26092.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ogc,e:GetHandler())
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
