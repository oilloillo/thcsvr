--决战符『清华』
function c37002.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c37002.condition)
	e1:SetTarget(c37002.target)
	e1:SetOperation(c37002.activate)
	c:RegisterEffect(e1)

	if c37002.counter == nil then
		c37002.counter = true
		Uds.regUdsEffect(e1,37002)
	end
end
function c37002.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and not re:GetHandler():IsCode(37000)
end
function c37002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandlerPlayer()~=tp and re:GetHandler():IsSetCard(0x214) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	end
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(c37002.chainlimit)
	end
end
function c37002.chainlimit(e,rp,tp)
	return e:GetHandler():IsSetCard(0x214)
end
function c37002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 and Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
