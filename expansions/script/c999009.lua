--凛冬不凋的花妖✿濑笈叶
local M = c999009
local Mid = 999009
function M.initial_effect(c)
	-- fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c, aux.FilterBoolFunction(Card.IsFusionSetCard, 0xaa6), aux.FilterBoolFunction(Card.IsFusionSetCard, 0x9999), true)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(M.sptg)
	e1:SetOperation(M.spop)
	e1:SetCountLimit(1, Mid*10+1)
	c:RegisterEffect(e1)

	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(M.indestg)
	c:RegisterEffect(e2)

	-- to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(Mid, 1))
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

function M.spfilter(c, e, tp, lv, def, code)
	local flag = (not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)) and lv > c:GetLevel() and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP_DEFENSE)
	if def then
		return flag and c:GetDefense() == def and c:GetCode() ~= code
	else
		return flag and Duel.IsExistingTarget(M.spfilter, tp, LOCATION_GRAVE, 0, 1, c, e, tp, lv - c:GetLevel(), c:GetDefense(), c:GetCode())
	end
end

function M.removefilter(c, def, code, lv)
	return c:GetDefense() ~= def or c:GetCode() == code or c:GetLevel() >= lv
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end

	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	if ft < 2 then return false end

	local lv = e:GetHandler():GetLevel()
	if not Duel.IsExistingTarget(M.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, lv) then return end
	if chk == 0 then return true end

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.GetMatchingGroup(M.spfilter, tp, LOCATION_GRAVE, 0, nil, e, tp, lv)
	local sg = Group.CreateGroup()
	count = 0
	if g:GetCount() == 0 then return false end
	while true do
		local temp = g:Select(tp, 1, 1, nil):GetFirst()
		lv = lv - temp:GetLevel()
		count = count + 1
		g:Remove(M.removefilter, nil, temp:GetDefense(), temp:GetCode(), lv)
		sg:AddCard(temp)
		if count > 1 and (count > ft or lv < 2 or g:GetCount() == 0 or not Duel.SelectYesNo(tp,aux.Stringid(Mid, 2)) ) then
			break
		end
	end

	Duel.SetTargetCard(sg)

	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, sg, sg:GetCount(), 0, 0)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect, nil, e)
	if g:GetCount() > 0 then 
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP_DEFENSE)

		local c = e:GetHandler()
		local lv = 0
		local tc = g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)

			lv = lv + tc:GetLevel()
			tc = g:GetNext()
		end

		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(-lv)
		c:RegisterEffect(e3)
	end
end

function M.indestg(e,re)
	return re:GetHandler():IsType(TYPE_TRAP)
end

function M.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function M.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, 0)
end

function M.thfilter(c)
	return c:IsAbleToHand() and (c:IsSetCard(0x9999) or c:GetCode() == 24094653 or c:GetCode() == 24235)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, nil) then return end
	local g = Duel.SelectMatchingCard(tp, M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
	end
end