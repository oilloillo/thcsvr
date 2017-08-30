 
--秘封 玛艾里贝莉·哈恩
function c28017.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28017,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c28017.spcost)
	e2:SetTarget(c28017.sptg)
	e2:SetOperation(c28017.spop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28017,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c28017.condition)
	e3:SetTarget(c28017.target)
	e3:SetOperation(c28017.operation)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(28017,2))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCondition(c28017.scon)
	e4:SetCost(c28017.cost)
	e4:SetTarget(c28017.stg)
	e4:SetOperation(c28017.sop)
	c:RegisterEffect(e4)
end
function c28017.costfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function c28017.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28017.costfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28017.costfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c28017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28017.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
		c:CompleteProcedure()
	end
end
function c28017.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c28017.thfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c28017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28017.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28017.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28017.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c28017.filter(c,tp)
	return c:IsSetCard(0xa211) and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp
end
function c28017.scon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28017.filter,1,nil,tp)
end
function c28017.rfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToRemoveAsCost()
end
function c28017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28017.rfilter,tp,LOCATION_GRAVE,0,7,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c28017.rfilter,tp,LOCATION_GRAVE,0,7,7,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c28017.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0x1e,0x1e,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28017.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
