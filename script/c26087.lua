--化符『遗忘之伞的夜行列车』
function c26087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26087.condition)
	e1:SetTarget(c26087.target)
	e1:SetOperation(c26087.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetCondition(c26087.condition2)
	c:RegisterEffect(e2)
end
function c26087.condition(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return (ec:GetSummonType()==0x20000000 or ec:GetSummonType()==0x49000000 or ec:GetSummonType()==0x45000000 or ec:GetSummonType()==0x43000000)
	and ec:GetSummonPlayer()==tp and ec:IsSetCard(0x229)
end
function c26087.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:GetSummonPlayer()==tp and ec:IsSetCard(0x229)
end
function c26087.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c26087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26087.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c26087.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c26087.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26087.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
