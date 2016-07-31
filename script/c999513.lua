--✿光之三妖精☆
local M = c999513
local Mid = 999513
function M.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,25020,25021,25022,false,false)
	if not M.counter then
		M.counter = true 
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(Mid, 0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHAIN_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1, 0)
		e1:SetTarget(M.chain_target)
		e1:SetOperation(M.chain_operation)
		e1:SetValue(aux.FilterBoolFunction(Card.IsCode, Mid))
		Duel.RegisterEffect(e1, 0)
		local e2 = e1:Clone()
		Duel.RegisterEffect(e2, 1)
	end
	-- search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(Mid,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(M.thtg)
	e3:SetOperation(M.thop)
	c:RegisterEffect(e3)
end

function M.filter(c, e)
	local loc = c:GetLocation()
	if loc == LOCATION_GRAVE then
		return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
	elseif loc == LOCATION_MZONE or loc == LOCATION_HAND then
		return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
	end
	return false
end

function M.filter2(c)
	return c:IsType(TYPE_SPELL) and (c:IsSetCard(0x999) or c:GetOriginalCode()==22090)
end

function M.chain_target(e, te, tp)
	local mg = Duel.GetMatchingGroup(M.filter2, tp, LOCATION_GRAVE+LOCATION_ONFIELD, 0, nil)
	local mg1 = Duel.GetMatchingGroup(M.filter, tp, LOCATION_MZONE+LOCATION_HAND, 0, nil, te)
	local mg2 = Duel.GetMatchingGroup(M.filter, tp, LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND, 0, nil, te)
	local num = mg:GetClassCount(Card.GetCode)
	local num1 = mg1:GetClassCount(Card.GetCode)
	local num2 = mg2:GetClassCount(Card.GetCode)
	if num2 > 2 and num1 + num > 2 then
		return mg2
	else
		return mg1
	end
end

function M.chain_operation(e, te, tp, tc, mat, sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	local mc = mat:GetFirst()
	while mc do 
		local loc = mc:GetLocation()
		if loc == LOCATION_GRAVE then
			Duel.Remove(mc, POS_FACEUP, REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		elseif loc == LOCATION_MZONE or loc == LOCATION_HAND then
			Duel.SendtoGrave(mc, REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		end
		mc = mat:GetNext()
	end
	Duel.BreakEffect()
	Duel.SpecialSummon(tc, sumtype, tp, tp, false, false, POS_FACEUP)
end

function M.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and (c:IsSetCard(0x999) or c:GetOriginalCode()==22090)
end

function M.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK+LOCATION_GRAVE)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp, M.thfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end