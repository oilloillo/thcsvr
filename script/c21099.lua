--狂战士之血
function c21099.initial_effect(c)
	c:SetUniqueOnField(1,0,21099)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c21099.damcon1)
	e2:SetValue(c21099.damval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c21099.damcon2)
	e3:SetValue(c21099.damval2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCondition(c21099.damcon3)
	e4:SetValue(c21099.damval3)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	--c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x137))
	e6:SetCondition(c21099.damcon1)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCondition(c21099.damcon2)
	e7:SetValue(2)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCondition(c21099.damcon3)
	e8:SetValue(3)
	c:RegisterEffect(e8)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetRange(LOCATION_SZONE)
	e9:SetValue(c21099.indval)
	e9:SetCondition(c21099.damcon4)
	c:RegisterEffect(e9)
	--immune
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetValue(c21099.efilter)
	e10:SetCondition(c21099.damcon3)
	c:RegisterEffect(e10)
end
function c21099.damcon1(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=4000 and Duel.GetLP(e:GetHandlerPlayer())>3000
end
function c21099.damval1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return math.ceil(val/2) end
	return val
end
function c21099.damcon2(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=3000 and Duel.GetLP(e:GetHandlerPlayer())>2000
end
function c21099.damval2(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return math.ceil(val/4) end
	return val
end
function c21099.damcon3(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=2000
end
function c21099.damval3(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return math.ceil(val/10) end
	return val
end
function c21099.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c21099.damcon4(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=3000
end
function c21099.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
