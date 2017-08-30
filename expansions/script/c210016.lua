--虎符「两门的彭祖」
function c210016.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(210016,0))
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCountLimit(1,210016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c210016.stg)
	e1:SetOperation(c210016.sop)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(210016,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCountLimit(1,210016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c210016.sptg)
	e1:SetOperation(c210016.spop)
	c:RegisterEffect(e1)
end
function c210016.cfilter(c)
	return c:IsSetCard(0x710) and c:IsFaceup()
end
function c210016.filter(c,e,tp)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e) and c:IsFaceup()-- and c:IsSetCard(0x710)
end
function c210016.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_SZONE and chkc:GetControler()==tp and c210016.filter(chkc,e,tp) end
	local m=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local n=Duel.GetMatchingGroupCount(c210016.filter,tp,LOCATION_SZONE,0,nil,e,tp)
	if m>n then m=n end
	if m>2 then m=2 end
	if chk==0 then return m>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c210016.filter,tp,LOCATION_SZONE,0,1,m,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_SZONE)
end
function c210016.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end	
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c210016.sfilter(c)
	return c:IsSetCard(0x710) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM)
end
function c210016.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local s=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c210016.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
		and (s>1 or (c:IsLocation(LOCATION_ONFIELD) and s>0)) end
end
function c210016.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,c210016.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then 
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
