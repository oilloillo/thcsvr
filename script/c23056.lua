 
--水符「河童泡沫波纹疾走」
function c23056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c23056.condition)
	e1:SetTarget(c23056.target)
	e1:SetOperation(c23056.operation)
	c:RegisterEffect(e1)
	--sh
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23056,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c23056.sgcon)
	e2:SetTarget(c23056.sgtg)
	e2:SetOperation(c23056.sgop)
	c:RegisterEffect(e2)
end
function c23056.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c23056.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x817)
end
function c23056.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c23056.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23056.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c23056.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c23056.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		--Atk/def
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(200)
		c:RegisterEffect(e1)
		--Level
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(1)
		c:RegisterEffect(e3)
		--Equip limit
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_EQUIP_LIMIT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetValue(c23056.eqlimit)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4)
	end
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(23056,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_REPEAT+EFFECT_FLAG_CHAIN_UNIQUE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c23056.descon)
	e5:SetTarget(c23056.destg)
	e5:SetOperation(c23056.desop)
	c:RegisterEffect(e5)
end
function c23056.eqlimit(e,c)
	return c:IsSetCard(0x817)
end
function c23056.sgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP)
end
function c23056.sgfilter(c)
	return c:IsSetCard(0x820) and c:IsAbleToHand()
end
function c23056.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23056.sgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c23056.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23056.sgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c23056.gfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE+LOCATION_DECK) and c:GetSummonPlayer()==1-tp
end
function c23056.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23056.gfilter,1,nil,tp)
end
function c23056.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c23056.gfilter,1,nil,tp) end
	local g=eg:Filter(c23056.gfilter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c23056.filter3(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsDestructable()
end
function c23056.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c23056.filter3,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 and g:GetCount()>0 then
	Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end
