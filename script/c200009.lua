 
--绯想✿八云紫
function c200009.initial_effect(c)
	c:EnableReviveLimit()
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(20038)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200009,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c200009.spcon)
	e2:SetOperation(c200009.spop)
	c:RegisterEffect(e2)
	--field
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c200009.fcon)
	e2:SetOperation(c200009.fop)
	c:RegisterEffect(e2)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(200009,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,200009)
	e2:SetCost(c200009.cost2)
	e2:SetTarget(c200009.tg2)
	e2:SetOperation(c200009.op2)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c200009.tg3)
	e3:SetOperation(c200009.op3)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
end
function c200009.spfilter(c)
	local x=c:GetOriginalCode()
	return x>=200001 and x<=200020 and x~=200009 and c:IsReleasable()
end
function c200009.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c200009.spfilter,tp,LOCATION_HAND,0,nil)
	return g:CheckWithSumGreater(Card.GetLevel,12)
end
function c200009.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c200009.spfilter,c:GetControler(),LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectWithSumGreater(tp,Card.GetLevel,12)
	Duel.Release(sg,REASON_COST)
end
function c200009.fcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==re:GetHandler()
end
function c200009.fop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200109)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200009.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
--	Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and 
	e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e:GetHandler():RegisterEffect(e1)
--	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c200009.filter(c,e,tp)
	local x=c:GetOriginalCode()
	return x>=200001 and x<=200020 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c200009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c200009.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c200009.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c200009.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c200009.filter2(c)
	return c:IsCode(200209) and c:IsAbleToHand()
end
function c200009.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and Duel.IsExistingMatchingCard(c200009.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c200009.filter3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c200009.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200009.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200009.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(c200009.filter3,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(200009,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=Duel.SelectMatchingCard(tp,c200009.filter3,tp,0,LOCATION_MZONE,1,1,nil)
			Duel.ChangePosition(sg,POS_FACEDOWN_DEFENCE) 
		end
	end
end