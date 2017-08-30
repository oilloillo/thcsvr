 
--通灵「铜铃芳香」
function c27028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c27028.ccon)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c27028.condition)
	e2:SetTarget(c27028.target)
	e2:SetOperation(c27028.operation)
	c:RegisterEffect(e2)
end
function c27028.ccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x240)
end
function c27028.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27028.ccfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c27028.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c27028.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and eg:IsExists(c27028.cfilter,1,nil,tp)
end
function c27028.filter(c,e,tp)
	return c:IsSetCard(0x242) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27028.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c27028.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27028.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(500)
		tc:RegisterEffect(e3)
	end
end
