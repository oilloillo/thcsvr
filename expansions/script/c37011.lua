--决战符『天女返』
function c37011.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c37011.condition)
	e1:SetTarget(c37011.target)
	e1:SetOperation(c37011.activate)
	c:RegisterEffect(e1)

	if c37011.counter == nil then
		c37011.counter = true
		Uds.regUdsEffect(e1,37011)
	end
end
function c37011.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and ep==tp
end
function c37011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,1,0,0)
end
function c37011.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==0 then return end
	local g=Duel.GetOperatedGroup()
	local ct1=g:GetCount()
	local c1=g:FilterCount(Card.IsControler,nil,tp)
	local c2=g:FilterCount(Card.IsControler,nil,1-tp)
	if c1==0 then c1=3 end
	if c2==0 then c2=3 end
	local g1=Duel.GetDecktopGroup(tp,3-c1)
	local g2=Duel.GetDecktopGroup(1-tp,3-c2)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct2=g:GetCount()+ct1
	Duel.Damage(1-tp,ct2*200,REASON_EFFECT)
end
