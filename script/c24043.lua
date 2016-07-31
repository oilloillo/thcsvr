 
--四天王奥义「三步必杀」
function c24043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c24043.activate)
	c:RegisterEffect(e1)
end
function c24043.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--turn count
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCountLimit(1)
	e0:SetLabel(0)
	e0:SetOperation(c24043.count)
	e0:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e0,tp)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabelObject(e0)
	e1:SetCondition(c24043.con1)
	e1:SetTarget(c24043.tg1)
	e1:SetOperation(c24043.op1)
	Duel.RegisterEffect(e1,tp)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetLabelObject(e0)
	e2:SetCondition(c24043.con2)
	e2:SetTarget(c24043.tg2)
	e2:SetOperation(c24043.op2)
	Duel.RegisterEffect(e2,tp)
end
function c24043.count(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if(ct<3) then
		ct=ct+1
		e:SetLabel(ct)
		e:GetHandler():SetTurnCounter(ct)
	end
end
function c24043.cfilter(c)
	return c:IsFaceup() and c:IsCode(24010)
end
function c24043.con1(e,tp,eg,ep,ev,re,r,rp)
	local e0=e:GetLabelObject()
	return e0 and e0:GetHandler():GetTurnCounter() == 3 and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
end
function c24043.spfilter(c,e,tp)
	return c:IsCode(24010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24043.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(24043)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c24043.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	e:GetHandler():RegisterFlagEffect(24043,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) 
end
function c24043.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c24043.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(24043,0)) then
			dc=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
			Duel.Destroy(dc,REASON_EFFECT)
		end
	end
end
function c24043.con2(e,tp,eg,ep,ev,re,r,rp)
	local e0=e:GetLabelObject()
	return e0 and e0:GetHandler():GetTurnCounter() == 3 and Duel.IsExistingMatchingCard(c24043.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c24043.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c24043.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(24043)==0 and Duel.IsExistingMatchingCard(c24043.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c24043.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(24043,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) 
end
function c24043.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c24043.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local g=og:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local def=0
	local tc=g:GetFirst()
	while tc do
		def=def+tc:GetBaseDefence()
		tc=g:GetNext()
	end
	Duel.Damage(1-tp,def,REASON_EFFECT)
end
