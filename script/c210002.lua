--质讯愿望的仙人✿茨木华扇
function c210002.initial_effect(c)
	--[[special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c210002.sptg)
	e1:SetOperation(c210002.spop)
	c:RegisterEffect(e1)]]
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210002,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c210002.tg)
	e1:SetOperation(c210002.op)
	c:RegisterEffect(e1)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c210002.tgcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)--[[
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(c210002.tgvalue)
	c:RegisterEffect(e5)]]
end--[[
function c210002.filter(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsSetCard(0x1710)
end
function c210002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_SZONE and chkc:GetControler()==tp and c210002.filter3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c210002.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c210002.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_SZONE)
end
function c210002.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end]]
function c210002.tgfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1710) or c:IsSetCard(0x2710))
end
function c210002.tgcon(e)
	return Duel.IsExistingMatchingCard(c210002.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end--[[
function c210002.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end]]
function c210002.filter(c)
	return c:IsSetCard(0x1710) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM)
end
function c210002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210002.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c210002.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,c210002.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
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