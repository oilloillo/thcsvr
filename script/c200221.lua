 
--符器-鲶鱼的大地震
function c200221.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c200221.activate)
	c:RegisterEffect(e1)
end
function c200221.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	--turn count
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetLabel(0)
	e0:SetCountLimit(1)
	e0:SetOperation(c200221.count)
	e0:SetReset(RESET_PHASE+PHASE_END,4)
	Duel.RegisterEffect(e0,tp)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetLabelObject(e0)
	e2:SetCountLimit(1)
	e2:SetCondition(c200221.con2)
	e2:SetTarget(c200221.tg2)
	e2:SetOperation(c200221.op2)
	Duel.RegisterEffect(e2,tp)
end
function c200221.count(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if(ct<4) then
		ct=ct+1
		e:SetLabel(ct)
		c:SetTurnCounter(ct)
	end
end
function c200221.con2(e,tp,eg,ep,ev,re,r,rp)
	local e0=e:GetLabelObject()
	return e0 and e0:GetHandler():GetTurnCounter() == 4
end
function c200221.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsDestructable()
end
function c200221.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(200221)==0 end
	local sg=Duel.GetMatchingGroup(c200221.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0) end
end
function c200221.filter2(c,e,tp)
	return c:IsCode(200021) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c200221.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,200221)
	local sg=Duel.GetMatchingGroup(c200221.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c200221.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	and Duel.SelectYesNo(tp,aux.Stringid(200221,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c200221.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENCE)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
