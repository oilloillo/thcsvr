 
--明罗
function c12006.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12006,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c12006.atcon)
	e1:SetOperation(c12006.atop)
	c:RegisterEffect(e1)
	--back
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12006,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c12006.condition)
	e2:SetTarget(c12006.target)
	e2:SetOperation(c12006.operation)
	c:RegisterEffect(e2)
end
function c12006.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabelObject(bc)
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end
function c12006.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local bc=e:GetLabelObject()
		local atk=bc:GetBaseAttack()
		if atk<0 then atk=0 end
		if atk>2000 then atk=2000 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c12006.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function c12006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c12006.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)==1 then
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
