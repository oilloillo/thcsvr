--水符『河童山洪大爆发』
function c23053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,23053)
	e1:SetTarget(c23053.target)
	e1:SetOperation(c23053.activate)
	c:RegisterEffect(e1)
end
function c23053.cfilter(c)
	return c:IsSetCard(0x817) and c:IsFaceup()
end
function c23053.filter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c23053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23053.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c23053.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDestructable,1-tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c23053.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
	local ct=g:GetCount()
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,1-tp,LOCATION_ONFIELD)
end
function c23053.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local sg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
