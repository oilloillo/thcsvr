--决战符『水满』
function c37008.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c37008.condition)
	e1:SetTarget(c37008.target)
	e1:SetOperation(c37008.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(-400)
	c:RegisterEffect(e4)
	--Def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(-400)
	c:RegisterEffect(e5)

	if c37008.counter == nil then
		c37008.counter = true
		Uds.regUdsEffect(e1,37008)
		Uds.regUdsEffect(e2,37008)
	end
end
function c37008.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and eg:GetFirst():GetSummonPlayer()~=tp
end
function c37008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg:GetFirst(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(c37008.chainlimit)
	end
end
function c37008.chainlimit(e,rp,tp)
	return e:GetHandler():IsSetCard(0x214)
end
function c37008.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
