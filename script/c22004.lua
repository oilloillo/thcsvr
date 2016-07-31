 
--大妖精
function c22004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22004.spcon)
	c:RegisterEffect(e1)
end
function c22004.spfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x999) or c:GetOriginalCode()==(22090))
end
function c22004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c22004.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end