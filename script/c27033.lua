--回复『借由欲望的恢复』
function c27033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c27033.target)
	e1:SetOperation(c27033.activate)
	c:RegisterEffect(e1)
end
function c27033.cfilter(c)
	return (c:GetAttack()~=c:GetTextAttack() or c:GetDefence()~=c:GetTextDefence() or c:IsDisabled()) and c:IsFaceup()
end
function c27033.filter(c)
	return c:IsSetCard(0x242) and c:IsFaceup()
end
function c27033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27033.cfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
end
function c27033.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27033.cfilter,tp,0,LOCATION_MZONE,nil)
	local ct=0
	local oil=0
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetTextAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if tc:GetAttack()~=tc:GetTextAttack() and tc:RegisterEffect(e1) then ct=ct+1 oil=1 end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e2:SetValue(tc:GetTextDefence())
		e2:SetReset(RESET_EVENT+0x1fe0000)
		if tc:GetDefence()~=tc:GetTextDefence() and tc:RegisterEffect(e2) and oil==0 then ct=ct+1 oil=1 end
		if tc:IsDisabled() and not tc:IsImmuneToEffect(e) then
			Duel.Remove(tc,POS_FACEDOWN,REASON_TEMPORARY)
			Duel.BreakEffect()
			Duel.ReturnToField(tc)
			if oil==0 then
				ct=ct+1
			end
		end
		tc=g:GetNext()
	end
	if ct>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		local dg=Duel.GetMatchingGroup(c27033.filter,tp,LOCATION_MZONE,0,nil)
		local tc=dg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*500)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENCE)
			tc:RegisterEffect(e2)
			tc=dg:GetNext()
		end
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end
