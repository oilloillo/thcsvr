--决战符『阳炎』
function c37001.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c37001.condition)
	e1:SetTarget(c37001.target)
	e1:SetOperation(c37001.activate)
	c:RegisterEffect(e1)

	if c37001.counter == nil then
		c37001.counter = true
		Uds.regUdsEffect(e1,37001)
	end
end
function c37001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND
end
function c37001.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c37001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37001.filter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c37001.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c37001.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
