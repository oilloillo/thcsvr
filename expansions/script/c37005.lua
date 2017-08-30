--决战符『春天Death☆』
function c37005.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c37005.condition)
	e1:SetTarget(c37005.target)
	e1:SetOperation(c37005.activate)
	c:RegisterEffect(e1)

	if c37005.counter == nil then
		c37005.counter = true
		Uds.regUdsEffect(e1,37005)
	end
end
function c37005.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and not re:GetHandler():IsCode(37000)
end
function c37005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetFieldGroupCount(tp,0,0xe)
	local ct2=Duel.GetFieldGroupCount(tp,0xe,0)
	if chk==0 then
		if e:GetHandler() and e:GetHandler():IsOnField() then 
			return ct1/(ct2-1)>=2 and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
		else
			return ct1/ct2>=2 and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,1,0,0)
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(c37005.chainlimit)
	end
end
function c37005.chainlimit(e,rp,tp)
	return e:GetHandler():IsSetCard(0x214)
end
function c37005.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,1600,REASON_EFFECT)>0 then
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
