--毒符『毒之铃兰』
function c25053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25053,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c25053.target)
	e1:SetOperation(c25053.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25053,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c25053.sptg)
	e2:SetOperation(c25053.spop)
	c:RegisterEffect(e2)
end
function c25053.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x165)
end
function c25053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c25053.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>ct
		and Duel.IsPlayerCanSpecialSummonMonster(tp,25015,0,0x208,400,600,1,RACE_PLANT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct+1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct+1,0,0)
end
function c25053.filterd(c)
	return (c:GetOriginalCode()==25059 or c:GetOriginalCode()==25060) and c:IsSSetable()
end
function c25053.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c25053.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>ct 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,25015,0,0x208,400,600,1,RACE_PLANT,ATTRIBUTE_WIND) then
		for i=1,ct+1 do
			local token=Duel.CreateToken(tp,25015)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
		if Duel.IsExistingMatchingCard(c25053.filterd,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(25053,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c25053.filterd,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SSet(tp,g:GetFirst())
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c25053.filter(c)
	return c:IsSetCard(0x165) and c:IsAbleToHand()
end
function c25053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25053.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c25053.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c25053.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
