 
--偷腥猫
function c20055.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c20055.cost)
	e1:SetTarget(c20055.target)
	e1:SetOperation(c20055.activate)
	c:RegisterEffect(e1)
end
function c20055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c20055.filter,nil,tp)
	if chk==0 then return Duel.CheckLPCost(tp,g:GetCount()*1000) end
	Duel.PayLPCost(tp,g:GetCount()*1000)
end
function c20055.filter(c,tp)
	return c:IsControlerCanBeChanged() and c:IsControler(1-tp) and c:GetSummonPlayer()==1-tp
end
function c20055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c20055.filter,nil,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() and eg:IsExists(c20055.filter,1,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c20055.filter3(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsControlerCanBeChanged() and c:IsControler(1-tp)
end
function c20055.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c20055.filter3,nil,e,tp)
	if g:GetCount()>0 then
		tc=g:GetFirst()
		while tc do
			Duel.GetControl(tc,tp,PHASE_END,1)
			tc=g:GetNext()
		end
	end
end
