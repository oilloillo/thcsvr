 
--上海人形✿攻击型
function c20142.initial_effect(c)
	--multiattack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c20142.val)
	c:RegisterEffect(e1)
	--self des
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c20142.sdcon)
	c:RegisterEffect(e3)
	--be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetOperation(c20142.desop1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetOperation(c20142.desop2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_BATTLED)
	e6:SetOperation(c20142.desop3)
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
end
function c20142.filter(c)
	return c:IsCode(20049) or c:IsCode(20149)
end
function c20142.val(e,c)
	return Duel.GetMatchingGroupCount(c20142.filter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
end
function c20142.sdcon(e)
	return e:GetHandler():GetOwnerTargetCount()>0
end
function c20142.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		e:SetLabelObject(re)
		e:SetLabel(0)
	end
end
function c20142.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re==e:GetLabelObject():GetLabelObject() and c:IsRelateToEffect(re) then
		if Duel.GetCurrentPhase()==PHASE_DAMAGE and not Duel.IsDamageCalculated() then
			e:GetLabelObject():SetLabel(1)
		else
			if c:IsHasEffect(EFFECT_DISABLE) then return end
			if not c:IsDisabled() then Duel.Destroy(c,REASON_EFFECT) end
		end
	end
end
function c20142.desop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local des=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(0)
	if c:IsHasEffect(EFFECT_DISABLE) then return end
	if des==1 and not c:IsDisabled() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
