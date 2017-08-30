 
---废狱-地狱的轮祸·火焰猫磷
function c24119.initial_effect(c)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c24119.synlimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c24119.spcon)
	e2:SetOperation(c24119.spop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24119,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_CAL)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c24119.condition)
	e3:SetCost(c24119.cost)
	e3:SetOperation(c24119.operation)
	c:RegisterEffect(e3)
end
function c24119.synlimit(e,c)
	if not c then return false end
	if c:IsSetCard(0x5208) then
	return else return not c:IsSetCard(0x120) end
end
function c24119.spfilter(c)
	return c:IsCode(24009) and c:IsAbleToRemoveAsCost()
end
function c24119.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c24119.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c24119.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24119.spfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24119.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
		and not Duel.IsDamageCalculated()
end
function c24119.cfilter(c)
	return c:IsSetCard(0x625) and c:IsAbleToRemoveAsCost()
end
function c24119.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(24119)==0
		and Duel.IsExistingMatchingCard(c24119.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24119.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(24119,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c24119.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(e:GetLabel())
		e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
