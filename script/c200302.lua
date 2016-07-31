 
--全人类的绯想天
function c200302.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c200302.condition)
	e1:SetTarget(c200302.target)
	e1:SetOperation(c200302.activate)
	c:RegisterEffect(e1)
end
function c200302.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c200302.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c200302.cfilter,tp,LOCATION_ONFIELD,0,1,nil,200015)
		and Duel.IsExistingMatchingCard(c200302.cfilter,tp,LOCATION_ONFIELD,0,1,nil,200115)
		and Duel.IsExistingMatchingCard(c200302.cfilter,tp,LOCATION_ONFIELD,0,1,nil,200215)
end
function c200302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
end
function c200302.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,3000,REASON_EFFECT)
end