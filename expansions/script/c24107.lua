--反应『妖怪测谎机』
function c24107.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c24107.condition)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c24107.cost)
	e2:SetTarget(c24107.target)
	e2:SetOperation(c24107.operation)
	c:RegisterEffect(e2)
end
function c24107.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x514a)
end
function c24107.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24107.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c24107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(1-tp,70,71,72)
	e:SetLabel(op)
end
function c24107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c24107.trop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
end
function c24107.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	if (op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP)) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCountLimit(1)
		e2:SetOperation(c24107.desop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e2)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
	if e:GetHandler():GetFlagEffect(24107)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c24107.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c24107.trop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() or rp==tp then return end
	e:GetHandler():RegisterFlagEffect(24107,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
