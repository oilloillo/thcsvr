--樱之恋冢『梦幻馆的开花』
function c14022.initial_effect(c)
	--find
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14022,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c14022.cost)
	e1:SetTarget(c14022.fitg)
	e1:SetOperation(c14022.fiop)
	c:RegisterEffect(e1)
	--draw
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(14022,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTarget(c14022.drtg)
	e2:SetOperation(c14022.drop)
	c:RegisterEffect(e2)
	--tohand
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(14022,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetTarget(c14022.thtg)
	e3:SetOperation(c14022.thop)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(14022,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetTarget(c14022.sptg)
	e4:SetOperation(c14022.spop)
	c:RegisterEffect(e4)
	--Recycling
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(14022,4))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetTarget(c14022.retg)
	e5:SetOperation(c14022.reop)
	c:RegisterEffect(e5)
end
function c14022.costfilter(c)
	return c:IsSetCard(0x3208) and c:IsAbleToGraveAsCost()
end
function c14022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14022.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c14022.costfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c14022.fifilter(c)
	return c:IsCode(14035) and c:IsAbleToHand()
end
function c14022.fitg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14022.fifilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14022.fiop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14022.fifilter,tp,LOCATION_DECK,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c14022.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c14022.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c14022.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c14022.tgfilter(c)
	return c:GetLevel()+c:GetRank()
end
function c14022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14022.thfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c14022.thfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(c14022.tgfilter)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,tg:GetCount(),0,0)
end
function c14022.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c14022.thfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(c14022.tgfilter)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
function c14022.spfilter(c,e,tp)
	return c:IsSetCard(0x112) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14022.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_DECK)
end
function c14022.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14022.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c14022.refilter(c)
	return c:IsSetCard(0x138) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c14022.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14022.refilter,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function c14022.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14022.refilter,tp,LOCATION_EXTRA,0,2,2,nil)
	if g:GetCount()>1 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
