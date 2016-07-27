--决战符『真红』
function c37006.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c37006.condition1)
	e1:SetTarget(c37006.target)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c37006.condition2)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetValue(c37006.etarget)
	c:RegisterEffect(e3)
	--Atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c37006.tg)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	--Def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c37006.tg)
	e5:SetValue(500)
	c:RegisterEffect(e5)

	if c37006.counter == nil then
		c37006.counter = true
		Uds.regUdsEffect(e1,37006)
		Uds.regUdsEffect(e2,37006)
	end
end
function c37006.filter(c)
	return c:GetLevel()>=8
end
function c37006.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND
		and eg:GetFirst():GetLevel()>=8 and bit.band(eg:GetFirst():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c37006.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and eg:IsExists(c37006.filter,1,nil)
end
function c37006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(c37006.chainlimit)
	end
end
function c37006.chainlimit(e,rp,tp)
	return e:GetHandler():IsSetCard(0x214)
end
function c37006.etarget(e,re,c)
	return c:IsFaceup() and c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x208) and c:GetLevel()==8 and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_FIEND)
end
function c37006.tg(e,c)
	return c:GetLevel()==8 and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x208)
end
