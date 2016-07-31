 
--WhiteHeart
function c70016.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c70016.ovfilter,aux.Stringid(70016,0))
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c70016.destg)
	e1:SetValue(c70016.value)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70016,2))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_CAL)
	e2:SetCondition(c70016.condition)
	e2:SetCost(c70016.cost)
	e2:SetOperation(c70016.operation)
	c:RegisterEffect(e2)
end
function c70016.ovfilter(c)
	return c:IsFaceup() and c:IsCode(70013)
end
function c70016.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(tp)
end
function c70016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and eg:IsExists(c70016.dfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(70016,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c70016.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(e:GetHandlerPlayer())
end
function c70016.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x149) and c:GetDefence()>=1000
end
function c70016.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
		and not Duel.IsDamageCalculated() and Duel.GetAttackTarget()~=nil
end
function c70016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetFlagEffect(70016)==0 and Duel.IsExistingMatchingCard(c70016.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	g=Duel.SelectMatchingCard(tp,c70016.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-1000)
	tc:RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(70016,RESET_PHASE+PHASE_DAMAGE,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c70016.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	if a:GetControler()==tp then
		e1:SetValue(d:GetBaseAttack())
		a:RegisterEffect(e1)
	else
		e1:SetValue(a:GetBaseAttack())
		d:RegisterEffect(e1)
	end
end
