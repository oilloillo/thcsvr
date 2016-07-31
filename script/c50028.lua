 
--岛风型驱逐舰-岛风
function c50028.initial_effect(c)
	c:SetUniqueOnField(1,1,50028)
	local temp = 0
	while temp<7 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c50028.spcon)
	c:RegisterEffect(e2)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
end
function c50028.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4bb) and c:IsLevelBelow(4)
end
function c50028.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c50028.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
