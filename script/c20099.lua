 
--反魂蝶 -八分咲-
function c20099.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20099.target)
	e1:SetOperation(c20099.activate)
	c:RegisterEffect(e1)
end
function c20099.xfilter(c)
	return c:GetCounter(0x28b)>7 and c:IsCode(20086)
end
function c20099.filter(c,e,tp)
	return c:IsSetCard(0x338) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c20099.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20099.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c20099.xfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c20099.xfilter,tp,LOCATION_SZONE,0,nil)
	local tc=g:GetFirst()
	tc:RemoveCounter(tp,0x28b,8,REASON_COST)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end
function c20099.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20099.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c20099.lpop)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function c20099.lpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return end
	local lp=Duel.GetLP(tp)
	if lp<=4000 then
		Duel.SetLP(tp,0)
	else
		Duel.SetLP(tp,lp-4000)
	end
end
