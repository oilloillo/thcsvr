 
--符器-病气平癒守
function c200216.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(200216,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE,0)
	e1:SetOperation(c200216.activate)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(200216,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c200216.target)
	e1:SetOperation(c200216.operation)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(200216,4))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c200216.target2)
	e1:SetOperation(c200216.operation2)
	c:RegisterEffect(e1)
end
function c200216.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	--turn count
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetCountLimit(1)
	e0:SetLabel(0)
	e0:SetOperation(c200216.count)
	e0:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
	Duel.RegisterEffect(e0,tp)
end
function c200216.count(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if(ct<3) then
		ct=ct+1
		e:SetLabel(ct)
		c:SetTurnCounter(ct)
		Duel.Recover(tp,800,REASON_EFFECT)
	end
end
function c200216.filter(c)
	return c:IsFaceup() and (c:IsHasEffect(EFFECT_DISABLE_EFFECT) or c:IsHasEffect(EFFECT_DISABLE)) and c:IsCanTurnSet()
	and not (c:IsLocation(LOCATION_SZONE) and c:GetSequence()>=6 and c:GetSequence()<=7)
end
function c200216.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and c200216.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c200216.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(200216,2))
	local g=Duel.SelectTarget(tp,c200216.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c200216.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_ONFIELD) then
		if tc:IsType(TYPE_MONSTER) then
			if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)>0 and tc:IsType(TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(200216,3)) then 
				Duel.BreakEffect()
				Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
			end
		else 
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tc:GetControler(),0) 
			if tc and tc:IsCode(200103) then tc:RegisterFlagEffect(200103,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) end
		end
	end
end
function c200216.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x208) and (c:GetAttack()<c:GetBaseAttack() or c:GetDefence()<c:GetBaseDefence())
end
function c200216.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c200216.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c200216.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(200216,2))
	local g=Duel.SelectTarget(tp,c200216.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c200216.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e2:SetValue(tc:GetBaseDefence())
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end