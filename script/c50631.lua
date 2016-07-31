 
--翔凤型轻型航空母舰-瑞凤改
function c50631.initial_effect(c)
	local temp = 0
	while temp<5 do
		c:RegisterFlagEffect(50900,0,0,0)
		temp = temp+1
	end
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c50631.spcon)
	e2:SetOperation(c50631.spop)
	c:RegisterEffect(e2)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_DECK)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c50631.rfilter(c)
	return c:IsCode(50271)
end
function c50631.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c50631.rfilter,1,nil)
end
function c50631.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c50631.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.Draw(tp,2,REASON_EFFECT)
end
