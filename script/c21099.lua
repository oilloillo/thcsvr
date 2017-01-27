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
	local e9=e4:Clone()
	e9:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e9)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x137))
	e5:SetCondition(c21099.damcon2)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCondition(c21099.damcon3)
	e6:SetValue(2)
	c:RegisterEffect(e6)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetRange(LOCATION_SZONE)
	e7:SetValue(c21099.indval)
	e7:SetCondition(c21099.damcon4)
	c:RegisterEffect(e7)
	--immune
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c21099.efilter)
	e8:SetCondition(c21099.damcon3)
	c:RegisterEffect(e8)
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
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function c21099.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c21099.damcon4(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=4000
end
function c21099.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
