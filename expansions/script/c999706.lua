--百万鬼夜行✿伊吹萃香
local M = c999706
local Mid = 999706
function M.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(Mid,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(M.spcon)
	e2:SetTarget(M.sptg)
	e2:SetOperation(M.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
	--xyz lv
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_XYZ_LEVEL)
	e5:SetValue(8)
	c:RegisterEffect(e5)
end

function M.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function M.spfilter(c,e,tp)
	return c:IsCode(999704) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and M.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(M.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,M.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
