 
--逆符「天地有用」
function c29039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c29039.condition)
	e1:SetOperation(c29039.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c29039.handcon)
	c:RegisterEffect(e2)
end
function c29039.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
		and Duel.IsExistingMatchingCard(c29039.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c29039.filter1(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c29039.filter2(c)
	return c:IsFaceup() and (c:GetAttack()~=c:GetBaseAttack() or c:GetDefence()~=c:GetBaseDefence())
end
function c29039.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x260)
end
function c29039.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29039.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if Duel.IsExistingMatchingCard(c29039.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c29039.filter1,tp,0,LOCATION_ONFIELD,1,e:GetHandler())
		and Duel.SelectYesNo(tp,aux.Stringid(29039,0)) then
		dg=Duel.GetMatchingGroup(c29039.filter1,tp,0,LOCATION_ONFIELD,c)
		local tc=dg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc=dg:GetNext()
		end
		tc=g:GetFirst()
	end
	local tc=g:GetFirst()
	while tc do
		if tc:GetAttack()~=tc:GetBaseAttack() then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(tc:GetBaseAttack())
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		if tc:GetDefence()~=tc:GetBaseDefence() then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_DEFENCE_FINAL)
			e4:SetValue(tc:GetBaseDefence())
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e4)
		end
		tc=g:GetNext()
	end
end
function c29039.cfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==(29030)
end
function c29039.handcon(e)
	return Duel.GetMatchingGroupCount(c29039.cfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,nil)>0
end
