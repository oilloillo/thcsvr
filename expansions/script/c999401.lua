--破灭的波动❀芙兰朵露•斯卡蕾特
local M = c999401
local Mid = 999401
function M.initial_effect(c)
	--destroy
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(M.destg)
	e1:SetOperation(M.desop)
	c:RegisterEffect(e1)
	--def down
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(M.defop)
	c:RegisterEffect(e2)
	--code
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(22028)
	c:RegisterEffect(e3)
end

M.DescSetName = 0xa3

function M.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end

function M.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and M.filter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(M.filter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, M.filter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function M.setfilter(c)
	local code = c:GetOriginalCode()
	local mt = _G["c" .. code]
	return mt and mt.DescSetName == 0xa3 and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end

function M.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc, REASON_EFFECT)>0 then
			local setg = Duel.GetMatchingGroup(M.setfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, nil)
			local ft = Duel.GetLocationCount(tp, LOCATION_SZONE)
			if Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, c) and
				setg:GetCount() > 0 and ft > 0 and Duel.SelectYesNo(tp,aux.Stringid(Mid, 1)) then
				--
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
				Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_EFFECT+REASON_DISCARD)
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
				local sg=Duel.SelectMatchingCard(tp, M.setfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil)
				Duel.SSet(tp, sg:GetFirst())
				Duel.ConfirmCards(1-tp, sg)
			end
		end
	end
end

function M.deffilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end

function M.defop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not re:GetHandler() then return end
	local hintflag = true
	if re:GetHandler():GetControler() ~= e:GetHandler():GetControler() then return end
	local code = re:GetHandler():GetOriginalCode()
	local mt=_G["c" .. code]
	if mt and mt.DescSetName == 0xa3 and re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) then
		local mg=Duel.GetMatchingGroup(M.deffilter, tp,LOCATION_MZONE, LOCATION_MZONE, nil)
		if mg:IsContains(c) then
			mg:RemoveCard(c)
		end
		if mg:GetCount()>0 then 
			Duel.Hint(HINT_CARD, 0, Mid)
			Duel.BreakEffect()
			hintflag = false
			local tc = mg:GetFirst()
			while tc do
				local e1 = Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_DEFENSE)
				e1:SetValue(-500)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				-- if tc:GetDefense()==0 then
				-- 	Duel.Destroy(tc, REASON_EFFECT)
				-- end
				tc = mg:GetNext()
			end
		end
		local desg = Duel.GetMatchingGroup(M.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
		if desg:GetCount()>0 then
			if hintflag == true then
				Duel.Hint(HINT_CARD, 0, Mid)
				Duel.BreakEffect()
			end
			Duel.Destroy(desg, REASON_EFFECT)
		end
	end
end

function M.desfilter(c)
	return c:GetDefense()<=0 and c:IsFaceup() and not c:IsType(TYPE_LINK)
end