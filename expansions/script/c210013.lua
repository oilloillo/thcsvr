--茨华仙邸
function c210013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210013,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c210013.tg)
	e2:SetOperation(c210013.op)
	c:RegisterEffect(e2)
	--ad up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_CALCULATING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c210013.con1)
	e2:SetOperation(c210013.adop)
	c:RegisterEffect(e2)
	--[[indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetCondition(c210013.con2)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)]]
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(210013,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
--	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c210013.con3)
	e6:SetTarget(c210013.sptg)
	e6:SetOperation(c210013.spop)
	c:RegisterEffect(e6)
end
function c210013.filter(c)
	return c:IsSetCard(0x710) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM)
end
function c210013.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local m=Duel.GetMatchingGroupCount(c210013.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	if chk==0 then return (m<3 and Duel.IsExistingMatchingCard(c210013.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil))
	or (m>=3 and Duel.IsExistingMatchingCard(c210013.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_EXTRA,0,1,nil))
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c210013.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local m=Duel.GetMatchingGroupCount(c210013.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	local tc=e:GetHandler()
	if m<3 then 
		tc=Duel.SelectMatchingCard(tp,c210013.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	else tc=Duel.SelectMatchingCard(tp,c210013.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst() end
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
function c210013.cfilter(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()
end
function c210013.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c210013.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c210013.adop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return end
	if a:IsControler(tp) and a:IsSetCard(0x710) then c210013.adup(a,e) end
	if d:IsControler(tp) and d:IsSetCard(0x710) then c210013.adup(d,e) end
end
function c210013.adup(c,e)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e2)
end
function c210013.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c210013.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,3,nil)
end
function c210013.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c210013.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,5,nil)
end
function c210013.filter3(c,e,tp)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()-- and c:IsSetCard(0x710)
end
function c210013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c210013.filter3,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c210013.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c210013.cfilter,tp,LOCATION_SZONE,0,5,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c210013.filter3,tp,LOCATION_SZONE,0,1,1,nil,e,tp):GetFirst()
	if tc then Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP) end
end