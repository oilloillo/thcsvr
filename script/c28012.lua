 
--秘封 宇佐见莲子
function c28012.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28012,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c28012.spcost)
	e2:SetTarget(c28012.sptg)
	e2:SetOperation(c28012.spop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28012,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c28012.target)
	e3:SetOperation(c28012.operation)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(28012,2))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCondition(c28012.scon)
	e4:SetCost(c28012.cost)
	e4:SetTarget(c28012.stg)
	e4:SetOperation(c28012.sop)
	c:RegisterEffect(e4)
end
function c28012.rfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToRemoveAsCost()
end
function c28012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28012.rfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c28012.rfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c28012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28012.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
		c:CompleteProcedure()
	end
end
function c28012.cfilter(c)
	return not c:IsPublic()
end
function c28012.jfilter(c)
	return c:IsAbleToRemove() or c:IsDestructable()
end
function c28012.filter1(c)
	return c:IsSetCard(0x208) and c:IsAbleToRemove() and c:IsFaceup()
end
function c28012.filter2(c)
	return not c:IsSetCard(0x208) and c:IsDestructable() and c:IsFaceup()
end
function c28012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28012.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c28012.jfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c28012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28012.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	if g:GetFirst():IsSetCard(0x208) then
		local sg1=Duel.SelectMatchingCard(tp,c28012.filter2,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
		Duel.Destroy(sg1,REASON_EFFECT)
	else local sg2=Duel.SelectMatchingCard(tp,c28012.filter1,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
		Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
function c28012.filter(c,tp)
	return c:IsSetCard(0xc211) and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp
end
function c28012.scon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28012.filter,1,nil,tp)
end
function c28012.costfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function c28012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28012.costfilter,tp,LOCATION_REMOVED,0,7,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28012.costfilter,tp,LOCATION_REMOVED,0,7,7,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c28012.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0xf,0xf,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xf,0xf,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28012.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xf,0xf,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
