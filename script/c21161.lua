--人类地狱火✿藤原妹红
function c21161.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21161,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21161.con)
	e1:SetTarget(c21161.tg)
	e1:SetOperation(c21161.op)
	c:RegisterEffect(e1)
	--addown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21161,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c21161.adcost)
	e2:SetTarget(c21161.adtg)
	e2:SetOperation(c21161.adop)
	c:RegisterEffect(e2)
end
function c21161.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c21161.sfilter(c)
	return (c:IsCode(21099) or c:IsCode(21100)) and c:IsAbleToHand()
end
function c21161.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21161.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetTargetPlayer(3)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,3,500)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21161.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(tp,d,REASON_EFFECT)
	Duel.Damage(1-tp,d,REASON_EFFECT)
	Duel.RDComplete()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21161.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21161.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c21161.filter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x137) and c:IsType(TYPE_MONSTER)
end
function c21161.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g1=e:GetHandler():GetOverlayGroup()
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
		g:Merge(g1)
		return g:FilterCount(c21161.filter,nil)>0 end
end
function c21161.adop(e,tp,eg,ep,ev,re,r,rp)
	local g1=e:GetHandler():GetOverlayGroup()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
	g:Merge(g1)
	if g:FilterCount(c21161.filter,nil)==0 then return end
	local sg=g:FilterSelect(tp,c21161.filter,1,1,nil)
	local sc=sg:GetFirst()
	Duel.SendtoGrave(sc,REASON_EFFECT)
	local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local ct=-100*2^math.floor(sc:GetAttack()/1000)
	local tc=dg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=dg:GetNext()
	end
end
