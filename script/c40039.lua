 
--精灵魔装-无穷的女王之城
function c40039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCost(c40039.cost)
	e1:SetTarget(c40039.target)
	e1:SetOperation(c40039.operation)
	c:RegisterEffect(e1)
	--Atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetValue(2500)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c40039.eqlimit)
	c:RegisterEffect(e3)
	--disable attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40039,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_ATTACK)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c40039.dacon)
	e4:SetCost(c40039.dacost)
	e4:SetOperation(c40039.daop)
	c:RegisterEffect(e4)
	--disable effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c40039.disop)
	c:RegisterEffect(e5)
end
function c40039.eqlimit(e,c)
	return c:IsSetCard(0x430) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c40039.refilter(c)
	return c:IsCode(40028) and c:IsAbleToRemoveAsCost()
end
function c40039.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x430) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c40039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40039.refilter,tp,0x16,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c40039.refilter,tp,0x16,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c40039.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c40039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c40039.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c40039.dacon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ph~=PHASE_MAIN2 and ph~=PHASE_END
		and Duel.IsExistingMatchingCard(Card.IsAttackable,tp,0,LOCATION_MZONE,1,nil)
end
function c40039.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c40039.dafilter(c)
	return c:IsCode(40039) and c:IsAbleToHand()
end
function c40039.daop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() then Duel.NegateAttack()
		if Duel.IsExistingMatchingCard(c40039.dafilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(40039,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c40039.dafilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c40039.disopppppppppppp)
		Duel.RegisterEffect(e1,tp)
	end
end
function c40039.disopppppppppppp(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	if Duel.IsExistingMatchingCard(c40039.dafilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(40039,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c40039.dafilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40039.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if e:GetHandler():GetFlagEffect(40039)~=0 then return end
	if not ec:GetEquipTarget() or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(ec:GetEquipTarget()) then return end
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(40039,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
