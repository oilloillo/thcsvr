 
--西行妖
function c20086.initial_effect(c)
	c:SetUniqueOnField(1,0,20086)
	c:EnableCounterPermit(0x28b)
	c:SetCounterLimit(0x28b,8)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20086,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetTarget(c20086.addct)
	e1:SetOperation(c20086.addc)
	c:RegisterEffect(e1)
	--sendtograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20086,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c20086.descost)
	e2:SetTarget(c20086.destg)
	e2:SetOperation(c20086.desop)
	c:RegisterEffect(e2)
	--Destroy effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c20086.desrepcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(c20086.efilter)
	e5:SetCondition(c20086.condition)
	c:RegisterEffect(e5)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(c20086.igcon)
	e4:SetTarget(c20086.cfilter)
	c:RegisterEffect(e4)
end
function c20086.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==tp end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x28b)
end
function c20086.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x28b,2)
	end
end
function c20086.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x28b,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x28b,4,REASON_COST)
end
function c20086.filter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
function c20086.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c20086.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20086.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c20086.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c20086.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsAttackPos() and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c20086.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c20086.desrepcon(e)
	return e:GetHandler():GetCounter(0x28b)>1
end
function c20086.condition(e)
	return e:GetHandler():GetCounter(0x28b)>3
end
function c20086.igcon(e)
	return e:GetHandler():GetCounter(0x28b)>5
end
function c20086.cfilter(e)
	return aux.TRUE
end
