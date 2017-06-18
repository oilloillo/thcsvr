--断神『一闪』
local M = c999215
local Mid = 999215
function M.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0, 0x1c0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
end

function M.filter(c, code, set)
	if code then
		return c:IsCode(code) and c:IsFaceup()
	else
		return c:IsSetCard(set) and c:IsFaceup()
	end
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, e:GetHandler(), REASON_COST) end
	Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST+REASON_DISCARD, e:GetHandler())
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsDestructable() end
	if chk==0 then 
		return Duel.IsExistingTarget(Card.IsDestructable, tp, 0, LOCATION_ONFIELD, 1, nil) 
			and (Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_ONFIELD, 0, 1, nil, 999211) or Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_ONFIELD, 0, 1, nil, 999214))
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, Card.IsDestructable, tp, 0, LOCATION_ONFIELD, 1, 1, e:GetHandler())
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local flag1 = Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_ONFIELD, 0, 1, nil, 999211)
		local flag2 = Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_ONFIELD, 0, 1, nil, 999214)
		local flag3 = Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_ONFIELD, 0, 1, nil, nil, 0xaa1)
		local flag4 = Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_ONFIELD, 0, 1, nil, 999201)

		local g = {}
		g[#g+1] = tc
		c = g[#g]
		while c do
			local result = 0
			local seq = c:GetSequence()
			local loc = c:GetLocation()
			if flag2 then 
				result = Duel.Destroy(c, REASON_EFFECT)
			elseif flag1 then
				result = Duel.Remove(c, POS_FACEUP, REASON_EFFECT)
			end
			g[#g] = nil
			--
			if result > 0 then
				if flag4 or flag3 then
					if seq > 0 and seq < 5 then
						local card = Duel.GetFieldCard(1-tp, loc, seq-1)
						if card then g[#g+1] = card end
					end
					if seq > -1 and seq < 4 then
						local card = Duel.GetFieldCard(1-tp, loc, seq+1)
						if card then g[#g+1] = card end
					end
					flag3 = false
				end
			end
			c = g[#g]
		end
	end
end