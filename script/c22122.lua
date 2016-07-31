 
--华符「破山炮」
function c22122.initial_effect(c)
	c:EnableCounterPermit(0x28c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c22122.ctcon)
	e2:SetOperation(c22122.ctop)
	c:RegisterEffect(e2)
	--lvdown
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(22122,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c22122.cost)
	e3:SetTarget(c22122.tg1)
	e3:SetOperation(c22122.op1)
	c:RegisterEffect(e3)
	--lvup
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetDescription(aux.Stringid(22122,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c22122.cost)
	e4:SetTarget(c22122.tg2)
	e4:SetOperation(c22122.op2)
	c:RegisterEffect(e4)
end
function c22122.ctfilter(c)
	return (c:IsSetCard(0x813) or c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117))
end
function c22122.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22122.ctfilter,1,nil)
end
function c22122.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x28c,1)
end
function c22122.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x28c,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,1,0x28c,1,REASON_COST)
end
function c22122.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c22122.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22122.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c22122.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22122.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetLevel)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-1)
			sg:GetFirst():RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetValue(500)
			sg:GetFirst():RegisterEffect(e2)
		elseif tg then
			local rg=tg:GetFirst()
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_LEVEL)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(-1)
			rg:RegisterEffect(e3)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_UPDATE_ATTACK)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e4:SetValue(500)
			rg:RegisterEffect(e4)
		end
	end
end
function c22122.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22122.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c22122.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22122.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local tg=g:GetMinGroup(Card.GetLevel)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(1)
			sg:GetFirst():RegisterEffect(e1)
		elseif tg then
			local rg=tg:GetFirst()
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_LEVEL)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(1)
			rg:RegisterEffect(e2)
		end
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
