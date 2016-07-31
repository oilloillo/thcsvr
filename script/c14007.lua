 
--梦幻馆的门番 艾丽
function c14007.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c14007.sumop)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3208))
	e2:SetValue(0x1)
	--c:RegisterEffect(e2)
	--double tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e3:SetValue(c14007.condition)
	c:RegisterEffect(e3)
end
function c14007.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,14007)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(c14007.filter))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,14007,RESET_PHASE+PHASE_END,0,1)
end
function c14007.filter(c)
	return (c:IsSetCard(0x208) and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_DARK)) or c:IsSetCard(0x3208)
end
function c14007.condition(e,c)
	return c:IsSetCard(0x3208)
end
