 
--虚人「无」
function c21125.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21125.cost)
	e1:SetTarget(c21125.target)
	e1:SetOperation(c21125.activate)
	c:RegisterEffect(e1)
end
function c21125.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c21125.cfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c21125.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c21125.cfilter(c)
	return c:IsType(TYPE_NORMAL) or c:IsSetCard(0x137)
end
function c21125.filter(c)
	return c:IsSetCard(0x161) and c:IsAbleToHand()
end
function c21125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21125.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21125.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21125.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(1)
		e1:SetCondition(c21125.regcon)
		e1:SetOperation(c21125.regop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c21125.spfilter(c,e,tp)
	return c:IsCode(21077) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21125.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c21125.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21125.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()<1 or not Duel.SelectYesNo(tp,aux.Stringid(21125,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(-1000)
		sg:GetFirst():RegisterEffect(e3)
	local tc=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Destroy(tc,REASON_EFFECT)
end
