 
--不死「火鸟 -凤翼天翔-」
function c21121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c21121.sumcon)
	e1:SetTarget(c21121.target)
	e1:SetOperation(c21121.activate)
	c:RegisterEffect(e1)
end
function c21121.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c21121.filter(c,e,tp)
	return (c:IsCode(21024) or c:IsCode(21077)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21121.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_HAND)
end
function c21121.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21121.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e3)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c21121.efilter)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local opt=0
		if tc:IsType(TYPE_SYNCHRO) then opt=2
		else opt=Duel.SelectOption(tp,aux.Stringid(21121,0),aux.Stringid(21121,1))+1 end
		if opt==1 then
			tc:RegisterFlagEffect(210770,RESET_EVENT+0x17a0000,0,0)
		else
			Duel.Recover(tp,ev*2,REASON_EFFECT)
		end
	end
end
function c21121.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
