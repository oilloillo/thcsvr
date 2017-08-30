--断命剑『冥想斩』
function c20190.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20190.condition)
	e1:SetTarget(c20190.target)
	e1:SetOperation(c20190.activate)
	c:RegisterEffect(e1)
end
function c20190.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x713)
end
function c20190.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20190.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20190.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)
end
function c20190.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local sg=g:RandomSelect(tp,1)
		Duel.Destroy(sg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
