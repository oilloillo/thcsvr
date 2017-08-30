 
--亡失的情感✿秦心
function c25086.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c25086.synfilter),1)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25086,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(c25086.destg)
	e1:SetOperation(c25086.desop)
	c:RegisterEffect(e1)
	--discard
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetDescription(aux.Stringid(25086,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c25086.distg)
	e2:SetOperation(c25086.disop)
	--c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c25086.efilter)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(25086,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c25086.target)
	e4:SetOperation(c25086.operation)
	c:RegisterEffect(e4)
end
function c25086.synfilter(c)
	return (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_RITUAL) or c:IsSetCard(0x223)) and c:IsSetCard(0x208)
end
function c25086.cfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==(25129) and not c:IsDisabled()
end
function c25086.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then 
		local cs=e:GetHandler():GetFlagEffect(25086)
		if Duel.IsExistingMatchingCard(c25086.cfilter,tp,LOCATION_SZONE,0,1,nil) then
			return cs<2 and Duel.GetCurrentPhase()==PHASE_MAIN1
		and Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
		else 
			return cs==0 and Duel.GetCurrentPhase()==PHASE_MAIN1
		and Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,12450,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(25086,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c25086.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(c25086.disop)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,25086,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c25086.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local cs=e:GetHandler():GetFlagEffect(250860)
		if Duel.IsExistingMatchingCard(c25086.cfilter,tp,LOCATION_SZONE,0,1,nil) then
			return cs<2 and Duel.GetFlagEffect(tp,25086)>0
		else 
			return cs==0 and Duel.GetFlagEffect(tp,25086)>0 end
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),tp,0)
	e:GetHandler():RegisterFlagEffect(250860,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c25086.disop(e,tp,eg,ep,ev,re,r,rp)
	--local c=e:GetHandler()
	--if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c25086.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and not (re:IsActiveType(TYPE_EQUIP) and re:GetHandler():IsSetCard(0x414))
end
function c25086.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function c25086.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c25086.filter(chkc) end
	if chk==0 then 
		local cs=e:GetHandler():GetFlagEffect(2508600)
		if Duel.IsExistingMatchingCard(c25086.cfilter,tp,LOCATION_SZONE,0,1,nil) then
			return cs<2
		and Duel.IsExistingTarget(c25086.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler())
		else 
			return cs==0
		and Duel.IsExistingTarget(c25086.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c25086.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(2508600,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c25086.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end
