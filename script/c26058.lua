 
--沉没的幽灵
function c26058.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c26058.spcon)
	e2:SetTarget(c26058.sptg)
	e2:SetOperation(c26058.spop)
	c:RegisterEffect(e2)
end
function c26058.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26058.spfilter(c,e,tp)
	return c:IsSetCard(0x251) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN))
end
function c26058.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c26058.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26058.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local spos=0
	local g=Duel.SelectMatchingCard(tp,c26058.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then spos=spos+POS_FACEUP_DEFENCE end
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) then spos=spos+POS_FACEDOWN_DEFENCE end
		if spos~=0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,spos) end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c26058.checkop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c26058.lpop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
end
function c26058.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():GetSummonPlayer()==tp then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function c26058.lpop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp<=1000 then
		Duel.SetLP(tp,0)
	else
		Duel.SetLP(tp,lp-1000)
	end
end
