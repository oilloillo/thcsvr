 
--露西亚人形✿
function c20140.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20140,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20140.cost)
	e1:SetTarget(c20140.target)
	e1:SetOperation(c20140.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetTarget(c20140.tg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c20140.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20140)==0 and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,20140,RESET_PHASE+PHASE_END,0,1)
end
function c20140.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x186) or c:IsCode(20007)) and not c:IsHasEffect(EFFECT_PIERCE)
end
function c20140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20140.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20140.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c20140.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c20140.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(700)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function c20140.tg(e,c)
	return c:IsSetCard(0x300) and c:IsLevelAbove(5)
end
