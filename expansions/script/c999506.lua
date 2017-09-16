--持花✿妖精☆
local M = c999506
local Mid = 999506
function M.initial_effect(c)
	--lvup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0, 0x1c0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, Mid)
	e1:SetCost(M.lvcost)
	e1:SetTarget(M.lvtg)
	e1:SetOperation(M.lvop)
	c:RegisterEffect(e1)
end

function M.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c, REASON_COST+REASON_DISCARD)
end

function M.lvfilter(c)
	if not c:IsFaceup() then return end
	if c:IsRace(RACE_PLANT) then
		return not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
	else
		return true
	end
end

function M.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and M.lvfilter(chkc, tp) end
	if chk == 0 then return Duel.IsExistingTarget(M.lvfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil, tp) end
	Duel.Hint(HINT_SELECTMSG, tp ,HINTMSG_FACEUP)
	Duel.SelectTarget(tp, M.lvfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil, tp)
end

function M.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRace(RACE_PLANT) and (tc:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)) then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- change race
		if not tc:IsRace(RACE_PLANT) then
			local e1 = Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(RACE_PLANT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
		-- change level
		if not tc:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK) then
			local op = -1
			if tc:GetLevel() == 1 then 
				op = Duel.SelectOption(tp,aux.Stringid(Mid, 1))
			else 
				op = Duel.SelectOption(tp,aux.Stringid(Mid, 1), aux.Stringid(Mid, 2)) 
			end

			local e2 = Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_LEVEL)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(op == 0 and 1 or -1)
			tc:RegisterEffect(e2)
		end
	end
end