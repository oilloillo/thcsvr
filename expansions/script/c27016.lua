 
--圣德道士 丰聪耳神子
function c27016.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c27016.spcon)
	e1:SetOperation(c27016.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27016,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c27016.con)
	e2:SetTarget(c27016.tg)
	e2:SetOperation(c27016.op)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(27016,1))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c27016.cost)
	e3:SetTarget(c27016.target)
	e3:SetOperation(c27016.operation)
	c:RegisterEffect(e3)
end
function c27016.spfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsRace(RACE_ZOMBIE) and c:IsSetCard(0x208) and c:IsType(TYPE_RITUAL)
end
function c27016.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c27016.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c27016.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c27016.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c27016.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT)~=0 and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
		and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp
end
function c27016.filter(c)
	return c:IsSetCard(0x246) and c:IsAbleToHand()
end
function c27016.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27016.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27016.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27016.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c27016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c27016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c27016.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
