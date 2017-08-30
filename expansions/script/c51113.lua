--摇曳百合✿松本理世
function c51113.initial_effect(c)
--同调
aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)	
	c:EnableReviveLimit()
	--cannot special summon
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c51113.con)
	e1:SetLabel(2)
	e1:SetValue(c51113.efilter)
	c:RegisterEffect(e1)
		--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH)
	e5:SetDescription(aux.Stringid(51113,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c51113.con)
	e5:SetLabel(3)
	e5:SetTarget(c51113.tg2)
	e5:SetOperation(c51113.op2)
	c:RegisterEffect(e5)
	--Negate summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(51113,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCondition(c51113.con)
	e2:SetLabel(4)
	e2:SetCost(c51113.cost)
	e2:SetTarget(c51113.distg)
	e2:SetOperation(c51113.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(51113,2))
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(51113,3))
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	
end
function c51113.filter(c)
	return c:IsSetCard(0x511) and c:IsFaceup()
end
function c51113.con(e)
	return Duel.GetMatchingGroup(c51113.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
end

function c51113.efilter(e,te)
	local c=te:GetHandler()
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(51203)
end
function c51113.filter2(c)
	return c:IsCode(51107) and c:IsAbleToHand()
end
function c51113.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51113.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51113.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c51113.filter2,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c51113.filter2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c51113.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(51113)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(51113,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c51113.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c51113.costfilter(c)
	return c:IsCode(51107) and c:IsAbleToDeckAsCost()
end
function c51113.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51113.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c51113.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
