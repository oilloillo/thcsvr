 
--光魔「星之漩涡」
function c26054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26054.condition)
	e1:SetTarget(c26054.target)
	e1:SetOperation(c26054.activate)
	c:RegisterEffect(e1)
end
function c26054.cfilter(c,tp)
	return c:IsSetCard(0x251) and c:GetSummonPlayer()==tp and
		(c:GetSummonType()==SUMMON_TYPE_SYNCHRO or c:GetSummonType()==SUMMON_TYPE_XYZ or c:GetSummonType()==SUMMON_TYPE_RITUAL or c:GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c26054.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26054.cfilter,1,nil,tp)
end
function c26054.filter(c)
	return c:IsDestructable() and not ((c:IsSetCard(0x251) or c:IsSetCard(0x252)) and c:IsFaceup())
end
function c26054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26054.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c26054.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c26054.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26054.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
