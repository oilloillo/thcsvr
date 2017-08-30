 
--沉睡的恐怖～Sleeping Terror
function c14034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c14034.condition)
	e1:SetTarget(c14034.target)
	e1:SetOperation(c14034.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c14034.filter1(c,sp,e)
	return c:IsSetCard(0x3208) and c:GetSummonPlayer()==sp and (not e or c:IsRelateToEffect(e))
end
function c14034.filter2(c)
	return c:IsSetCard(0x138) and c:IsType(TYPE_MONSTER)
end
function c14034.filter3(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c14034.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c14034.filter2,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>2
end
function c14034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c14034.filter1,1,nil,tp,nil) and Duel.IsExistingMatchingCard(c14034.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c14034.filter3,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,sg:GetCount()*1000)
end
function c14034.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c14034.filter3,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
end
