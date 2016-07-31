--废狱之心 地灵殿
-- --require "expansions/nef/nef"
function c24083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x625))
	e2:SetValue(0x1)
	c:RegisterEffect(e2)
	--cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c24083.condition)
	e3:SetValue(c24083.aclimit)
	c:RegisterEffect(e3)
end
function c24083.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x625)
end
function c24083.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	-- Nef.Log(string.format("1 %s", tostring(Duel.IsExistingMatchingCard(c24083.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil))))
	-- Nef.Log(string.format("2 %s", tostring(ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)))
	-- Nef.Log(string.format("3 %s", tostring(tp)))
	return Duel.IsExistingMatchingCard(c24083.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil) 
		and (ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
end
function c24083.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
