--吞噬历史的半兽　上白泽慧音
--require "expansions/nef/nef"
function c999204.initial_effect(c)
	--Dual
	Nef.EnableDualAttributeSP(c)
	--search / sp
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(999204,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c999204.thcost)
	e1:SetTarget(c999204.thtg)
	e1:SetOperation(c999204.thop)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	--duel status
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c999204.dualfilterTarget)
	e2:SetCode(EFFECT_DUAL_STATUS)
	c:RegisterEffect(e2)
end
function c999204.cfilter(c,tp)
	return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c999204.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c999204.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999204.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c999204.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c999204.thfilter(c,code)
	return c:IsSetCard(0xaa1) and c:IsAbleToHand() and c:GetCode()~=code
end
function c999204.spfilter(c,e,tp)
	return c:IsSetCard(0xaa1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999204.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c999204.thfilter,tp,LOCATION_DECK,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999204.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999204.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetHandler():IsDualState() then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c999204.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c999204.dualfilterTarget(e,c)
	return c:IsSetCard(0xaa1) and c:IsType(TYPE_DUAL)
end

-- function c999204.sptar(e,tp,eg,ep,ev,re,r,rp,chk)
-- 	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
-- 		and Duel.IsExistingMatchingCard(c999204.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
-- 	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
-- end
-- function c999204.spop(e,tp,eg,ep,ev,re,r,rp)
-- 	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
-- 	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
-- 	local g=Duel.SelectMatchingCard(tp,c999204.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
-- 	if g:GetCount()>0 then
-- 		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
-- 	end
-- end