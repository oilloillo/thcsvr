--苍翠✿雷光 濑笈叶
local M = c999005
local Mid = 999005
function M.initial_effect(c)
	-- fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c, aux.FilterBoolFunction(Card.IsFusionSetCard, 0xaa6), aux.FilterBoolFunction(Card.IsFusionSetCard, 0x190), true)
	
	-- pos 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(M.postg)
	e1:SetOperation(M.posop)
	c:RegisterEffect(e1)

	-- indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(M.ind2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(M.ind1)
	c:RegisterEffect(e3)

	-- to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(Mid,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1, Mid+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(M.tdcon)
	e2:SetTarget(M.tdtg)
	e2:SetOperation(M.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
end

M.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0xaa6),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x190),
}

function M.ind1(e,re,rp,c)
	local c = re:GetHandler()
	if not c or not c:IsLocation(LOCATION_ONFIELD) then return false end
	return e:GetHandler():GetColumnGroup():IsContains(c)
end

function M.ind2(e, c)
	if not c:IsLocation(LOCATION_ONFIELD) then return false end
	return not e:GetHandler():GetColumnGroup():IsContains(c)
end

function M.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function M.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, 0)
end

function M.thfilter(c)
	return c:IsAbleToHand() and (c:IsSetCard(0x190) or c:GetCode() == 24094653 or c:GetCode() == 24235)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, nil) then return end
	local g = Duel.SelectMatchingCard(tp, M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
	end
end

function M.posfilter(c)
	local seq = c:GetSequence()
	if seq > 4 then return false end
	return (seq > 0 and Duel.CheckLocation(tp, LOCATION_MZONE, seq-1))
		or (seq < 4 and Duel.CheckLocation(tp, LOCATION_MZONE, seq+1))
end

function M.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and M.posfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(M.posfilter, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, M.posfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end

function M.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local seq = tc:GetSequence()
		local l, r = Duel.CheckLocation(tp, LOCATION_MZONE, seq-1), Duel.CheckLocation(tp, LOCATION_MZONE, seq+1)
		if not l and not r then return end
		local flag = 0
		if seq > 0 and Duel.CheckLocation(tp, LOCATION_MZONE, seq-1) then flag = bit.bor(flag, bit.lshift(0x1, seq-1)) end
		if seq < 4 and Duel.CheckLocation(tp, LOCATION_MZONE, seq+1) then flag = bit.bor(flag, bit.lshift(0x1, seq+1)) end
		flag = bit.bxor(flag, 0xff)
		local s = Duel.SelectDisableField(tp, 1, LOCATION_MZONE, 0, flag)
		local nseq = 0 
		if s == 1 then nseq = 0
		elseif s == 2 then nseq = 1
		elseif s == 4 then nseq = 2
		elseif s == 8 then nseq = 3
		else nseq = 4 end
		Duel.MoveSequence(e:GetHandler(), nseq)
		--
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end