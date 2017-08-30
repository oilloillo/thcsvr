--冥界侍卫✿妖梦
function c20252.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--effect indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c20252.condition)
	e2:SetTarget(c20252.indtg)
	e2:SetValue(c20252.indval)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20252,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c20252.tkcost)
	e3:SetTarget(c20252.tktg)
	e3:SetOperation(c20252.tkop)
	c:RegisterEffect(e3)
end
function c20252.condition(e,tp,eg,ep,ev,re,r,rp)
	local p = Duel.GetCurrentPhase()
	return bit.band(p,0xf8)==p
end
function c20252.indtg(e,c)
	return c:IsType(TYPE_SPIRIT)
end
function c20252.indval(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c20252.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	Duel.PayLPCost(tp,1200)
end
function c20252.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20046,0x208,0x4011,100,0,1,RACE_ZOMBIE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c20252.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,20046,0x208,0x4011,100,0,1,RACE_ZOMBIE,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,20046)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end
