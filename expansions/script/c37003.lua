--决战符『三月精』
function c37003.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_MSET)
	e1:SetCondition(c37003.condition)
	e1:SetTarget(c37003.target)
	e1:SetOperation(c37003.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SSET)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)

	if c37003.counter == nil then
		c37003.counter = true
		Uds.regUdsEffect(e1,37003)
		Uds.regUdsEffect(e2,37003)
		Uds.regUdsEffect(e3,37003)
		Uds.regUdsEffect(e4,37003)
	end
end
function c37003.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and Duel.GetTurnCount()>=3
end
function c37003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2
		and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(c37003.chainlimit)
	end
end
function c37003.chainlimit(e,rp,tp)
	return e:GetHandler():IsSetCard(0x214)
end
function c37003.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	local g=g1:RandomSelect(tp,1)
	local g3=g2:RandomSelect(tp,1)
	g:Merge(g3)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
