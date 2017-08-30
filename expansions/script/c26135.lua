--搜符『黄金探测器』
function c26135.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26135,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCost(c26135.cost)
	e2:SetTarget(c26135.target)
	e2:SetOperation(c26135.operation)
	c:RegisterEffect(e2)
	if not c26135.global_check then
		c26135.global_check=true
		c26135[0]=0
		c26135[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c26135.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(c26135.checkop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c26135.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c26135.checkfilter(c,tp)
	return c:IsSetCard(0x251) and c:GetSummonPlayer()==tp
end
function c26135.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c26135.checkfilter,1,nil,0) then
		c26135[0]=1
	end

	if eg:IsExists(c26135.checkfilter,1,nil,1) then
		c26135[1]=1
	end
end
function c26135.clear(e,tp,eg,ep,ev,re,r,rp)
	c26135[0]=0
	c26135[1]=0
end
function c26135.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c26135.filter1(c)
	return c:IsSetCard(0x251) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c26135.filter2(c)
	return c:IsSetCard(0x252) or c:IsSetCard(0x251e)
end
function c26135.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c26135[tp]>0 and Duel.IsExistingMatchingCard(c26135.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c26135.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26135.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26135.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26135,1))
		local dg=Duel.SelectMatchingCard(tp,c26135.filter2,tp,LOCATION_DECK,0,1,1,nil)
		local tc=dg:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
