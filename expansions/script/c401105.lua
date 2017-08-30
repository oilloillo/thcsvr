--深海栖舰-中间栖姬
function c401105.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(401105,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_RETURN_TO_GRAVE)
	e1:SetCountLimit(1,40110501)
	e1:SetCondition(c401105.spcondtion)
	e1:SetTarget(c401105.sptarget)
	e1:SetOperation(c401105.spoperation)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(401105,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCountLimit(1,40110502)
	e4:SetCost(c401105.hspcost)
	e4:SetTarget(c401105.hsptg)
	e4:SetOperation(c401105.hspop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c401105.retcon)
	e2:SetTarget(c401105.rettg)
	e2:SetOperation(c401105.retop)
	c:RegisterEffect(e2)
	end
function c401105.spcondtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_REMOVED
	and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c401105.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c401105.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,1,tp,tp,true,true,POS_FACEUP)>0 
	then
		c:CompleteProcedure()
	end
end
function c401105.rfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemoveAsCost()
end
function c401105.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c401105.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c401105.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c401105.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c401105.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c401105.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c401105.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c401105.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
