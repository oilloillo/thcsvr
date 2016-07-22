--决战符『绝对零度』
function c37009.initial_effect(c)
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
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c37009.condition)
	e1:SetTarget(c37009.target)
	e1:SetOperation(c37009.activate)
	c:RegisterEffect(e1)

	if c37009.counter == nil then
		c37009.counter = true
		Uds.regUdsEffect(e1,37009)
	end
end
function c37009.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and Duel.GetTurnCount()>=9
end
function c37009.filter1(c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemove()
end
function c37009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c37009.filter1,tp,0x12,0x12,nil)
	if chk==0 then return g1:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c37009.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(c37009.filter1,tp,0x12,0x12,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	--forbidden
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c37009.bantg)
	e2:SetLabel(c:GetFieldID())
	e2:SetLabelObject(c)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c37009.bantg)
	e3:SetLabel(c:GetFieldID())
	e3:SetLabelObject(c)
	c:RegisterEffect(e3)
end
function c37009.bantg(e,c)
	return c:GetFieldID()<e:GetLabel() and c~=e:GetLabelObject() and not (c:IsAttribute(ATTRIBUTE_WATER) and c:GetDefence()==900)
end
