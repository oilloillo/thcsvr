 
--妖精大战争
function c25029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c25029.target)
	e1:SetOperation(c25029.operation)
	c:RegisterEffect(e1)
end
function c25029.spfilter(c,e,tp)
	return c:IsSetCard(0x999) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		return h1>0 and Duel.IsExistingMatchingCard(c25029.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c25029.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c25029.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c25029.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=Duel.SendtoGrave(g1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c25029.spfilter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(25029,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			tc=g2:GetNext()
		end
	end
	Duel.SpecialSummonComplete()
	g2:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(g2)
	e1:SetOperation(c25029.desop)
	Duel.RegisterEffect(e1,tp)
end
function c25029.desfilter(c)
	return c:GetFlagEffect(25029)>0
end
function c25029.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c25029.desfilter,nil)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
