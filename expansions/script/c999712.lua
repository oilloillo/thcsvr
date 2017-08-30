--伊吹瓢
local M = c999712
local Mid = 999712
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,Mid)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(Mid, ACTIVITY_SPSUMMON, M.counterfilter)
end

function M.counterfilter(c)
	return c:IsSetCard(0xaa5)
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(Mid, tp, ACTIVITY_SPSUMMON)==0 end
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
	return not c:IsSetCard(0xaa5)
end

function M.filter(c,e,tp)
	return c:IsCode(999701) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(M.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,M.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end