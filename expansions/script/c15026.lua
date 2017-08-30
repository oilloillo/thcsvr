--梦境破碎
function c15026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END)
	e1:SetTarget(c15026.target)
	e1:SetOperation(c15026.operation)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c15026.atkcon)
	e2:SetTarget(c15026.atktg)
	c:RegisterEffect(e2)
	--check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c15026.checkop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c15026.desop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c15026.sdescon)
	e5:SetOperation(c15026.sdesop)
	c:RegisterEffect(e5)
end
function c15026.filter(c,e,tp)
	return c:IsSetCard(0x150) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c15026.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c15026.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c15026.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		c:SetCardTarget(tc)
		Duel.SpecialSummonComplete()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c15026.rcon)
		tc:RegisterEffect(e1,true)
	end
end
function c15026.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c15026.atkcon(e)
	return e:GetHandler():GetFlagEffect(15026)~=0
end
function c15026.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c15026.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(15026)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(15026,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c15026.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c15026.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c15026.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
