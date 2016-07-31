 
--妖魔书变化 幼邪龙
function c21470012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21470012.tg)
	e1:SetOperation(c21470012.op)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21470012,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c21470012.spcon)
	e2:SetTarget(c21470012.sptg)
	e2:SetOperation(c21470012.spop)
	c:RegisterEffect(e2)
end
function c21470012.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,21470012,0,0x21,100,100,4,RACE_DRAGON,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21470012.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,21470012,0,0x21,100,100,4,RACE_DRAGON,ATTRIBUTE_DARK) then return end
	c:AddTrapMonsterAttribute(TYPE_EFFECT+TYPE_TUNER,ATTRIBUTE_DARK,RACE_DRAGON,4,100,100)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:TrapMonsterBlock()
	--tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21470012,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21470012.target)
	e1:SetOperation(c21470012.operation)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetCondition(c21470012.syncon)
	e2:SetValue(c21470012.synlimit)
	c:RegisterEffect(e2,true)
	--XYZ limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetCondition(c21470012.syncon)
	e3:SetValue(c21470012.synlimit)
	c:RegisterEffect(e3,true)
	--[[release sum limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	e4:SetValue(1)
	c:RegisterEffect(e4,true)]]
end
function c21470012.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x742) and c:IsType(TYPE_TUNER)
end
function c21470012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21470012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21470012.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21470012.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21470012.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c21470012.syncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCode()==e:GetHandler():GetOriginalCode()
end
function c21470012.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x742)
end
function c21470012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c21470012.sfilter(c,e,tp)
	return c:IsCode(21470016) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c21470012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21470012.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21470012.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c21470012.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tc then 
		Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP) 
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCategory(CATEGORY_TODECK)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetOperation(c21470012.tdop)
		tc:RegisterEffect(e2)
	end
end
function c21470012.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end