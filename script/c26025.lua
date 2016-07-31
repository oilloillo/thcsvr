 
--光魔「星之漩涡」
function c26025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26025.condition)
	e1:SetTarget(c26025.target)
	e1:SetOperation(c26025.activate)
	c:RegisterEffect(e1)
end
function c26025.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and (eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ or eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO) and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x251)
end
function c26025.filter(c)
	return c:IsDestructable() and not (c:GetOriginalCode()==(26010) and c:IsFaceup())
end
function c26025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26025.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c26025.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c26025.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26025.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
