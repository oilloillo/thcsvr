--鬼群『小鬼成群』
local M = c999717
local Mid = 999717
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(Mid,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(Mid, ACTIVITY_SPSUMMON, M.counterfilter)
end

function M.counterfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end

function M.filter1(c)
	return c:IsFaceup() and c:GetLevel()>1
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(Mid,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(M.sumlimit)
	Duel.RegisterEffect(e1,tp)
end

function M.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_ZOMBIE)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and M.filter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(M.filter1, tp, 0, LOCATION_MZONE, 1, nil) 
		and Duel.IsExistingMatchingCard(M.filter2, tp, LOCATION_DECK, 0, 1, nil, e, tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp, M.filter1, tp, 0, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end

function M.filter2(c,e,tp)
	return c:IsSetCard(0xaa5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local count = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if count < 1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(tp) or tc:IsImmuneToEffect(e) then return end

	local lv = tc:GetLevel()
	local d = Duel.TossDice(tp, 1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-d)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local num = math.floor(d/2)
	if num > count then num = count end
	local g=Duel.SelectMatchingCard(tp, M.filter2, tp, LOCATION_DECK, 0, 1, num, nil, e, tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end